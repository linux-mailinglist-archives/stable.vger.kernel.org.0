Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44F3D177631
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 13:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgCCMg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 07:36:57 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.81]:20281 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727585AbgCCMg5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 07:36:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1583239014;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=VMrHKMbD83NkBboxDHGdQ72KMc222y8alTEvMYhCHlU=;
        b=mPQLb0f5ASKIwloweC0L6YW6lSVEbG946OwHgHpPu6I0Nv1ocdhrzkVjFSO036nsvd
        866CG2wJ9HI+ydwaRXGXASYPn0OuIniDAFHI7If2GgHiG6EuGE+TdCkP9hgoLeH2SAbv
        Mt+s9KsQGl7qgYVhcWoKatnK4eyi8GK/o49a91dHKa6C3pdFGmfMjaVxj2tfthVdYOum
        GelULxTtnKWyqQKC2DtpkMM9TK/OkhRAHyXMkVMmD8oy3Z7Oq6S+50Tmuk5x/iB+xyEL
        ZCJz7FpTYaM6Ak1nTf5DLW8mCSZTf+nt8ooCx7w4ujvJDrzp7Ost1kDioM8Xg2l5SwFT
        0EuA==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7wpz8NMGHPrpwDGvxw=="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 46.2.0 DYNA|AUTH)
        with ESMTPSA id y0a02cw23CaqIDD
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Tue, 3 Mar 2020 13:36:52 +0100 (CET)
Subject: Re: [PATCH v5 2/5] MIPS: DTS: CI20: fix PMU definitions for ACT8600
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20200303123214.GA15333@alpha.franken.de>
Date:   Tue, 3 Mar 2020 13:36:51 +0100
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
Message-Id: <D0A35BF6-D044-4AB9-BC4D-15E5924E1171@goldelico.com>
References: <cover.1583005548.git.hns@goldelico.com> <02f18080fa0e0c214b40431749ca1ce514c53d37.1583005548.git.hns@goldelico.com> <20200303101818.GA12103@alpha.franken.de> <85F9D066-EAF6-4840-8F54-24E6D8A534DC@goldelico.com> <20200303123214.GA15333@alpha.franken.de>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
X-Mailer: Apple Mail (2.3124)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> Am 03.03.2020 um 13:32 schrieb Thomas Bogendoerfer =
<tsbogend@alpha.franken.de>:
>=20
> On Tue, Mar 03, 2020 at 01:10:22PM +0100, H. Nikolaus Schaller wrote:
>>> And please seperate fixes from improvments, thank you.
>>=20
>> What do you mean by "separate"? Two separate patches?
>> This patch only contains fixes (which I would consider
>> all of them to be improvements).
>=20
> There are two patches with Fixes tag, which IMHO should go
> into 5.6 via mips-fixes branch. All others are going
> via mips-next into 5.7. So it helps me, if they come in different
> patch series (or as single patches).

Ah, ok. I didn't know that there are two branches and originally
I didn't see them as fixes - they became by review suggestions.

> I see other DT changes in your other patch series. Are the changes
> there independent from each other or do they require correct order
> when appling them ?

I think they are independent. Only the fixes should go to stable as =
well.
The others can wait.

>=20
> Thomas.

BR and thanks,
Nikolaus

