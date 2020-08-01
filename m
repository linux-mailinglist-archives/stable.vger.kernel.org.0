Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8595A235499
	for <lists+stable@lfdr.de>; Sun,  2 Aug 2020 01:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgHAXSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Aug 2020 19:18:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbgHAXSR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Aug 2020 19:18:17 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D2C920888;
        Sat,  1 Aug 2020 23:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596323896;
        bh=T8WCDzQV//dhGaP65YVXdlNFqnhK5KsODKjlOFzXAlI=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=ttAXtCpJpfBTJtvmzu7LEo/I5gOwxY5+IKS9SRwNSdBiGfACvynCTiQ1w8v4vdoIg
         7V5ct++mw2lIpwer1al2gs+Kts+lwq9TRhHDtkbGw/fJNfNAQ8T+PUTy8Nxfh5iuf1
         hF50LL/jXUoOrVQdu6sxTDkDVzf5yvlM48S55p4g=
Date:   Sat, 01 Aug 2020 23:18:15 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Jason Wang <jasowang@redhat.com>
To:     Max Gurtovoy <maxg@mellanox.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     Max Gurtovoy <maxg@mellanox.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] vdpasim: protect concurrent access to iommu iotlb
In-Reply-To: <20200731073822.13326-1-jasowang@redhat.com>
References: <20200731073822.13326-1-jasowang@redhat.com>
Message-Id: <20200801231816.5D2C920888@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: .

The bot has tested the following trees: v5.7.11, v5.4.54, v4.19.135, v4.14.190, v4.9.231, v4.4.231.

v5.7.11: Build OK!
v5.4.54: Failed to apply! Possible dependencies:
    2c53d0f64c06 ("vdpasim: vDPA device simulator")
    961e9c84077f ("vDPA: introduce vDPA bus")

v4.19.135: Failed to apply! Possible dependencies:
    2c53d0f64c06 ("vdpasim: vDPA device simulator")
    961e9c84077f ("vDPA: introduce vDPA bus")

v4.14.190: Failed to apply! Possible dependencies:
    2c53d0f64c06 ("vdpasim: vDPA device simulator")
    7b95fec6d2ff ("virtio: make VIRTIO a menuconfig to ease disabling it all")
    961e9c84077f ("vDPA: introduce vDPA bus")

v4.9.231: Failed to apply! Possible dependencies:
    0d7f4f0594fc ("MAINTAINERS: update rmk's entries")
    2c53d0f64c06 ("vdpasim: vDPA device simulator")
    384fe7a4d732 ("drivers: net: xgene-v2: Add DMA descriptor")
    3b3f9a75d931 ("drivers: net: xgene-v2: Add base driver")
    404a5c392dcc ("MAINTAINERS: fix virtio file pattern")
    51c5d8447bd7 ("MMC: meson: initial support for GX platforms")
    6bc37fac30cf ("arm64: dts: add Allwinner A64 SoC .dtsi")
    70dbd9b258d5 ("MAINTAINERS: Add entry for APM X-Gene SoC Ethernet (v2) driver")
    7683e9e52925 ("Properly alphabetize MAINTAINERS file")
    81ccd0cab29b ("drivers: net: xgene-v2: Add mac configuration")
    872d1ba47bdc ("MAINTAINERS: Add Actions Semi Owl section")
    87c586a6a0e1 ("MAINTAINERS: Update the Allwinner sunXi entry")
    961e9c84077f ("vDPA: introduce vDPA bus")
    b105bcdaaa0e ("drivers: net: xgene-v2: Add transmit and receive")
    b26bff6e52d8 ("MAINTAINERS: Add device tree bindings to mv88e6xx section")
    c0a6a5ae6b5d ("MAINTAINERS: copy virtio on balloon_compaction.c")
    d5d4602e0405 ("Staging: iio: fix a MAINTAINERS entry")
    dbaf0624ffa5 ("crypto: add virtio-crypto driver")
    fd33f3eca6bf ("MAINTAINERS: Add maintainers for the meson clock driver")

v4.4.231: Failed to apply! Possible dependencies:
    02038fd6645a ("crypto: Added Chelsio Menu to the Kconfig file")
    06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
    2c53d0f64c06 ("vdpasim: vDPA device simulator")
    404a5c392dcc ("MAINTAINERS: fix virtio file pattern")
    433cd2c617bf ("crypto: rockchip - add crypto driver for rk3288")
    6f99612e2500 ("tpm: Proxy driver for supporting multiple emulated TPMs")
    961e9c84077f ("vDPA: introduce vDPA bus")
    c0a6a5ae6b5d ("MAINTAINERS: copy virtio on balloon_compaction.c")
    dbaf0624ffa5 ("crypto: add virtio-crypto driver")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
