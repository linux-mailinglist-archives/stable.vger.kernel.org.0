Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12662629FF1
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 18:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbiKORHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 12:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbiKORHd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 12:07:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC17F332
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 09:07:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8045861937
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 17:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B006C433D6;
        Tue, 15 Nov 2022 17:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668532049;
        bh=LdSGfFbzDzr6jj0WRoZHdB09e27a1J+TRKk8CJ2jqb4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dw1Rqx7eEByS8sMXdSbMrUlVt/M0/E8JvlDpSbA/VYRIfUhc9/pUaZRqJoQ4O8Qqa
         5AZI9VX60AEyjsOpPJixQy+aMCL8J7g/6R9N7VqO2ueSO/4ZUxp5EMeB31K1+pnMv4
         kcd/xkfzVYbca3pUB+ZSuH2ypn6miMedxQYIv8/s=
Date:   Tue, 15 Nov 2022 18:07:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.15 1/3] bitops: always define asm-generic non-atomic
 bitops
Message-ID: <Y3PHTy85wVcsWoUF@kroah.com>
References: <alpine.LRH.2.21.2211151139030.32285@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.2211151139030.32285@file01.intranet.prod.int.rdu2.redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 15, 2022 at 11:42:55AM -0500, Mikulas Patocka wrote:
> commit 21bb8af513d35c005c401706030f4eb469538d1d upstream.
> 
> Move generic non-atomic bitops from the asm-generic header which
> gets included only when there are no architecture-specific
> alternatives, to a separate independent file to make them always
> available.
> Almost no actual code changes, only one comment added to
> generic_test_bit() saying that it's an atomic operation itself
> and thus `volatile` must always stay there with no cast-aways.
> 
> Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com> # comment
> Suggested-by: Marco Elver <elver@google.com> # reference to kernel-doc
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Marco Elver <elver@google.com>
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> 
> ---
>  include/asm-generic/bitops/generic-non-atomic.h |  130 ++++++++++++++++++++++++
>  include/asm-generic/bitops/non-atomic.h         |  110 +-------------------
>  2 files changed, 138 insertions(+), 102 deletions(-)
> 

{sigh}

Please work with a kernel developer at your company that understands how
to send out patch series properly (correctly threaded and versioned),
and also go and read the DCO for what you need to do when sending on
patches that you want submitted (hint, you have to sign off on it.)

Then get THEM to also sign off on the contribution as well, showing that
they agree this change is needed, and is correct, and THEN resend all of
these, with the proper people copied also, in the correct format.

And properly use a 0/X email that explains why these changes are needed,
and what is involved with them, as I have no context at all (remember,
we deal with hundreds of changes a day.)

As it is, I can not take these patches at all, sorry, nor should you
want me to.

greg k-h
