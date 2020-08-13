Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C98243D49
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 18:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgHMQZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 12:25:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgHMQZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Aug 2020 12:25:52 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78D1820658;
        Thu, 13 Aug 2020 16:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597335951;
        bh=N4cTHbpyTzRgefGNTX6eMNj+YTOHrqh3DNHNX5mkbR8=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=PqO/hSLfEg+zfqgndH6fSHS7KGo6XNm5trvED5/SNMyIh32PiWd48OJkPkIOYrVrX
         xj45Qgqgavztqr2wAHGVJDH43M5OFanoDeKnSSNO/rUIhETkNUTw/7XLwWNmxsD3Ov
         f8jrfD1ezWo6Ta1ypXqQIOapqxMxN2eT7NDp3AgM=
Date:   Thu, 13 Aug 2020 16:25:50 +0000
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
Message-Id: <20200813162551.78D1820658@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: .

The bot has tested the following trees: v5.8, v5.7.14, v5.4.57, v4.19.138, v4.14.193, v4.9.232, v4.4.232.

v5.8: Build OK!
v5.7.14: Build OK!
v5.4.57: Failed to apply! Possible dependencies:
    2c53d0f64c06 ("vdpasim: vDPA device simulator")
    961e9c84077f ("vDPA: introduce vDPA bus")

v4.19.138: Failed to apply! Possible dependencies:
    2c53d0f64c06 ("vdpasim: vDPA device simulator")
    961e9c84077f ("vDPA: introduce vDPA bus")

v4.14.193: Failed to apply! Possible dependencies:
    2c53d0f64c06 ("vdpasim: vDPA device simulator")
    7b95fec6d2ff ("virtio: make VIRTIO a menuconfig to ease disabling it all")
    961e9c84077f ("vDPA: introduce vDPA bus")

v4.9.232: Failed to apply! Possible dependencies:
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

v4.4.232: Failed to apply! Possible dependencies:
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
