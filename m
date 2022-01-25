Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B72649B6EA
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 15:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1580650AbiAYOvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 09:51:32 -0500
Received: from mout.gmx.net ([212.227.15.15]:39231 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1580394AbiAYOtB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jan 2022 09:49:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1643122114;
        bh=32sYEjsZyyUuWa7dxJwt6Mmt68jrPJjcYdpKHSfVi2o=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=RnByn+2m3/DKZ2YShTKmf3pFYGjIXyftCro1TKATNgX+VC2iB1ZPpTLjrxOwUt7Wp
         LbKlNR/V3JckUj/qSgmONlotU+wKgojdXUFXpKkwld4fDs5MoRs0Wk3ORWVsKWm5ui
         egHlUY+/MXyr7KlJphiBQY4rKJ8fY2hStkM6/o34=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from p100 ([92.116.165.229]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MGQjH-1n2mku3FTJ-00Gnx1; Tue, 25
 Jan 2022 15:48:33 +0100
Date:   Tue, 25 Jan 2022 15:48:31 +0100
From:   Helge Deller <deller@gmx.de>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org,
        Daniel =?iso-8859-15?Q?D=EDaz?= <daniel.diaz@linaro.org>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH 5.4 000/320] 5.4.174-rc1 review
Message-ID: <YfANvxrigpCy5spk@p100>
References: <20220124183953.750177707@linuxfoundation.org>
 <e2c9b01d-0500-645f-b4cc-f8dcb769996e@linaro.org>
 <CA+G9fYsvgQyUNBnySuiOrAXRrh4_ZAnqygZ0A5y7pGO5vrXAYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsvgQyUNBnySuiOrAXRrh4_ZAnqygZ0A5y7pGO5vrXAYA@mail.gmail.com>
X-Provags-ID: V03:K1:sVuPM6EQvKj+2Z9eY1Txuq2yocT8d0ywm3M7r8LhNzrGFMZ+NRu
 9GzxEb1Ne93b7SPl0HqYQ7QzZvk0mt7JSGxcr/YLfqgjujFcqZMQfqiYo6/3ylkN8BTaiQi
 tB24TdfhijMROs3t64ajV7MlqXiv7yH5He9IsLxh1QBbHUCatT34Pjaj6sVVjBixTSMkZkB
 yppOium26dsepweXuRiCQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:sWc5+fYLNCs=:IV9arVUOaeNbDnY4DqBHtc
 qrNEUs4b14gy3LhNE8rBj/Hx6dE8EgJttZXh5+03HK4+zPGaRtsgvsoKOt/vi8mWTzCzck8OF
 daFieiXF3cWf4z1Z3nfLBd32XzQNUBj+de77pDGI/cLuV4L9A9y6GBC2dXEm7LLjoKGYVgayP
 dKo7qfXHkCtaVdDTuOr8Sx+KKQFkfaip/wG492k9TrQDMNzZwHzb8ASshGbUXVNiiRaCRuZHg
 PGQQNMZSKs2bMd8Tzrl9G0Gs6zVJr9GVuj98zrjqE31RW1lZu0WjFbpbh6kKT01SImBGGT3Um
 0D3gF/sUcj6Gj6a8/v8CAfkwwz2UXLi6s5u5Fuo9NYDRRfXKmFtUiA0r2SoKbHs3qszwPV4Wa
 2QPtoOtmH1tDkEdAoBOXRQypKEJtswTavPoIRI3uWnyJeUkbaYYbjPICnNg2t6DuvfN7I6n6n
 La9FJ2j/XMDPITEmfcKB318n2PPhpJiP29cqTm03ivRFAr9082HL+FNFzm8b2qETFomXUIlS9
 v+YnnsYIiudRpb1ELj2xjxmLUT36td1kUNpMSxALYrr88t+NYzWhwo7C0/ng5G+uti/pP8OrC
 3yx/aTnRdiojkQXERFO+dNCWmkwiT5u/55pPPPBoh93ukZmc1xtRuBegPdJZ3/Ki8oRUOxbPM
 W+asg6Rbivv/l5hnvyWtxydfLxlLf7EYkGp/rX1x5wPSP0+5uoEWq/y5mqtyv4FQFF/ECW1v3
 ozEy7vwliHpqpejbL7GGCY3ARfRQIME2gTG6ygfcNXsGJtun2hL60Gl8RS7HH0KGbMCoUTxeO
 FsYOBS0bSRI4nxpKmR2iheBQ4ndbX5kjiwbe6OHYliOabsDSxSdONzesOP2kfG5Qi7EfkfP7o
 dpCnX2+z6+nV1vSbFZH3qiIyQq40vkP4+rK52ILNw9whO9AGFffewYBtdJ4zHV8BXL7HiSQjv
 5lJNHp9t+WfvgaAq/siTPm4B1Em2gVkApgTjv4l8wokh6tWHxWexSY1SdDHKcCPESREhCP6rU
 82oSuOC40RrVFju6ziBDuWk1Z/LIEesDBHue/Gw2BrojzOuc8V32ZDRvgjbyXqlsAzxRlTlPJ
 3+GHwAiNdQsy+o=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Naresh Kamboju <naresh.kamboju@linaro.org>:
> > On 1/24/22 12:39, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.4.174 release=
.
> > > There are 320 patches in this series, all will be posted as a respon=
se
> > > to this one.  If anyone has any issues with these being applied, ple=
ase
> > > let me know.
> > >
> > > Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/pat=
ch-5.4.174-rc1.gz
> > > or in the git tree and branch at:
> > >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-sta=
ble-rc.git linux-5.4.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
>
> [...]
>
> This is from PA-RISC with gcc-8, gcc-9, gcc-10, gcc-11:
>
> >    /builds/linux/drivers/parisc/sba_iommu.c: In function 'sba_io_pdir_=
entry':
> >    /builds/linux/arch/parisc/include/asm/special_insns.h:11:3: error: =
expected ':' or ')' before 'ASM_EXCEPTIONTABLE_ENTRY'
> >       ASM_EXCEPTIONTABLE_ENTRY(8b, 9b) \
> >       ^~~~~~~~~~~~~~~~~~~~~~~~
>
> Bisection of the latter points to "parisc: Fix lpa and lpa_user defines"=
.
>
> commit 73c8c7ecdc141c20c9dbc8f3ec176e233942b0d9
> parisc: Fix lpa and lpa_user defines
>     [ commit db19c6f1a2a353cc8dec35b4789733a3cf6e2838 upstream ]

Naresh, thanks for noticing and bisecting!

The problem is, that in v5.4.x we are missing to include a header file
which is probably already indirectly included in the other Linux versions.

Greg, can you either drop this commit:

   commit 73c8c7ecdc141c20c9dbc8f3ec176e233942b0d9
   parisc: Fix lpa and lpa_user defines

or simply add the patch below to the commit?

Either solution which is easier for you is ok.

Thanks,
Helge


diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index e410033b6df0..e72990c92add 100644
=2D-- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -31,6 +31,7 @@
 #include <asm/byteorder.h>
 #include <asm/io.h>
 #include <asm/dma.h>		/* for DMA_CHUNK_SIZE */
+#include <asm/uaccess.h>

 #include <asm/hardware.h>	/* for register_parisc_driver() stuff */

