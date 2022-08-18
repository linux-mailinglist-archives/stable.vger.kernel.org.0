Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E25598312
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 14:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244624AbiHRMYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 08:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244363AbiHRMYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 08:24:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109181A3BD;
        Thu, 18 Aug 2022 05:24:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A45A56155B;
        Thu, 18 Aug 2022 12:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0DAC433B5;
        Thu, 18 Aug 2022 12:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660825439;
        bh=lkhtAhHekrK/WIjo+sqKBPMPctsv+BUIViYgMeJQZhk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RsBhFaAJA76baLX8NpNADMaHZ6eix0MiYmw9Q/B4gd2T2MH6DygJ7fhCTuIV857Jn
         WaqOhxXr4sXlOp6C4jPmiu+qRunueqk5zm7vkYxWPWyMxDak3m1vEHrs8uo7qmm02A
         3VAkybAPMdwU/7/omj30kNvI0753Xk+GCMGDU1Lo=
Date:   Thu, 18 Aug 2022 14:23:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kbuild@vger.kernel.org, live-patching@vger.kernel.org,
        lkp@intel.com, stable@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] [STUB] increase kallsyms length limit
Message-ID: <Yv4vXG8hqvUVs0uC@kroah.com>
References: <20220818115306.1109642-1-alexandr.lobakin@intel.com>
 <20220818115306.1109642-3-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818115306.1109642-3-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 18, 2022 at 01:53:05PM +0200, Alexander Lobakin wrote:
> This is a stub just to make it work without including one more
> series into this one, for the actual changes please look at the
> Rust kallsyms prereqs[0].
> 
> [0] https://github.com/Rust-for-Linux/linux/commits/rust-next
> 
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---
>  include/linux/kallsyms.h | 2 +-
>  kernel/livepatch/core.c  | 4 ++--
>  scripts/kallsyms.c       | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
