Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1761EFA0D
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgFEOKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:10:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726553AbgFEOKv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:10:51 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AACEA207D3;
        Fri,  5 Jun 2020 14:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366250;
        bh=ebgu688rDGjm6LNJM1GdCvl/C02ouX3iabU447jkzb0=;
        h=Date:From:To:To:To:CC:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Subject:
         In-Reply-To:References:From;
        b=eycV+JrDmk5b/2thl/HWl0hIocIAu1PnE/iuCoiSEzo8Zgj83uMeVpS/Tsu8gNPTn
         Qco8edeP97vS1Box7/AEVfxcfa1dBL3TgvDLclS5rClXFvJyepmXk72zhF5Vck53PP
         KDT05ZrNp9Nqk8H7meZ1MxPV98DG9yiNFqWbrm3M=
Date:   Fri, 05 Jun 2020 14:10:50 +0000
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
Subject: Re: [PATCH v3 3/3] crypto: virtio: Fix dest length calculation in __virtio_crypto_skcipher_do_req()
In-Reply-To: <20200602070501.2023-4-longpeng2@huawei.com>
References: <20200602070501.2023-4-longpeng2@huawei.com>
Message-Id: <20200605141050.AACEA207D3@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: dbaf0624ffa5 ("crypto: add virtio-crypto driver").

The bot has tested the following trees: v5.6.15, v5.4.43, v4.19.125, v4.14.182.

v5.6.15: Build OK!
v5.4.43: Build failed! Errors:
    drivers/crypto/virtio/virtio_crypto_algs.c:408:35: error: ‘struct ablkcipher_request’ has no member named ‘cryptlen’
    drivers/crypto/virtio/virtio_crypto_algs.c:408:35: error: ‘struct ablkcipher_request’ has no member named ‘cryptlen’
    drivers/crypto/virtio/virtio_crypto_algs.c:408:35: error: ‘struct ablkcipher_request’ has no member named ‘cryptlen’
    drivers/crypto/virtio/virtio_crypto_algs.c:408:35: error: ‘struct ablkcipher_request’ has no member named ‘cryptlen’
    drivers/crypto/virtio/virtio_crypto_algs.c:408:35: error: ‘struct ablkcipher_request’ has no member named ‘cryptlen’
    drivers/crypto/virtio/virtio_crypto_algs.c:408:35: error: ‘struct ablkcipher_request’ has no member named ‘cryptlen’
    ./include/linux/kernel.h:866:2: error: first argument to ‘__builtin_choose_expr’ not a constant

v4.19.125: Build failed! Errors:
    drivers/crypto/virtio/virtio_crypto_algs.c:422:35: error: ‘struct ablkcipher_request’ has no member named ‘cryptlen’
    drivers/crypto/virtio/virtio_crypto_algs.c:422:35: error: ‘struct ablkcipher_request’ has no member named ‘cryptlen’
    drivers/crypto/virtio/virtio_crypto_algs.c:422:35: error: ‘struct ablkcipher_request’ has no member named ‘cryptlen’
    drivers/crypto/virtio/virtio_crypto_algs.c:422:35: error: ‘struct ablkcipher_request’ has no member named ‘cryptlen’
    drivers/crypto/virtio/virtio_crypto_algs.c:422:35: error: ‘struct ablkcipher_request’ has no member named ‘cryptlen’
    drivers/crypto/virtio/virtio_crypto_algs.c:422:35: error: ‘struct ablkcipher_request’ has no member named ‘cryptlen’
    ./include/linux/kernel.h:870:2: error: first argument to ‘__builtin_choose_expr’ not a constant

v4.14.182: Build failed! Errors:
    drivers/crypto/virtio/virtio_crypto_algs.c:409:35: error: ‘struct ablkcipher_request’ has no member named ‘cryptlen’


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
