Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC13F17626B
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 19:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbgCBSWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 13:22:30 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:43185 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbgCBSWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Mar 2020 13:22:30 -0500
Received: by mail-il1-f194.google.com with SMTP id o18so331421ilg.10
        for <stable@vger.kernel.org>; Mon, 02 Mar 2020 10:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mQmButSUn+XhPD47Gd9ma2Yp+YshyG+FZj4b2tsKIVY=;
        b=KU6BkO4QvaLn4HwtkIwUz/1Aun62dbkLkmLH1abXgzWGXWLeclbF8a8zhyYZvTzDDY
         pBkM4oKBm+PovUo/fvK4eH/CP2FG92pZqmBNasqUkgCV32XNIBPVt/lB/Ud25ip1F1zm
         9oulgyQ5FUkmRWC4hB3/loERxp4NZMR50ZIoa3qrH4BI9wEF2H9pH2iq6xYRorLxYGhP
         +Jv3hGAc/Pz5TRfQdEhVeNv/+QCE7zdrx7TgNu67wVxgoy41eEm3+GJWOEezFuXB7A22
         88q5GJUlTieZz0mtBHn77BpKjX8g0f/cufikDAeyPsX8yoxpoY96LkRTsG9kuf+121ML
         +ehA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mQmButSUn+XhPD47Gd9ma2Yp+YshyG+FZj4b2tsKIVY=;
        b=dL8RFXHedtxMtxszr4nJvVFYqyLyw8vl9ip+zYCSzOZtL1aiG5LNbNClZJzWN+uaAJ
         635vNQ/lOkajU1Xa0RRcLfeqs+W0KwOgzbGIS26zkPF7ZBkKuH3iBwo1FikyOMRNRdjT
         408mpMtSokqVA1pgnQtbpUFSYzKD5ZwCSbZpQB/Im9bwSUIZeZL14a6FjhsPf17VdsQM
         2/4r4T5ygBK8MlvLYrxVxesdm/qr3ExlPvH8oQVcbGpMcYWffamM/EGJ1Twg4gsy3Kby
         Mlhw6uEKHrEDHkeku8LL5mglbwCBMEJYPi7qE5gyxMleCxbi5wxZFs2UVnD77UkRtKuY
         1b+Q==
X-Gm-Message-State: ANhLgQ20eGkP1QMiDPn9s0FEbkJ1m+2mnbaxlRIMPcGohKsJQtLvtVLV
        PO+tA9R3DZvsBgXf7NYCe2NrvlmzYDo=
X-Google-Smtp-Source: ADFU+vu4HjnxKWyou6wV6qX0t5wgU+SLSXHhXP84ApiXxs84/idiShE1WvVpiANvn8IMI5YI0XYK3A==
X-Received: by 2002:a92:a198:: with SMTP id b24mr883150ill.79.1583173347578;
        Mon, 02 Mar 2020 10:22:27 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j1sm494247iok.2.2020.03.02.10.22.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 10:22:27 -0800 (PST)
Subject: Re: FAILED: patch "[PATCH] io_uring: fix 32-bit compatability with
 sendmsg/recvmsg" failed to apply to 5.4-stable tree
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
References: <158317278525473@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <344856f5-2da1-7019-fc64-f3d26b6f8962@kernel.dk>
Date:   Mon, 2 Mar 2020 11:22:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <158317278525473@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/2/20 11:13 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's a 5.4 version.


commit d876836204897b6d7d911f942084f69a1e9d5c4d
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Feb 27 14:17:49 2020 -0700

    io_uring: fix 32-bit compatability with sendmsg/recvmsg
    
    We must set MSG_CMSG_COMPAT if we're in compatability mode, otherwise
    the iovec import for these commands will not do the right thing and fail
    the command with -EINVAL.
    
    Found by running the test suite compiled as 32-bit.
    
    Cc: stable@vger.kernel.org
    Fixes: aa1fa28fc73e ("io_uring: add support for recvmsg()")
    Fixes: 0fa03c624d8f ("io_uring: add support for sendmsg()")
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 607edaef5e71..4e7504eeb015 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1666,6 +1666,11 @@ static int io_send_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		else if (force_nonblock)
 			flags |= MSG_DONTWAIT;
 
+#ifdef CONFIG_COMPAT
+		if (req->ctx->compat)
+			flags |= MSG_CMSG_COMPAT;
+#endif
+
 		msg = (struct user_msghdr __user *) (unsigned long)
 			READ_ONCE(sqe->addr);
 

-- 
Jens Axboe

