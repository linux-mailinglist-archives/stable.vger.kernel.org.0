Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBB61CAF65
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgEHNRe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:17:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728182AbgEHMnx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:43:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DA39207DD;
        Fri,  8 May 2020 12:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941832;
        bh=zU/KGDWSH/GSGW/PVSMIQOZ9CrPdwXtgZfYDOAMPFpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PgWiLwD3EiT/oY2aOvlrPdkfOzNrr02u9VLtiT2Emff7ZnSk2tcE226NfUQXQuiCV
         RZwf79EcX1NFOwR94GT8TfpRo0rIVRlSpCttZvJrZcvS5+VWxBgJrlmo/2ogX0Xpkf
         iKFJEb3yZDq9KEidkX2pRzufkdAhgR7TjIb/1ERE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 4.4 150/312] sunrpc: Update RPCBIND_MAXNETIDLEN
Date:   Fri,  8 May 2020 14:32:21 +0200
Message-Id: <20200508123135.008266264@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit 4b9c7f9db9a003f5c342184dc4401c1b7f2efb39 upstream.

Commit 176e21ee2ec8 ("SUNRPC: Support for RPC over AF_LOCAL
transports") added a 5-character netid, but did not bump
RPCBIND_MAXNETIDLEN from 4 to 5.

Fixes: 176e21ee2ec8 ("SUNRPC: Support for RPC over AF_LOCAL ...")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/sunrpc/msg_prot.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/sunrpc/msg_prot.h
+++ b/include/linux/sunrpc/msg_prot.h
@@ -158,9 +158,9 @@ typedef __be32	rpc_fraghdr;
 
 /*
  * Note that RFC 1833 does not put any size restrictions on the
- * netid string, but all currently defined netid's fit in 4 bytes.
+ * netid string, but all currently defined netid's fit in 5 bytes.
  */
-#define RPCBIND_MAXNETIDLEN	(4u)
+#define RPCBIND_MAXNETIDLEN	(5u)
 
 /*
  * Universal addresses are introduced in RFC 1833 and further spelled


