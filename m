Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E494B82A0
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 09:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiBPIIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 03:08:05 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiBPIIE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 03:08:04 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FAC12751;
        Wed, 16 Feb 2022 00:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1644998869;
        bh=5OubCNom4S5WMRoOXu3g3S6q1dEi8H8V8gtylUu8IC8=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=hV4ODSpLA7JhScZq4mb0NRQ0lYf/S52L7RQ2LU0JzkPesW4jq2JEYpkrWMTHyxDXx
         vACZwqkFNQBiblSvSK0p9isyJq2pkb8HJWrq+xcUR3IA1DSYduXfwiOTPt+Mm8XEvE
         xRamTNE4To3/ZUENXX4IV6HuDtVjf3QpEO2jTU6I=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.60] ([92.116.128.232]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N9dwd-1oNIlk1VhN-015YHJ; Wed, 16
 Feb 2022 09:07:49 +0100
Message-ID: <2306df0f-7073-52bc-8216-17b244168319@gmx.de>
Date:   Wed, 16 Feb 2022 09:07:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v1] video/fbdev: Atari 2 bpp (STe) palette bugfix
Content-Language: en-US
To:     Michael Schmitz <schmitzmic@gmail.com>,
        linux-fbdev@vger.kernel.org, linux-m68k@vger.kernel.org
Cc:     geert@linux-m68k.org, stable@vger.kernel.org
References: <20220216072625.16947-1-schmitzmic@gmail.com>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <20220216072625.16947-1-schmitzmic@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:0D6eD6PQ6cLFQTlZ9IbUk0xtbYGYZn7mxj8cbfp/6AVEOQRzrmT
 aERTINQRdzlsYeFXTzOlByllHen6Xa2FrxdiPGimauIvkLRuIDhvZpehylGsXvf1Gfv4lK3
 Ha2JYor7hTvL9YXOzqZCynLNpCM4lE8p5EseAnbV885BrWbkHkiUBnmPBcqmu3GZEuDWB7l
 QW13i1SOJKqznw8wVn42w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:oVBV5+YSAdI=:7cYVl3EHE1fR+RzZx2AMPw
 69hiehi3vk6NvRsKe4TXwls6VNdWXXPeCsBvAq0o9eyjAxsHq2jeFceQ1ixPLn0tEjbmQT21Z
 OF37mJ0jYC52BvlIxN+xjzPJkb72dSZ99v/BznUKe4QAMZ9ZX9MUTejApZTaEeJrSdbEOsarO
 MBqLPRoMFoXwuUEpj7Ra60jvi6E2xBjj3t61Kf8f262otklovcm0+x9tZzKcgSckxdO0A4Ew8
 lKiTVuBooyZV+ki8/49HnFvGj9EuJYOH/8A/jjqIgVPamE7fEYY2jcEUXb5heGpDWOHX4jfL+
 uGzQOXyFqDKWbacKDyH9jsFCp4/qr/0/q2zu1WFYrSw1FXt1RCVOsn62aIIoktVb6vkESPpR5
 mNGaTHwS/WOy9Nm6KE7ZEtVmWfUGBUqW7vn6VI/Jv+tkrZ+oLD55XjgIfjXy2K8vtX4Bymcio
 ekda+ohNZqCKnFKp4OgcvnLtbH0qEQKEeMWUrTqqbSnuCfDfgQ60cqVRO5VG1TbvGF1SGtwgV
 qjfi5/9dTAYoXKIiGswQuXbrdWQWxXd63qFpgEI0lIsrxcUBmLHzSZkRP2Qgc/hi1e+LZJEmi
 ghEbE+bnz4cMwhBlYBHzyNyLW6CLXzfABkABvIO9W6KSsThHAk6ksHtTXiQfJYwH3mpQgGkz1
 fmf8NAQNn+A+qs/BD6SlPh49lTnlBGzri5MOcvGLMX1h+dLL4aWtlLeyxFcA6cBdoVTUYmVxS
 jX4lm3/a9F9ne47Co5u4rxb/kFEkOWTZPg0ykQFTMkd8Ka8TiNJgf06erYa4UJGXtijpOGNvC
 jcciTNXG8y4lvlINGWtzC0nOC/Zt1KdTzRIdRmlLOwx3n1p8cGMhkRzagQqT/ebLpaDUoHNQf
 Y4+HaXRciVj625rgnuzaCbsScjbGVmfPiM/lJLhgZth8TGlJIvan8g8btx7ElaY0g65ttXsHR
 cc1jKtwKhPPYSQJ+KbwJwm/Os60b11oC20i/GbHAalMZiA+ziJXHf2AcAxUWzFvxlMfleQ8xd
 3luAIxpvKtCuLj2DG5aBY2bj3P6WYsE4VrGtpf4J9U7h0mZeJITmC00TydhP0cP9u6ZhCi32h
 zs9Sj0nPMxypRc=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/16/22 08:26, Michael Schmitz wrote:
> The code to set the shifter STe palette registers has a long
> standing operator precedence bug, manifesting as colors set
> on a 2 bits per pixel frame buffer coming up with a distinctive
> blue tint.
>
> Add parentheses around the calculation of the per-color palette
> data before shifting those into their respective bit field position.
>
> This bug goes back a long way (2.4 days at the very least) so there
> won't be a Fixes: tag.
>
> Tested on ARAnyM as well on Falcon030 hardware.
>
> Cc: stable@vger.kernel.org
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Link: https://lore.kernel.org/all/CAMuHMdU3ievhXxKR_xi_v3aumnYW7UNUO6qMd=
hgfyWTyVSsCkQ@mail.gmail.com
> Tested-by: Michael Schmitz <schmitzmic@gmail.com>
> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>

applied.
Thanks!
Helge



> ---
>  drivers/video/fbdev/atafb.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/video/fbdev/atafb.c b/drivers/video/fbdev/atafb.c
> index e3812a8ff55a..29e650ecfceb 100644
> --- a/drivers/video/fbdev/atafb.c
> +++ b/drivers/video/fbdev/atafb.c
> @@ -1683,9 +1683,9 @@ static int falcon_setcolreg(unsigned int regno, un=
signed int red,
>  			   ((blue & 0xfc00) >> 8));
>  	if (regno < 16) {
>  		shifter_tt.color_reg[regno] =3D
> -			(((red & 0xe000) >> 13) | ((red & 0x1000) >> 12) << 8) |
> -			(((green & 0xe000) >> 13) | ((green & 0x1000) >> 12) << 4) |
> -			((blue & 0xe000) >> 13) | ((blue & 0x1000) >> 12);
> +			((((red & 0xe000) >> 13)   | ((red & 0x1000) >> 12)) << 8)   |
> +			((((green & 0xe000) >> 13) | ((green & 0x1000) >> 12)) << 4) |
> +			   ((blue & 0xe000) >> 13) | ((blue & 0x1000) >> 12);
>  		((u32 *)info->pseudo_palette)[regno] =3D ((red & 0xf800) |
>  						       ((green & 0xfc00) >> 5) |
>  						       ((blue & 0xf800) >> 11));
> @@ -1971,9 +1971,9 @@ static int stste_setcolreg(unsigned int regno, uns=
igned int red,
>  	green >>=3D 12;
>  	if (ATARIHW_PRESENT(EXTD_SHIFTER))
>  		shifter_tt.color_reg[regno] =3D
> -			(((red & 0xe) >> 1) | ((red & 1) << 3) << 8) |
> -			(((green & 0xe) >> 1) | ((green & 1) << 3) << 4) |
> -			((blue & 0xe) >> 1) | ((blue & 1) << 3);
> +			((((red & 0xe)   >> 1) | ((red & 1)   << 3)) << 8) |
> +			((((green & 0xe) >> 1) | ((green & 1) << 3)) << 4) |
> +			  ((blue & 0xe)  >> 1) | ((blue & 1)  << 3);
>  	else
>  		shifter_tt.color_reg[regno] =3D
>  			((red & 0xe) << 7) |
>

