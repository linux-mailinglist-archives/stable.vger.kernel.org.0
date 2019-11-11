Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6614F7AC5
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfKKS2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:28:33 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33424 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbfKKS2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 13:28:32 -0500
Received: by mail-pg1-f195.google.com with SMTP id h27so9976571pgn.0;
        Mon, 11 Nov 2019 10:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RbCZSYiVTU101K0AA6gbWFKQ+nZynWbnU7jW8rMxKYg=;
        b=SRNx4uCNBMhfemthmSO/MfE8FdhBpN2WtxKpWHR9+pqp+iX2ymL7ktoZu6I63kKGtM
         b9YxNLLyJlJvhzmqbSOHokptSjB1VBLhEL0KFXsXy++WUMRAgYCqQvU87TA6IegVgLiF
         BARAnkjtYz0DVbvnyZmnUpCg4P7C9b6+YM3TFM90qgUo8J7tMjAUTKyKBWTUQG97KBep
         62UbBPEKCS+PeF12cC8XgESL+cFtEAjDGfdCogeNEfYgKDme2P6gfkHnJJ6nBHeMDFBq
         qg0ax6E9lbMLh2RVEYaaS1vC1XkKmBCJm2jheviAQZqlyFAY/NoaqL+DdPWykBh9k+pi
         XLMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RbCZSYiVTU101K0AA6gbWFKQ+nZynWbnU7jW8rMxKYg=;
        b=GqU8kuRCEpESXDnBXQvzJPd7mNrjIPhFTm9/k/dhG/vp/AI6bCrHq/mvERvw0uO+KZ
         zk857lgWA0EElNi8EuRHM3ltoACEyc/mTn92MJZlRnT3ZSJmlmMblUjdzaqWt9kIynWn
         OYid7SofSa5ylgRsWfolpU+FXo6h3nSFRKNNwPZJAS99Z1sSI/YG6/emoLpeNreGzJPc
         uA80l4dhE93WSD1T0y2kSMGngnJRDrrP3RGbq+VzRvlc20i6ACQLr1+8EeUS7vA8HMKg
         /oMDioWJSJdugcw9xlCDiz7p511sVh8zb00eFoE+iywro/0qiNBn0ukLtT1SBpVjuJhP
         f20w==
X-Gm-Message-State: APjAAAV3fplQo4hFWDVK7qWeRVt8Zm54BZqGTYAYj0F7O43rEpFave2y
        NaylUnuY/zrqfS4aRUStEY0=
X-Google-Smtp-Source: APXvYqyw47XTWwwm7rzrpkFmKJBvHWRie8OeGw9ToQTp9sFTkPYKJ5qr6Rgqa39mRw2qfrFCSfDloA==
X-Received: by 2002:a63:134a:: with SMTP id 10mr30128602pgt.441.1573496910944;
        Mon, 11 Nov 2019 10:28:30 -0800 (PST)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id 12sm144320pjm.11.2019.11.11.10.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 10:28:30 -0800 (PST)
Date:   Mon, 11 Nov 2019 10:28:28 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 8/8] Input: input_event: fix struct padding on sparc64
Message-ID: <20191111182828.GC57214@dtor-ws>
References: <20191108203435.112759-1-arnd@arndb.de>
 <20191108203435.112759-9-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108203435.112759-9-arnd@arndb.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Arnd,

On Fri, Nov 08, 2019 at 09:34:31PM +0100, Arnd Bergmann wrote:
> Going through all uses of timeval, I noticed that we screwed up
> input_event in the previous attempts to fix it:
> 
> The time fields now match between kernel and user space, but
> all following fields are in the wrong place.
> 
> Add the required padding that is implied by the glibc timeval
> definition to fix the layout, and add explicit initialization
> to avoid leaking kernel stack data.
> 
> Cc: sparclinux@vger.kernel.org
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: stable@vger.kernel.org
> Fixes: 141e5dcaa735 ("Input: input_event - fix the CONFIG_SPARC64 mixup")
> Fixes: 2e746942ebac ("Input: input_event - provide override for sparc64")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/input/evdev.c       | 3 +++
>  drivers/input/misc/uinput.c | 3 +++
>  include/uapi/linux/input.h  | 1 +
>  3 files changed, 7 insertions(+)
> 
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index d7dd6fcf2db0..24a90793caf0 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -228,6 +228,9 @@ static void __pass_event(struct evdev_client *client,
>  						event->input_event_sec;
>  		client->buffer[client->tail].input_event_usec =
>  						event->input_event_usec;
> +#ifdef CONFIG_SPARC64
> +		client->buffer[client->tail].__pad = 0;
> +#endif
>  		client->buffer[client->tail].type = EV_SYN;
>  		client->buffer[client->tail].code = SYN_DROPPED;
>  		client->buffer[client->tail].value = 0;

I do not like ifdefs here, do you think we could write:

		client->buffer[client->tail] = (struct input_event) {
			.input_event_sec = event->input_event_sec,
			.input_event_usec = event->input_event_usec,
			.type = EV_SYN,
			.code = SYN_DROPPED,
		};

to ensure all padded fields are initialized? This is not hot path as we
do not expect queue to overfill too often.

Thanks.

-- 
Dmitry
