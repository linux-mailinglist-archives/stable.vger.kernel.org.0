Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650EE338852
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 10:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbhCLJLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 04:11:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:44068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232432AbhCLJKa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 04:10:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 949DF64F12;
        Fri, 12 Mar 2021 09:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615540230;
        bh=SAkw79smdm3x51J6Maik1+AhkqVbmEz9HEut7b9tqSo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N6ynxmkF7KiNQK/aVGCpXDGwQvbVvp+BZ0y6yLLazMEAo1WcSnfzDuc+g2gjmEeyH
         kfK3f1av1iilD5fRWU99GFfpd3w+hfwp6OrUGz8D1lOtThlBIZouRE8l24RuXt3ZvJ
         sBV8PyQZddaQYUt4x/m9qgY2Vh9QZHuB//QGH58fj+epf2Ml3OBwEdeNtuCeOcT79f
         UwusHjZbiHUOgsttCciufD4BkNRa2plFXp2p0wNVV3p1x0fsQPqxhoz7rRqWYbumjB
         BwyNLXLHc2IJgDdS+KBy89fn0YkL7ufmMN6Pfy9NsFWwPCNirXFpjqJM6jcLdLKoHc
         ZDFvrAa/Ow0Yg==
Date:   Fri, 12 Mar 2021 10:10:27 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Gregory CLEMENT <gregory.clement@bootlin.com>
Cc:     linux-arm-kernel@lists.infradead.org, pali@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH mvebu + mvebu/dt64 4/4] arm64: dts: marvell:
 armada-37xx: move firmware node to generic dtsi file
Message-ID: <20210312101027.1997ec75@kernel.org>
In-Reply-To: <87czw4kath.fsf@BL-laptop>
References: <20210308153703.23097-1-kabel@kernel.org>
        <20210308153703.23097-4-kabel@kernel.org>
        <87czw4kath.fsf@BL-laptop>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 12 Mar 2021 09:58:34 +0100
Gregory CLEMENT <gregory.clement@bootlin.com> wrote:

> Hello Marek,
>=20
> > From: Pali Roh=C3=A1r <pali@kernel.org>
> >
> > Move the turris-mox-rwtm firmware node from Turris MOX' device tree into
> > the generic armada-37xx.dtsi file. =20
>=20
> I disagree with this patch. This firmware is specific to Turris MOX so
> it is not something that should be exposed to all the Armada 3700 based
> boards.
>=20
> If you want you still can create an dtsi for this and include it when
> needed.
>=20
> Gregory

Gregory, we are planning to send pull-request for TF-A documentation,
adding information that people can compile the firmware with CZ.NIC's
firmware.

Since this firmware exposes HW random number generator, it is
possible that people will start using it for espressobin.

In that case this won't be specific for Turris MOX anymore.

Maybe we should add another compatible to the turris-mox-rwtm driver?

Marek
