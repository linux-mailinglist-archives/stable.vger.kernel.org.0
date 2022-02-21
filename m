Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2B04BDE79
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355588AbiBULRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 06:17:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356010AbiBULPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 06:15:42 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0056394
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 02:55:43 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id gf13-20020a17090ac7cd00b001bbfb9d760eso4911980pjb.2
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 02:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zBMxT6mUsrZF5CxDEWFMeByDYV1JnyiE3N8k2hcGECU=;
        b=oqqOHqSypYg25IJxdVoI6B6JMbaJVEET4dh0ZwvKdM02nESkKShqcQcEAeJH4V0VCM
         uXI9iuhFXbb++O9ukcBiCbNALAKfx5DpdMHwczy9DbTUsW44kL/lnka85qqWvRej0RPF
         RnZ5VQi9/Mjq9HqVC0zMI/jx6jaX6l3eySLLacUi2cknQyzHpMuotUajsmC3GEpzlOin
         o1tPkiMKwsJupC8oYXfyRQVBef8zEU0ZGw4rtAZoHwAnKLbd9vZK1AgZndTWoifXBC8/
         AuESCa6BessImTSDHkf64leJzic5r/rVZzBOg5nQtxSNoV3iHs4YEsgn1YleKilaig88
         BkCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zBMxT6mUsrZF5CxDEWFMeByDYV1JnyiE3N8k2hcGECU=;
        b=K+pPYFOiOC7vJw95ajK5PDBXrYJzLYnpnNPt4eGt37UcrJPA7mEzq2axQQuhZQWlK3
         vs6YRHEKuPRHt1SDgX2eChg33Vkm3tte/3gvXbA+b6YLqHaE9u3sxfEsAqRIG+QcgziM
         A74qdtMmzG8wPrpqebOe31BMbKT6xjpS8SDrGo8AHSng6hyoAEg1sqj3Lw8RNj5+Rm/c
         DAtQImh1sR69UyuVXMRt5MTkeR91wANAdkwbyHKFhaf2XBU+NGqbpDT9ni3Ec1b9+6Qx
         3V5sSdLtgSjhiQXzzyQoZDOZVLq1kqmz5VL+J0h0l/kg/FgDG1PQPzN4xCoYYGJo/gaX
         H0+w==
X-Gm-Message-State: AOAM531fprrdwpKNT1K4tf35jEwI79DWqVXeq277rb6Ov1FhJbdoFZtC
        TQu+clCuFWTGkLlBmgtwyGfDnxMVKNa7uNzQd9hpUA==
X-Google-Smtp-Source: ABdhPJzLPLl27GzyMzXw22z+KHCroSxZ4M5UCV0cxecdAaXbkaNvw97Gtw7SM49XgmH59JPQQgrNHNZqjAsxzIhWJ+U=
X-Received: by 2002:a17:90a:db90:b0:1bc:529f:7071 with SMTP id
 h16-20020a17090adb9000b001bc529f7071mr1589092pjv.40.1645440943069; Mon, 21
 Feb 2022 02:55:43 -0800 (PST)
MIME-Version: 1.0
References: <yonglin.tan@outlook.com> <MEYP282MB237443EA389045F03FF2B48BFD3A9@MEYP282MB2374.AUSP282.PROD.OUTLOOK.COM>
 <CAMZdPi9xN_gQRUz3C2MPoSu9O_byaHnydZm3spX3Buecb8_hng@mail.gmail.com> <MEYP282MB2374345FC80FFA7045D897FEFD3A9@MEYP282MB2374.AUSP282.PROD.OUTLOOK.COM>
In-Reply-To: <MEYP282MB2374345FC80FFA7045D897FEFD3A9@MEYP282MB2374.AUSP282.PROD.OUTLOOK.COM>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Mon, 21 Feb 2022 11:55:07 +0100
Message-ID: <CAMZdPi__Kf__hy4TGJ1sz=VA_PCZpKk_HPgXX8+AH3sv_8mkmg@mail.gmail.com>
Subject: Re: [PATCH] net: wwan: To support SAHARA port for Qualcomm WWAN module.
To:     =?UTF-8?B?6LCtIOawuOaelw==?= <yonglin.tan@outlook.com>
Cc:     "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Feb 2022 at 10:27, =E8=B0=AD =E6=B0=B8=E6=9E=97 <yonglin.tan@out=
look.com> wrote:
>
> Dear Loic,
>
> The Qualcomm x24&x55&x6x platform are all using SAHARA port to collect me=
mory dump log. User can use QLOG tool to collect the whole memory dump of d=
evice while the device entered into Dump mode. The firehose protocol is use=
d to download FW from the host, it's different from SAHARA. MHI CH 2&3 are =
used as SAHARA CH but firehose use 34&35 CH.

Ah right, firehose programmer is loaded when entering EDL mode, not SBL.

>
> The bus driver use " MHI_CHANNEL_CONFIG_UL&DL_SBL " to initiate SAHARA CH=
 configs.
>
> The code is Quectel EM1XX channel config.
> MHI_CHANNEL_CONFIG_DL_SBL(3, "SAHARA", 32, 0),
>
> For example,
> - Once the device crashed due to some reasons.
> - The module entered into DUMP mode(SBL Stage), and changed the EE to SBL=
.
> - Then the host should detect the change and re-enumerate the SAHARA port=
.
> - Then users can use QLOG tool to collect the Device Memory LOG by SAHARA=
 Protocol via CH 2&3.

OK, you should add that to the commit message.

Also, instead of exposing the raw sahara protocol, can't this be
integrated with the devcoredump framework
(https://lwn.net/Articles/610887/)?

Regards,
Loic
