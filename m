Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76263A3DFF
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 10:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhFKIcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 04:32:32 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:59717 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbhFKIcc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Jun 2021 04:32:32 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1M894P-1lvAvy0ox1-005Kkm for <stable@vger.kernel.org>; Fri, 11 Jun 2021
 10:30:33 +0200
Received: by mail-wm1-f52.google.com with SMTP id f16-20020a05600c1550b02901b00c1be4abso8152489wmg.2
        for <stable@vger.kernel.org>; Fri, 11 Jun 2021 01:30:32 -0700 (PDT)
X-Gm-Message-State: AOAM533JJl80k9U5NAZpqMiHtDCrW/RYbc9yDuKmrfcvCbSvp94LsNhC
        TrhpgadndM1KM0gn2dAfstLy2N8BVf8et1DC6Ts=
X-Google-Smtp-Source: ABdhPJz5Igdr7qTUilfDsDACAHaQ+LGylgdqQEDBESDj5FplcsbbM+x3QQF6svtMO8+ld43ggKMptlP9isNLRtBMKG0=
X-Received: by 2002:a1c:7d15:: with SMTP id y21mr18762498wmc.120.1623400232374;
 Fri, 11 Jun 2021 01:30:32 -0700 (PDT)
MIME-Version: 1.0
References: <1623396129105150@kroah.com>
In-Reply-To: <1623396129105150@kroah.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 11 Jun 2021 10:28:35 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1Y2g+-tKy=zD3yKhxjhVuWdMQvuP_MRbxzdeQFvAB-pQ@mail.gmail.com>
Message-ID: <CAK8P3a1Y2g+-tKy=zD3yKhxjhVuWdMQvuP_MRbxzdeQFvAB-pQ@mail.gmail.com>
Subject: Re: patch "Revert "usb: gadget: fsl: Re-enable driver for ARM SoCs""
 added to usb-linus
To:     gregkh <gregkh@linuxfoundation.org>
Cc:     Felipe Balbi <balbi@kernel.org>, Joel Stanley <joel@jms.id.au>,
        Leo Li <leoyang.li@nxp.com>, kbuild test robot <lkp@intel.com>,
        Peter Chen <peter.chen@nxp.com>, ran.wang_1@nxp.com,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Shawn Guo <shawnguo@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:0hrjQA/Mve+eLmDmdjM6dU9mZG6aoA4T2/X9nuRAQyrRnB8mzuH
 aJ412+9vC61v47EUbYeTf1us0sRj2qsjr6e9oezS6oaSgzuCV+zG3dCuR0ITN11fzj1gyK0
 wJnLJUYRSuIQ8PPyMaojp7FlP/yYXh0krNcuw45Q+1OjntYIvWBq6AR48rcxIeWwDtw4Jss
 nizGIrxzDsKOwXoP9IwYw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ARgLt286pT0=:wWJzETKACzk6DZGy9RHo0H
 v6EQGtNmmx1UhSNyNeUvem22tDBkX/8jaEkIWFzpGVs0ytLXCg9Aukyoih4RQz19rFv3Sm0yj
 k76X/HDgEurfDKYg5i/+3GksucgybyuD2lS7pKeiuzxCEqRGnn9EHb0CEDPJBS0c0bTodpdl1
 hybwogP6ZlvYLKnvvTdhMMDGRYP7gmL8353txemFrRdCJVhdm/KMMVztm0ElSO54tA0ndflkE
 va3VB1Y2nej6ECXkk2cdvsEjz18t5KJaVPO/j9QpAEiBQkRtOJlpoHdD5pXONoqkUxlEB/eJZ
 S61TewirIQmsHc+fSVCYtiCk9d9RBpsX+Vb6g+AIvqGl5YE1t8Y4wRRu4KycBRkX3ssi+WuYL
 Ox3geOFAM4aqgeMRtAu0yDdO1Pw2jjYfOnUa2b/jgJAEaVs6FRrl//9hkz7UmZ98iu4vK3cyc
 5WkqOrF+9S7k3NztOv1z0MhzYRmYhLadevSxUzTJ7TAx/inQ2mzZc+vMQtRjwFjyZ3KVS1a7M
 oifNVXwzN5HOG/ujgyDela4w/oWgTFl2km6RShZdoo8gve9ipSHcqBUbIuQ8dZkff6nWyDHYb
 k/m/QnoADTqRFNrf55sPAQjAYIC4u1UB9CT+XnwK5MH1LnN169TetdteQr6SYEMIM/syX9bRX
 Ep3U=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 11, 2021 at 9:22 AM <gregkh@linuxfoundation.org> wrote:
>
> Turns out this breaks the build.  We had numerous reports of problems
> from linux-next and 0-day about this not working properly, so revert it
> for now until it can be figured out properly.
>
> The build errors are:
>         arm-linux-gnueabi-ld: fsl_udc_core.c:(.text+0x29d4): undefined reference to `fsl_udc_clk_finalize'
>         arm-linux-gnueabi-ld: fsl_udc_core.c:(.text+0x2ba8): undefined reference to `fsl_udc_clk_release'
>         fsl_udc_core.c:(.text+0x2848): undefined reference to `fsl_udc_clk_init'
>         fsl_udc_core.c:(.text+0xe88): undefined reference to `fsl_udc_clk_release'
>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: e0e8b6abe8c8 ("usb: gadget: fsl: Re-enable driver for ARM SoCs")

Adding Fabio and Guennadi to Cc.

I can see that the missing symbols were in a driver that got removed in commit
a390bef7db1f ("usb: gadget: fsl_mxc_udc: Remove the driver").

If CONFIG_ARCH_MXC is disabled, these are stubbed out in the header file.
These were added a long time ago by Guennadi Liakhovetski 54e4026b64a9
("USB: gadget: Add i.MX3x support to the fsl_usb2_udc driver"). I also
see that this patch added  a few #ifdef CONFIG_ARCH_MXC checks to the
driver that still remain today. This is clearly broken as it must be possible
to use the same driver module on both SOC_LS1021A and i.MX using
a runtime check.

I also don't see any i.MX variant actually using this driver, but instead see
the dts files declaring fsl,imx27-usb devices, which bind to the
drivers/usb/chipidea/ci_hdrc_imx.c driver. Is this one of those cases
where we have two separate drivers for the same hardware, or is this
for a different device?

        Arnd
