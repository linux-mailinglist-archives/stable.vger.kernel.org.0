Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 028513CED55
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 22:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239357AbhGSSBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 14:01:13 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:57486 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355275AbhGSReC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 13:34:02 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 16JIEY0N091630;
        Mon, 19 Jul 2021 13:14:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1626718475;
        bh=fjp46X5kK+VUZ498CuAc7TOQTONLa6oycnjw2UFyGcc=;
        h=Date:From:To:CC:Subject:References:In-Reply-To;
        b=V8wjZsAVRV+dLcDAh/ajDZR+q+blpdz9kVeSck6qdZllfRkoy7AZyty8PVNzAtDlU
         j8FpPUOIkQM4fn8BOEGcpzN1uuA02pBWliwqp0/eWiqYxIQtgeIw/vA3syDWqR3A14
         lMyL7WCUmCDVihp+gFBLfX9t19KFnHQ2OZ77sL6g=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 16JIEYDL081192
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 19 Jul 2021 13:14:34 -0500
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 19
 Jul 2021 13:14:34 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Mon, 19 Jul 2021 13:14:34 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 16JIEYv7033548;
        Mon, 19 Jul 2021 13:14:34 -0500
Date:   Mon, 19 Jul 2021 13:14:34 -0500
From:   Nishanth Menon <nm@ti.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Aswath Govindraju <a-govindraju@ti.com>,
        <lkft-triage@lists.linaro.org>
Subject: Re: [PATCH 5.10 216/243] arm64: dts: ti: k3-j721e-common-proc-board:
 Use external clock for SERDES
Message-ID: <20210719181434.2qmpaypu6paozllb@afternoon>
References: <20210719144940.904087935@linuxfoundation.org>
 <20210719144947.891096868@linuxfoundation.org>
 <CA+G9fYt3-5vb_1rjdW3=4nASPGMe3gRrXzdCu10bSgR+Zeo-Hw@mail.gmail.com>
 <CA+G9fYvHj9w1ZYk7UCCh2raCybeb0QeFFic-cuCgj8s_Ffwtbw@mail.gmail.com>
 <YPW8/AZQe4x6i9DY@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YPW8/AZQe4x6i9DY@sashalap>
User-Agent: NeoMutt/20171215
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13:57-20210719, Sasha Levin wrote:
> On Mon, Jul 19, 2021 at 10:59:14PM +0530, Naresh Kamboju wrote:
> > On Mon, 19 Jul 2021 at 22:01, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > > 
> > > On Mon, 19 Jul 2021 at 21:42, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > From: Kishon Vijay Abraham I <kishon@ti.com>
> > > >
> > > > [ Upstream commit f2a7657ad7a821de9cc77d071a5587b243144cd5 ]
> > > >
> > > > Use external clock for all the SERDES used by PCIe controller. This will
> > > > make the same clock used by the local SERDES as well as the clock
> > > > provided to the PCIe connector.
> > > >
> > > > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> > > > Reviewed-by: Aswath Govindraju <a-govindraju@ti.com>
> > > > Signed-off-by: Nishanth Menon <nm@ti.com>
> > > > Link: https://lore.kernel.org/r/20210603143427.28735-4-kishon@ti.com
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > ---
> > > >  .../dts/ti/k3-j721e-common-proc-board.dts     | 40 +++++++++++++++++++
> > > >  1 file changed, 40 insertions(+)
> > > >
> > > > diff --git a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
> > > > index 7cd31ac67f88..56a92f59c3a1 100644
> > > > --- a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
> > > > +++ b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
> > > > @@ -9,6 +9,7 @@
> > > >  #include <dt-bindings/gpio/gpio.h>
> > > >  #include <dt-bindings/input/input.h>
> > > >  #include <dt-bindings/net/ti-dp83867.h>
> > > > +#include <dt-bindings/phy/phy-cadence.h>
> > > 
> > > Following build errors noticed on arm64 architecture on 5.10 branch.
> > 
> > also noticed on stable-rc 5.12.
> 
> Dropped from both, thanks!


Sorry about that.

Kishon: You might want to send the fixes separately to stable for fixup.

-- 
Regards,
Nishanth Menon
Key (0xDDB5849D1736249D) / Fingerprint: F8A2 8693 54EB 8232 17A3  1A34 DDB5 849D 1736 249D
