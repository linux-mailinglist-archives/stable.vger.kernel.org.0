Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9471642BAA4
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 10:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbhJMIkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 04:40:23 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:54755 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbhJMIkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 04:40:23 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]) by
 mrelayeu.kundenserver.de (mreue012 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MTw02-1m9jDc1EHK-00R2xI; Wed, 13 Oct 2021 10:38:18 +0200
Received: by mail-wr1-f45.google.com with SMTP id t2so5611840wrb.8;
        Wed, 13 Oct 2021 01:38:18 -0700 (PDT)
X-Gm-Message-State: AOAM532sIms2k2gL9BMiv8xID3CPh7cFSIveAH5Y8WyvdAWsIEGWyEgZ
        iv9ehvy8A0i6G3ZX+hTnK+srXYjStOxauLLqUGU=
X-Google-Smtp-Source: ABdhPJzERy7qzxbolOT39FrUcwqPdeh2fIURPv4ilmByKiguzqnvn/Xhapdln0hugnZ2cVo72Y7EAER3Sss3B8QKu2E=
X-Received: by 2002:adf:a3da:: with SMTP id m26mr37292890wrb.336.1634114297720;
 Wed, 13 Oct 2021 01:38:17 -0700 (PDT)
MIME-Version: 1.0
References: <20211013005532.700190-1-sashal@kernel.org> <20211013005532.700190-11-sashal@kernel.org>
 <YWZ1om+pLmV3atTd@kroah.com>
In-Reply-To: <YWZ1om+pLmV3atTd@kroah.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 13 Oct 2021 10:38:01 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2AC9-ogoxi1q+NQyBqMwrFqSZtHvZVdJ9HF+OLB3O62g@mail.gmail.com>
Message-ID: <CAK8P3a2AC9-ogoxi1q+NQyBqMwrFqSZtHvZVdJ9HF+OLB3O62g@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.10 11/11] firmware: include drivers/firmware/Kconfig
 unconditionally
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Simon Trimmer <simont@opensource.cirrus.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Mike Rapoport <rppt@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Sergei Trofimovich <slyfox@gentoo.org>,
        Jens Axboe <axboe@kernel.dk>, ben.widawsky@intel.com,
        Dan Williams <dan.j.williams@intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-ia64@vger.kernel.org,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:zhj9YlgIJvmAFu1sVCt9oWh31Lweh3k5LoV6efB6VHK7enEic5L
 0lnGmkqqdJ+BqVVa49I3PMBcAU5O/W2dgpXbb3bx8ZBRCK3pFXKDFiXFDVt0BOHyVhhHo9W
 fVZLkHYBUtk8BWjH7XC6NZb8jNqAE70rJfVP11RuN0gte7xLck4Yt0toweqvM8zBtuvGkKX
 aCT663Pj+9ZvzG+rWL7Pw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:cNkEPDcmdec=:Dn2SUKIhNPMW5NrVK4+yq3
 LoxGp86ovdWOWxU1h/l8RkVfDuwwKWW2l1meWQiyxmJdIJVHmU+mMpk/GxPcGaMoxPWbyaHRt
 UhVOwsJEVGZd7hQR2YFYS4QewnAbh7jLgOICYBit/xCpjG/Ux7YAK9WHxozkwTWuhG69fG9jk
 pqynODcbLH8kxolLq2JrVywRRNXN1wxtkgRwmdY2PyqRozOjSukXiQcJx3gpcVJeSonF2y+tS
 /jSgeMvKCk8ZGgLCTOXT8f64z1+9uFc4ZBrI67INehFfd3HSmK4xkttWlQjCmNSb4Iw728451
 wyZVGn2iXknQtPiJR5Hn1ihfxHHtkZeztZ/mCk0aagrZzREBKXdijqVATUh4Z2QZZIHHmOfQ1
 cW4IJ5WD3OpxcxY5u1nUHqY867j97yTjxaoZgRxwdj9ZG7w91GylgKf9oM/mhKW2cE5x160mS
 in5SYhz4kXcHBFTFSOt9l9Gv5XlQY8V4oapOH+wAGySPWlESLNHJEUnxQZiu3F4WPJLRrN1Jb
 Gnz9dIv8KSxtOGNPP1O04evz59eXObl2fyzfqcv81m3eDPNlcn9FHudA9DQ4e29aGeuPVraOv
 DW+nhPHzlMqTtZpS/foczN2MRZzDKASXXS+SoF7qzcyOzJ1khyuh4pdD47TfHCBtxzAqr4WIk
 p9QyRpWHUY3c4FYdiM2Wbp7FMIPrSTon7m10/hulJdCJJLBCa9r+zXa0xg/OKq6YJyxgiG8I2
 ULjP4gSNeElevnFOxzrgBnirhHycAiNstPuymr4CrXLd1AbX0FKeBi9t2vOpMXp9CXJ9fZKNI
 BIWP4Ip9XULklH9MHWfZDBC5FslZZIU5ClLJ+H8JpRg3j9IKXYidoHeoMDsYtENLNoKMscyyC
 h0ZzjXaMGXqKPCquwZAg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 13, 2021 at 7:58 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Oct 12, 2021 at 08:55:31PM -0400, Sasha Levin wrote:
>
> This isn't for stable kernels, it should be dropped from all of your
> AUTOSEL queues.

Agreed. The second patch that depends on this does fix a (randconfig)
build issue in stable kernels as well, but that patch is currently broken,
and the two patches combined do feel a little too invasive for addressing
such a minor issue in the stable kernels.

If anyone runs into the QCOM_SCM link failures on stable kernels, I
can come up with a more localized fix.

       Arnd
