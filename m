Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4AF1FA14E
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 22:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729983AbgFOUTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 16:19:33 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:56547 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728346AbgFOUTd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 16:19:33 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 13AE01940665;
        Mon, 15 Jun 2020 16:19:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 16:19:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Wk0cJV
        SZma0fyGrK5CDARsZFox5yIt7aKxFxjXUDSo4=; b=uV5HSgHndp+FciMv+krmim
        Axvx/DAjThqDvq3Mq7cBORajZe57N437+TGDuCHITOOzVSxtMNbscnAqKtE0LS7k
        PbooQrPJJqBj58qonK1kdSHl0widAOOTXymN06n6JUJinSH60gVXAXGiKq3E9eZJ
        2Pgd7KTekxeH0nRg3IYfnqlEosZGMdav9XAL9xk3tpN8ZJHoPTPa89fxkYGLarqy
        G7kKIAKGuT4jc3EV5SiGp9PE8Edu0xbU22/iEDNTTDkkZZcQZ7yrSxRQQ89Y0DaI
        bZc9PERO7Qv7RDhReM4Krs2HJfIyCGbSx9Nx/GVX2tZewXoFaQQ0WmWxGU66noEQ
        ==
X-ME-Sender: <xms:0tfnXnFIhsxv5_32Iod6R7VO4yYoTUstV7QyYY0scH48jdPZN1WpJQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgudeglecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:0tfnXkV6ZMgq7lJFXj7wv3BlJZlZu_Mc7ZV5bd-BrFRz61XMs21I3w>
    <xmx:0tfnXpJlnh0QOIoAJ_zuc387ij0Aj7M2yjhMWTRaGiTvKOthDY6jgQ>
    <xmx:0tfnXlHXLW_2DspbC28uTylRr00wQzEtvj7T-g_1tkchC9JssIk2ww>
    <xmx:1NfnXjyAyl1Q9tgyuCxvatoOeWkiuEzC4xxXPbbdWMnCpRTh5G96rg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 53C4D328005E;
        Mon, 15 Jun 2020 16:19:30 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: virtio: Fix use-after-free in" failed to apply to 4.14-stable tree
To:     longpeng2@huawei.com, arei.gonglei@huawei.com, clabbe@baylibre.com,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        jasowang@redhat.com, mst@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 22:19:26 +0200
Message-ID: <1592252366228200@kroah.com>
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

