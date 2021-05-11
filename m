Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8293D37A3CF
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 11:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhEKJiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 05:38:15 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2774 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbhEKJiO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 05:38:14 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FfXmS522wzmg6X;
        Tue, 11 May 2021 17:33:44 +0800 (CST)
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Tue, 11 May 2021 17:36:58 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <longpeng2@huawei.com>
CC:     Gonglei <arei.gonglei@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Jason Wang" <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v3 0/3] crypto: virtio: Fix three  issues                   
Date:   Tue, 11 May 2021 17:36:54 +0800
Message-ID: <20210511093654.596-1-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.148.223]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Patch 1 & 2: fix two crash issues, Link: https://lkml.org/lkml/2020/1/23/205
Patch 3: fix another functional issue

Changes since v2:
 - put another bugfix together

Changes since v1:
 - remove some redundant checks [Jason]
 - normalize the commit message [Markus]

Cc: Gonglei <arei.gonglei@huawei.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: virtualization@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org

Longpeng(Mike) (3):
  crypto: virtio: Fix src/dst scatterlist calculation in
    __virtio_crypto_skcipher_do_req()
  crypto: virtio: Fix use-after-free in
    virtio_crypto_skcipher_finalize_req()
  crypto: virtio: Fix dest length calculation in
    __virtio_crypto_skcipher_do_req()

 drivers/crypto/virtio/virtio_crypto_algs.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

-- 
1.8.3.1

