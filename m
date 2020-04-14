Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984051A84FE
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 18:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391704AbgDNQbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 12:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391702AbgDNQbk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 12:31:40 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A739BC061A0C
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 09:31:40 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id n10so162030pff.3
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 09:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Uz1yaekv7Fun002mUPP+tLPKZaBb24PzPJXgb3PMM7M=;
        b=OBGFJS9kSZNY1MTWg1o6SUhZE2x3ycLr63Vrk35/xEaESXP5py5OoHfbd8W5dTKe7K
         KRUneqm9HHST+aqrC8eJBb35f5bOGZaH3kxDT8UPX4ECnaw/paATxUnvLlFZp7Vfz756
         Oi9g+P94UcNTkqdY57TYavm2THWE2OP42YN952uHNT8Yq8HKHjT0hVvmQeNmo/GF11c+
         sJPW/hnk0suk7Bj9XNYoh1yf/hAWWPjGFqWW3gaPmo3n2UyQAdqUEidbJjKcaWEBMJAG
         y9R1uzHwj3edCL3ekDTaQDkTpQmgYhoSDR3JsmghyDe8ojRrn7U72MHri8FHBWOApneZ
         Dm+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Uz1yaekv7Fun002mUPP+tLPKZaBb24PzPJXgb3PMM7M=;
        b=A7q4R4LF0jycx+3ZLdsWkXxLj1SoAyUVMIko1OHrSpPbFsHv7amBzSGrSqJQGdgWpP
         coztQ5rbV8msdM6jV9QTr4PYmqS/dRw+22fbiYUqLL5TnfUJ3UOXAavNLd9GKcRSulXZ
         oGm3UpknByYVtCpj9fBMfY6JDA6SbPmbaKuIXOBsC9u2XWH7Nr1ujN58GnB+xOflDeZ5
         JrD0MIFwOraF4mX7fh70rSA+xtP0T0U7M9US5RloB7hxxTa2d9CVSD2a7UAoPU/T0TNA
         waudNvwca2qZ/+PzdTHPiVDuR1bd8BlNh1/rJWQzq4hve+vJVOlyUQTT+6AP8Uzk+pF2
         xXqw==
X-Gm-Message-State: AGi0PubcpSKUeoEk1cTGmPzwQMBgzp5o0GB5pJsqodQgjQjJYOk7+cv+
        qmSFkZP3JtgRKHxJaa3K+czUaisA7g7s7A==
X-Google-Smtp-Source: APiQypJ13YEaqPXy5Y1/iBkWOVjYXf/WRuC/VHVn4LUwcrL6yWiPbTp4zcWq75VxWjNZKU0aU/SfuQ==
X-Received: by 2002:a63:4850:: with SMTP id x16mr22957008pgk.317.1586881899904;
        Tue, 14 Apr 2020 09:31:39 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id d8sm5998819pfd.159.2020.04.14.09.31.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 09:31:38 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: honor original task
 RLIMIT_FSIZE" failed to apply to 5.4-stable tree
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
References: <15868668307141@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <898eca01-58e5-8452-34b3-100de2506b38@kernel.dk>
Date:   Tue, 14 Apr 2020 10:31:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <15868668307141@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/14/20 6:20 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's a 5.4 backport.

From 4ed734b0d0913e566a9d871e15d24eb240f269f7 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Fri, 20 Mar 2020 11:23:41 -0600
Subject: [PATCH] io_uring: honor original task RLIMIT_FSIZE

With the previous fixes for number of files open checking, I added some
debug code to see if we had other spots where we're checking rlimit()
against the async io-wq workers. The only one I found was file size
checking, which we should also honor.

During write and fallocate prep, store the max file size and override
that for the current ask if we're in io-wq worker context.

Cc: stable@vger.kernel.org # 5.1+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 607edaef5e71..3550dd97ed64 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -331,6 +331,7 @@ struct io_kiocb {
 #define REQ_F_ISREG		2048	/* regular file */
 #define REQ_F_MUST_PUNT		4096	/* must be punted even for NONBLOCK */
 #define REQ_F_TIMEOUT_NOSEQ	8192	/* no timeout sequence */
+	unsigned long		fsize;
 	u64			user_data;
 	u32			result;
 	u32			sequence;
@@ -1404,6 +1405,8 @@ static int io_read(struct io_kiocb *req, const struct sqe_submit *s,
 	size_t iov_count;
 	ssize_t read_size, ret;
 
+	req->fsize = rlimit(RLIMIT_FSIZE);
+
 	ret = io_prep_rw(req, s, force_nonblock);
 	if (ret)
 		return ret;
@@ -1513,10 +1516,17 @@ static int io_write(struct io_kiocb *req, const struct sqe_submit *s,
 		}
 		kiocb->ki_flags |= IOCB_WRITE;
 
+		if (!force_nonblock)
+			current->signal->rlim[RLIMIT_FSIZE].rlim_cur = req->fsize;
+
 		if (file->f_op->write_iter)
 			ret2 = call_write_iter(file, kiocb, &iter);
 		else
 			ret2 = loop_rw_iter(WRITE, file, kiocb, &iter);
+
+		if (!force_nonblock)
+			current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
+
 		if (!force_nonblock || ret2 != -EAGAIN) {
 			io_rw_done(kiocb, ret2);
 		} else {


-- 
Jens Axboe

