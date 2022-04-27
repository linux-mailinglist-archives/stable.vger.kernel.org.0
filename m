Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77AC9511487
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 11:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiD0JuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 05:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiD0JuH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 05:50:07 -0400
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84CC289FF8
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 02:45:53 -0700 (PDT)
Received: from relay8-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::228])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 9D2C2C3653
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 09:38:32 +0000 (UTC)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id DD1531BF21A;
        Wed, 27 Apr 2022 09:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651052232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x6OmSt9//PD2uTPBDmWbiLCiWUmqxq5pjMj19s/dXho=;
        b=YZabMqJ9NyUVCyuZtN6Ksq5nLmOdpu9LkeuZpkdN3yBVJRbyuQzWu3FtLOESoNlhcMbrA9
        XuzfqRH/wq0OxapMMU0pk3EoIU4efpIXQMBUc6uzbP+cLn/1i9TsrD0wF+zcs6W/FjqwYJ
        Dd/YOtLZrDiiXzeQliY1VgzdZva8ZrDIc/HHOlm+1mZBKO0sDWgK/wL/cPt+tZKS/8ZGti
        5aJ0DR48Ks91+QfgepkhaMv369WmrUfmBEjhYjDrWbp8SsQiLDq+WIhbbB49cnrSIsBWx7
        /k4/Dgze4AZIW7E//sbnsbrMGxWT1c6FSmLbJE+dgfGOSEPhBD/mWjMM3q3EjQ==
Date:   Wed, 27 Apr 2022 11:37:09 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Tokunori Ikegami <ikegami.t@gmail.com>, richard@nod.at,
        vigneshr@ti.com, linux-mtd@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v7 0/4] mtd: cfi_cmdset_0002: Use chip_ready() for write
 on S29GL064N
Message-ID: <20220427113709.01f460c8@xps13>
In-Reply-To: <20220411094047.06556ee1@xps13>
References: <20220323170458.5608-1-ikegami.t@gmail.com>
        <6b09d10e-2098-9fb7-be4c-ae67d802cd2d@leemhuis.info>
        <20220411094047.06556ee1@xps13>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Vignesh,

miquel.raynal@bootlin.com wrote on Mon, 11 Apr 2022 09:40:47 +0200:

> Hello,
>=20
> regressions@leemhuis.info wrote on Sun, 10 Apr 2022 10:51:17 +0200:
>=20
> > Hi, this is your Linux kernel regression tracker. Top-posting for once,
> > to make this easily accessible to everyone.
> >=20
> > Miquel, Richard, Vignesh: what's up here? This patchset fixes a
> > regression. It's quite old, so it's not that urgent, but it looked like
> > nothing happened for two and a half week now. Or was progress made
> > somewhere? =20
>=20
> Vignesh, I'm waiting for your review/ack ;)

Are you still around? We wait for your ack on this.

> > Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat=
) =20
>=20
> Nice 'tool' :)
>=20
> > P.S.: As the Linux kernel's regression tracker I'm getting a lot of
> > reports on my table. I can only look briefly into most of them and lack
> > knowledge about most of the areas they concern. I thus unfortunately
> > will sometimes get things wrong or miss something important. I hope
> > that's not the case here; if you think it is, don't hesitate to tell me
> > in a public reply, it's in everyone's interest to set the public record
> > straight.
> >=20
> > #regzbot poke
> >=20
> > On 23.03.22 18:04, Tokunori Ikegami wrote: =20
> > > Since commit dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer =
to
> > > check correct value") buffered writes fail on S29GL064N. This is
> > > because, on S29GL064N, reads return 0xFF at the end of DQ polling for
> > > write completion, where as, chip_good() check expects actual data
> > > written to the last location to be returned post DQ polling completio=
n.
> > > Fix is to revert to using chip_good() for S29GL064N which only checks
> > > for DQ lines to settle down to determine write completion.
> > >=20
> > > Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to che=
ck correct value")
> > > Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
> > > Cc: stable@vger.kernel.org
> > > Link: https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@=
pengutronix.de/
> > >=20
> > > Tokunori Ikegami (4):
> > >   mtd: cfi_cmdset_0002: Move and rename
> > >     chip_check/chip_ready/chip_good_for_write
> > >   mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N
> > >   mtd: cfi_cmdset_0002: Add S29GL064N ID definition
> > >   mtd: cfi_cmdset_0002: Rename chip_ready variables
> > >=20
> > >  drivers/mtd/chips/cfi_cmdset_0002.c | 112 ++++++++++++++------------=
--
> > >  include/linux/mtd/cfi.h             |   1 +
> > >  2 files changed, 55 insertions(+), 58 deletions(-)
> > >    =20
> >  =20
>=20
>=20
> Thanks,
> Miqu=C3=A8l
>=20
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/


Thanks,
Miqu=C3=A8l
