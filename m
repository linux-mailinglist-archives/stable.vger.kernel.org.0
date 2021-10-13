Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3448B42BADC
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 10:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238879AbhJMIwl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 13 Oct 2021 04:52:41 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:45551 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238783AbhJMIwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 04:52:40 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]) by
 mrelayeu.kundenserver.de (mreue011 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MkpKR-1n1gep0gnf-00mJUb; Wed, 13 Oct 2021 10:50:36 +0200
Received: by mail-wr1-f41.google.com with SMTP id i12so5705485wrb.7;
        Wed, 13 Oct 2021 01:50:35 -0700 (PDT)
X-Gm-Message-State: AOAM532QreUSVeNB8db2BalVW4tVfsMqMW+JtXo7B0KgCpZgqLfujYS/
        wt931CBGsVGGy80p37c49rPd/br75MtT+mD65ww=
X-Google-Smtp-Source: ABdhPJy4ax2DOEenbhpvRSkuJ9CRdYTu4grvvOPn7yMQSLzLP/3xJn1PX15gLIrH87BwseWRBSVj7ZpEfl6RXEtn7Q0=
X-Received: by 2002:a05:600c:4f42:: with SMTP id m2mr8654190wmq.82.1634115035568;
 Wed, 13 Oct 2021 01:50:35 -0700 (PDT)
MIME-Version: 1.0
References: <20211013005532.700190-1-sashal@kernel.org> <20211013005532.700190-11-sashal@kernel.org>
 <YWZ1om+pLmV3atTd@kroah.com> <CAK8P3a2AC9-ogoxi1q+NQyBqMwrFqSZtHvZVdJ9HF+OLB3O62g@mail.gmail.com>
 <20211013084538.vitv6u5ahds7arpw@pengutronix.de>
In-Reply-To: <20211013084538.vitv6u5ahds7arpw@pengutronix.de>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 13 Oct 2021 10:50:16 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0HVJ6B8Mu8xS5FTvKncKyvz0bzR_NSdhGYp=syuORmCA@mail.gmail.com>
Message-ID: <CAK8P3a0HVJ6B8Mu8xS5FTvKncKyvz0bzR_NSdhGYp=syuORmCA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.10 11/11] firmware: include drivers/firmware/Kconfig
 unconditionally
To:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
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
        Mike Rapoport <rppt@kernel.org>,
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
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:3aT1Lw1J7XBsLeFH+WJ/O9Gzn1o9G20iH9Ll3hyk/GBvXJXn1p4
 8tPl8MVFtGq09opg8EpkIu6eaJ96oKnpZvAkhMILIAqiVFCiWFU+iWAHlW407suW7ia9o7w
 nG0GG8UJw23zjhPXstwTJNzk+vnzN6j+EA0VscmG/iXcRlMbRm/IuO4Jrm1PF4CF4QqCRPe
 ZWcmeO1FTLtL8t3+rNI1Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:wgCDJdtsuF8=:OAXgxbIPvZftUytiQHC1wf
 uVekZzTgmAYMrPnFbzxCYhE1G+O5AULB6yEG1dPfmaXRK1g6LGygCNyBtunsiyTCcjnw8DvoQ
 x8po+/gOYneA76pmauEBi6P7OyoRXk0CMWNVjfDhMn0ZwpdU9aoqsdUnQ351u6255/ksbMgH4
 Od1C9i4Fcaa3345aOzWQPNV2zCQSWXAwEceRGuKHoaZoIrBpnGtT0ASQCyFXs+lrXX6DKj2qI
 eqOYWT+rAjJXqdujii7qgFMNnHikJ7bWMHTMCJYScbNC+k4JAGTZUUPctry2C/yqI3/pF5OsV
 Uw/82Ai1qRS7Bi0nYVJ8BYYyeFXviQGCeQFhit8JpcmF9tKu8xjqaHzKfewvuBUlH87ngMCVG
 NO4GqIAAKCSA5aP8AMRrphq5tpaH0At3Vs36Nh0eaGctAaKO9FqKFGdB1vm+G0jmhrGFoigjs
 rtVk/oGJDqu1Ba7Tyz96dAiqkAMr18xigFwTRNX2YIM/QHbev2tnTeZowV8AS+chu1/xWVcQ+
 j45FAIyc7oVI7hzx3zVxd7cgcF70eH80ZiaegdK0TLJJXxPv2iVFYY7Azgecao5y1IRMKn7Id
 3gB+K1lhCD60fcCsdQWz0wzwCx3XYnniSFITU13pI+heQ29ows07hC/kz3d2hzIrWQqIVtMA6
 3/kulhUluVDe3KL3FlR4oUtVbWTmU/M8YhcKQ3sS5ISxqR5S3zNlDYMXOfk4U7uAkUOAZw0Es
 2+7nrvR4zJ9UrdYK/5xWbqmXsHkQgpuyc14kL0rIkgPe+RHFcEfRdzVK8fsumz00ASH+SIG1B
 kp7w3mBOb4guqAd06y4N1Kga7TlKxTS2T3CD0qtMsYdNEMpnerZIC8YW/CHYxahDRUbOkgABx
 crKh+3Q7FThCwIU3zi1A==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 13, 2021 at 10:45 AM Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
> On Wed, Oct 13, 2021 at 10:38:01AM +0200, Arnd Bergmann wrote:
> > On Wed, Oct 13, 2021 at 7:58 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > On Tue, Oct 12, 2021 at 08:55:31PM -0400, Sasha Levin wrote:
> > >
> > > This isn't for stable kernels, it should be dropped from all of your
> > > AUTOSEL queues.
> >
> > Agreed. The second patch that depends on this does fix a (randconfig)
> > build issue in stable kernels as well, but that patch is currently broken,
>
> Fixing randconfig issues isn't important for stable, is it? The target
> audience for 5.10.74 are people running a kernel between 5.10 and
> 5.10.73, and those don't suffer from this type of build problem, right?

In general, I think randconfig build testing is useful for validating stable
kernels, to help avoid regressions, but there are a number of known
randconfig problems that you hit much more frequently than this one,
which only breaks once every few hundred kernel builds.

      Arnd
