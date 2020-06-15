Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451231FA152
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 22:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729692AbgFOUT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 16:19:59 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:48003 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731015AbgFOUT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 16:19:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1898F194068B;
        Mon, 15 Jun 2020 16:19:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 16:19:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=yIlQQY
        tYz59Sx+2hflVsC+ky/xwadBihd2oaVl/kgmM=; b=fJe2ZOT7nhFcyKih1icYI4
        WfBpq0OznvuuWaoie7ATiLJyMiy/3QAQZ8s3/tEPJKsNYT2UK9EsGiJwsIS1TN3t
        gkBAwOWrNi47ZaQp5iKAT/Woae/gwx59k7tLM91z5E8TKf5sB+snLsMp+S/2FKqh
        9zyGlicH09FZ89OidEUk/fnFPmjD4qTPKyunbeyX/ZhnTuBm7J7596IKAW4d4H9+
        bgnyJm7S1Ad085EgrT1t9W/POh58nx+9iqWCvbk3l6HYBN3h67HOb+7u6ahqUykJ
        osYIKOM8CVyaB20V6QnRBuDQCIX05d2PhE18VyAyPBKhMcLEsnzDHtEPqpznUM0A
        ==
X-ME-Sender: <xms:7dfnXh3YCf0KOZsUYkIcdoYM7ZnCXEh123hauI5zBf6NPverMHGonw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgudeglecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:7dfnXoEuDT4dud6GxGI7uRzVG2XgkV4n42z34eGCx_csrhPZM-zYXQ>
    <xmx:7dfnXh4Lsff5p1S_42tJuRrCcseWS4jmbjwN0sniHowKR6-kXdvZYQ>
    <xmx:7dfnXu0b6g7vlT6IOsaGEPCmYEq1--2XXgwRlOCRjObgF-31rM8Pew>
    <xmx:7tfnXgjwfRjmJ0YB0c_jA9lhx0CZGu62OLbz4jTOUjafuab6sBFHbA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8D75D328005E;
        Mon, 15 Jun 2020 16:19:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: virtio: Fix src/dst scatterlist calculation in" failed to apply to 4.14-stable tree
To:     longpeng2@huawei.com, arei.gonglei@huawei.com, clabbe@baylibre.com,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        jasowang@redhat.com, mst@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 22:19:46 +0200
Message-ID: <1592252386144209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b02989f37fc5e865ceeee9070907e4493b3a21e2 Mon Sep 17 00:00:00 2001
From: "Longpeng(Mike)" <longpeng2@huawei.com>
Date: Tue, 2 Jun 2020 15:04:59 +0800
Subject: [PATCH] crypto: virtio: Fix src/dst scatterlist calculation in
 __virtio_crypto_skcipher_do_req()

The system will crash when the users insmod crypto/tcrypt.ko with mode=38
( testing "cts(cbc(aes))" ).

Usually the next entry of one sg will be @sg@ + 1, but if this sg element
is part of a chained scatterlist, it could jump to the start of a new
scatterlist array. Fix it by sg_next() on calculation of src/dst
scatterlist.

Fixes: dbaf0624ffa5 ("crypto: add virtio-crypto driver")
Reported-by: LABBE Corentin <clabbe@baylibre.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: virtualization@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200123101000.GB24255@Red
Signed-off-by: Gonglei <arei.gonglei@huawei.com>
Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
Link: https://lore.kernel.org/r/20200602070501.2023-2-longpeng2@huawei.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
index fd045e64972a..5f8243563009 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -350,13 +350,18 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 	int err;
 	unsigned long flags;
 	struct scatterlist outhdr, iv_sg, status_sg, **sgs;
-	int i;
 	u64 dst_len;
 	unsigned int num_out = 0, num_in = 0;
 	int sg_total;
 	uint8_t *iv;
+	struct scatterlist *sg;
 
 	src_nents = sg_nents_for_len(req->src, req->cryptlen);
+	if (src_nents < 0) {
+		pr_err("Invalid number of src SG.\n");
+		return src_nents;
+	}
+
 	dst_nents = sg_nents(req->dst);
 
 	pr_debug("virtio_crypto: Number of sgs (src_nents: %d, dst_nents: %d)\n",
@@ -442,12 +447,12 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 	vc_sym_req->iv = iv;
 
 	/* Source data */
-	for (i = 0; i < src_nents; i++)
-		sgs[num_out++] = &req->src[i];
+	for (sg = req->src; src_nents; sg = sg_next(sg), src_nents--)
+		sgs[num_out++] = sg;
 
 	/* Destination data */
-	for (i = 0; i < dst_nents; i++)
-		sgs[num_out + num_in++] = &req->dst[i];
+	for (sg = req->dst; sg; sg = sg_next(sg))
+		sgs[num_out + num_in++] = sg;
 
 	/* Status */
 	sg_init_one(&status_sg, &vc_req->status, sizeof(vc_req->status));

