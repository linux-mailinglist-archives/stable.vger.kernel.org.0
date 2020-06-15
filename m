Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA571FA17C
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 22:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729836AbgFOUac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 16:30:32 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:55519 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728346AbgFOUab (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 16:30:31 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 895061940692;
        Mon, 15 Jun 2020 16:30:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 16:30:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=P4yZNi
        glJFbDEfpZojwZicgvLd6KpNNkhgxQQWOHsAI=; b=Tx2Lt2p5fJ/7s0YVRucWmu
        8OgHs1TUGQWsSU1PHO0vJaLhl8CKRcFTb+4LFCztCsiMkNq9iIiRGFrP/n7W7MJE
        AVHtiFwhaL1uipj2JaaKLs1VCUsmx4mC/RuPMJjCXt4rr4OrTLIjIPJNB/9qRSvN
        WA8GUyhCA3LI51i98Q0w1noekZ6795onFkB+5Vkwz91HKrdgNMg1nnayr5csHa96
        2YidaRRHj4uF8FoAHTl4dLaHDDieQTYm52dIuzd6/vNDr/fhaXF/3zwmaF09oWlr
        ToP1rcl1nBH33bB+P4BC6D0groNDfJZz6DuAlmtb/M1ZJN5QnHxnl1S3mfi3+9rw
        ==
X-ME-Sender: <xms:ZdrnXtknf4CJpyh4Z1lZUTV5_APuEJH0FT0ZKHHBP2n5WcK7_03CPw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgudehudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:ZdrnXo0J8yWMjz6STFMbzn2jjPj8rWE3ockjhOosrh64zq7rYuqvKg>
    <xmx:ZdrnXjoXbI515XsRmK3be-1gKnzgZjHtyg7IVNDUUD9ceqAbi6D2pA>
    <xmx:ZdrnXtlrP7slk2myT5nM8iEkKKE_Ol_sb5J2bio6y1ibmhq-XuXfHA>
    <xmx:ZtrnXszvg6At3oxuXfxZ_QFa453HRc4QLOdzJh51QQQsxHpoHIaKog>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 797983060FE7;
        Mon, 15 Jun 2020 16:30:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: virtio: Fix dest length calculation in" failed to apply to 5.4-stable tree
To:     longpeng2@huawei.com, arei.gonglei@huawei.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, jasowang@redhat.com, mst@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 22:30:24 +0200
Message-ID: <159225302411542@kroah.com>
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
 

