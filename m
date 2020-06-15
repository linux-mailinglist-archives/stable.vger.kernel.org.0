Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4525B1FA1AA
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 22:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731143AbgFOUd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 16:33:26 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:51121 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728346AbgFOUd0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 16:33:26 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2F94D1940632;
        Mon, 15 Jun 2020 16:33:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 16:33:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9Lf6sI
        WjB8wy2n8DvopeATyVFgvsw3TEwnXmzY+xmpM=; b=XyPUvBAbTNoEnptPMchnbC
        kTikaM6wE0nGZ2QDu4z/NRxGAPoI08UCtumelR900E7k2P2xVoAO4nFSnUAkl17a
        ZoryjpwM622G11btgOhLe5C7EJN1Wz47JzWbEjAgbrP/pcksRo95GPvrquuqx5My
        fPxu7wjsi2ib4gIxOq14B/X8kprMA+67ej9o63E0T3wsGwBU74ZclPRvgyZNoZLa
        rikQDAwtiGaAQFMTxc+Kblfpnh1tzrqeA5z7HwBqmMdGFXHtv9+5p7fX/DHcazr8
        4uP2Vm9AdSVsKGfG1pHFM3bR5dKOA2fpxBuqK9qUj7TPfwYxZBFiyyIvKyL2CLnQ
        ==
X-ME-Sender: <xms:FNvnXsDFsEZXqCrC0sodnQx0YHGV3xEiB8meb1lUj3Gl_Xbp63raEQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgudehvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:FNvnXujO5P86vausVyP3fhRkqc5xXMoKKDV-FXK9VpSFX2ULg4TlqA>
    <xmx:FNvnXvngkGsi0xtp2qaZytqmsemFSQE-1RT2OLi3HnXX67Ef5qw3Lw>
    <xmx:FNvnXizsPo-XKgt_DRgfPm__ZetaV5hWExAOxL-ECdFVyg5duGZb3Q>
    <xmx:FdvnXjemDNygwOzNnongKgY9EqG1qrVrYBPHHYzZM_W1Ks8GwtKm3A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D922D30618B7;
        Mon, 15 Jun 2020 16:33:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: virtio: Fix dest length calculation in" failed to apply to 4.14-stable tree
To:     longpeng2@huawei.com, arei.gonglei@huawei.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, jasowang@redhat.com, mst@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 22:33:19 +0200
Message-ID: <159225319965245@kroah.com>
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

From d90ca42012db2863a9a30b564a2ace6016594bda Mon Sep 17 00:00:00 2001
From: "Longpeng(Mike)" <longpeng2@huawei.com>
Date: Tue, 2 Jun 2020 15:05:01 +0800
Subject: [PATCH] crypto: virtio: Fix dest length calculation in
 __virtio_crypto_skcipher_do_req()

The src/dst length is not aligned with AES_BLOCK_SIZE(which is 16) in some
testcases in tcrypto.ko.

For example, the src/dst length of one of cts(cbc(aes))'s testcase is 17, the
crypto_virtio driver will set @src_data_len=16 but @dst_data_len=17 in this
case and get a wrong at then end.

  SRC: pp pp pp pp pp pp pp pp pp pp pp pp pp pp pp pp pp (17 bytes)
  EXP: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc pp (17 bytes)
  DST: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 00 (pollute the last bytes)
  (pp: plaintext  cc:ciphertext)

Fix this issue by limit the length of dest buffer.

Fixes: dbaf0624ffa5 ("crypto: add virtio-crypto driver")
Cc: Gonglei <arei.gonglei@huawei.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: virtualization@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
Link: https://lore.kernel.org/r/20200602070501.2023-4-longpeng2@huawei.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
index 52261b6c247e..cb8a6ea2a4bc 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -407,6 +407,7 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 		goto free;
 	}
 
+	dst_len = min_t(unsigned int, req->cryptlen, dst_len);
 	pr_debug("virtio_crypto: src_len: %u, dst_len: %llu\n",
 			req->cryptlen, dst_len);
 

