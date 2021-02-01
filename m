Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC84A30ADA8
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 18:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhBARWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 12:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhBARV7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 12:21:59 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC15C061573
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 09:21:20 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id z9so2795146pjl.5
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 09:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:content-transfer-encoding:in-reply-to:references
         :subject:from:cc:to:date:message-id:user-agent;
        bh=kDqGRf4FttiBDKIYty4DHlbqtTPR0M13Mn1MktX6Mc0=;
        b=BxGhbFF9/WSHL1FoHZqA6fpNdSUnUUEoDakLh121eTZJfLpSWiPpXOWh4nG2x6mcyq
         KBT7m9axcMhnfgP8CVNRufG84DcmjYhDbZHfKaxtEWQem9Je0X34IKh5qV5TAJA+mbhn
         1uccJYIFbJKrkld4+Bk1cjW6G0/Al5Pz9IJXc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:content-transfer-encoding
         :in-reply-to:references:subject:from:cc:to:date:message-id
         :user-agent;
        bh=kDqGRf4FttiBDKIYty4DHlbqtTPR0M13Mn1MktX6Mc0=;
        b=O6+ZKdRpuYuQZZeRrMSZ1inbQp1/IZ5duXg1DCRfxVqvJdJdpXPL0RISnLCNjD+COC
         YNYQdXvYRSteQ5DSd6daSstYrANDwsfpYiHAgyFnoWi4I5rLPw9cu76cFjn1fxJOkptW
         g1nJ1uFk0EFJsnr6uUkTgfvjTg2Ma+xaEGECRFP5jqwDTDoFpyqhSwscAFdqIB0EU//g
         SJH+XEKhKO63XPxT9VisQoRmshzX7EsvuUiJckC+fJbusV1zDPPn+WJ6llyf3rMFIxEX
         7nL2tW1hitL8N1qc0KCo/6kfDAvSM0iac36ZxhDWI61tOqcVHFgW/rR1WGpQH5TXyolB
         1bqg==
X-Gm-Message-State: AOAM532QVK80VWwL7k9VDj4UMStxO74oWsrzE4g/Hm/3mpV52K+NiQ+B
        0SGzdCBRClq5aOFxzIU/M5o/Lw==
X-Google-Smtp-Source: ABdhPJxt+iqEYmAzObDDvwnmrfkmRvFVo9t4Waon0oH5aryYfw/ANsBvOrPFtNkq6hu58l3MpH5rfw==
X-Received: by 2002:a17:902:be0e:b029:e0:5b2:659e with SMTP id r14-20020a170902be0eb02900e005b2659emr18592908pls.74.1612200079656;
        Mon, 01 Feb 2021 09:21:19 -0800 (PST)
Received: from chromium.org ([2620:15c:202:201:f860:7722:867d:19f7])
        by smtp.gmail.com with ESMTPSA id f15sm15928437pja.24.2021.02.01.09.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:21:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210201165232.C608864EC4@mail.kernel.org>
References: <20210201165232.C608864EC4@mail.kernel.org>
Subject: Re: Patch "ASoC: qcom: Fix number of HDMI RDMA channels on sc7180" has been added to the 5.10-stable tree
From:   Stephen Boyd <swboyd@chromium.org>
Cc:     stable-commits@vger.kernel.org,
        Srinivasa Rao <srivasam@codeaurora.org>,
        Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Date:   Mon, 01 Feb 2021 09:21:17 -0800
Message-ID: <161220007749.76967.8280890350734846898@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Sasha Levin (2021-02-01 08:52:31)
> This is a note to let you know that I've just added the patch titled
>=20
>     ASoC: qcom: Fix number of HDMI RDMA channels on sc7180
>=20
> to the 5.10-stable tree which can be found at:
>     http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-queue.g=
it;a=3Dsummary
>=20
> The filename of the patch is:
>      asoc-qcom-fix-number-of-hdmi-rdma-channels-on-sc7180.patch
> and it can be found in the queue-5.10 subdirectory.
>=20
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
>=20

Please drop this from stable queue. It will be reverted shortly and
replaced with a proper patch. See [2] for more info.

Quote:
> In my opinion, It 's better not to apply this patch.
>=20
> I will post patch with changing size in sc7180.dtsi file.

After further discussion with Srinivasa it turns out the dtsi file is
correct, but the regmap size is wrong in a different way and the valid
registers functions are also wrong. We'll be sending a proper fix this
week.

Thanks,
Stephen

[2] https://lore.kernel.org/alsa-devel/89cc3dfb-35da-3498-b126-b440c91f9a45=
@codeaurora.org/

>=20
>=20
> commit f3d3274aa72af6366a4cfef1a5a51154aca8cd69
> Author: Stephen Boyd <swboyd@chromium.org>
> Date:   Fri Jan 15 12:33:29 2021 -0800
>=20
>     ASoC: qcom: Fix number of HDMI RDMA channels on sc7180
>    =20
>     [ Upstream commit 7dfe20ee92f681ab1342015254ddb77a18f40cdb ]
>    =20
>     Suspending/resuming with an HDMI dongle attached leads to crashes from
>     an audio regmap.
>    =20
>      Unable to handle kernel paging request at virtual address ffffffc018=
068000
>      Mem abort info:
>        ESR =3D 0x96000047
>        EC =3D 0x25: DABT (current EL), IL =3D 32 bits
>        SET =3D 0, FnV =3D 0
>        EA =3D 0, S1PTW =3D 0
>      Data abort info:
>        ISV =3D 0, ISS =3D 0x00000047
>        CM =3D 0, WnR =3D 1
>      swapper pgtable: 4k pages, 39-bit VAs, pgdp=3D0000000081b12000
>      [ffffffc018068000] pgd=3D0000000275d14003, pud=3D0000000275d14003, p=
md=3D000000026365d003, pte=3D0000000000000000
>      Internal error: Oops: 96000047 [#1] PREEMPT SMP
>      Call trace:
>       regmap_mmio_write32le+0x2c/0x40
>       regmap_mmio_write+0x48/0x6c
>       _regmap_bus_reg_write+0x34/0x44
>       _regmap_write+0x100/0x150
>       regcache_default_sync+0xc0/0x138
>       regcache_sync+0x188/0x26c
>       lpass_platform_pcmops_resume+0x48/0x54 [snd_soc_lpass_platform]
>       snd_soc_component_resume+0x28/0x40
>       soc_resume_deferred+0x6c/0x178
>       process_one_work+0x208/0x3c8
>       worker_thread+0x23c/0x3e8
>       kthread+0x144/0x178
>       ret_from_fork+0x10/0x18
>      Code: d503201f d50332bf f94002a8 8b344108 (b9000113)
>    =20
>     I can reliably reproduce this problem by running 'tail' on the regist=
ers
>     file in debugfs for the hdmi regmap.
>    =20
>      # tail /sys/kernel/debug/regmap/62d87000.lpass-lpass_hdmi/registers
>      [   84.658733] Unable to handle kernel paging request at virtual add=
ress ffffffd0128e800c
>    =20
>     This crash happens because we're trying to read registers from the
>     regmap beyond the length of the mapping created by ioremap().
>    =20
>     The number of hdmi_rdma_channels determines the size of the regmap via
>     this code in sound/soc/qcom/lpass-cpu.c:
>    =20
>       lpass_hdmi_regmap_config.max_register =3D LPAIF_HDMI_RDMAPER_REG(va=
riant, variant->hdmi_rdma_channels);
>    =20
>     According to debugfs the size of the regmap is 0x68010 but according =
to
>     the DTS file posted in [1] the size is only 0x68000 (see the first reg
>     property of the lpass_cpu node). Let's change the number of channels =
to
>     be 3 instead of 4 so the math works out to have a max register of
>     0x67010, nicely fitting inside of the region size of 0x68000.
>    =20
>     Note: I tried to bump up the size of the register region to the next
>     page to include the 0x68010 register but then the tail command caused
>     SErrors with an async abort, implying that the register region doesn't
>     exist or it isn't clocked because the bus is telling us that the
>     register read failed. I reduce the number of channels and played audio
>     through the HDMI channel and it kept working so I think this is corre=
ct.
>    =20
>     Fixes: 2ad63dc8df6b ("ASoC: qcom: sc7180: Add support for audio over =
DP")
>     Link: https://lore.kernel.org/r/1601448168-18396-2-git-send-email-sri=
vasam@codeaurora.org [1]
>     Cc: V Sujith Kumar Reddy <vsujithk@codeaurora.org>
>     Cc: Srinivasa Rao <srivasam@codeaurora.org>
>     Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>     Cc: Cheng-Yi Chiang <cychiang@chromium.org>
>     Signed-off-by: Stephen Boyd <swboyd@chromium.org>
>     Link: https://lore.kernel.org/r/20210115203329.846824-1-swboyd@chromi=
um.org
>     Signed-off-by: Mark Brown <broonie@kernel.org>
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
>=20
> diff --git a/sound/soc/qcom/lpass-sc7180.c b/sound/soc/qcom/lpass-sc7180.c
> index c647e627897a2..c33da7faaf913 100644
> --- a/sound/soc/qcom/lpass-sc7180.c
> +++ b/sound/soc/qcom/lpass-sc7180.c
> @@ -170,7 +170,7 @@ static struct lpass_variant sc7180_data =3D {
>         .rdma_channels          =3D 5,
>         .hdmi_rdma_reg_base             =3D 0x64000,
>         .hdmi_rdma_reg_stride   =3D 0x1000,
> -       .hdmi_rdma_channels             =3D 4,
> +       .hdmi_rdma_channels             =3D 3,
>         .dmactl_audif_start     =3D 1,
>         .wrdma_reg_base         =3D 0x18000,
>         .wrdma_reg_stride       =3D 0x1000,
