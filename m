Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF586082EB
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 02:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiJVAh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 20:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiJVAhz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 20:37:55 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756D52B4EAD
        for <stable@vger.kernel.org>; Fri, 21 Oct 2022 17:37:54 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id g8-20020a17090a128800b0020c79f987ceso8136743pja.5
        for <stable@vger.kernel.org>; Fri, 21 Oct 2022 17:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=06hJKxHnqJ1xBDKh32gs167oDbEPVS7g4B9VFoTQ0lc=;
        b=43RhBul7xQ0OxIKNggFHs/d9YIqGv9YO6jowfpYDmNhJNUUFD6AZ3ObfiT+UcqglD9
         RkxEdQIvtPJRK1tph3HALptzgD5tETKIapMPPe1iQgnrW6bfftiPrOEVA4E0tM59qf9J
         /tR5JaIQZCrLFA1GIgcoVzpY5kn9SBazjTGRlLY7tH10FRKrvFmeJdiuzHXbyS12Tmn1
         OaQVL/6F4Xv0N/eg760H0/XSLDDDiQuK7Hs2qrRW7XqvCmHNkdmbZdQ+87Bbz15e4dVd
         N/9+V+n13wFV6tGGgK8QXOMfZSX7DGYcq6AB/c5vuXn5cE0lxb/XoB3LdIToUoegN1nA
         Z8gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=06hJKxHnqJ1xBDKh32gs167oDbEPVS7g4B9VFoTQ0lc=;
        b=W7z9Sk9OcRu2tkwmEcR11jEfNpM2NGzD8bzUBUNgaf0RBIp+hodIbMKp2Ah/GhcpZ3
         zweNvkFDk1z0JMfO4mrYcMdVIjjj//oUxsqPYhxhDvJAbDPkb8eQNiLGFUsDPvxW54/U
         ALZXz7KdfgRNRgqGPNN/tZHdyox/A3KzsoCh3Kne+fw3rwKSlEh1UJ05+eOwVQortaMC
         Crlm30MxvqRiNMinQpGEzM/vlbVYttupPLYYaYkDkMZpLOFYE8gw1zpDPOeu3R16ntRX
         c/BKvbnf/uRVeEOsa1jJaR6XkuBlbOxao0MwjWfe3iXr0piiStoNLQIuhO7lsGkg7qtf
         70pw==
X-Gm-Message-State: ACrzQf3QLt+Buc4jvsHPcjTIcaPtOdiuoRFaQYaGLc9WLVdxuo33t1NL
        wmiAN+XNYy6vS+YiNpTBH7sjWI88f4jFdfjR5u4wR6HS68xo3w==
X-Google-Smtp-Source: AMsMyM5jSvEa2ZkBmmKOSrCpNQPQkaqHUp0zDNT/aZZOD3t4OarUnTrt2uiWTNzSZzJGsPvGD7RjT8upAIjwMSoELgE=
X-Received: by 2002:a17:902:eb8e:b0:17f:637b:9548 with SMTP id
 q14-20020a170902eb8e00b0017f637b9548mr22303069plg.158.1666399073916; Fri, 21
 Oct 2022 17:37:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220701110341.3094023-1-s.hauer@pengutronix.de>
 <c2d545d1f5478e66c0dac47f4bc4c04256ff44aa.camel@camlingroup.com>
 <fd830c7e94de6b4a0b532dfcf46cf1edd22b42fb.camel@camlingroup.com>
 <YtD/9KJZwlVj+6hS@kroah.com> <20220715074631.GA7333@pengutronix.de>
 <YtEdIujszEKSprbF@kroah.com> <770744970.283550.1657871950910.JavaMail.zimbra@nod.at>
 <20220902090252.75285234@xps-13> <CAJ+vNU0r3Enkwn+WzvEJYc_O4NurRyCssx2S-_ZS_cYCpk2-cA@mail.gmail.com>
In-Reply-To: <CAJ+vNU0r3Enkwn+WzvEJYc_O4NurRyCssx2S-_ZS_cYCpk2-cA@mail.gmail.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Fri, 21 Oct 2022 17:37:42 -0700
Message-ID: <CAJ+vNU03stcALHQEbyfB8vqSZ8EGo7arCNtH3P=oyhjPEirj4w@mail.gmail.com>
Subject: Re: [PATCH] mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on
 program/erase times
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Tomasz_Mo=C5=84?= <tomasz.mon@camlingroup.com>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux-mtd <linux-mtd@lists.infradead.org>,
        torvalds <torvalds@linux-foundation.org>,
        Han Xu <han.xu@nxp.com>, kernel <kernel@pengutronix.de>,
        stable <stable@vger.kernel.org>,
        k drobinski <k.drobinski@camlintechnologies.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 21, 2022 at 2:55 PM Tim Harvey <tharvey@gateworks.com> wrote:
>
> On Fri, Sep 2, 2022 at 12:03 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hey folks,
> >
> > richard@nod.at wrote on Fri, 15 Jul 2022 09:59:10 +0200 (CEST):
> >
> > > ----- Urspr=C3=BCngliche Mail -----
> > > >> My IRC history doesn't go back far enough, but if I recall correct=
ly
> > > >> Miquel is on vacation, he would have picked up this patch for linu=
x-next
> > > >> otherwise.
> > >
> > > Exactly.
> >
> > Indeed, I was off for an extended period of time, I'm (very) slowly
> > catching up now.
> >
> > >
> > > > Ok, let me do a round of stable releases so that people don't get h=
it by
> > > > this now...
> > >
> > > Thanks a lot for doing so.
> > >
> > > > Hopefully this gets fixed up by 5.19-final.
> > >
> > > Sure, I'll pickup this patch.
> >
> > Thanks Greg & Richard for the handling of this issue.
> >
> > Cheers,
> > Miqu=C3=A8l
> >
>
> Hello All,
>
> As Tomasz stated previously 06781a5026350 was merged in v5.19-rc4 and
> then was picked up by several stable kernels. While this made it into
> the 5.15 and 5.18 stable branches it did not make it into the
> following which are thus the are currently broken:
> 5.10.y
> 5.17.y
>
> How do we get this patch applied to those stable branches as well to
> resolve this?
>
> Best regards,
>

Some more details here as I also find that stable 5.4 is broken as
well 5.10 and 5.17:

The issue I see here is on a Gateworks imx6q-gw54xx board with a 2GiB
Cypress NAND part
[    2.703324] nand: device found, Manufacturer ID: 0x01, Chip ID: 0xd5
[    2.709815] nand: AMD/Spansion S34ML16G2
[    2.713758] nand: 2048 MiB, SLC, erase size: 128 KiB, page size:
2048, OOB size: 128
[    2.721990] Scanning device for bad blocks
[    2.727025] Bad eraseblock 0 at 0x000000000000
[    2.731628] Bad eraseblock 1 at 0x000000020000
[    2.736191] Bad eraseblock 2 at 0x000000040000
...

The original regression was from commit d99e7feaed4c: ("mtd: rawnand:
gpmi: fix controller timings setting") which was fixed by commit
156427b3123c ("mtd: rawnand: gpmi: Fix setting busy timeout setting")
but later deemed to be an invalid fix so that got reverted (thus
breaking things again) and fixed instead with commit 0fddf9ad06fd
("mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on
program/erase times") which did not make it into all the stable
branches that had the original commit or the revert of the potential
fix.

Here is history of each stable branch affected as best I can tell
(I've actually built/booted all of these trying to understand this so
fixed/broken refers to the issue I see above):

v5.4:
 - v5.4.189 broken with commit 0d0ee651e72c: ("mtd: rawnand: gpmi: fix
controller timings setting")
 - v5.4.202 fixed with commit 71c76f56b97c: ("mtd: rawnand: gpmi: Fix
setting busy timeout setting")
 - v5.4.206 broken with commit 15a3adfe7593: ("Revert "mtd: rawnand:
gpmi: Fix setting busy timeout setting"")
 *** still broken as of v5.4.219 but can be fixed by commit
0fddf9ad06fd ("mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on
program/erase times")

v5.10:
 - v5.10.110 broken with commit d99e7feaed4c: ("mtd: rawnand: gpmi:
fix controller timings setting")
 - v5.10.127 fixed with commit 156427b3123c ("mtd: rawnand: gpmi: Fix
setting busy timeout setting")
 - v5.10.131 broken with commit cc5ee0e0eed0 Revert "mtd: rawnand:
gpmi: Fix setting busy timeout setting"
 *** still broken as of v5.10.149 but can be fixed by commit
0fddf9ad06fd ("mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on
program/erase times")

v5.15:
 - v5.15.33 broken with commit 8480efe815e5: ("mtd: rawnand: gpmi: fix
controller timings setting")
 - v5.15.51 fixed with commit 0af674e7a764: ("mtd: rawnand: gpmi: Fix
setting busy timeout setting")
 - v5.15.55 broken with commit c80b15105a08 ("Revert "mtd: rawnand:
gpmi: Fix setting busy timeout setting"")
 - v5.15.58 fixed with commit 212a5360ef40 ("mtd: rawnand: gpmi: Set
WAIT_FOR_READY timeout based on program/erase times")

v5.17:
 - v5.17.2 broken with commit 4b2eed1d1ee8 ("mtd: rawnand: gpmi: fix
controller timings setting")
 *** still broken as of v5.17.15 but can be fixed by commit
0fddf9ad06fd ("mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on
program/erase times")

v5.18:
 - v5.18-rc2 broken with commit 2970bf5a32f0 mtd: rawnand: gpmi: fix
controller timings setting
 - v5.18.8 fixed with commit 8d45b05f7eaf: ("mtd: rawnand: gpmi: Fix
setting busy timeout setting")
 - v5.18.12 broken with commit f8d01e0f004a: ("Revert "mtd: rawnand:
gpmi: Fix setting busy timeout setting"")
 - v5.18.15 fixed with commit c283223e769d: ("mtd: rawnand: gpmi: Set
WAIT_FOR_READY timeout based on program/erase times")

v5.19:
- v5.19-rc3 broken by commit 06781a502635: ("mtd: rawnand: gpmi: Fix
setting busy timeout setting")
- v5.19-rc7 fixed by commit 0fddf9ad06fd: ("mtd: rawnand: gpmi: Set
WAIT_FOR_READY timeout based on program/erase times")

Best Regards,

Tim
