Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B86B6EB84E
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 11:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjDVJug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Apr 2023 05:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDVJuf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Apr 2023 05:50:35 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D3C1987;
        Sat, 22 Apr 2023 02:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1682157023; i=deller@gmx.de;
        bh=LinhArFfnf7KGQs8kxbfvg2R3rvrChV9Pz18t9V6fps=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=GtrZhGJCWkZj6IhoDJn5F0r5esIH6WhD1wBiethk8ztvVgbycemkEw+TvHxXDFqm1
         zAfDBDRN9998n9P47ZJvp8QtZn9RHNRNtZhrCTMd/bfBRU+XE+xcTSx2slHoixqRM9
         3i9FJ1o9/3i4GOcviWORwONKVSu17I98j4cYlPCxwKkK3j27+2lVGeKM4k32EWr7LQ
         VQoWcZ5SuW8tWm7uC/jk7f8EXVfuMYP4n3UBGOG5vBcxhLCOeIlzLGOpIbjR1jVIpP
         VIqHFvL84+80LPlJ/6TmuYEx1/L5ehJz8I4XQ0VJ/mfvfBeBzs3jxLgIxeB8bgMJob
         bm/FU2aWPYRRw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.157.94]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MDysg-1q01Fr0jIK-009to4; Sat, 22
 Apr 2023 11:50:23 +0200
Message-ID: <9f6547e5-ba5d-11bf-3646-2f65b4a6a2ea@gmx.de>
Date:   Sat, 22 Apr 2023 11:50:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/2] fbdev/offb: Update expected device name
Content-Language: en-US
To:     Cyril Brulebois <cyril@debamax.com>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        Rob Herring <robh@kernel.org>,
        Michal Suchanek <msuchanek@suse.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20230412095509.2196162-1-cyril@debamax.com>
 <20230412095509.2196162-2-cyril@debamax.com>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <20230412095509.2196162-2-cyril@debamax.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:H6SNLZBC93QHTP8rBnvbbn8eavBf7kTQSVkEbnwzBzmtG2S5hM7
 kpH2H3Fye7vMU2MUkYkH5FL8r/WH3zBMaD5TZGgmZ/s2TARfPAwlyTL5rg0rqSOmO0A61Ll
 PowLcApDXINEb1WPol75OD5Q4HkGq5WxtMi3RVoBzjDBavFbyo26kXBgbMAHziiQpM4GSx9
 Oyhrm7IxF/6Em1xfXj7HA==
UI-OutboundReport: notjunk:1;M01:P0:y38Rp/jC5iw=;OoilsxTUaVzuVBE/eSPC9mDIJuS
 0SFsSqkyASTfSUVd2yKX8krnYZLx8qYNjsgehKRYHPTysreQF6cB7YSceiSuJwyQ5jJ3EXfJf
 DBWj7GQovPx6t8HlUH9Iq7IAcIniT1HCtq7tOdvNVkG2oSASirxyWm31t5BPbJEq2H9/bclFw
 grXBvB6y9l32jUMqLN4SV2X+k3r1A7GQxhsT9d/iNQmhHSOWD7Mni/JAU3dEJPnOEWJ6AORwz
 nAwoPR+tgToE7JeaqvGhhdupQYpcffqzJmMlzQ/JVd6SHiaqlzwFpcvPgfgoipcZxsN81A8oc
 wjLc1Tone5fh3oSMcKcSvSENKqsmgP8G077WxgxksE/rCVJZBDxWbRTihWdJDdhbIhBpkx4sv
 vkvTu59GH69InrSoF9drVOHsjo5nvTQMIh0SvmVwFgtienUZKS8TF2d1Ewv0+W34nlgzwCVhK
 nZdVUIForkcc4Zkgqe3TucgQiggUcJDQPzLxi6xI6HOe0Y81MweWvKLow4DjGUiVXLvZzzaFI
 ujmcvXpWNRtvYZXDv784t7En5ewNsiGSfNt4/8cTWIPQbfEyO0nEmJvmAMf7AJN0g0W2qdV3N
 cs768pEpQdrmAAjYdPa6VAmrB0Yh2+lKMCCysEZQTfqi7+xKECQWkJ6YiY93MA7U85gOgpUEx
 bQaqpSv5nhnWvxCpu5wyDuYTzyo/+qqIZP1dW5XljX1k1KvF2hlsPV+JH+Ted+3KVE5Ak99gy
 r9r048VS46HVx6uqJTWZzIqnJZzq8k6LSV+DoQ/LyaNgS3Hh1PPmX5T+T9ZXJrPjSjaAry83V
 2f3sO88vufkYyWLb5sx91ZYq/9jls3yW0IioH65rzXv0f8rtSMxG1L90GopXv7XUEAde7JThR
 H0fjYoSmJW6lRYeWH/pQqc89wcQ4TzFNVCWsjhPQZ2ydnGTwzkY1QLvxgDUNMabmLC3KlItvY
 5KNmPf9wziT85PODFJ6M6Nf3CGk=
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/12/23 11:55, Cyril Brulebois wrote:
> Since commit 241d2fb56a18 ("of: Make OF framebuffer device names unique"=
),
> as spotted by Fr=C3=A9d=C3=A9ric Bonnard, the historical "of-display" de=
vice is
> gone: the updated logic creates "of-display.0" instead, then as many
> "of-display.N" as required.
>
> This means that offb no longer finds the expected device, which prevents
> the Debian Installer from setting up its interface, at least on ppc64el.
>
> It might be better to iterate on all possible nodes, but updating the
> hardcoded device from "of-display" to "of-display.0" is confirmed to fix
> the Debian Installer at the very least.
>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D217328
> Link: https://bugs.debian.org/1033058
> Fixes: 241d2fb56a18 ("of: Make OF framebuffer device names unique")
> Cc: stable@vger.kernel.org
> Signed-off-by: Cyril Brulebois <cyril@debamax.com>

I've applied the series (2 patches, one of them in drm) to the fbdev git t=
ree.

Thanks!
Helge

> ---
>   drivers/video/fbdev/offb.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/video/fbdev/offb.c b/drivers/video/fbdev/offb.c
> index b97d251d894b..6264c7184457 100644
> --- a/drivers/video/fbdev/offb.c
> +++ b/drivers/video/fbdev/offb.c
> @@ -698,7 +698,7 @@ MODULE_DEVICE_TABLE(of, offb_of_match_display);
>
>   static struct platform_driver offb_driver_display =3D {
>   	.driver =3D {
> -		.name =3D "of-display",
> +		.name =3D "of-display.0",
>   		.of_match_table =3D offb_of_match_display,
>   	},
>   	.probe =3D offb_probe_display,

