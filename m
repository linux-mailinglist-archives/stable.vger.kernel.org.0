Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5924B1EFA1B
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgFEOK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:10:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728025AbgFEOKw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:10:52 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAE3D207D8;
        Fri,  5 Jun 2020 14:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366251;
        bh=6CAvZuBjeBM0ZEQzjCvTEjempo7YDRIo6woMgR5VCTc=;
        h=Date:From:To:To:To:CC:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Subject:
         In-Reply-To:From;
        b=fho5hoZlTyKUsdCwJCGiQwIPyo9Gh8DAvxPiSiLTEPMwovO2eb4MQJuVdQ/nnwY6V
         duSjOxxv77vhW972j5zek6sE2ow+C2tR7BE4bMCHwGhl2W9y5BdyusDXcVZcXbRAjj
         BICurL4ZW38BM5gDWohKVnSN8egvpb8q40c8dX/g=
Date:   Fri, 05 Jun 2020 14:10:51 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <linux-crypto@vger.kernel.org>
CC:     "Longpeng(Mike)" <longpeng2@huawei.com>
Cc:     Gonglei <arei.gonglei@huawei.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>
Cc:     virtualization@lists.linux-foundation.org
Cc:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 2/3] crypto: virtio: Fix use-after-free in virtio_crypto_skcipher_finalize_req()
In-Reply-To: <20200602070501.2023-3-longpeng2@huawei.com>
Message-Id: <20200605141051.BAE3D207D8@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

<20200123101000.GB24255@Red>
References: <20200602070501.2023-3-longpeng2@huawei.com>
<20200123101000.GB24255@Red>

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: dbaf0624ffa5 ("crypto: add virtio-crypto driver").

The bot has tested the following trees: v5.6.15, v5.4.43, v4.19.125, v4.14.182.

v5.6.15: Build OK!
v5.4.43: Failed to apply! Possible dependencies:
    eee1d6fca0a0 ("crypto: virtio - switch to skcipher API")

v4.19.125: Failed to apply! Possible dependencies:
    eee1d6fca0a0 ("crypto: virtio - switch to skcipher API")

v4.14.182: Failed to apply! Possible dependencies:
    500e6807ce93 ("crypto: virtio - implement missing support for output IVs")
    67189375bb3a ("crypto: virtio - convert to new crypto engine API")
    d0d859bb87ac ("crypto: virtio - Register an algo only if it's supported")
    e02b8b43f55a ("crypto: virtio - pr_err() strings should end with newlines")
    eee1d6fca0a0 ("crypto: virtio - switch to skcipher API")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
