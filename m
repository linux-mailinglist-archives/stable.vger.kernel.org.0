Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29D5601FA2
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbiJRAem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiJRAeg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:34:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA70BA1B0;
        Mon, 17 Oct 2022 17:34:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CC3B611F5;
        Tue, 18 Oct 2022 00:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F678C433C1;
        Tue, 18 Oct 2022 00:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666052556;
        bh=w8dO5flJtUJ9RxNmvELTwbRTnOO/jaWU4CHl6yTVTtY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dgU0FONrfUG14UKEzGn6NWQEdmezbNgsBKBMCAE84b4HSKux7d1CBg6+awMblpCJr
         b/dVyxnS6PRzGOX/bIZG2BEEQ6httxDRKW4lWTZLFVvcOIk+r9IF1JreiuEykWyTwL
         LohTR9JwZ9xeiYFZ5nlSTgMyfCmkhgv7SL6awThizNbNtlGjdipWYyCOHb7XCJoBTr
         AGYKljHxkFg6z5F3EqHUczqiZxed/czQkxuGWpeM8V39Ri9D8mXE6hSKCoubV+e2EN
         hIeVyo8877ZKZJJ8e7mU2+oTUR7ufsxBGWsHvJZIrgM0DWRb196QYpnAQ2a6bKl3aj
         QWQKsPeRTEl6Q==
Date:   Mon, 17 Oct 2022 17:22:33 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexander Potapenko <glider@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Christoph Hellwig <hch@lst.de>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Petr Mladek <pmladek@suse.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-block@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 10/13] kmsan: disable physical page merging
 in biovec
Message-ID: <Y03xyaUhL6gSLWYQ@sol.localdomain>
References: <20221018001102.2731930-1-sashal@kernel.org>
 <20221018001102.2731930-10-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018001102.2731930-10-sashal@kernel.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 17, 2022 at 08:10:59PM -0400, Sasha Levin wrote:
> From: Alexander Potapenko <glider@google.com>
> 
> [ Upstream commit f630a5d0ca59a6e73b61e3f82c371dc230da99ff ]
> 
> KMSAN metadata for adjacent physical pages may not be adjacent, therefore
> accessing such pages together may lead to metadata corruption.  We disable
> merging pages in biovec to prevent such corruptions.
> 
> Link: https://lkml.kernel.org/r/20220915150417.722975-28-glider@google.com
> Signed-off-by: Alexander Potapenko <glider@google.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Andrey Konovalov <andreyknvl@gmail.com>
> Cc: Andrey Konovalov <andreyknvl@google.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Eric Biggers <ebiggers@google.com>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Ilya Leoshkevich <iii@linux.ibm.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Marco Elver <elver@google.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Vegard Nossum <vegard.nossum@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  block/blk.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/block/blk.h b/block/blk.h
> index ee3d5664d962..3358ef4244fe 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -79,6 +79,13 @@ static inline bool biovec_phys_mergeable(struct request_queue *q,
>  	phys_addr_t addr1 = page_to_phys(vec1->bv_page) + vec1->bv_offset;
>  	phys_addr_t addr2 = page_to_phys(vec2->bv_page) + vec2->bv_offset;
>  
> +	/*
> +	 * Merging adjacent physical pages may not work correctly under KMSAN
> +	 * if their metadata pages aren't adjacent. Just disable merging.
> +	 */
> +	if (IS_ENABLED(CONFIG_KMSAN))
> +		return false;
> +
>  	if (addr1 + vec1->bv_len != addr2)
>  		return false;
>  	if (xen_domain() && !xen_biovec_phys_mergeable(vec1, vec2->bv_page))

So KMSAN is being backported to 5.4?

- Eric
