Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBFB3DB51C
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 10:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237612AbhG3Ikz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 04:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237956AbhG3Ikz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 04:40:55 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053D0C0613C1
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 01:40:51 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id d8so10269820wrm.4
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 01:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=N9CfuVrE8NyENUiWEeWRoNMyrUFC6+MrHNF+wvFKAa4=;
        b=dY54A5JJtUnUmtjAXSSXy582NMn7sjKikE8oXVGK3P4NkbPQSRfnFK/t7w7JlP5eyK
         +4WezJ4eeWO/O4C7KyEIt4b0FVxKdztwH6LALy+uxUQoJ+K+J5Y/D1JyZKKOv8QMROl8
         gM82ONzfcnydgnbxD66UTCPnAF9vKmmLGruPbp4oyRUatBNQu9NYAhNmlIcFpFXyHJUP
         sZT5YDGkSy3NNF4yndjgWSHeRIQkqfRmU62/5DWBpXY+IgBkImEoJWAZTf6fs5XGtqdP
         HyDq10b5gCU8JGIHA2Ip+zIWRNlPqjlWq/L0JqaAsVyv6zH1ksycj7xWNLzHI0zBGAFB
         /v9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=N9CfuVrE8NyENUiWEeWRoNMyrUFC6+MrHNF+wvFKAa4=;
        b=es9WQwzPabnmldERXGiM4OY1NizuiM0uegW+cRLGlF3E0JCGaBAk3AaK/7g5+bDIsX
         UvXnyDBnKAaI9AFJ3ouAmrVVnPkVqUHba14EtmI2LizZkTiGFODV31BQeRv6X6QpTpE3
         xG0TXakPz1nlEKT43CilPmWSKG1xHEi91PcrwgI9JCesAZ062C99ACJDE92GXHhPJa8G
         QacKUQNUWbH2b/LuU/SKA4TAkhkfL+UKYGyqXkajCG4WFEkogzpbyYaTR6Vdj0jKs3/S
         GS3vbasDlNvit5Wyifd6r6S543o++3cVc8mQhikRKpBmmbZ9xdfUc8VQKusUgt2qvcEu
         /BPQ==
X-Gm-Message-State: AOAM531GPmIK3cr4ss+27F3NX1RxnCPEtez/Ukqt0dDEYmc4WRIWXuku
        sw8Y2RvgijEbJJOvs78ToiA=
X-Google-Smtp-Source: ABdhPJx7fIjxEUopvxM27V9IPXbst19PQVpBh75dmPQ2RveKfTQH2M7reiSV9RpwbWeskmCdTFjn1A==
X-Received: by 2002:adf:f602:: with SMTP id t2mr1741410wrp.232.1627634449694;
        Fri, 30 Jul 2021 01:40:49 -0700 (PDT)
Received: from [192.168.11.11] (156.133.46.217.dyn.plus.net. [217.46.133.156])
        by smtp.googlemail.com with ESMTPSA id x15sm912946wrs.57.2021.07.30.01.40.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jul 2021 01:40:49 -0700 (PDT)
From:   Alan Young <consult.awy@gmail.com>
Subject: Re: FAILED: patch "[PATCH] ALSA: pcm: Call substream ack() method
 upon compat mmap" failed to apply to 4.14-stable tree
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org, tiwai@suse.de
References: <1627286971116209@kroah.com>
Message-ID: <d5aad089-e2f5-2637-eed2-7e9551cfdb26@gmail.com>
Date:   Fri, 30 Jul 2021 09:40:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1627286971116209@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This commit is not applicable before the 64-bit time_t in user space 
with 32-bit compatibility changes introduces by 
80fe7430c7085951d1246d83f638cc17e6c0be36 in 5.6.

On 26/07/2021 09:09, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to<stable@vger.kernel.org>.
>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
>  From 2e2832562c877e6530b8480982d99a4ff90c6777 Mon Sep 17 00:00:00 2001
> From: Alan Young<consult.awy@gmail.com>
> Date: Fri, 9 Jul 2021 09:48:54 +0100
> Subject: [PATCH] ALSA: pcm: Call substream ack() method upon compat mmap
>   commit
>
> If a 32-bit application is being used with a 64-bit kernel and is using
> the mmap mechanism to write data, then the SNDRV_PCM_IOCTL_SYNC_PTR
> ioctl results in calling snd_pcm_ioctl_sync_ptr_compat(). Make this use
> pcm_lib_apply_appl_ptr() so that the substream's ack() method, if
> defined, is called.
>
> The snd_pcm_sync_ptr() function, used in the 64-bit ioctl case, already
> uses snd_pcm_ioctl_sync_ptr_compat().
>
> Fixes: 9027c4639ef1 ("ALSA: pcm: Call ack() whenever appl_ptr is updated")
> Signed-off-by: Alan Young<consult.awy@gmail.com>
> Cc:<stable@vger.kernel.org>
> Link:https://lore.kernel.org/r/c441f18c-eb2a-3bdd-299a-696ccca2de9c@gmail.com
> Signed-off-by: Takashi Iwai<tiwai@suse.de>
>
> diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
> index 14e32825c339..c88c4316c417 100644
> --- a/sound/core/pcm_native.c
> +++ b/sound/core/pcm_native.c
> @@ -3063,9 +3063,14 @@ static int snd_pcm_ioctl_sync_ptr_compat(struct snd_pcm_substream *substream,
>   		boundary = 0x7fffffff;
>   	snd_pcm_stream_lock_irq(substream);
>   	/* FIXME: we should consider the boundary for the sync from app */
> -	if (!(sflags & SNDRV_PCM_SYNC_PTR_APPL))
> -		control->appl_ptr = scontrol.appl_ptr;
> -	else
> +	if (!(sflags & SNDRV_PCM_SYNC_PTR_APPL)) {
> +		err = pcm_lib_apply_appl_ptr(substream,
> +				scontrol.appl_ptr);
> +		if (err < 0) {
> +			snd_pcm_stream_unlock_irq(substream);
> +			return err;
> +		}
> +	} else
>   		scontrol.appl_ptr = control->appl_ptr % boundary;
>   	if (!(sflags & SNDRV_PCM_SYNC_PTR_AVAIL_MIN))
>   		control->avail_min = scontrol.avail_min;
>

