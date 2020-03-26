Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0221193D96
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 12:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbgCZLHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 07:07:18 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:48489 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbgCZLHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 07:07:17 -0400
Received: from mail-qt1-f181.google.com ([209.85.160.181]) by
 mrelayeu.kundenserver.de (mreue011 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MHoAg-1j3iy52lEc-00Erul; Thu, 26 Mar 2020 12:07:15 +0100
Received: by mail-qt1-f181.google.com with SMTP id x16so4801289qts.11;
        Thu, 26 Mar 2020 04:07:15 -0700 (PDT)
X-Gm-Message-State: ANhLgQ246PVFK3RozDZhvL1903srTU3QoucjbVezBYlglsPRsSsAF+GZ
        P6G6KQO/nJAqfSJBed11/7yZ5ybT3blFDptfq3c=
X-Google-Smtp-Source: ADFU+vsauIMn1HANI4rLiudPV5R6gi5DYVcgBlL8wZTq3fkMCxAt4oEZzNrRjgAq/uoQkrcXg8Zjy2w1vCbkQYHHbc4=
X-Received: by 2002:ac8:16b8:: with SMTP id r53mr7632032qtj.7.1585220834376;
 Thu, 26 Mar 2020 04:07:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200325113407.26996-1-ulf.hansson@linaro.org> <20200325113407.26996-2-ulf.hansson@linaro.org>
In-Reply-To: <20200325113407.26996-2-ulf.hansson@linaro.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 26 Mar 2020 12:06:58 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1Jy-DDCB6Ub9hoshhRZWFbF4W75M6P1q9dNTyt=JoV5g@mail.gmail.com>
Message-ID: <CAK8P3a1Jy-DDCB6Ub9hoshhRZWFbF4W75M6P1q9dNTyt=JoV5g@mail.gmail.com>
Subject: Re: [PATCH 1/2] driver core: platform: Initialize dma_parms for
 platform devices
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Haibo Chen <haibo.chen@nxp.com>,
        Ludovic Barre <ludovic.barre@st.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        dmaengine@vger.kernel.org, "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:5ViHE+t5nUWB6qvP/N7yW2QCkpHbhVGftimcIn7pbJelKwdjZSr
 M2Vb+e6Y/CAxDJH3TKjgZRVkbog1Qrln6ajF3ifpTpI7CwtCh/u2rDEmNVplC/Cx+3ydWR9
 s6k+CA6RTI4kyFKl0p3ytKQRdjSb9FOMTLC40tqNgE+C3dBl/iaX2/YSXnCR5VTaPNgKq62
 tuogBseu7PfH1U1GaLyfw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:UtQ3KE2aZhk=:6ihyQwLVgIxY+IhgQSbTG8
 h5WntQT84UhF+AeEEIyhVseOik+rGa1TrGJdJ4GGAf92VALkg0fsBhlWuVTI1wCZRUmNNA+tv
 75GL9QzRTLJwDPMCWUI227bgMcq2qEYYnajfDeMOK0vGyJP4EijWljEaXozxDR0Zogux8XIPs
 94W2Llp8geUQ/iZtkRqcutIK/dywlNzoOkxUKERekTKYEMR9QSjGmh93+DJxBFbo+amHmqwhk
 CSbeBpf3WbNz0cwl0FGvESxl7i9zuEiuzaOATyOMtDA25a7sD5Y8HGsSDQ6+AvXiiskxJN0GF
 pKdgNWY8/zQDSErZ6EoxQ523O35y/CaQYdX4Cz6ZoJmbhyaBDY2qxn73INqspwhsjFv9bbQ8x
 a+oREGcZ1+5vhOePkbYqltiTOe/xpEYwlqewgy+Gj1S01kabcVojP5I07PeJJ8l6eC+YCIm7K
 qVGbCkWq61vIUxx6LSU+mD4EAvx6boZt749EjhnrJhA/DZWGkl+0Pg+y8hgmPU0Sfap82vnbC
 CWrUEuz12uAnfCq8NxkmuEbdoDuUaXvudDhb7xOVlOyodbTIyHVbatSgp9rtNyEntqSfvLIRV
 Tyj9boJkSuzpG1y9qA7M5RrRAI4y1FCO5nHdUzs+hi13m3CtvGTG6ScMN4nZ6yjLg7FTMCeKP
 QRkPB91VOaWmGJLm4PP8+GyRJpU9dcR1rB5jeRK4UZQ1CECVH/UQ9F4POn3l/Eh9vH7isxtOx
 C+nIa/+KUmLnmaSFXi/J+YaAjbFB+LyjZMpDhP9mm0WbccWSW1eCygAttXhAMBqrRrfjROuT0
 XNgTOjKjUsBuCx+Wia3CO1+Czy9A74sCacRNnqJ2CbaFgPbZb0=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 25, 2020 at 12:34 PM Ulf Hansson <ulf.hansson@linaro.org> wrote:
>
> It's currently the platform driver's responsibility to initialize the
> pointer, dma_parms, for its corresponding struct device. The benefit with
> this approach allows us to avoid the initialization and to not waste memory
> for the struct device_dma_parameters, as this can be decided on a case by
> case basis.
>
> However, it has turned out that this approach is not very practical.  Not
> only does it lead to open coding, but also to real errors. In principle
> callers of dma_set_max_seg_size() doesn't check the error code, but just
> assumes it succeeds.
>
> For these reasons, let's do the initialization from the common platform bus
> at the device registration point. This also follows the way the PCI devices
> are being managed, see pci_device_add().
>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
