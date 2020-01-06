Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 558A813122E
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 13:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgAFMdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 07:33:32 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:43209 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726080AbgAFMdc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 07:33:32 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 76B32692;
        Mon,  6 Jan 2020 07:33:31 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 06 Jan 2020 07:33:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=RC9gly
        G7Y6bK93QDo82UKvIHE3cxIapaEfNRibOq6M4=; b=gJgPv7dHu2Q6i2nuKavqdW
        R89Z9S1AWJz7ZcIFyf6l4fSguhG/x9GYkWaNjqslVB4FLdbXEnqGa+x66/T0feAu
        AoLjVIoKX7teiOMwX2icEBwSycdtATR9BHjeqBdZSdPFv8SgpTTNiYUbOgfshYzM
        P6OJMZxl0c0JvIqqdjtkKo4r6isoj/x1GXh6yQ1f0qSXSFCcoXUr8Wp6UDLRUtoY
        osbyEwN+lOImijLGSYpb42WgNj6/0Gmw3yHIA+cwF8mwsqEZw0+X0FfeGFbyWnXj
        pfQpfKed7cV2TOg+lG9me07q4sAIGUnSZEAdiCWE69P/9qorYCR9ju+GRpYyLAZA
        ==
X-ME-Sender: <xms:GikTXvg63vU_xLy8NJhgkRiSAcAc5ebLLrE6IEfm2KaIrvV0eqSD1g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdehtddggeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:GykTXkZraMXKomCgJAEoSY4HN4uv3k84e9CSi3gejR1F3_PkqUkIzA>
    <xmx:GykTXrLG7HId3sLgIMfwFGikSBfqnLxfDM9IuXnkXKE7jvqvK5YFzw>
    <xmx:GykTXhtX2tAHmrCdoi3HChs8ylYxe3ZvgJNopJuCuUGsbEeWdQPNtw>
    <xmx:GykTXnHj1mReiql85qBRZ-Pfm2F5xFuMjMAwRZb2bs8Jth7QYtBi4w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id ABADB8005A;
        Mon,  6 Jan 2020 07:33:30 -0500 (EST)
Subject: FAILED: patch "[PATCH] pstore/ram: Write new dumps to start of recycled zones" failed to apply to 4.9-stable tree
To:     a.yashkin@inango-systems.com, a.gilman@inango-systems.com,
        keescook@chromium.org, n.merinov@inango-systems.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jan 2020 13:33:18 +0100
Message-ID: <157831399811194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9e5f1c19800b808a37fb9815a26d382132c26c3d Mon Sep 17 00:00:00 2001
From: Aleksandr Yashkin <a.yashkin@inango-systems.com>
Date: Mon, 23 Dec 2019 18:38:16 +0500
Subject: [PATCH] pstore/ram: Write new dumps to start of recycled zones

The ram_core.c routines treat przs as circular buffers. When writing a
new crash dump, the old buffer needs to be cleared so that the new dump
doesn't end up in the wrong place (i.e. at the end).

The solution to this problem is to reset the circular buffer state before
writing a new Oops dump.

Signed-off-by: Aleksandr Yashkin <a.yashkin@inango-systems.com>
Signed-off-by: Nikolay Merinov <n.merinov@inango-systems.com>
Signed-off-by: Ariel Gilman <a.gilman@inango-systems.com>
Link: https://lore.kernel.org/r/20191223133816.28155-1-n.merinov@inango-systems.com
Fixes: 896fc1f0c4c6 ("pstore/ram: Switch to persistent_ram routines")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index f753f3b6f88d..487ee39b438a 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -407,6 +407,17 @@ static int notrace ramoops_pstore_write(struct pstore_record *record)
 
 	prz = cxt->dprzs[cxt->dump_write_cnt];
 
+	/*
+	 * Since this is a new crash dump, we need to reset the buffer in
+	 * case it still has an old dump present. Without this, the new dump
+	 * will get appended, which would seriously confuse anything trying
+	 * to check dump file contents. Specifically, ramoops_read_kmsg_hdr()
+	 * expects to find a dump header in the beginning of buffer data, so
+	 * we must to reset the buffer values, in order to ensure that the
+	 * header will be written to the beginning of the buffer.
+	 */
+	persistent_ram_zap(prz);
+
 	/* Build header and append record contents. */
 	hlen = ramoops_write_kmsg_hdr(prz, record);
 	if (!hlen)

