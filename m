Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47CD765B391
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 15:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbjABOs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 09:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbjABOss (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 09:48:48 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84966465;
        Mon,  2 Jan 2023 06:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1672670903; bh=cUUTc8Fvgowvs3kRn4xQ5Ko18CAYd2NLfEAuO5+9Il0=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=sD1gBsVq08UZG71PKBLJYyt449w8RFoLAtADqA7lKzYYXIiP4q1IrLsA5nsx/puCh
         PbP1yLh92PZwboVF6SaxJ7E8Z8XfthrzMjOyHyKrShzBin83Pw1HHow18vG8r4NTZy
         wwRq7pVdKlZMMHb/+CbolLS51iG0mTestS/4NWMMs4AZHVffTQrA9wtfCzMM0lqOcT
         BEUCVlutiiFB2krRoHQJuTKTEWQhksOw/IMNR02m2b4TV70Yxr/W9ulk0zT7wNLWm4
         jthcfUy3hDU+57pjRq8sAWQAYlTt9SQdB7D4QDQskV4H4+jcRQCFflgApd6EDXNomR
         pHT/4H+IRSLDg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([92.116.130.137]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MN5if-1pVG2U07HB-00J0eB; Mon, 02
 Jan 2023 15:48:23 +0100
Message-ID: <17a2982e-f4e8-f8bd-db8f-dd14bf27b4e7@gmx.de>
Date:   Mon, 2 Jan 2023 15:48:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] matroxfb: G200eW: Increase max memory from 1 MB to 16 MB
Content-Language: en-US
To:     Paul Menzel <pmenzel@molgen.mpg.de>, "Z. Liu" <liuzx@knownsec.com>
Cc:     it+linux-fbdev@molgen.mpg.de, Rich Felker <dalias@libc.org>,
        stable@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20230102135731.6487-1-pmenzel@molgen.mpg.de>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <20230102135731.6487-1-pmenzel@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:8eWfw4Opnqkzxf+1Ev79iySp2RH8FDZc46AiwNc3lV8sHnsUFte
 xLvNG2vJLuvr5TD3q2zUoVnuIq62vEur8NRiJq7o4pib6toIMrTia5S6gTslmF9e9CS4Kkj
 HoI5n5TbXYIczVViYf5cM7e/w7ekz6GH2UW0641AnDFWTzy5+QEwQ/R+2lpRDKrnXP9YFlS
 0mt/7r2YOVGS30eLPCKhA==
UI-OutboundReport: notjunk:1;M01:P0:z6gzU0P4Vkk=;dQYG9VM4sTyZ0ppmp5CCsi7GSut
 GDuitMne9sLdvy5EKVAwni+274uOK1jvMkCfssSsjpDCpi6YHvBXUoFGQVaT/QEYP0IFyGGae
 Fh2UXq9hv2FXUFokyhxP6OmbELq6G5IotwKXCHszdU9o9zrR+Cu/USPuaftynrVEA+LdpOv8M
 QrFtSHKUF4Bz7ZmAZiVBE581Yn8P/0Nf2khlAu8lP283SeeCXrljHkYKsiV9deECUZSnYQAXG
 Pz0UzlJoFKLGMO/LaQQ8AfYCgn7M0UFSlDDC2AtS/u4NNjHmMkXoi88YALov9VEiqwhTmMygb
 0zj6knzAXWC35VkDnS0e7hFbF5f0Wlw1HwFDxsJLDMTYvuVu+VVlJkzaIDvxQW5/d5g4m60EP
 WNJKvPath2U1ux8m9zvBPgQOxrJA1G15KG994xSAMX1orJ6sKFjyKmbTV8k+wpEvfdFyB0K94
 8V4R6bm9MXAB6RGQ3KJhgVnrxCr4xlTXefRxwCQzTD+iZ9pI4Jp/xbCMmEBNcNZvu8TQzp+ZM
 rtsJ75tShkzjvJ6HJkMhe3wjTG+vWnnVYGy086+iR4b6un5nu1OtPeCILB2fg/i8NJodIKAaV
 YJRACTjwiQr9wfgm5Swh1tFo6Sauv4oLp4HV5cAsOREDkXrHX4mZZ6ZoObWM1gBWlKGV9xAcY
 VXIbLv+y6y88/8E5+c6V5qsdSf7bNgPqkTsOJxAmx229irjZxSXI0nascGN/ceffp//chH/pZ
 ck0vA7oYg6L6AZeGp47MPzBy30LRRs2dg0t7TXyqwFeBzFKDD6tdJ4Ix+4Uxa4hcyzBysdZSh
 kEsw1UzKOOhcVCD/5W2hR7pwVVO79jBs5hxciNYe1zTMdGXV18cQYWDhJkGycY/4FMGguvYDa
 HGQwEcdA3cISEpcezc1sE1IW2VoGozI7w93+vS0VYCV31i/DC1QaEsCWDBgR4MVjQy/j0JNsm
 0cvPRuBttroAuvFizkPwr2NbmPY=
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/2/23 14:57, Paul Menzel wrote:
> Commit 62d89a7d49af ("video: fbdev: matroxfb: set maxvram of vbG200eW to
> the same as vbG200 to avoid black screen") accidently decreases the
> maximum memory size for the Matrox G200eW (102b:0532) from 8 MB to 1 MB
> by missing one zero. This caused the driver initialization to fail with
> the messages below, as the minimum required VRAM size is 2 MB:
>
>       [    9.436420] matroxfb: Matrox MGA-G200eW (PCI) detected
>       [    9.444502] matroxfb: cannot determine memory size
>       [    9.449316] matroxfb: probe of 0000:0a:03.0 failed with error -=
1
>
> So, add the missing 0 to make it the intended 16 MB. Successfully tested=
 on
> the Dell PowerEdge R910/0KYD3D, BIOS 2.10.0 08/29/2013, that the warning=
 is
> gone.
>
> While at it, add a leading 0 to the maxdisplayable entry, so it=E2=80=99=
s aligned
> properly. The value could probably also be increased from 8 MB to 16 MB,=
 as
> the G200 uses the same values, but I have not checked any datasheet.
>
> Note, matroxfb is obsolete and superseded by the maintained DRM driver
> mga200, which is used by default on most systems where both drivers are
> available. Therefore, on most systems it was only a cosmetic issue.
>
> Fixes: 62d89a7d49af ("video: fbdev: matroxfb: set maxvram of vbG200eW to=
 the same as vbG200 to avoid black screen")
> Link: https://lore.kernel.org/linux-fbdev/972999d3-b75d-5680-fcef-6e6905=
c52ac5@suse.de/T/#mb6953a9995ebd18acc8552f99d6db39787aec775
> Cc: it+linux-fbdev@molgen.mpg.de
> Cc: Z. Liu <liuzx@knownsec.com>
> Cc: Rich Felker <dalias@libc.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>

applied this v1 version to the fbdev git tree.
Thanks!
Helge


> ---
>   drivers/video/fbdev/matrox/matroxfb_base.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/video/fbdev/matrox/matroxfb_base.c b/drivers/video/=
fbdev/matrox/matroxfb_base.c
> index 0d3cee7ae7268..a043a737ea9f7 100644
> --- a/drivers/video/fbdev/matrox/matroxfb_base.c
> +++ b/drivers/video/fbdev/matrox/matroxfb_base.c
> @@ -1378,8 +1378,8 @@ static struct video_board vbG200 =3D {
>   	.lowlevel =3D &matrox_G100
>   };
>   static struct video_board vbG200eW =3D {
> -	.maxvram =3D 0x100000,
> -	.maxdisplayable =3D 0x800000,
> +	.maxvram =3D 0x1000000,
> +	.maxdisplayable =3D 0x0800000,
>   	.accelID =3D FB_ACCEL_MATROX_MGAG200,
>   	.lowlevel =3D &matrox_G100
>   };

