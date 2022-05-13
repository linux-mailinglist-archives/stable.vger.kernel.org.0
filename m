Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09FB2525D86
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 10:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376866AbiEMIcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 04:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378299AbiEMIb5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 04:31:57 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCB264BC8
        for <stable@vger.kernel.org>; Fri, 13 May 2022 01:31:52 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 3C6BA5C013A;
        Fri, 13 May 2022 04:31:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 13 May 2022 04:31:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1652430712; x=1652517112; bh=p2EE+SCtB/
        XSDpee9f2slaCEJe6A2grZj3gJ+psGrFI=; b=OIPWjkrYy1rvZ5zf3vtLvxuQrU
        3txMcoRraX2KYOnWULAkhNdKGCvgVRxU8yivrEJPdjusXcce9m9JCrNhHrP1vwPW
        iyNM3GLIEliI6lFS9X+qeOqpebxeW6k8m0otqIZimaJM530lxXehsbVETnitFNdA
        DIde42W//y5+yTaVm0qI5SlMWdVzl0wvrRQXOJeHv3cvdwozo56H+o74dQZYB8om
        fOvO3xwcgRn7kQKmBxS+KW53WK+8SO8T6TIyH5GAzEPnzVFKzJSnNIctODYsWJUu
        HKLPEgv+PPFD9nHj0FcQu8rfeBGTGGqKfHpXisj8VMns2RavtvUevWazzW4A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1652430712; x=
        1652517112; bh=p2EE+SCtB/XSDpee9f2slaCEJe6A2grZj3gJ+psGrFI=; b=E
        pVvTe5ii0JhPOD4CstFZA//VXN/Wv1CLtKn02Awpt8UWLr8iE8z3qtm+x/Fv9VXE
        6e7k6BkSuHzX0Q/mIBZ5TkiOmjIzQh5Baw3dwfBzGuMAdmK8Kd2N5DlBpqaHwJov
        YwAh/pNOcmBDHrK5SLenkVrxXaTW7BOZGKEMvFE8GIJ0hrcWg2atzTWLKr8bc6Tg
        CY7e78JMdwoWT0uJ7iv1c17rKLPOmUot+sOxh6FXstsb04wtvvI1ieeNvlmN1jqv
        ulC9UkY6HP/HtGcmkCD3BrliZdASD2bYr2tXcUtDWSmVc3tMUKCkB8q6K6NWV54s
        aQz7XFOhXz7KGU4Z42bhA==
X-ME-Sender: <xms:dxd-Yuj5iooG7H-63vgk4YtKlJlpVDnm9GXzW77ADrwFrfw0KobuWg>
    <xme:dxd-YvDziLNDa6FqTjSNEEF9R4xpn6HEWNInr-tfh0ib1DcGIFeqBT7GQkwk-dDs0
    r9YuIaW0Cq6dw>
X-ME-Received: <xmr:dxd-YmHVGXXAsdLu3PAADEduCGKoQrZmqp54XNvHubKLomooLRrgb4gDjIjCPfpMNIgtqaLlEsePz7ZTxJr47sdq3dx4bYIw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrgeelgddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeegheeuhe
    fgtdeluddtleekfeegjeetgeeikeehfeduieffvddufeefleevtddtvdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:dxd-YnRsBCpnFJxtDr7Nwg3Q_jgmxl1TMJGVmz2yaTSzYr93ibuVvA>
    <xmx:dxd-YrwphqwFZKdPWJXskAFCBoJ62eU6B1d08V1PwPHirgX0qEEIFA>
    <xmx:dxd-Yl5J1QDQv6ydzb4Aw28A4gQ0FPDrPduQFydBkBHYTejeSFPfug>
    <xmx:eBd-YinY3DZJ1upptd7TKI0Qgi5VveVjGPSNWPbICoMBSdvzW4af0A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 May 2022 04:31:51 -0400 (EDT)
Date:   Fri, 13 May 2022 10:31:38 +0200
From:   Greg KH <greg@kroah.com>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Hu Jiahui <kirin.say@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>
Subject: Re: [PATCH 4.19 1/5] ALSA: pcm: Fix races among concurrent hw_params
 and hw_free calls
Message-ID: <Yn4XamS/r9/7MK1I@kroah.com>
References: <20220513080018.1302825-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513080018.1302825-1-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 13, 2022 at 11:00:14AM +0300, Ovidiu Panait wrote:
> From: Takashi Iwai <tiwai@suse.de>
> 
> commit 92ee3c60ec9fe64404dc035e7c41277d74aa26cb upstream.
> 
> Currently we have neither proper check nor protection against the
> concurrent calls of PCM hw_params and hw_free ioctls, which may result
> in a UAF.  Since the existing PCM stream lock can't be used for
> protecting the whole ioctl operations, we need a new mutex to protect
> those racy calls.
> 
> This patch introduced a new mutex, runtime->buffer_mutex, and applies
> it to both hw_params and hw_free ioctl code paths.  Along with it, the
> both functions are slightly modified (the mmap_count check is moved
> into the state-check block) for code simplicity.
> 
> Reported-by: Hu Jiahui <kirin.say@gmail.com>
> Cc: <stable@vger.kernel.org>
> Reviewed-by: Jaroslav Kysela <perex@perex.cz>
> Link: https://lore.kernel.org/r/20220322170720.3529-2-tiwai@suse.de
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> [OP: backport to 4.19: adjusted context]
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
>  include/sound/pcm.h     |  1 +
>  sound/core/pcm.c        |  2 ++
>  sound/core/pcm_native.c | 55 +++++++++++++++++++++++++++--------------
>  3 files changed, 39 insertions(+), 19 deletions(-)
> 
> diff --git a/include/sound/pcm.h b/include/sound/pcm.h
> index d6bd3caf6878..0871e16cd04b 100644
> --- a/include/sound/pcm.h
> +++ b/include/sound/pcm.h
> @@ -404,6 +404,7 @@ struct snd_pcm_runtime {
>  	wait_queue_head_t sleep;	/* poll sleep */
>  	wait_queue_head_t tsleep;	/* transfer sleep */
>  	struct fasync_struct *fasync;
> +	struct mutex buffer_mutex;	/* protect for buffer changes */
>  
>  	/* -- private section -- */
>  	void *private_data;
> diff --git a/sound/core/pcm.c b/sound/core/pcm.c
> index b6ed38dec435..a11365dc5349 100644
> --- a/sound/core/pcm.c
> +++ b/sound/core/pcm.c
> @@ -1031,6 +1031,7 @@ int snd_pcm_attach_substream(struct snd_pcm *pcm, int stream,
>  	init_waitqueue_head(&runtime->tsleep);
>  
>  	runtime->status->state = SNDRV_PCM_STATE_OPEN;
> +	mutex_init(&runtime->buffer_mutex);
>  
>  	substream->runtime = runtime;
>  	substream->private_data = pcm->private_data;
> @@ -1062,6 +1063,7 @@ void snd_pcm_detach_substream(struct snd_pcm_substream *substream)
>  	substream->runtime = NULL;
>  	if (substream->timer)
>  		spin_unlock_irq(&substream->timer->lock);
> +	mutex_destroy(&runtime->buffer_mutex);
>  	kfree(runtime);
>  	put_pid(substream->pid);
>  	substream->pid = NULL;
> diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
> index c92eca627840..2b46a2ebefe0 100644
> --- a/sound/core/pcm_native.c
> +++ b/sound/core/pcm_native.c
> @@ -666,33 +666,40 @@ static int snd_pcm_hw_params_choose(struct snd_pcm_substream *pcm,
>  	return 0;
>  }
>  
> +#if IS_ENABLED(CONFIG_SND_PCM_OSS)
> +#define is_oss_stream(substream)	((substream)->oss.oss)
> +#else
> +#define is_oss_stream(substream)	false
> +#endif
> +
>  static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
>  			     struct snd_pcm_hw_params *params)
>  {
>  	struct snd_pcm_runtime *runtime;
> -	int err, usecs;
> +	int err = 0, usecs;
>  	unsigned int bits;
>  	snd_pcm_uframes_t frames;
>  
>  	if (PCM_RUNTIME_CHECK(substream))
>  		return -ENXIO;
>  	runtime = substream->runtime;
> +	mutex_lock(&runtime->buffer_mutex);
>  	snd_pcm_stream_lock_irq(substream);
>  	switch (runtime->status->state) {
>  	case SNDRV_PCM_STATE_OPEN:
>  	case SNDRV_PCM_STATE_SETUP:
>  	case SNDRV_PCM_STATE_PREPARED:
> +		if (!is_oss_stream(substream) &&
> +		    atomic_read(&substream->mmap_count))
> +			err = -EBADFD;
>  		break;
>  	default:
> -		snd_pcm_stream_unlock_irq(substream);
> -		return -EBADFD;
> +		err = -EBADFD;
> +		break;
>  	}
>  	snd_pcm_stream_unlock_irq(substream);
> -#if IS_ENABLED(CONFIG_SND_PCM_OSS)
> -	if (!substream->oss.oss)
> -#endif
> -		if (atomic_read(&substream->mmap_count))
> -			return -EBADFD;
> +	if (err)
> +		goto unlock;
>  
>  	params->rmask = ~0U;
>  	err = snd_pcm_hw_refine(substream, params);
> @@ -769,14 +776,19 @@ static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
>  	if ((usecs = period_to_usecs(runtime)) >= 0)
>  		pm_qos_add_request(&substream->latency_pm_qos_req,
>  				   PM_QOS_CPU_DMA_LATENCY, usecs);
> -	return 0;
> +	err = 0;
>   _error:
> -	/* hardware might be unusable from this time,
> -	   so we force application to retry to set
> -	   the correct hardware parameter settings */
> -	snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
> -	if (substream->ops->hw_free != NULL)
> -		substream->ops->hw_free(substream);
> +	if (err) {
> +		/* hardware might be unusable from this time,
> +		 * so we force application to retry to set
> +		 * the correct hardware parameter settings
> +		 */
> +		snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
> +		if (substream->ops->hw_free != NULL)
> +			substream->ops->hw_free(substream);
> +	}
> + unlock:
> +	mutex_unlock(&runtime->buffer_mutex);
>  	return err;
>  }
>  
> @@ -809,22 +821,27 @@ static int snd_pcm_hw_free(struct snd_pcm_substream *substream)
>  	if (PCM_RUNTIME_CHECK(substream))
>  		return -ENXIO;
>  	runtime = substream->runtime;
> +	mutex_lock(&runtime->buffer_mutex);
>  	snd_pcm_stream_lock_irq(substream);
>  	switch (runtime->status->state) {
>  	case SNDRV_PCM_STATE_SETUP:
>  	case SNDRV_PCM_STATE_PREPARED:
> +		if (atomic_read(&substream->mmap_count))
> +			result = -EBADFD;
>  		break;
>  	default:
> -		snd_pcm_stream_unlock_irq(substream);
> -		return -EBADFD;
> +		result = -EBADFD;
> +		break;
>  	}
>  	snd_pcm_stream_unlock_irq(substream);
> -	if (atomic_read(&substream->mmap_count))
> -		return -EBADFD;
> +	if (result)
> +		goto unlock;
>  	if (substream->ops->hw_free)
>  		result = substream->ops->hw_free(substream);
>  	snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
>  	pm_qos_remove_request(&substream->latency_pm_qos_req);
> + unlock:
> +	mutex_unlock(&runtime->buffer_mutex);
>  	return result;
>  }
>  
> -- 
> 2.36.0
> 

All now queued up, thanks!

greg k-h
