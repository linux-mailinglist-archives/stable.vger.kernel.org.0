Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CCC67888F
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 21:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbjAWUo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 15:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232626AbjAWUo6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 15:44:58 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595A72CC50
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 12:44:46 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id g2-20020a9d6b02000000b006864bf5e658so8070933otp.1
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 12:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VrjOO32mNE4cQXTG/5bnvMEvE4xDptS6D0NuFaAh9As=;
        b=HbX7geOV2qLjM/wbfb+xfLGQo4tolO4JlkeMuLh/8dMK/M6VE0LZIRr0ESlFwU/y8G
         ysyLBMC0rfci65+5JvvVwnB0NWkDnX/+EIWKfMjtm2D9pPJh3I57lS1getiVFThkX/Bn
         8B/cEj7D1vHrsBZqXamdIC5E6Sk1McbSoRbHe3rajFzGQ4MHKEpccOI7MBxaBsGvqbm4
         16W6OvWg3BsLnf33pNAXA9mN/QLqSlYo7mrnY0RDdbD8/hcMs36OKxKCIIjeGNtsr6L9
         AWfCIJLZvX89PemsOM37i26aOknb7shOAKLgV2Omg6jrh/3eSBdG8kk7ImAr/i7JMvHU
         O0Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VrjOO32mNE4cQXTG/5bnvMEvE4xDptS6D0NuFaAh9As=;
        b=mmJIEdoz+bEmtqTvU8UtwqVTkQ3pt5ntWo/RVvEsSN5Cs0M4KMUKUPTGBkUNxlQtyg
         C7OIZyFoib87UAGDUuuuH8IyAIQje8kRzNkbk6ddmXFZpFBVeMQe/ofmxZz0krP+1UDw
         u8jOmFZjHxFEPfQ18dIIQhNvnc0IwdEzH/addf3d4r0PGa4hkG79QmcLncECCVzheB5m
         sIPCZzvKU0t38HcDsX7LLfaRjp/0JOI5A3/mp/FiYkrHGYCbxPinaMgsp0zVDlldKNYx
         4K2/MU+fxNM7Lx0m61V4vZQUfi0xElQPrurCNm09wuFCswnR7vPJk5JPSigFFYLn5Pz8
         Odpg==
X-Gm-Message-State: AFqh2kqrvcue5WMNR1CNjbrcT1Mj8zleQghJVEF9NdyqpDCxo1rUHqQh
        MD8OeBnt0d49UdJQvH5NnqSV8P9CGI+PVzw09VU60pqfKRSx3w==
X-Google-Smtp-Source: AMrXdXs3l3gUfztHj78uyC3hU4p/JrALyEzNHga+xl9JqUTRvagHylQnRrXqWn2grNZbWu234FB+zUHhAZbWnPn13fg=
X-Received: by 2002:a05:6830:26d3:b0:66e:c78e:9aca with SMTP id
 m19-20020a05683026d300b0066ec78e9acamr1344994otu.196.1674506685568; Mon, 23
 Jan 2023 12:44:45 -0800 (PST)
MIME-Version: 1.0
From:   Sasa Ostrouska <casaxa@gmail.com>
Date:   Mon, 23 Jan 2023 21:44:34 +0100
Message-ID: <CALFERdzKUodLsm6=Ub3g2+PxpNpPtPq3bGBLbff=eZr9_S=YVA@mail.gmail.com>
Subject: Google Pixelbook EVE, no sound in kernel 6.1.x
To:     stable@vger.kernel.org
Cc:     regressions@lists.linux.dev,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Lukasz Majczak <lma@semihalf.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all, sorry if I put somebody in CC who is not the correct one. I
have a google pixelbook and using it with Fedora 37.
The last few kernels supplied by fedora 37, 6.1.6, 6.1.7 but also some
earlier have no working sound.
I see the last kernel for me with working sound is 6.0.18.
On my pixelbook this is showing in dmesg:

[    7.623064] snd_soc_skl 0000:00:1f.3: ASoC: no sink widget found
for AEC Capture
[    7.623070] snd_soc_skl 0000:00:1f.3: ASoC: Failed to add route
echo_ref_out cpr 7 -> direct -> AEC Capture
[    7.623083] kbl_r5514_5663_max kbl_r5514_5663_max: ASoC: Parent
card not yet available, widget card binding deferred
[    8.090716] NET: Registered PF_QIPCRTR protocol family
[    8.273905] rt5663 i2c-10EC5663:00: sysclk < 384 x fs, disable i2s asrc
[    8.275043] HDMI HDA Codec ehdaudio0D2: hdac_hdmi_present_sense:
disconnect for pin:port 5:0
[    8.275165] HDMI HDA Codec ehdaudio0D2: hdac_hdmi_present_sense:
disconnect for pin:port 6:0
[    8.275291] HDMI HDA Codec ehdaudio0D2: hdac_hdmi_present_sense:
disconnect for pin:port 7:0
[    8.278569] input: kbl-r5514-5663-max Headset Jack as
/devices/platform/kbl_r5514_5663_max/sound/card0/input30
[    8.278771] input: kbl-r5514-5663-max HDMI/DP,pcm=6 Jack as
/devices/platform/kbl_r5514_5663_max/sound/card0/input31
[    8.278875] input: kbl-r5514-5663-max HDMI/DP,pcm=7 Jack as
/devices/platform/kbl_r5514_5663_max/sound/card0/input32
[    8.891244] iwlwifi 0000:01:00.0: Applying debug destination EXTERNAL_DRAM
[    8.902009] r8152 2-2.1:1.0 enp0s20f0u2u1: carrier on
[    8.977070] iwlwifi 0000:01:00.0: Applying debug destination EXTERNAL_DRAM
[    8.978496] iwlwifi 0000:01:00.0: FW already configured (0) - re-configuring
[    8.991112] IPv6: ADDRCONF(NETDEV_CHANGE): enp0s20f0u2u1: link becomes ready
[    9.027053] iwlwifi 0000:01:00.0: Applying debug destination EXTERNAL_DRAM
[    9.112264] iwlwifi 0000:01:00.0: Applying debug destination EXTERNAL_DRAM
[    9.113562] iwlwifi 0000:01:00.0: FW already configured (0) - re-configuring
[   14.579846] HDMI HDA Codec ehdaudio0D2: No connections found for pin:port 5:0

Can please somebody help with this issue ?
Also in the latests kernels the shutdown stops and the machine does
not halt. It stays forever waiting for something to happen it seems.

If you need more details please dont hesitate to contact me. And
please CC me as I am not subscribed in these miling lists.

Rgds
Sasa
