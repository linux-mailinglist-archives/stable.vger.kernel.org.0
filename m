Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA434323E13
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236584AbhBXNYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:24:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234798AbhBXNTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 08:19:03 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2CFC06174A;
        Wed, 24 Feb 2021 05:18:00 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id g5so3016040ejt.2;
        Wed, 24 Feb 2021 05:18:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LXMkDdorsWFPtdrDM7+glKcfLi3dZE94irm5Fz1OGxk=;
        b=DMXFCNhDdgPWnsMshFEUe6+gFqCEQhp4+1z73CkPWntA8Skg0pqJ8uyg+Nh4Z6/BKs
         lX8RbffPYPls23fJnmJe2C5oL+uo3sITmH/0tBaIfP370Ql95gmEZUsQ/wtUY9TkpYTk
         84yGq19NsHryOT8/XshQHwvewpLQRD5GIsNNhutYMwYaiTM+bhokMyMVCQ4WP4iPcaHD
         AJ2S+WqX6APOKcKzfd6dNMIw7GZNo6WMYATNRGmZ9EsEku7DZhkI7C4jiR+F3+EG0+tl
         vsMnk6o6PeO6lO2mmJzhGIQz7ecITcOJXzunHU0fI7MgW78cN6GAszLdcvePKfr0NtXL
         53ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LXMkDdorsWFPtdrDM7+glKcfLi3dZE94irm5Fz1OGxk=;
        b=EIycH/VARUBVmFuMFreSjoXov6rZd0a9Rqwa8fOxaSiVLP7HRhfeW+xWF/B/uEVPoG
         HbEhOWnAvq6Bk4e6nK2NR1sv1bVT3H6SbSaqPZMFkW8KubAcT6ndEUjMXw5MmMRX9BMC
         AzQNICvKep70kwcNsAaFUcorSvE9bRLI28zUT0DPQ3I8BlrXz9TP8gqBrCv+CvN3xsNV
         lmsfQzDbWp2qLBUHl6kWUBXhD1KJKRB8A4bBpWxvud6cwmQRI2oFJtqAKB9frnJNoIyA
         Ug3YHfy8lXB90LGHJDNBbDD+ta0AGH576OSYFhOL6zuQtbqEiOiZCzHjl3iRhX8HmziC
         mixg==
X-Gm-Message-State: AOAM533fHzrKaAZpCJM/apKQZsLW6KNlMfEGYgzhEGP0U/RyeT2c6F7I
        mS5OqAbA9cI0Gx0llfRVBRk=
X-Google-Smtp-Source: ABdhPJyI37ZlW3HePqgevNJIQC3//kd1P+tYfwt17Tc+iTjt+edpUd/xYjWHDPwjhEXZbDdqICZt+Q==
X-Received: by 2002:a17:906:5391:: with SMTP id g17mr14490550ejo.283.1614172678863;
        Wed, 24 Feb 2021 05:17:58 -0800 (PST)
Received: from anparri (host-82-59-6-76.retail.telecomitalia.it. [82.59.6.76])
        by smtp.gmail.com with ESMTPSA id p3sm1552520edu.64.2021.02.24.05.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 05:17:58 -0800 (PST)
Date:   Wed, 24 Feb 2021 14:17:55 +0100
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Juan Vazquez <juvazq@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.11 51/67] Drivers: hv: vmbus: Resolve race
 condition in vmbus_onoffer_rescind()
Message-ID: <20210224131755.GB1920@anparri>
References: <20210224125026.481804-1-sashal@kernel.org>
 <20210224125026.481804-51-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224125026.481804-51-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 24, 2021 at 07:50:09AM -0500, Sasha Levin wrote:
> From: "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
> 
> [ Upstream commit e4d221b42354b2e2ddb9187a806afb651eee2cda ]
> 
> An erroneous or malicious host could send multiple rescind messages for
> a same channel.  In vmbus_onoffer_rescind(), the guest maps the channel
> ID to obtain a pointer to the channel object and it eventually releases
> such object and associated data.  The host could time rescind messages
> and lead to an use-after-free.  Add a new flag to the channel structure
> to make sure that only one instance of vmbus_onoffer_rescind() can get
> the reference to the channel object.
> 
> Reported-by: Juan Vazquez <juvazq@microsoft.com>
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> Link: https://lore.kernel.org/r/20201209070827.29335-6-parri.andrea@gmail.com
> Signed-off-by: Wei Liu <wei.liu@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Sasha - This patch is one of a group of patches where a Linux guest running on
Hyper-V will start assuming that hypervisor behavior might be malicious, and
guards against such behavior.  Because this is a new assumption, these patches
are more properly treated as new functionality rather than as bug fixes.  So I
would propose that we *not* bring such patches back to stable branches.

Thanks,
  Andrea


> ---
>  drivers/hv/channel_mgmt.c | 12 ++++++++++++
>  include/linux/hyperv.h    |  1 +
>  2 files changed, 13 insertions(+)
> 
> diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
> index 1d44bb635bb84..a9f58840f85dc 100644
> --- a/drivers/hv/channel_mgmt.c
> +++ b/drivers/hv/channel_mgmt.c
> @@ -1049,6 +1049,18 @@ static void vmbus_onoffer_rescind(struct vmbus_channel_message_header *hdr)
>  
>  	mutex_lock(&vmbus_connection.channel_mutex);
>  	channel = relid2channel(rescind->child_relid);
> +	if (channel != NULL) {
> +		/*
> +		 * Guarantee that no other instance of vmbus_onoffer_rescind()
> +		 * has got a reference to the channel object.  Synchronize on
> +		 * &vmbus_connection.channel_mutex.
> +		 */
> +		if (channel->rescind_ref) {
> +			mutex_unlock(&vmbus_connection.channel_mutex);
> +			return;
> +		}
> +		channel->rescind_ref = true;
> +	}
>  	mutex_unlock(&vmbus_connection.channel_mutex);
>  
>  	if (channel == NULL) {
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 5ddb479c4d4cb..ef3573e99d989 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -803,6 +803,7 @@ struct vmbus_channel {
>  	u8 monitor_bit;
>  
>  	bool rescind; /* got rescind msg */
> +	bool rescind_ref; /* got rescind msg, got channel reference */
>  	struct completion rescind_event;
>  
>  	u32 ringbuffer_gpadlhandle;
> -- 
> 2.27.0
> 
