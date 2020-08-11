Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85EEA241895
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 10:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgHKI4P convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 11 Aug 2020 04:56:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35852 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728390AbgHKI4O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 04:56:14 -0400
Received: from mail-pg1-f198.google.com ([209.85.215.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1k5Q4p-0002Sd-Gz
        for stable@vger.kernel.org; Tue, 11 Aug 2020 08:56:11 +0000
Received: by mail-pg1-f198.google.com with SMTP id l20so8298833pgn.23
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 01:56:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=u21NqTiGBaO3K/btYj1Wn3aQqEJu/JKT9VndsfXZEPI=;
        b=h+8VRJ0162VmnMNKk7N6uXU4A164LPQKzUpTgqCaAAEXasq4leeSE6m3OLJXto40Hy
         SW4YmhTQ02gJEMLh7KMxrs9ZC3G1L3tywnktbUdLcRJHFFI01SkS26TcETxaWaDxF4SO
         3WI5LFR3SknaER+aDhyW4++THPT9I2EhQ6OjjLcB7SZ8GHxFtUmRoP4YB6mN1IKy/2TD
         dd+wjqan+jz9aeNHRSEC4gEzcYg6qz++XD25pcPj+5TZFHgpQgTzlgPO7RJu+7Acgvyi
         eUddjmztiOSqn3zoPSYxH+aJwY18uK5Wh/6NnwjwXmIVoqed6PWhHhG4EUOrG5ns5V32
         CsLA==
X-Gm-Message-State: AOAM530ItyCFdvMfPCnr6wmW+69zXc95ksSnQcfNzJIZ/mfkK8KH3gS1
        Qeq75Z9Y332brNdge77wJx0G8YYWx0P+IdK6o6XiEVVEmJng9P+dcJfby6FqLJh/dnJH+Zg7XGx
        pcst+mCAAXXk1i6ZmQJPqkWrbEvObdeihCg==
X-Received: by 2002:a17:90a:c781:: with SMTP id gn1mr12972pjb.151.1597136169876;
        Tue, 11 Aug 2020 01:56:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7PvV/m+33ro9dfryiIo4G78TwNxgylekeGjGa/1zQVw9IhU/vDyVlS84kqG1cPozrtHHlww==
X-Received: by 2002:a17:90a:c781:: with SMTP id gn1mr12945pjb.151.1597136169437;
        Tue, 11 Aug 2020 01:56:09 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id w23sm20160621pgj.5.2020.08.11.01.56.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Aug 2020 01:56:08 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH] ALSA: hda - fix the micmute led status for Lenovo
 ThinkCentre AIO
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <s5ha6z36lk8.wl-tiwai@suse.de>
Date:   Tue, 11 Aug 2020 16:56:06 +0800
Cc:     Hui Wang <hui.wang@canonical.com>,
        "moderated list:SOUND" <alsa-devel@alsa-project.org>,
        stable@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <01D08974-C4EB-4820-9870-42B633DC19B3@canonical.com>
References: <20200810021659.7429-1-hui.wang@canonical.com>
 <s5hd03z6min.wl-tiwai@suse.de>
 <c8ca5bd3-d9a1-6269-e088-6bc6e3936876@canonical.com>
 <s5ha6z36lk8.wl-tiwai@suse.de>
To:     Takashi Iwai <tiwai@suse.de>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

> On Aug 10, 2020, at 14:51, Takashi Iwai <tiwai@suse.de> wrote:
> 
> On Mon, 10 Aug 2020 08:34:36 +0200,
> Hui Wang wrote:
>> 
>> 
>> On 2020/8/10 下午2:30, Takashi Iwai wrote:
>>> On Mon, 10 Aug 2020 04:16:59 +0200,
>>> Hui Wang wrote:
>>>> After installing the Ubuntu Linux, the micmute led status is not
>>>> correct. Users expect that the led is on if the capture is disabled,
>>>> but with the current kernel, the led is off with the capture disabled.
>>>> 
>>>> We tried the old linux kernel like linux-4.15, there is no this issue.
>>>> It looks like we introduced this issue when switching to the led_cdev.
>>> The behavior can be controlled via "Mic Mute-LED Mode" enum kcontrol.
>>> Which value does it have now?  If it's "Follow Capture", that's the
>>> correct behavior.  OTOH, if it's "Follow Mute", the LED polarity is
>>> indeed wrong.
>> 
>> It is "Follow Mute",  if I change it to "Follow Capture" manually, the
>> led status becomes correct.
> 
> OK, thanks for confirmation.  Applied now.

I wonder if it's because how brightness value passed to gpio_mute_led_set() and micmute_led_set():

static int gpio_mute_led_set(struct led_classdev *led_cdev,
                             enum led_brightness brightness)
{
        struct hda_codec *codec = dev_to_hda_codec(led_cdev->dev->parent);
        struct alc_spec *spec = codec->spec;

        alc_update_gpio_led(codec, spec->gpio_mute_led_mask,
                            spec->mute_led_polarity, !brightness);
        return 0;
}

static int micmute_led_set(struct led_classdev *led_cdev,
                           enum led_brightness brightness)
{
        struct hda_codec *codec = dev_to_hda_codec(led_cdev->dev->parent);
        struct alc_spec *spec = codec->spec;

        alc_update_gpio_led(codec, spec->gpio_mic_led_mask,
                            spec->micmute_led_polarity, !!brightness);      
        return 0;
}

Maybe we should let micmute_led_set() match gpio_mute_led_set() so the micmute polarity can be removed?

Kai-Heng

> 
> 
> Takashi

