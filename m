Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAFD60034C
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 22:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiJPUfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 16:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiJPUfn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 16:35:43 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC4F37188
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 13:35:42 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id 13so20885862ejn.3
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 13:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1dsEJtRQSO2w3laOKJnGSSoqsh2IPl5ke2XC2Hs2x3c=;
        b=RhSMk5y4Sdg0o6uGOnThJKO7/LlchUGuEaezSFk9ELxNbL77j6E2FwRGhC0OyLQkeE
         LOXj8vQWaY3x/P8qih6tGoIVhYF7KalL/SE/OPaCA2gM8DLR3n6peYGizWeDNr+vN/Os
         oc+yU6s9Faa5JIL4joE2MK6uFFO99WxNGzGJiEjlq/m9072ynGsALF3yhtXuoe3mRTGq
         Ug5gcJsNpFOyIq8bH0dERbVLAVqLnwcbRm1UzQLGM93p1PCs1v8v2c/ycYPhO0OQyVFd
         wgR0gCfVRtDK09Cxp59ej2THFFfn2WE/FY/81YUXsf+KyHhpX5iv3NoScGTh3m/whHEr
         FiDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1dsEJtRQSO2w3laOKJnGSSoqsh2IPl5ke2XC2Hs2x3c=;
        b=k13KeQdpNktBwg4rac7TQKIea+7Jms9e+en9WEiEhf8TEvfADFSWmQKWsaFz9XZYkZ
         0262bPEZidb1TZ+sSqhUAqyjxjxQIUtROMI61ytQ2RJV/UrlVKo+lubqx4UdtnjeFCPd
         vfflwbcq+LJzF+YLI/YtV5mXwr6WOCARjSpnJaUIGoA4aHwM+v/qfn80TCf/yyD4sb5x
         m0YSWjiOh1X5msMhVHGbK2FD8rZuBDC7ApbwdFXYt3LI1l/TOXHZ3qzo86/Cl1jGh+a4
         Tr7C4JwzpxeHCbQzwoXNyzwb9bHz0XraC4X7tcJchkFXMYtGJg6h75ne4gMyqkm94yXj
         Iejw==
X-Gm-Message-State: ACrzQf2AlcjewODSB85sQbRV6i28RkYLXGT4/OLOd6qMn8SJmEOTOSMG
        QeN+ipEBC3E6Wiw7y10jsyvHuUWZnBE=
X-Google-Smtp-Source: AMsMyM44sj0fKxn/mIijIS66tfePYezhnWguiZ6M9LBLvg7/56btxjxXgj+mcc0GalnFVWhIJhy6ZQ==
X-Received: by 2002:a17:907:3f27:b0:78d:ad42:f733 with SMTP id hq39-20020a1709073f2700b0078dad42f733mr6396418ejc.320.1665952540429;
        Sun, 16 Oct 2022 13:35:40 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id m3-20020a170906160300b0078194737761sm5008083ejd.124.2022.10.16.13.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 13:35:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-6.0 4/6] io_uring/net: rename io_sendzc()
Date:   Sun, 16 Oct 2022 21:33:28 +0100
Message-Id: <7f580aebe73419deff39d7300544b1ca559a9057.1665951939.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1665951939.git.asml.silence@gmail.com>
References: <cover.1665951939.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ upstream commit b0e9b5517eb12fa80c72e205fe28534c2e2f39b9 ]

Simple renaming of io_sendzc*() functions in preparatio to adding
a zerocopy sendmsg variant.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/265af46829e6076dd220011b1858dc3151969226.1663668091.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c   | 6 +++---
 io_uring/net.h   | 6 +++---
 io_uring/opdef.c | 6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 83cb8f1f6672..3dbb2bf99b4d 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -871,7 +871,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	return ret;
 }
 
-void io_sendzc_cleanup(struct io_kiocb *req)
+void io_send_zc_cleanup(struct io_kiocb *req)
 {
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 
@@ -880,7 +880,7 @@ void io_sendzc_cleanup(struct io_kiocb *req)
 	zc->notif = NULL;
 }
 
-int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_ring_ctx *ctx = req->ctx;
@@ -985,7 +985,7 @@ static int io_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 	return ret;
 }
 
-int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
+int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct sockaddr_storage __address, *addr = NULL;
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
diff --git a/io_uring/net.h b/io_uring/net.h
index e7366aac335c..4090d008fd55 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -55,9 +55,9 @@ int io_connect_prep_async(struct io_kiocb *req);
 int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_connect(struct io_kiocb *req, unsigned int issue_flags);
 
-int io_sendzc(struct io_kiocb *req, unsigned int issue_flags);
-int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
-void io_sendzc_cleanup(struct io_kiocb *req);
+int io_send_zc(struct io_kiocb *req, unsigned int issue_flags);
+int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+void io_send_zc_cleanup(struct io_kiocb *req);
 void io_send_zc_fail(struct io_kiocb *req);
 
 void io_netmsg_cache_free(struct io_cache_entry *entry);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 7f85e0fbd60b..4f0f69482016 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -484,10 +484,10 @@ const struct io_op_def io_op_defs[] = {
 		.manual_alloc		= 1,
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
-		.prep			= io_sendzc_prep,
-		.issue			= io_sendzc,
+		.prep			= io_send_zc_prep,
+		.issue			= io_send_zc,
 		.prep_async		= io_sendzc_prep_async,
-		.cleanup		= io_sendzc_cleanup,
+		.cleanup		= io_send_zc_cleanup,
 		.fail			= io_send_zc_fail,
 #else
 		.prep			= io_eopnotsupp_prep,
-- 
2.38.0

