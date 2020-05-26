Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C191E19CA
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 05:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388582AbgEZDUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 23:20:33 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:40964 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725294AbgEZDU1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 May 2020 23:20:27 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 60C1DC81E9FF647E2D7C;
        Tue, 26 May 2020 11:20:24 +0800 (CST)
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.151.115) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Tue, 26 May 2020 11:20:15 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <linux-crypto@vger.kernel.org>
CC:     "Longpeng(Mike)" <longpeng2@huawei.com>,
        Gonglei <arei.gonglei@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Markus Elfring <Markus.Elfring@web.de>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v2 0/2] crypto: virtio: Fix two crash issue
Date:   Tue, 26 May 2020 11:19:54 +0800
Message-ID: <20200526031956.1897-1-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.151.115]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Link: https://lkml.org/lkml/2020/1/23/205

Changes since v1:
 - remove some redundant checks [Jason]
 - normalize the commit message [Markus]

Cc: Gonglei <arei.gonglei@huawei.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Markus Elfring <Markus.Elfring@web.de>
Cc: virtualization@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org

Longpeng(Mike) (2):
  crypto: virtio: Fix src/dst scatterlist calculation in
    __virtio_crypto_skcipher_do_req()
  crypto: virtio: Fix use-after-free in
    virtio_crypto_skcipher_finalize_req()

 drivers/crypto/virtio/virtio_crypto_algs.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

-- 
2.23.0

