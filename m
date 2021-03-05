Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7888332E07E
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 05:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhCEERM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 23:17:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:51698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229458AbhCEERL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 23:17:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87D256500C;
        Fri,  5 Mar 2021 04:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614917831;
        bh=Zc6jH/y5D3mJkIKC5vVqs3ZTzbN81eOPry2bjbCBQjk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OQz8UGPlRZNWpq3crJx80py1PDo79b2MbEVTnvp+7UTRxxgkzW5hVEAq1gYlvVmi3
         b/HLvlte8HPmBYtqWX4OOUcEzG7tuxMPThR3gutOBzBY+aLa1JnYqY6LK7ci8gmcoW
         WgW2SQW6hqJQXRylENEKK7eBnWPtIm+noQPAaj8UP2g9BbeCWke0j07k/8Zxfw70Mc
         +zVQ3j6Ie2AWuqiAwB2QUO2u0RIGJlox+lFSglTbHDMgze9bpERJVoPKSfF53Zd6ZJ
         +SqOcK+HcgXc8zIGZQ7MS7KhgfhPoJaLhuxBzrm5//gRryzlYXBSgGgnakh5PyR4YU
         Pj5doL8e/+v5A==
Date:   Fri, 5 Mar 2021 09:47:07 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     srinivas.kandagatla@linaro.org, stable-commits@vger.kernel.org
Subject: Re: Patch "soundwire: debugfs: use controller id instead of link_id"
 has been added to the 5.11-stable tree
Message-ID: <YEGww3u0QR3pYGhF@vkoul-mobl>
References: <161487107335140@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161487107335140@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 04-03-21, 16:17, gregkh@linuxfoundation.org wrote:
> 
> This is a note to let you know that I've just added the patch titled
> 
>     soundwire: debugfs: use controller id instead of link_id
> 
> to the 5.11-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      soundwire-debugfs-use-controller-id-instead-of-link_id.patch
> and it can be found in the queue-5.11 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

Please drop this patch from stable, it was not tagged to stable and it
is reverted

Thanks



> 
> 
> >From 6d5e7af1f6f5924de5dd1ebe97675c2363100878 Mon Sep 17 00:00:00 2001
> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Date: Fri, 15 Jan 2021 16:25:59 +0000
> Subject: soundwire: debugfs: use controller id instead of link_id
> 
> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> 
> commit 6d5e7af1f6f5924de5dd1ebe97675c2363100878 upstream.
> 
> link_id can be zero and if we have multiple controller instances
> in a system like Qualcomm debugfs will end-up with duplicate namespace
> resulting in incorrect debugfs entries.
> 
> Using id should give a unique debugfs directory entry and should fix below
> warning too.
> "debugfs: Directory 'master-0' with parent 'soundwire' already present!"
> 
> Fixes: bf03473d5bcc ("soundwire: add debugfs support")
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Link: https://lore.kernel.org/r/20210115162559.20869-1-srinivas.kandagatla@linaro.org
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/soundwire/debugfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/soundwire/debugfs.c
> +++ b/drivers/soundwire/debugfs.c
> @@ -19,7 +19,7 @@ void sdw_bus_debugfs_init(struct sdw_bus
>  		return;
>  
>  	/* create the debugfs master-N */
> -	snprintf(name, sizeof(name), "master-%d", bus->link_id);
> +	snprintf(name, sizeof(name), "master-%d", bus->id);
>  	bus->debugfs = debugfs_create_dir(name, sdw_debugfs_root);
>  }
>  
> 
> 
> Patches currently in stable-queue which might be from srinivas.kandagatla@linaro.org are
> 
> queue-5.11/asoc-qcom-remove-useless-debug-print.patch
> queue-5.11/soundwire-debugfs-use-controller-id-instead-of-link_id.patch

-- 
~Vinod
