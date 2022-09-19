Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402AA5BD184
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 17:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbiISP57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 11:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiISP57 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 11:57:59 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CC41115E;
        Mon, 19 Sep 2022 08:57:56 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 885C1FF804;
        Mon, 19 Sep 2022 15:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1663603071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rX6igEp7IvrSFf9zz5G2VF1s9bfuFqim/tJ7yj60HZk=;
        b=VFOQLqKEQQT+DyALaRT8PGXPTo9qwflkK+tTQ/Vf2iZGEYSJ6EF95G5CljZtBk2OY7FXAg
        9ZFNu7gFH3SySLgSQMFbi/QoY+pgwA/ChlAxzq8nyKW9UeN+fgx5+hR2udB2jdyuvAX9C4
        pr4MV+4wFvgvHE7uScz5+vDS86QTS2neExADk0Di7qBgqLqAzl1px4bRT6TGn/KaYc3h+B
        bKi1rqhmlD14tWElXrqHcHF1rCnfknvvciDYN53Zc/zGXa3J9LdYQoBGzVf/rwXqz9JHbm
        Ct/TcJX56HCUw8ok0klpUuxLr5RheZCHqICLkAux3RVtJ/DOsCD7CwFQ54oqsw==
Date:   Mon, 19 Sep 2022 17:57:49 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Adrian Zaharia <Adrian.Zaharia@windriver.com>,
        linux-mtd@lists.infradead.org, richard@nod.at, vigneshr@ti.com,
        jani.nurminen@windriver.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] mtd: mtdpart: Fix cosmetic print
Message-ID: <20220919175749.6ba76d13@xps-13>
In-Reply-To: <43059215-aa56-e8c5-53a4-143643058797@gmail.com>
References: <20220825060407.335475-1-Adrian.Zaharia@windriver.com>
        <20220825060407.335475-2-Adrian.Zaharia@windriver.com>
        <43059215-aa56-e8c5-53a4-143643058797@gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

zajec5@gmail.com wrote on Tue, 13 Sep 2022 09:37:21 +0200:

> On 25.08.2022 08:04, Adrian Zaharia wrote:
> > From: Jani Nurminen <jani.nurminen@windriver.com>
> >=20
> > The print of the MTD partitions during boot are off-by-one for the size.
> > Fix this and show the real last offset. =20
>=20
> I see that PCI subsystem and printk() + %pR do that. Probably more. I
> guess it makes sense but I'm also wondering if/how confusing is that
> change going to be for users. We did printing like that for probably
> dozens of years.

Agreed, I would rather not mess with this output which might be
considered part of the ABI, I am sure there are plenty of scripts out
there which do silly things with those lines :-)

>=20
>=20
> > Fixes: 3d6f657ced2b ("mtd: mtdpart: Fix cosmetic print") =20
>=20
> I can't find that hash / commit anywhere. Are you sure it exists?
>=20
>=20
> > Signed-off-by: Jani Nurminen <jani.nurminen@windriver.com>
> > Signed-off-by: Adrian Zaharia <Adrian.Zaharia@windriver.com>
> > ---
> >   drivers/mtd/mtdpart.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
> > index d442fa94c872..fab10e6d4171 100644
> > --- a/drivers/mtd/mtdpart.c
> > +++ b/drivers/mtd/mtdpart.c
> > @@ -118,7 +118,7 @@ static struct mtd_info *allocate_partition(struct m=
td_info *parent,
> >   		child->part.size =3D parent_size - child->part.offset; =20
> >   >   	printk(KERN_NOTICE "0x%012llx-0x%012llx : \"%s\"\n", =20
> > -	       child->part.offset, child->part.offset + child->part.size,
> > +	       child->part.offset, child->part.offset + child->part.size - 1,
> >   	       child->name); =20
> >   >   	/* let's do some sanity checks */ =20
>=20


Thanks,
Miqu=C3=A8l
