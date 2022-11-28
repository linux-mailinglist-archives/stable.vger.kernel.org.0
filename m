Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA5C863AEB4
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbiK1RR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbiK1RR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:17:28 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C3925E87
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 09:17:26 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id k2-20020a17090a4c8200b002187cce2f92so14679398pjh.2
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 09:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DWFgfn7sl4yRxD6csRHBAYHMq81sRHzc2nkScUHiHKo=;
        b=WTIMKifgTx7fIvYm6ryFKZeDz9eDqd4eUILvbSnXYv+qBvhCFbDN5WIzqgN1Ig0gGY
         FrFkCuK9k61a2Ut7hudNt5CNn1qoMrE66Ggs+sQKYD+Ma3hrUQ1txkEz412JaNxnHrrH
         wGZLhEyAK5D9hklt2yjpqybl2BxHqGdAqSVII=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DWFgfn7sl4yRxD6csRHBAYHMq81sRHzc2nkScUHiHKo=;
        b=GBj5ycreb/yOqtfnzpGmAvZxY9yd0VQtxgXJCGCaaNZ1EToVl3d5iVh89RkCl66k57
         h33qZkLlADfLfoCczQfuJJfIafW2nkibR+e4SzmJFefByj6Y73NMk20uWjgg7o0XnX38
         eICJaODrfT1TaZnzaXTYjdEauezYrczOSV/5mG2ZD9rMT1JmYApu77egfBKCbp1mmDL+
         vx2XgLWBMR8LigFo2DieALrJjl3hWuMT1S7pDzLS2EWt6zt7fVghQM4os1l6vxb+ye8Z
         UytyGcW9Vp4w2c0WUT0nFYPlx4AqA2vdmmIskFm7J+w050t+WfWAzem97Zxg3YL0TDyd
         PvtQ==
X-Gm-Message-State: ANoB5pnAXwepeqJlqWjEpMoeRO7bRhN3G1AGMUIeF1Ngsf+o1yYZf3j1
        aGYL82Ljg+ny78cNZswiE/TxTjt4559fp2T4
X-Google-Smtp-Source: AA0mqf5vbC/gLhWCMjfkn4LU6li/fR7OjWz4EV1GCfw5ayLiKzmRGJ0afiflkOUBJ/qkbST/vDPmeA==
X-Received: by 2002:a17:902:ec01:b0:188:b8cf:83f with SMTP id l1-20020a170902ec0100b00188b8cf083fmr35545287pld.134.1669655845972;
        Mon, 28 Nov 2022 09:17:25 -0800 (PST)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com. [209.85.210.170])
        by smtp.gmail.com with ESMTPSA id m14-20020a17090a34ce00b00218b47be793sm7776891pjf.3.2022.11.28.09.17.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 09:17:25 -0800 (PST)
Received: by mail-pf1-f170.google.com with SMTP id 140so11137705pfz.6
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 09:17:25 -0800 (PST)
X-Received: by 2002:a05:6e02:66d:b0:303:1196:96c7 with SMTP id
 l13-20020a056e02066d00b00303119696c7mr2904256ilt.133.1669655452584; Mon, 28
 Nov 2022 09:10:52 -0800 (PST)
MIME-Version: 1.0
References: <20221127-snd-freeze-v5-0-4ededeb08ba0@chromium.org> <alpine.DEB.2.22.394.2211281629120.3532114@eliteleevi.tm.intel.com>
In-Reply-To: <alpine.DEB.2.22.394.2211281629120.3532114@eliteleevi.tm.intel.com>
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Mon, 28 Nov 2022 18:10:41 +0100
X-Gmail-Original-Message-ID: <CANiDSCtd52UX1WQDj4PLTuTogurr63ZdMXVWmYqJHCMo_kEoMQ@mail.gmail.com>
Message-ID: <CANiDSCtd52UX1WQDj4PLTuTogurr63ZdMXVWmYqJHCMo_kEoMQ@mail.gmail.com>
Subject: Re: [PATCH v5] ASoC: SOF: Fix deadlock when shutdown a frozen userspace
To:     Kai Vehmanen <kai.vehmanen@linux.intel.com>
Cc:     Liam Girdwood <lgirdwood@gmail.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Alsa-devel <alsa-devel@alsa-project.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        sound-open-firmware@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Kay

Thanks for your review

On Mon, 28 Nov 2022 at 15:41, Kai Vehmanen <kai.vehmanen@linux.intel.com> wrote:
>
> Hi,
>
> On Mon, 28 Nov 2022, Ricardo Ribalda wrote:
>
> > During kexec(), the userspace is frozen. Therefore we cannot wait for it
> > to complete.
> >
> > Avoid running snd_sof_machine_unregister during shutdown.
> [...]
> >       /*
> > -      * make sure clients and machine driver(s) are unregistered to force
> > -      * all userspace devices to be closed prior to the DSP shutdown sequence
> > +      * make sure clients are unregistered prior to the DSP shutdown
> > +      * sequence.
> >        */
> >       sof_unregister_clients(sdev);
> >
> > -     snd_sof_machine_unregister(sdev, pdata);
> > -
> >       if (sdev->fw_state == SOF_FW_BOOT_COMPLETE)
>
> this is problematic as removing that machine_unregister() call will (at
> least) bring back an issue on Intel platforms (rare problem hitting S5 on
> Chromebooks).

Do you know which devices were affected or how to trigger the issue?

I have access to the ChromeOS lab, so I can test on a big variety of devices

Thanks!


>
> Not sure how to solve this, but if that call needs to be removed
> (unsafe to call at shutdown), then we need to rework how SOF
> does the cleanup.
>
> Br, Kai



-- 
Ricardo Ribalda
