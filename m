Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB42B4E8FDD
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 10:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237283AbiC1IQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 04:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239182AbiC1IQ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 04:16:26 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2909212084;
        Mon, 28 Mar 2022 01:14:46 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id i186so14863604vsc.9;
        Mon, 28 Mar 2022 01:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ckeifvMgypYIXe2YgiWpWX4ERXd6JiyVbgZjkElUqkw=;
        b=bb7BiXkUvettQVFG2b2eBr0W/iV4goyxNm4XVLJaGy3HZvPh3RVrvIv2tWXYjmUMlh
         ZEvrUU9MpAmROK1hzjTHYtCU3uamFwmnMTfBh4Hoc8whz5qulNvW22QiiBV5aEVGE9T0
         2vQR/l09RmcwQnXTP0ipRtP3ovapuGXq8Nl5vn8KrPGTot22hASsXHcww6FEQeM4jZI8
         mkO5yAHAjNK0Gr6KNqLH0q6zQcZsnVFDSe3Wsv+CsIR3U6dNHs8yRlK/ZmGz5rwzCjBC
         UIJeWgmJI3dghIi9npT36UR17kA88DimcfHWkPsHOTF7fnb0qnozz+M+HX3yY30OHukQ
         OYdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ckeifvMgypYIXe2YgiWpWX4ERXd6JiyVbgZjkElUqkw=;
        b=HzTnnssGnAmqsGDjauy/34Rlu9t6Av4mfBlunvoSRKVPzmeskM+0csuS0X3wyX0d94
         +0S1LhWL2fVMQNM4SXZx2XOl6ww/YY7Y9661Orn5EVmKoOMSPW4z9WYDx3FmJKVJZDRk
         USBbqEklFinGb6lpwnh/LbwJHHC4NpO1zi3G6rfejRj79TByDeke08VbZFmDoDCKf2m4
         ZPO5hpyq3kHK6Y1F9auIn8gDtoE3SoXRgQWPjN3lu333MxlpajZXUQbnDPG8shEqZdZF
         veg80Yp4e/VM/r9ZdCSPNu3rAplDSZULozFQ+5uNHMX7eY2LWl1zQlKYk33t1mGw2ZoA
         0rew==
X-Gm-Message-State: AOAM5315Waed4rNJmQvA5XKSXK+EgMqevZdcrudPDvgNH6CbnUApdVKg
        PBr58XlyECVbKFb1e6qxaRvppN0soJgU465Zbdo=
X-Google-Smtp-Source: ABdhPJxFQoIeG8FrbG0yH0KD2Y75ZKlCMCBW5Kpuo5y1CF1Sci0KcpcoTnZkk11mu+xEVVK3UFdPxQXu7KlppP2mTmU=
X-Received: by 2002:a67:fe12:0:b0:31b:9356:40fe with SMTP id
 l18-20020a67fe12000000b0031b935640femr8815628vsr.1.1648455285174; Mon, 28 Mar
 2022 01:14:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220327060120.4316-1-xiam0nd.tong@gmail.com>
In-Reply-To: <20220327060120.4316-1-xiam0nd.tong@gmail.com>
From:   Vaibhav Agarwal <vaibhav.sr@gmail.com>
Date:   Mon, 28 Mar 2022 13:44:09 +0530
Message-ID: <CAAs364-MaXu5JevibWzV1GD1VN+XQPGT1uBUke3-9MfUq7iWQQ@mail.gmail.com>
Subject: Re: [PATCH] greybus: audio_codec: fix three missing initializers for data
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     Mark Greer <mgreer@animalcreek.com>,
        Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "moderated list:GREYBUS SUBSYSTEM" <greybus-dev@lists.linaro.org>,
        linux-staging@lists.linux.dev,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 27, 2022 at 11:31 AM Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:
>
> These three bugs are here:
>         struct gbaudio_data_connection *data;
>
> If the list '&codec->module_list' is empty then the 'data' will
> keep unchanged. However, the 'data' is not initialized and filled
> with trash value. As a result, if the value is not NULL, the check
> 'if (!data) {' will always be false and never exit expectly.
>
> To fix these bug, just initialize 'data' with NULL.
>
> Cc: stable@vger.kernel.org
> Fixes: 6dd67645f22cf ("greybus: audio: Use single codec driver registration")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
>  drivers/staging/greybus/audio_codec.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/greybus/audio_codec.c b/drivers/staging/greybus/audio_codec.c
> index b589cf6b1d03..939e05af4dcf 100644
> --- a/drivers/staging/greybus/audio_codec.c
> +++ b/drivers/staging/greybus/audio_codec.c
> @@ -397,7 +397,7 @@ static int gbcodec_hw_params(struct snd_pcm_substream *substream,
>         u8 sig_bits, channels;
>         u32 format, rate;
>         struct gbaudio_module_info *module;
> -       struct gbaudio_data_connection *data;
> +       struct gbaudio_data_connection *data = NULL;
>         struct gb_bundle *bundle;
>         struct gbaudio_codec_info *codec = dev_get_drvdata(dai->dev);
>         struct gbaudio_stream_params *params;
> @@ -498,7 +498,7 @@ static int gbcodec_prepare(struct snd_pcm_substream *substream,
>  {
>         int ret;
>         struct gbaudio_module_info *module;
> -       struct gbaudio_data_connection *data;
> +       struct gbaudio_data_connection *data = NULL;
>         struct gb_bundle *bundle;
>         struct gbaudio_codec_info *codec = dev_get_drvdata(dai->dev);
>         struct gbaudio_stream_params *params;
> @@ -562,7 +562,7 @@ static int gbcodec_prepare(struct snd_pcm_substream *substream,
>  static int gbcodec_mute_stream(struct snd_soc_dai *dai, int mute, int stream)
>  {
>         int ret;
> -       struct gbaudio_data_connection *data;
> +       struct gbaudio_data_connection *data = NULL;
>         struct gbaudio_module_info *module;
>         struct gb_bundle *bundle;
>         struct gbaudio_codec_info *codec = dev_get_drvdata(dai->dev);
> --
> 2.17.1
>
Thanks Xiaomeng for sharing the fix.

Reviewed by: Vaibhav Agarwal <vaibhav.sr@gmail.com>
