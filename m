Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA347614BC3
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 14:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiKAN34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 09:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiKAN3x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 09:29:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B3715823;
        Tue,  1 Nov 2022 06:29:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1C9461230;
        Tue,  1 Nov 2022 13:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B84BC433C1;
        Tue,  1 Nov 2022 13:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667309392;
        bh=wgF15WbJ4A+wAddVowTV506/Nopb/uRZ9KyWYptTzhA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pl5ABAXDmGEeIsqlW28nJu7jlaPPfuI+ZvKmmel1BPJawCqB/s/+XBYfrltusPp+E
         15lGgJvKyF4FeCtf9ukMM9Qpcfcz7FvUDS8qbGu8pmL9S7eDixDq24s0JgX8Tdh43w
         q90lAg3ujLB4bIfKIH21TCnwrVQ1KalpAu/zOBvY=
Date:   Tue, 1 Nov 2022 14:30:45 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     stable@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@denx.de>,
        Biju Das <biju.das.jz@bp.renesas.com>
Subject: Re: [PATCH] Documentation: process: Describe kernel version prefix
 for third option
Message-ID: <Y2EfhWxk0j/oVLJx@kroah.com>
References: <20221101131743.371340-1-bagasdotme@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101131743.371340-1-bagasdotme@gmail.com>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 01, 2022 at 08:17:43PM +0700, Bagas Sanjaya wrote:
> The current wording on third option of stable kernel submission doesn't
> mention how to specify desired kernel version. Submitters reading the
> documentation could simply send multiple backported patches of the same
> upstream commit without any kernel version information, leaving stable
> maintainers and reviewers hard time to figure out the correct kernel
> version to be applied.
> 
> Describe the subject prefix for specifying kernel version for the case
> above.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  This patch is sent as response to [1].
> 
>  [1]: https://lore.kernel.org/stable/20221101074351.GA8310@amd/
> 
>  Documentation/process/stable-kernel-rules.rst | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/process/stable-kernel-rules.rst b/Documentation/process/stable-kernel-rules.rst
> index 2fd8aa593a2851..409ae73c1ffcd1 100644
> --- a/Documentation/process/stable-kernel-rules.rst
> +++ b/Documentation/process/stable-kernel-rules.rst
> @@ -77,7 +77,9 @@ Option 3
>  Send the patch, after verifying that it follows the above rules, to
>  stable@vger.kernel.org.  You must note the upstream commit ID in the
>  changelog of your submission, as well as the kernel version you wish
> -it to be applied to.
> +it to be applied to by adding desired kernel version number to the
> +patch subject prefix. For example, patches targeting 5.15 kernel should
> +have ``[PATCH 5.15]`` prefix.

No, sorry, this is not needed and does not have to be in the subject
line at all.

The current wording is fine, it's just that people don't always read it.

so consider this a NAK.

thanks,

greg k-h-
