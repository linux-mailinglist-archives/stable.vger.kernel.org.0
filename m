Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02DC4D6DCA
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 10:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbiCLJly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 04:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiCLJly (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 04:41:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475771E6EAA;
        Sat, 12 Mar 2022 01:40:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE7F560A25;
        Sat, 12 Mar 2022 09:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB41CC340EB;
        Sat, 12 Mar 2022 09:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647078048;
        bh=ZVSVuE716SVWZ8ing31mCUoBFVx1GTpTayrR9ETv+bk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t4jUIJf0p0/kzAiStf+ONlCOqNGOfx7YdTg+vXbePV8tlR75Km0Vo8xA3Zgs15Ggi
         zvC47q+Cy3RCGAQHcZIVCR5BqaACuO0+cyWLGsxf1GBohM1yGFMaBgRvF1/9WTyQiF
         dyUbmNnKaUmdxpoOCN3lOf0j7BUEmhXi4ck6+tPw=
Date:   Sat, 12 Mar 2022 10:40:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     linux-doc@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] Documentation: update stable review cycle
 documentation
Message-ID: <YixqnPTe0Wr6E1G3@kroah.com>
References: <20220312080043.37581-1-bagasdotme@gmail.com>
 <20220312080043.37581-3-bagasdotme@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220312080043.37581-3-bagasdotme@gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 12, 2022 at 03:00:41PM +0700, Bagas Sanjaya wrote:
> In recent times, the review cycle for stable releases have been changed.
> In particular, there is release candidate phase between ACKing patches
> and new stable release. Also, in case of failed submissions (fail to
> apply to stable tree), manual backport (Option 3) have to be submitted
> instead.
> 
> Update the release cycle documentation on stable-kernel-rules.rst to
> reflect the above.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Sasha Levin <sashal@kernel.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  Documentation/process/stable-kernel-rules.rst | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/process/stable-kernel-rules.rst b/Documentation/process/stable-kernel-rules.rst
> index d8ce4c0c775..c0c87d87f7d 100644
> --- a/Documentation/process/stable-kernel-rules.rst
> +++ b/Documentation/process/stable-kernel-rules.rst
> @@ -139,6 +139,9 @@ Following the submission:
>     days, according to the developer's schedules.
>   - If accepted, the patch will be added to the -stable queue, for review by
>     other developers and by the relevant subsystem maintainer.
> + - Some submitted patches may fail to apply to -stable tree. When this is the
> +   case, the maintainer will reply to the sender requesting the backport.

This is tricky, as yes, most of the time this happens, but there are
exceptions.  I would just leave this out for now as I don't think it
helps anyone, right?

> +   If no backport is made, the submission will be ignored.

That's kind of obvious :)


> @@ -147,13 +150,22 @@ Review cycle
>   - When the -stable maintainers decide for a review cycle, the patches will be
>     sent to the review committee, and the maintainer of the affected area of
>     the patch (unless the submitter is the maintainer of the area) and CC: to
> -   the linux-kernel mailing list.
> +   the linux-kernel mailing list. Patches are prefixed with either ``[PATCH
> +   AUTOSEL]`` (for automatically selected patches) or ``[PATCH MANUALSEL]``
> +   for manually backported patches.

These two prefixes are different and not part of the review cycle for
the normal releases.  So that shouldn't go into this list.  Perhaps a
different section?

>   - The review committee has 48 hours in which to ACK or NAK the patch.
>   - If the patch is rejected by a member of the committee, or linux-kernel
>     members object to the patch, bringing up issues that the maintainers and
>     members did not realize, the patch will be dropped from the queue.
> - - At the end of the review cycle, the ACKed patches will be added to the
> -   latest -stable release, and a new -stable release will happen.
> + - The ACKed patches will be posted again as part of release candidate (-rc)

Is this the first place we call it "-rc"?

> +   to be tested by developers and users willing to test (testers). When

No need for "(testers)".

> +   testing all went OK, they can give Tested-by: tag for the -rc. Usually

"testing all went OK" is a bit ackward.  How about this wording instead:
	Responses to the -rc releases can be done on the mailing list by
	sending a "Tested-by:" email with any other testing information
	desired.  The "Tested-by:" tags will be collected and added to
	the release commit.

Thanks for taking this on, it's been a long time since we looked at this
document.

thanks,

greg k-h
