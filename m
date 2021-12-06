Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D591469279
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 10:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240865AbhLFJhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 04:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240866AbhLFJhO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 04:37:14 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55D8C0613F8
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 01:33:45 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id t9so21035430wrx.7
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 01:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version;
        bh=r9zDudZHRWc49tEGECpf4ZvP6KcUsKNYm4+ZqytPGy8=;
        b=kGNzku0/gn5Dx7uydZoQvNU3Xc6Ig25OfAF/vlQkOkKgPrFvMFg16U8rcTu27+XaH8
         QApDcbMAR5F37JSDEjbJ5RRyx4CSXg2+IS3LcSo8CkmJNLzjiKNWfsmeXf0oB1Uvbs2l
         pTwo9OL7UviBqK10epC8vezhMA216rEjhSKN4Zc+QmSFFqytaq2aH+XVsCYYTekiK0DT
         us9/Pn7Z5D54Tq9321chufj12ak/qrU71yWoxMDjAZz87xAiZUwAY/QvQFHj9HZAEtqg
         1EVhL5eQ4JiDguuAnzHETWV7iardGGMBOv1pUroT0hDoRSX1ATTkArYHwZyqHuZ9diGN
         DaXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version;
        bh=r9zDudZHRWc49tEGECpf4ZvP6KcUsKNYm4+ZqytPGy8=;
        b=0nuj5Ctp77qsCKhyaBkp8XFEdkjSBRRg83tX5J+HEpxYTDycNcHeDO4Dr1MjCpfSJa
         uYr2Qt95kmf7Kb/25aR0sTjv+TNTfT1owwwj4rErIgR8Lc9GKAtp1UuYktqrfZdymVBP
         pu0VULgzm7+GnyWVNYpUnpDOZItxdbcb4fWbO8rAIkhPVtPqTDmkvEhV+IzQ2Rwdji+/
         8kOU784pZXSsKbMQzZDsDKpRklnciT5hUVT6Hz51ZxfL5BBEZ49KReYMsHinDZIQPmDU
         i044nmoZh32hlQezJGz5eyAg40tJbshdkZuja+IHT5WW4bcu+Y9uGn47A6C0s1S9Pbco
         eE0g==
X-Gm-Message-State: AOAM5306A0nllmgpWY+mVbN28UV3qT71xkfguxDfWP8MHN8UKftsrGm7
        jMVVMCol7u9Wjx9RquSxmegzNx83tnK5xIMC
X-Google-Smtp-Source: ABdhPJx5PdCfnKTYp21ys81MqXkxKAEDCeDVThwvz/X/Znp3hAawAgzTmuiSX+0cLUf3uf6Imo8OnA==
X-Received: by 2002:a5d:58c5:: with SMTP id o5mr44001940wrf.15.1638783224385;
        Mon, 06 Dec 2021 01:33:44 -0800 (PST)
Received: from localhost (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id h27sm14379246wmc.43.2021.12.06.01.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 01:33:44 -0800 (PST)
References: <20210315135545.132503808@linuxfoundation.org>
 <61abde5e.1c69fb81.474b3.97fbSMTPIN_ADDED_BROKEN@mx.google.com>
 <CAKaHn9J+vhMcxwYxV0L2edZ9sFT11LEokDCvM6j_ccMuqo-__Q@mail.gmail.com>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     Art Nikpal <email2tema@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        Artem Lapkin <art@khadas.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: Re: [PATCH 5.10] Revert "drm: meson_drv add shutdown function"
Date:   Mon, 06 Dec 2021 10:32:49 +0100
In-reply-to: <CAKaHn9J+vhMcxwYxV0L2edZ9sFT11LEokDCvM6j_ccMuqo-__Q@mail.gmail.com>
Message-ID: <1jk0gi5b7q.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Sun 05 Dec 2021 at 09:40, Art Nikpal <email2tema@gmail.com> wrote:

> hi all
>
> i have test it on (VIM1 VIM2 VIM3 VIM3L) its works on my side
> + 5.10.11
> + 5.11.x
> + 5.13.x
> + 5.14.x
> + 5.15.x
> + 5.16.x
>
> can u share your kernel config (i know for some kernel configuration
> drivers still have problem with reboot )

The kernel configuration is the default arm64 defconfig

>
>
> On Sun, Dec 5, 2021 at 5:32 AM Jerome Brunet <jbrunet@baylibre.com> wrote:
>>
>> This reverts commit d66083c0d6f5125a4d982aa177dd71ab4cd3d212
>> and commit d4ec1ffbdaa8939a208656e9c1440742c457ef16.
>>
>> On v5.10 stable, reboot gets stuck on gxl and g12a chip family (at least).
>> This was tested on the aml-s905x-cc from libretch and the u200 reference
>> design.
>>
>> Bisecting on the v5.10 stable branch lead to
>> commit d4ec1ffbdaa8 ("drm: meson_drv add shutdown function").
>>
>> Reverting it (and a fixes on the it) sloves the problem.
>>
>> Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
>> ---
>>
>> Hi Greg,
>>
>> Things are fine on master but it breaks on v5.10-y.
>> I did not check v5.14-y yet. I'll try next week.
>>
>>
>>  drivers/gpu/drm/meson/meson_drv.c | 12 ------------
>>  1 file changed, 12 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/meson/meson_drv.c b/drivers/gpu/drm/meson/meson_drv.c
>> index 2753067c08e6..3d1de9cbb1c8 100644
>> --- a/drivers/gpu/drm/meson/meson_drv.c
>> +++ b/drivers/gpu/drm/meson/meson_drv.c
>> @@ -482,17 +482,6 @@ static int meson_probe_remote(struct platform_device *pdev,
>>         return count;
>>  }
>>
>> -static void meson_drv_shutdown(struct platform_device *pdev)
>> -{
>> -       struct meson_drm *priv = dev_get_drvdata(&pdev->dev);
>> -
>> -       if (!priv)
>> -               return;
>> -
>> -       drm_kms_helper_poll_fini(priv->drm);
>> -       drm_atomic_helper_shutdown(priv->drm);
>> -}
>> -
>>  static int meson_drv_probe(struct platform_device *pdev)
>>  {
>>         struct component_match *match = NULL;
>> @@ -564,7 +553,6 @@ static const struct dev_pm_ops meson_drv_pm_ops = {
>>
>>  static struct platform_driver meson_drm_platform_driver = {
>>         .probe      = meson_drv_probe,
>> -       .shutdown   = meson_drv_shutdown,
>>         .driver     = {
>>                 .name   = "meson-drm",
>>                 .of_match_table = dt_match,
>> --
>> 2.34.0
>>

