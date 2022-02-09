Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DBA4AEC6E
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 09:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbiBIIbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 03:31:46 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241300AbiBIIbm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 03:31:42 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1984FC05CBB6;
        Wed,  9 Feb 2022 00:31:42 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C2BB6C000B;
        Wed,  9 Feb 2022 08:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1644395501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yn/tDzsvR67+hM5dhzHnFqmkUv46YSHjaLURannh73M=;
        b=FFM4bbu7zjLpioUf4sgYhH0feSKroqMddbwES59Cisxhrz0HVINB0uo61wvlbEntoL1fAv
        ThQ3oxeJfm3wLHvj2sj3Vfei6jWTHvpl7YhGeRA3PQ1cmz7B8BkusoYFpHsruNLXdZeYPi
        BD9u0h+IlvLHyQ2bNT9ZL3jn4MeYfxarLDO4NLEvc7rElndZJeibGD6ndrXy2MZh8Mo7PY
        5NiTTFntZBtfsC9R9ecmh7oBVWvFzhBZ+IofbDj187bkHYaNzSzEYCaPucut0ksMIeVP7g
        /zaFKi2rzeOV563L65rzt/9Ds+R8TLOwwagbpN98b3RB+N9m9QSowZh/v3S6rw==
Date:   Wed, 9 Feb 2022 09:31:38 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Sean Nyekjaer <sean@geanix.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Boris Brezillon <bbrezillon@kernel.org>
Cc:     stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mtd: rawnand: protect access to rawnand devices
 while in suspend
Message-ID: <20220209093138.4104a874@xps13>
In-Reply-To: <20220207153940.710464-1-miquel.raynal@bootlin.com>
References: <20220131215138.2013649-1-sean@geanix.com>
        <20220207153940.710464-1-miquel.raynal@bootlin.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

miquel.raynal@bootlin.com wrote on Mon,  7 Feb 2022 16:39:40 +0100:

> On Mon, 2022-01-31 at 21:51:38 UTC, Sean Nyekjaer wrote:
> > Prevent rawnend access while in a suspended state.
> >=20
> > Commit 013e6292aaf5 ("mtd: rawnand: Simplify the locking") allows the
> > rawnand layer to return errors rather than waiting in a blocking wait.
> >=20
> > Tested on a iMX6ULL.
> >=20
> > Fixes: 013e6292aaf5 ("mtd: rawnand: Simplify the locking")
> > Signed-off-by: Sean Nyekjaer <sean@geanix.com>
> > Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com> =20
>=20
> Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git =
nand/next, thanks.

Dropped because of the kdoc warning/stable style issues. I will soon
apply the v4 instead.

Thanks,
Miqu=C3=A8l
