Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67DD21FA150
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 22:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730943AbgFOUTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 16:19:38 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:47291 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729692AbgFOUTi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 16:19:38 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id E7F2E1940679;
        Mon, 15 Jun 2020 16:19:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 16:19:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=29SaQs
        tWR7MStyJDlo0Vfrf1pYpg7jZadAhZYb0n8xw=; b=qh21OgwpmCdLOyeNJl2Ca/
        klsAuGJiatyxUbJhSxxhVNhwI3lHdA1nWCr4M/0nOzmZ7WEoztnr5TV+toJSKMrQ
        IitGn0Z142PYZVqZGgDRonjuLTX4D1vqmsMgZQVsEKpLrkF4Cita00qhHkCDisPS
        bY52XG2jaH3rk85+N4dwAtNhbAQbo8SfeSxC4mF7K1o2JvTkiGSiPI3bwoUmi9Ng
        X6cFU9OgZTl0xSYXPe9JBnQnP+suyHYYCO/zfvwUpe74pE+SlHnEx+Y8ZPqKzPnH
        Du9roRr//gIoTypY0Qad63C4zCgfnOP0UrUnxKSPUMmipysLCadVIRNzCXBiGEOw
        ==
X-ME-Sender: <xms:2NfnXjdP2M1VGmHPu3sN4G6VQx9e9ob6NYanSdyA9V1bjnfSYdO7pA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgudeglecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:2NfnXpNA7_xxXn-YAFs7rPLgGmWgXRF3CV54smYtl87IsxtFRMj5yA>
    <xmx:2NfnXsjoxp41OJ2nXIuLGjf9ScBGkgNmZbeWYf1zrhuw7X_E_LhC5w>
    <xmx:2NfnXk85GJ0Lq9GHo7zthQ0-pvTBCDGGwOLuNEgJNc0F3101bj-f4g>
    <xmx:2NfnXpJ994QFfcH2AR1MwV4Rr5rW9GqHX_ZZiYColo53Y7jW_BdVaA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7690A3061856;
        Mon, 15 Jun 2020 16:19:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: virtio: Fix use-after-free in" failed to apply to 5.4-stable tree
To:     longpeng2@huawei.com, arei.gonglei@huawei.com, clabbe@baylibre.com,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        jasowang@redhat.com, mst@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 22:19:29 +0200
Message-ID: <159225236994131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8c855f0720ff006d75d0a2512c7f6c4f60ff60ee Mon Sep 17 00:00:00 2001
From: "Longpeng(Mike)" <longpeng2@huawei.com>
Date: Tue, 2 Jun 2020 15:05:00 +0800
Subject: [PATCH] crypto: virtio: Fix use-after-free in
 virtio_crypto_skcipher_finalize_req()

The system'll crash when the users insmod crypto/tcrypto.ko with mode=155
( testing "authenc(hmac(sha1),cbc(aes))" ). It's caused by reuse the memory
of request structure.

In crypto_authenc_init_tfm(), the reqsize is set to:
  [PART 1] sizeof(authenc_request_ctx) +
  [PART 2] ictx->reqoff +
  [PART 3] MAX(ahash part, skcipher part)
and the 'PART 3' is used by both ahash and skcipher in turn.

When the virtio_crypto driver finish skcipher req, it'll call ->complete
callback(in crypto_finalize_skcipher_request) and then free its
resources whose pointers are recorded in 'skcipher parts'.

However, the ->complete is 'crypto_authenc_encrypt_done' in this case,
it will use the 'ahash part' of the request and change its content,
so virtio_crypto driver will get the wrong pointer after ->complete
finish and mistakenly free some other's memory. So the system will crash
when these memory will be used again.

The resources which need to be cleaned up are not used any more. But the
pointers of these resources may be changed in the function
"crypto_finalize_skcipher_request". Thus release specific resources before
calling this function.

Fixes: dbaf0624ffa5 ("crypto: add virtio-crypto driver")
Reported-by: LABBE Corentin <clabbe@baylibre.com>
Cc: Gonglei <arei.gonglei@huawei.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: virtualization@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200123101000.GB24255@Red
Acked-by: Gonglei <arei.gonglei@huawei.com>
Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
Link: https://lore.kernel.org/r/20200602070501.2023-3-longpeng2@huawei.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
index 5f8243563009..52261b6c247e 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -582,10 +582,11 @@ static void virtio_crypto_skcipher_finalize_req(
 		scatterwalk_map_and_copy(req->iv, req->dst,
 					 req->cryptlen - AES_BLOCK_SIZE,
 					 AES_BLOCK_SIZE, 0);
-	crypto_finalize_skcipher_request(vc_sym_req->base.dataq->engine,
-					   req, err);
 	kzfree(vc_sym_req->iv);
 	virtcrypto_clear_request(&vc_sym_req->base);
+
+	crypto_finalize_skcipher_request(vc_sym_req->base.dataq->engine,
+					   req, err);
 }
 
 static struct virtio_crypto_algo virtio_crypto_algs[] = { {

