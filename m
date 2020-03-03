Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 785F21775B0
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 13:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgCCMK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 07:10:28 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.80]:22467 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729141AbgCCMK2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 07:10:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1583237426;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=3mMB/nNVi0z8+CG/KyauyvUCLnkwQ+0FkBfzbfehBPw=;
        b=bHJTJlPR7zkJEKfZX+qM/uKwKiG1YeRW2itLAEZwn4Eyy7fuZjvFI3M9gGMOM29wV4
        EVjd6McnM90OSor4fvFw5tjFhAnkl6CRBq+iemfbgb+CNoBATC7htLKymKlxdbUV5vy1
        a+ZLTtrGzfTsd+MJActzN0XsHHlMihfSjtO83J2UnRsoODc4gk0F7Xzdd2Ri4xElPgdx
        ltQMHAAcBOgg+FHQmejjpm7uz13Q8dzqEEgsyYxjxo1EC2y+HE9760TA4oJ0gQoohKQV
        H4Zpt7JG5j5yeEdn617kPxXCKWfCvF3p/ocXaga2IhkK3L+hjkSC5IrnWAaa2qr2Wava
        WsHA==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7wpz8NMGHPrpwDGvxw=="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 46.2.0 DYNA|AUTH)
        with ESMTPSA id y0a02cw23CANI4n
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Tue, 3 Mar 2020 13:10:23 +0100 (CET)
Subject: Re: [PATCH v5 2/5] MIPS: DTS: CI20: fix PMU definitions for ACT8600
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20200303101818.GA12103@alpha.franken.de>
Date:   Tue, 3 Mar 2020 13:10:22 +0100
Cc:     Paul Boddie <paul@boddie.org.uk>,
        Paul Cercueil <paul@crapouillou.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Andi Kleen <ak@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-mips@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>, stable <stable@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <85F9D066-EAF6-4840-8F54-24E6D8A534DC@goldelico.com>
References: <cover.1583005548.git.hns@goldelico.com> <02f18080fa0e0c214b40431749ca1ce514c53d37.1583005548.git.hns@goldelico.com> <20200303101818.GA12103@alpha.franken.de>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
X-Mailer: Apple Mail (2.3124)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Thomas,

> Am 03.03.2020 um 11:18 schrieb Thomas Bogendoerfer =
<tsbogend@alpha.franken.de>:
>=20
> On Sat, Feb 29, 2020 at 08:45:45PM +0100, H. Nikolaus Schaller wrote:
>> There is a ACT8600 on the CI20 board and the bindings of the
>> ACT8865 driver have changed without updating the CI20 device
>> tree. Therefore the PMU can not be probed successfully and
>> is running in power-on reset state.
>>=20
>> Fix DT to match the latest act8865-regulator bindings.
>>=20
>> Fixes: 73f2b940474d ("MIPS: CI20: DTS: Add I2C nodes")
>=20
> I see checkpatch warnings in this patch, could please fix them ?

Ah, ok. The comment. Well, on a 5k screen this 80 character limit
is really outdated. But checkpatch is the king :)

Noted for v6.

> And please seperate fixes from improvments, thank you.

What do you mean by "separate"? Two separate patches?
This patch only contains fixes (which I would consider
all of them to be improvements).

>=20
> Thomas.

BR and thanks,
Nikolaus

