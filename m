Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0DEB56BF91
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 20:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238087AbiGHQjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 12:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238504AbiGHQjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 12:39:24 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9862250A;
        Fri,  8 Jul 2022 09:39:24 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id D4D0532009A4;
        Fri,  8 Jul 2022 12:39:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 08 Jul 2022 12:39:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm2; t=
        1657298362; x=1657384762; bh=jL+f1joq8YvrpHlirkwlocAEqytxnYsGsQN
        MmbsBj+k=; b=bkpVHl53b6JBmcsyJgTrDWib8he62qL7C+p5bEgemRrib5QUhn2
        wpp+opvwGDksTCS5DUVqpjtWOjuBDCEbfUwfWhj7mVdOH6RAcgssxN0Fe5ZjJjaV
        YENGvqh/CV9AjykdnrGexhKaEfKXWLL11MRGYkGtRtcYMKlKYXywvicPXgvvlyO6
        v5D9zvO0v/GMXLN65+F9Ge3H4T+vlDQCCAJkbd5k3b1LHim/UVfLp9J6Xnm2lcuD
        4TBpLuEeLLvcxjShA2zitcrZRa24RNbVZFDXwo2uJVLiO2TjV1F9kgMaMOlFSGLb
        zyEdPOVsG3mcIombJvc9zA3KZbKdfH8AvxA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1657298362; x=1657384762; bh=jL+f1joq8Yvrp
        HlirkwlocAEqytxnYsGsQNMmbsBj+k=; b=vKTndTFzZaxVI615asSUe9gpMDLgS
        +nHU0dIfe7pSOlYkTbY/jyN1iCYbEIf0PlPEzzOf0C2iEiUxwbhq0zRBRF3EOMyQ
        IWFkeBdr98gPxRkKA/I3BhShc5e9n5lDJImtif6Lc/9YQ0AcesTLt/+B0UxVGy7l
        taMR5r2kMaNFfBF7wNnNXxwKSkP/h3NZ57f7zHgUckakI2EgxhVt0Htgni6zE8VF
        ddAJN5qdEqSc/2NTKBo8xGGC4D4zEMnQEu+7EhdMeqDAaIJUBEW/2zYh6MkwaR3a
        YcIQKh05r/QoSvfANp5E5ubj55/NasCjHkZ3IbEKfMXt4+yHyeq4/rPjQ==
X-ME-Sender: <xms:ul3IYqugTcFs7fDhQep5OGrog9MnTk6Qa4OjypkHEFJbUnyRkThDfQ>
    <xme:ul3IYvcmAbyD8etKR5XvRZ5grvacVku40-ldmAStBZr5Ct4FQjMKSe7SvGVWV0esh
    UuxWvGhUi9dt40>
X-ME-Received: <xmr:ul3IYlzZkyoTLKEyuh-vMEv_YyflMnozvt95dVgx0En-rrj0cFKjJjZ8zbCzEN_oQYjQDs7t14Qj>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeijedguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffvghm
    ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
    hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeejffejgffgueegudevvdejkefg
    hefghffhffejteekleeufeffteffhfdtudehteenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
    shhlrggsrdgtohhm
X-ME-Proxy: <xmx:ul3IYlOg72N1L_tCFAwuN4UD4TYUBbGGJ6S0W-RyVxB3aCU38o5vEA>
    <xmx:ul3IYq-Z2dm_HkEF-9X55SINX9HbzKoHzg_m5rtGuj3THaXZe6YnYg>
    <xmx:ul3IYtVF9DGKUFXn09DLMQmXTuE_LpPTP2uvP-jhsZgiBrj7tXBpug>
    <xmx:ul3IYqyG4Eh8LjDTAVjzx7ZcjazmnyO9Aq6ny4jKMIlpMkeKSyV0og>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 Jul 2022 12:39:21 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Juergen Gross <jgross@suse.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Demi Marie Obenour <demi@invisiblethingslab.com>
Cc:     Linux kernel regressions <regressions@lists.linux.dev>,
        stable@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Xen developer discussion <xen-devel@lists.xenproject.org>
Subject: [PATCH 5.18] Ignore failure to unmap INVALID_GRANT_HANDLE
Date:   Fri,  8 Jul 2022 12:37:50 -0400
Message-Id: <20220708163750.2005-7-demi@invisiblethingslab.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220708163750.2005-1-demi@invisiblethingslab.com>
References: <20220708163750.2005-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The error paths of gntdev_mmap() can call unmap_grant_pages() even
though not all of the pages have been successfully mapped.  This will
trigger the WARN_ON()s in __unmap_grant_pages_done().  The number of
warnings can be very large; I have observed thousands of lines of
warnings in the systemd journal.

Avoid this problem by only warning on unmapping failure if the handle
being unmapped is not INVALID_GRANT_HANDLE.  The handle field of any
page that was not successfully mapped will be INVALID_GRANT_HANDLE, so
this catches all cases where unmapping can legitimately fail.

Suggested-by: Juergen Gross <jgross@suse.com>
Cc: stable@vger.kernel.org
Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Fixes: d4a49d20cd7c ("xen/gntdev: Avoid blocking in unmap_grant_pages()")
---
 drivers/xen/gntdev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 4b56c39f766d4da68570d08d963f6ef40c8d9c37..22fcd503f4a4487d0aed147c94f432683dad8c73 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -396,13 +396,17 @@ static void __unmap_grant_pages_done(int result,
 	unsigned int offset = data->unmap_ops - map->unmap_ops;
 
 	for (i = 0; i < data->count; i++) {
-		WARN_ON(map->unmap_ops[offset+i].status);
+		WARN_ON(map->unmap_ops[offset+i].status &&
+			map->unmap_ops[offset+i].handle !=
+			INVALID_GRANT_HANDLE);
 		pr_debug("unmap handle=%d st=%d\n",
 			map->unmap_ops[offset+i].handle,
 			map->unmap_ops[offset+i].status);
 		map->unmap_ops[offset+i].handle = INVALID_GRANT_HANDLE;
 		if (use_ptemod) {
-			WARN_ON(map->kunmap_ops[offset+i].status);
+			WARN_ON(map->kunmap_ops[offset+i].status &&
+				map->kunmap_ops[offset+i].handle !=
+				INVALID_GRANT_HANDLE);
 			pr_debug("kunmap handle=%u st=%d\n",
 				 map->kunmap_ops[offset+i].handle,
 				 map->kunmap_ops[offset+i].status);
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab
