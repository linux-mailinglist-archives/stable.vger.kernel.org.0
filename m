Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3CF297BAC
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 11:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760492AbgJXJlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 05:41:14 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:36487 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1760452AbgJXJlO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 05:41:14 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id CDB2860C;
        Sat, 24 Oct 2020 05:41:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 24 Oct 2020 05:41:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Cr9IAp
        GADXEXGG85BQcWXy88IsCCTIjNfNI8XWtub40=; b=IpYnsoDU4A2llAQkzT7ter
        +/rtRihDD5V1DbUcqHcV0tbLjXWQ0YCv3E91sR8KJrs0x6p83tmlyv91WmUVpLWe
        RXAY6us/33OyP3hMw/tYpXDt1KFRpKD+6gwEI8V2nP28HdayXOrSoY6Vry5pA7Sg
        SePnH1q9QlRp1PemCqLs4Q9Y26QCVIYU2DbGPu26bEIsUc5a0G3Dlz1c150k5o8k
        us4aC7ZW+HIywGrBRQAuMjnBSoGkSvGD+8cTWUsLob25VIznWwEca4vsyi/WZHJ6
        Clls6wFWfhoZGVnIoXD5y9zsZPbm9BT2QODQwd+0Y55nvB0qqrwIhnGkWVwvA69A
        ==
X-ME-Sender: <xms:ufaTX-Q6Oj2_4p_F42gJo40pEP4583zg2S0q31kmrlLDl5KDX-hYlQ>
    <xme:ufaTXzwH2qzuWvdMUK0OJ8h2GcYD9R7cTYryFMgpaK_auPg5fuSd532eOE_JtgpVe
    GTXoP24mDzD2g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkedvgddulecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:ufaTX71UBSa_gzuuJ4VCaT8gVpDN931VwbyGa9tydczKG7kvp7uNZQ>
    <xmx:ufaTX6BOhkPMROJjcQBM6RyeI78a1g2Uae2H1PhR_OM0wnaiF9XcTg>
    <xmx:ufaTX3j-luLyNJyN3Q4SAUrNWNl00vjJdftwCLXZXdXFKB83B-flvw>
    <xmx:ufaTX5dlCXKsxDaNMLkwpZgjBWxbT4hgrQ93I-9_57ihMjs0PClOrrvoiCE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DA4BC3064674;
        Sat, 24 Oct 2020 05:41:12 -0400 (EDT)
Subject: FAILED: patch "[PATCH] smb3: do not try to cache root directory if dir leases not" failed to apply to 5.4-stable tree
To:     stfrench@microsoft.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 24 Oct 2020 11:41:47 +0200
Message-ID: <160353250724318@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 3c6e65e679182d55779ef6f8582f0945af4319b0 Mon Sep 17 00:00:00 2001
From: Steve French <stfrench@microsoft.com>
Date: Wed, 21 Oct 2020 00:15:42 -0500
Subject: [PATCH] smb3: do not try to cache root directory if dir leases not
 supported

To servers which do not support directory leases (e.g. Samba)
it is wasteful to try to open_shroot (ie attempt to cache the
root directory handle).  Skip attempt to open_shroot when
server does not indicate support for directory leases.

Cuts the number of requests on mount from 17 to 15, and
cuts the number of requests on stat of the root directory
from 4 to 3.

Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org> # v5.1+

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d096cfda56eb..3a9980bf0d6e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3608,7 +3608,10 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 	 */
 	tcon->retry = volume_info->retry;
 	tcon->nocase = volume_info->nocase;
-	tcon->nohandlecache = volume_info->nohandlecache;
+	if (ses->server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASING)
+		tcon->nohandlecache = volume_info->nohandlecache;
+	else
+		tcon->nohandlecache = 1;
 	tcon->nodelete = volume_info->nodelete;
 	tcon->local_lease = volume_info->local_lease;
 	INIT_LIST_HEAD(&tcon->pending_opens);

