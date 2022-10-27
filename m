Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E1060F107
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 09:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233565AbiJ0HQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 03:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234291AbiJ0HQU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 03:16:20 -0400
Received: from smtp2.axis.com (smtp2.axis.com [195.60.68.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3157285D;
        Thu, 27 Oct 2022 00:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1666854980;
  x=1698390980;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DgpmxpJLQoE0t4/UnPA3rE8eNHNh7Re4EvIrdHUUArM=;
  b=DnXOoSFt1t6DLb/F6pTJpRdLmxiNdIYdInnOY4V1CYRjyge5GcSjqJ8S
   QupWKSTWXQ3/7ir9DOgDJbLm6b8dJh1t200UCp1A87w7w8bxrvtUNepJn
   yMUw1Dv2mY6aITIzWvpAFOEp2luzZ30ajGTdGTUVY3vXy4Ac+TfgA1Vsx
   Q4uo9FMEISlV8Y7d0KcS2t0q8k5d9zAE+Xglm/0WMDVvusTqLTSya1zfL
   zttgITF7urcBQ36pkrZR9Bem2RcPfwBaH6/TjKvRYNfu6ABrZ5lR2hLgT
   1GvdZczwunOImW5x1+ZjFQO8cB9HCcK5WiwnjBoVfyKqrOouB4Y1Hmh5z
   w==;
Date:   Thu, 27 Oct 2022 09:16:17 +0200
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     Sasha Levin <sashal@kernel.org>, <stable@vger.kernel.org>
CC:     "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: Patch "mmc: core: Support zeroout using TRIM for eMMC" has been
 added to the 5.15-stable tree
Message-ID: <Y1owQYlr+vfxEmS8@axis.com>
References: <20221027015309.384916-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221027015309.384916-1-sashal@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 03:53:08AM +0200, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
>     mmc: core: Support zeroout using TRIM for eMMC
> 
> to the 5.15-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      mmc-core-support-zeroout-using-trim-for-emmc.patch
> and it can be found in the queue-5.15 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
> 
> commit d3cc702e4a9f80cf1ae41399593d843d4c509e08
> Author: Vincent Whitchurch <vincent.whitchurch@axis.com>
> Date:   Fri Apr 29 17:21:18 2022 +0200
> 
>     mmc: core: Support zeroout using TRIM for eMMC
>     
>     [ Upstream commit f7b6fc327327698924ef3afa0c3e87a5b7466af3 ]
>     
>     If an eMMC card supports TRIM and indicates that it erases to zeros, we can
>     use it to support hardware offloading of REQ_OP_WRITE_ZEROES, so let's add
>     support for this.
>     
>     Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
>     Reviewed-by: Avri Altman <Avri.Altman@wdc.com>
>     Link: https://lore.kernel.org/r/20220429152118.3617303-1-vincent.whitchurch@axis.com
>     Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>     Stable-dep-of: 07d2872bf4c8 ("mmc: core: Add SD card quirk for broken discard")
>     Signed-off-by: Sasha Levin <sashal@kernel.org>

This patch is not stable material, please do not backport it.
