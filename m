Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0092B0B79
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 18:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgKLRpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 12:45:17 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:57328 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgKLRpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Nov 2020 12:45:17 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0ACHjANm025114;
        Thu, 12 Nov 2020 11:45:10 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1605203110;
        bh=eYo6eiY5ignY/aHe6H4M6UVjPbP1IqC8Ag9kp6N1Sk8=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=btD9r1J55HW8jbCKISbe/E9N8hxbz/b44QW2cLvzNnk64y+tCzwb06wLmh2JPMidO
         /T93Eq14woJ27KwjS2XXgByEVgEOAmIzJ9xBWqH+5j29gwVT9tDzc423QZh98TCwHw
         KdwkLbZx3lOUpK0hRIuZEewPoBSvz2BNf/L/B+94=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0ACHjAB4103631
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 12 Nov 2020 11:45:10 -0600
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 12
 Nov 2020 11:45:09 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 12 Nov 2020 11:45:09 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0ACHj9ug075854;
        Thu, 12 Nov 2020 11:45:09 -0600
From:   Nishanth Menon <nm@ti.com>
To:     Tero Kristo <t-kristo@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
CC:     Nishanth Menon <nm@ti.com>, <devicetree@vger.kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, <stable@vger.kernel.org>,
        Nikhil Devshatwar <nikhil.nd@ti.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] arm64: dts: ti: k3-am65: mark dss as dma-coherent
Date:   Thu, 12 Nov 2020 11:45:08 -0600
Message-ID: <160520304042.31396.15457398770735161506.b4-ty@ti.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201102134650.55321-1-tomi.valkeinen@ti.com>
References: <20201102134650.55321-1-tomi.valkeinen@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2 Nov 2020 15:46:50 +0200, Tomi Valkeinen wrote:
> DSS is IO coherent on AM65, so we should mark it as such with
> 'dma-coherent' property in the DT file.

Hi Tomi Valkeinen,

I have applied the following to branch ti-k3-dts-next on [1].
Thank you!

[1/1] arm64: dts: ti: k3-am65: mark dss as dma-coherent
      commit: 50301e8815c681bc5de8ca7050c4b426923d4e19


All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent up the chain during
the next merge window (or sooner if it is a relevant bug fix), however if
problems are discovered then the patch may be dropped or reverted.

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/nmenon/linux.git
-- 
Regards,
Nishanth Menon
Key (0xDDB5849D1736249D) / Fingerprint: F8A2 8693 54EB 8232 17A3  1A34 DDB5 849D 1736 249D

