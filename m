Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8239D4D6DD6
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 10:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbiCLJpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 04:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiCLJpY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 04:45:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25A4344D7;
        Sat, 12 Mar 2022 01:44:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F93CB8069C;
        Sat, 12 Mar 2022 09:44:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE096C340EB;
        Sat, 12 Mar 2022 09:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647078257;
        bh=hcEZK6STxb1KW63OqC+3/M1UffAiIRQsYQQcL04nr0A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dZxNgAZ8DFbqesUj+hFzCjv4qrTtoqPwtt1uPsqsFeXwIAOLAztRn6QM9euvYhoLt
         3HcZG6qICY4fMfqJ0DoWYfbqam88NTS3ZOeIOIp/qj46Cksrq8CYwObpUNXCRm0wcA
         SqPv5K+va6FBgVuAnYA14WeMP3F/8ZWkEynJJ710=
Date:   Sat, 12 Mar 2022 10:44:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     linux-doc@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Documentation: add link to stable release candidate
 tree
Message-ID: <YixrbWkVPx76a/E5@kroah.com>
References: <20220312080043.37581-1-bagasdotme@gmail.com>
 <20220312080043.37581-4-bagasdotme@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220312080043.37581-4-bagasdotme@gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 12, 2022 at 03:00:42PM +0700, Bagas Sanjaya wrote:
> There is also stable release candidate tree. Mention it.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Sasha Levin <sashal@kernel.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  Documentation/process/stable-kernel-rules.rst | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/process/stable-kernel-rules.rst b/Documentation/process/stable-kernel-rules.rst
> index c0c87d87f7d..523d2d35127 100644
> --- a/Documentation/process/stable-kernel-rules.rst
> +++ b/Documentation/process/stable-kernel-rules.rst
> @@ -183,6 +183,10 @@ Trees
>  
>  	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
>  
> + - The release candidate of all stable kernel versions can be found at:
> +
> +        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/
> +

Please add something here that says this tree will be rebased often and
should only be used for testing CI systems to pull from.  It is a
snapshot in time of the stable-queue.git tree and will change
frequently.

In short, I really don't like people using this tree, but have provided
it for those CI systems that don't like dealing with quilt patches only.

I also constantly forget to push the release tags to it, as I'm reminded
frequently :)

thanks,

greg k-h
