Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 923D74D6DCD
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 10:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbiCLJmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 04:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231633AbiCLJml (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 04:42:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FEF91E7A4D;
        Sat, 12 Mar 2022 01:41:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE6C3608C4;
        Sat, 12 Mar 2022 09:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3803C340EB;
        Sat, 12 Mar 2022 09:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647078095;
        bh=74Qk+1Lz/y7wm8qSZrARmBvUukIFHvun9Zno4jfx6FY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HM+0sFoDr8Q/js1IW0R8AzUT3ch38BnyEGZlgWC1PYjK+1gEeFbKVS+yTd9Lur4LZ
         BBnCEWIItwB/QD3PLmmodkNF9byuR3N/JsA62XCmav1lMRl2iEHpGRwEinUgKoxrsJ
         3MjSzfAb5EWyTAJ6zvVXwluo1nm+xt/FUHsStGOY=
Date:   Sat, 12 Mar 2022 10:41:31 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     linux-doc@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] Documentation: update stable tree link
Message-ID: <Yixqy++gz6pEAsmL@kroah.com>
References: <20220312080043.37581-1-bagasdotme@gmail.com>
 <20220312080043.37581-5-bagasdotme@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220312080043.37581-5-bagasdotme@gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 12, 2022 at 03:00:43PM +0700, Bagas Sanjaya wrote:
> The link to stable tree is redirected to
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git. Update
> accordingly.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Sasha Levin <sashal@kernel.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  Documentation/process/stable-kernel-rules.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/process/stable-kernel-rules.rst b/Documentation/process/stable-kernel-rules.rst
> index 523d2d35127..c242fe1788c 100644
> --- a/Documentation/process/stable-kernel-rules.rst
> +++ b/Documentation/process/stable-kernel-rules.rst
> @@ -181,7 +181,7 @@ Trees
>   - The finalized and tagged releases of all stable kernels can be found
>     in separate branches per version at:
>  
> -	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
> +	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git

I should take this change right now as this should have been changed a
while ago.

thanks,

greg k-h
