Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0418A23CEF3
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 21:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbgHETKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 15:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729284AbgHESeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 14:34:16 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299A9C061757
        for <stable@vger.kernel.org>; Wed,  5 Aug 2020 11:34:13 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id r11so15352159pfl.11
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 11:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=3uKuALbj50Q0JbREXDATt+b6tbcgxg3fyPprhXR9jxw=;
        b=PGvCZeBZnPQ7kxClhlJx3KEt+9lwPsjzWJ3i767WlbBF/q5CtSovvI6H0b5dOrMdjp
         kbqnVo0hwAhsrQvSkan2rzqsCzdtUVwXsPRg8qHF4hgrvSTaP1Bd8DU6TNc4880bS10Q
         Vfyv39h4PFr3XLVqyTsPZlkDcxDJs1advTw5r25+E+xSjKFUhDBvp3KoLbJysD85kr00
         QajXL0D1+CYoz6nZZ+i5yrixkFBR6pl8OoXTcjazEmRgREYVNC9lBkeZUMyQVYSr8Hqj
         tpF+VCg7tY7h4BucdDRvQM06sulbq/TfmxRh88tQJT45be/LD6LmLJLrBpeGuMOtBbtd
         ag1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=3uKuALbj50Q0JbREXDATt+b6tbcgxg3fyPprhXR9jxw=;
        b=pNBVFFBWdE3JZPAEuzb9NTZL5A+8RMeYAiXCErFaezgg0J+2OqZniu6sfG1yzG/LNO
         i4oKw9awHzC6iJeshfh+0RY11h+TGPwGhvz0AR7GgDiuQtRyZbs9PemY6LktiqnxhoPu
         UM2O0b4nDZAqTFab1XX6KEb8fe2pWn/lj3Pm644FdW38g/0r0qMMEzDha3fr3f4hBaxx
         sxLxHRefmzZhw92q+uR9ZJtCMYJw6XWysP4pfLTR43chw42/dp4EC/ACNtmXasl9tesu
         xmWZU6G28CdaiHtJvcj2xLs+znS/EJjKN+xAXjD9nexzzVtYrjBn9BXnbzXhoPEooAy6
         hwaQ==
X-Gm-Message-State: AOAM530cqOWJABc4y6Fcgm4vLZ11FvZnknSvbeg/PEC87hywLe4pfO1O
        R2M13a2qnYrSNpVzu+1DRRiZGbGSLSU=
X-Google-Smtp-Source: ABdhPJw1+2Aaih2XDyyawtBHXCe937KDSQ2TnTTxjEDC7KhuzpIU99rAtrkKkBPVlKAhBPxUorqT1Q==
X-Received: by 2002:a63:4c48:: with SMTP id m8mr4203406pgl.290.1596652451769;
        Wed, 05 Aug 2020 11:34:11 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l9sm3812046pjf.46.2020.08.05.11.34.10
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 11:34:10 -0700 (PDT)
To:     stable@vger.kernel.org
From:   Jens Axboe <axboe@kernel.dk>
Subject: 5.4 stable inclusion request
Message-ID: <9740b863-25f0-7adc-7bdc-f95bf8c664f5@kernel.dk>
Date:   Wed, 5 Aug 2020 12:34:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Below is a io_uring patch that I'd like to get into 5.4. There's no
equiv 5.5 commit, because the resulting changes were a lot more invasive
there to avoid re-reading important sqe fields. But the reporter has
also tested this one and verifies it fixes his issue. Can we get this
queued up for 5.4?


commit 8cfecb9a5d7b2aff34547652adc5bb00a8da5fac
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed Aug 5 12:30:36 2020 -0600

    io_uring: prevent re-read of sqe->opcode
    
    Liu reports that he can trigger a NULL pointer dereference with
    IORING_OP_SENDMSG, by changing the sqe->opcode after we've validated
    that the previous opcode didn't need a file and didn't assign one.
    
    Ensure we validate and read the opcode only once.
    
    Reported-by: Liu Yong <pkfxxxing@gmail.com>
    Tested-by: Liu Yong <pkfxxxing@gmail.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e0200406765c..8bb5e19b7c3c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -279,6 +279,7 @@ struct sqe_submit {
 	bool				has_user;
 	bool				needs_lock;
 	bool				needs_fixed_file;
+	u8				opcode;
 };
 
 /*
@@ -505,7 +506,7 @@ static inline void io_queue_async_work(struct io_ring_ctx *ctx,
 	int rw = 0;
 
 	if (req->submit.sqe) {
-		switch (req->submit.sqe->opcode) {
+		switch (req->submit.opcode) {
 		case IORING_OP_WRITEV:
 		case IORING_OP_WRITE_FIXED:
 			rw = !(req->rw.ki_flags & IOCB_DIRECT);
@@ -1254,23 +1255,15 @@ static int io_import_fixed(struct io_ring_ctx *ctx, int rw,
 }
 
 static ssize_t io_import_iovec(struct io_ring_ctx *ctx, int rw,
-			       const struct sqe_submit *s, struct iovec **iovec,
+			       struct io_kiocb *req, struct iovec **iovec,
 			       struct iov_iter *iter)
 {
-	const struct io_uring_sqe *sqe = s->sqe;
+	const struct io_uring_sqe *sqe = req->submit.sqe;
 	void __user *buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	size_t sqe_len = READ_ONCE(sqe->len);
 	u8 opcode;
 
-	/*
-	 * We're reading ->opcode for the second time, but the first read
-	 * doesn't care whether it's _FIXED or not, so it doesn't matter
-	 * whether ->opcode changes concurrently. The first read does care
-	 * about whether it is a READ or a WRITE, so we don't trust this read
-	 * for that purpose and instead let the caller pass in the read/write
-	 * flag.
-	 */
-	opcode = READ_ONCE(sqe->opcode);
+	opcode = req->submit.opcode;
 	if (opcode == IORING_OP_READ_FIXED ||
 	    opcode == IORING_OP_WRITE_FIXED) {
 		ssize_t ret = io_import_fixed(ctx, rw, sqe, iter);
@@ -1278,7 +1271,7 @@ static ssize_t io_import_iovec(struct io_ring_ctx *ctx, int rw,
 		return ret;
 	}
 
-	if (!s->has_user)
+	if (!req->submit.has_user)
 		return -EFAULT;
 
 #ifdef CONFIG_COMPAT
@@ -1425,7 +1418,7 @@ static int io_read(struct io_kiocb *req, const struct sqe_submit *s,
 	if (unlikely(!(file->f_mode & FMODE_READ)))
 		return -EBADF;
 
-	ret = io_import_iovec(req->ctx, READ, s, &iovec, &iter);
+	ret = io_import_iovec(req->ctx, READ, req, &iovec, &iter);
 	if (ret < 0)
 		return ret;
 
@@ -1490,7 +1483,7 @@ static int io_write(struct io_kiocb *req, const struct sqe_submit *s,
 	if (unlikely(!(file->f_mode & FMODE_WRITE)))
 		return -EBADF;
 
-	ret = io_import_iovec(req->ctx, WRITE, s, &iovec, &iter);
+	ret = io_import_iovec(req->ctx, WRITE, req, &iovec, &iter);
 	if (ret < 0)
 		return ret;
 
@@ -2109,15 +2102,14 @@ static int io_req_defer(struct io_ring_ctx *ctx, struct io_kiocb *req,
 static int __io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			   const struct sqe_submit *s, bool force_nonblock)
 {
-	int ret, opcode;
+	int ret;
 
 	req->user_data = READ_ONCE(s->sqe->user_data);
 
 	if (unlikely(s->index >= ctx->sq_entries))
 		return -EINVAL;
 
-	opcode = READ_ONCE(s->sqe->opcode);
-	switch (opcode) {
+	switch (req->submit.opcode) {
 	case IORING_OP_NOP:
 		ret = io_nop(req, req->user_data);
 		break;
@@ -2181,10 +2173,10 @@ static int __io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	return 0;
 }
 
-static struct async_list *io_async_list_from_sqe(struct io_ring_ctx *ctx,
-						 const struct io_uring_sqe *sqe)
+static struct async_list *io_async_list_from_req(struct io_ring_ctx *ctx,
+						 struct io_kiocb *req)
 {
-	switch (sqe->opcode) {
+	switch (req->submit.opcode) {
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
 		return &ctx->pending_async[READ];
@@ -2196,12 +2188,10 @@ static struct async_list *io_async_list_from_sqe(struct io_ring_ctx *ctx,
 	}
 }
 
-static inline bool io_sqe_needs_user(const struct io_uring_sqe *sqe)
+static inline bool io_req_needs_user(struct io_kiocb *req)
 {
-	u8 opcode = READ_ONCE(sqe->opcode);
-
-	return !(opcode == IORING_OP_READ_FIXED ||
-		 opcode == IORING_OP_WRITE_FIXED);
+	return !(req->submit.opcode == IORING_OP_READ_FIXED ||
+		req->submit.opcode == IORING_OP_WRITE_FIXED);
 }
 
 static void io_sq_wq_submit_work(struct work_struct *work)
@@ -2217,7 +2207,7 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 	int ret;
 
 	old_cred = override_creds(ctx->creds);
-	async_list = io_async_list_from_sqe(ctx, req->submit.sqe);
+	async_list = io_async_list_from_req(ctx, req);
 
 	allow_kernel_signal(SIGINT);
 restart:
@@ -2239,7 +2229,7 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 		}
 
 		ret = 0;
-		if (io_sqe_needs_user(sqe) && !cur_mm) {
+		if (io_req_needs_user(req) && !cur_mm) {
 			if (!mmget_not_zero(ctx->sqo_mm)) {
 				ret = -EFAULT;
 			} else {
@@ -2387,11 +2377,9 @@ static bool io_add_to_prev_work(struct async_list *list, struct io_kiocb *req)
 	return ret;
 }
 
-static bool io_op_needs_file(const struct io_uring_sqe *sqe)
+static bool io_op_needs_file(struct io_kiocb *req)
 {
-	int op = READ_ONCE(sqe->opcode);
-
-	switch (op) {
+	switch (req->submit.opcode) {
 	case IORING_OP_NOP:
 	case IORING_OP_POLL_REMOVE:
 	case IORING_OP_TIMEOUT:
@@ -2419,7 +2407,7 @@ static int io_req_set_file(struct io_ring_ctx *ctx, const struct sqe_submit *s,
 	 */
 	req->sequence = s->sequence;
 
-	if (!io_op_needs_file(s->sqe))
+	if (!io_op_needs_file(req))
 		return 0;
 
 	if (flags & IOSQE_FIXED_FILE) {
@@ -2460,7 +2448,7 @@ static int __io_queue_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 			s->sqe = sqe_copy;
 			memcpy(&req->submit, s, sizeof(*s));
-			list = io_async_list_from_sqe(ctx, s->sqe);
+			list = io_async_list_from_req(ctx, req);
 			if (!io_add_to_prev_work(list, req)) {
 				if (list)
 					atomic_inc(&list->cnt);
@@ -2582,7 +2570,7 @@ static void io_submit_sqe(struct io_ring_ctx *ctx, struct sqe_submit *s,
 	req->user_data = s->sqe->user_data;
 
 #if defined(CONFIG_NET)
-	switch (READ_ONCE(s->sqe->opcode)) {
+	switch (req->submit.opcode) {
 	case IORING_OP_SENDMSG:
 	case IORING_OP_RECVMSG:
 		spin_lock(&current->fs->lock);
@@ -2697,6 +2685,7 @@ static bool io_get_sqring(struct io_ring_ctx *ctx, struct sqe_submit *s)
 	if (head < ctx->sq_entries) {
 		s->index = head;
 		s->sqe = &ctx->sq_sqes[head];
+		s->opcode = READ_ONCE(s->sqe->opcode);
 		s->sequence = ctx->cached_sq_head;
 		ctx->cached_sq_head++;
 		return true;

-- 
Jens Axboe

