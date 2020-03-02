Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 000D917626C
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 19:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbgCBSWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 13:22:47 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:45150 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbgCBSWr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Mar 2020 13:22:47 -0500
Received: by mail-io1-f68.google.com with SMTP id w9so403446iob.12
        for <stable@vger.kernel.org>; Mon, 02 Mar 2020 10:22:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=stinbNLKCKOXABZ4u+1LXHzUVOAA4t3UMSCvnDize/Y=;
        b=go0ZZxaIYsbRfOm6srt5QOf02lWDLIqOu0fHtDL/0sDRt/vZfEYOEnEws5UZyeKwRb
         MPHzlgb1dNVusK2HY6BP5r/BNhuDGAxvVPaPpxZGym2tMBykAV45BCs8Ui59RWczETes
         JAOux7AtMpOyDtZ/fkhhXULhIWjjz+vhhBblC39ga0Sx9r/7CtJd7JJIkhru9uepNBhv
         jjyoEJWzgD8whZ4OMOmecfkoWrA8gOAJ//WhCmU1TFpjqMG2zJxtMvrBGFtIiYp1hK5p
         8/4B2X1O6c9PuRkTDY3eb0Ssi+bqvoDAHgm+Uxo8esjz3WZRAQc+NREsWAQGMAgF2BdU
         jHlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=stinbNLKCKOXABZ4u+1LXHzUVOAA4t3UMSCvnDize/Y=;
        b=ByZkl+C6rFCyCwtw+hlDrDTUqiQKYqvN89/mNzW6QAQT9VhnJfYkmQn9W7mzM5XuaL
         fV3hRd/LuD77RtparYkG6LeFfUlWp3YwPcQij6XKIMKHYq9gS+ofmJ4lFfE0tw1qW23t
         GP763vaa5w7TQ/PI83IpoRX28WFiWf20aYvKyZ+x5noDcNnZwTmBGzDJums8lIsWxEvo
         DCgGq5u5LcIQ9VQ/S5Yl2v7/B46qm49QlXwxjrRqRWsI+/ylaGMnK23AV2uoYPOfo6GU
         lzdTWeC25dkZNCdlP81yhy1jqLGr9umARgfb1d/fUGXZwJNBGeNGGcGAEXybfumiPU1b
         kbjw==
X-Gm-Message-State: ANhLgQ0wym145JseDHEQxIBfgfkEL7nnA/Mgchcw/hNUBGY6cCQjpQx+
        8p4V1kqOk/t8wo3rw/o1HmAoeyqHQm4=
X-Google-Smtp-Source: ADFU+vsSeVvZKlhpOv/yMk6MSkkWS+j9p5uBQYqPkAKZpINwOE5wPmpnZ03apVhCj9XKspZ5+540FQ==
X-Received: by 2002:a6b:4f1a:: with SMTP id d26mr679268iob.90.1583173365154;
        Mon, 02 Mar 2020 10:22:45 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l18sm4499914ild.51.2020.03.02.10.22.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 10:22:44 -0800 (PST)
Subject: Re: FAILED: patch "[PATCH] io_uring: fix 32-bit compatability with
 sendmsg/recvmsg" failed to apply to 5.5-stable tree
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
References: <15831727869827@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9ca024de-9a11-cfdd-f720-f98baab0a11e@kernel.dk>
Date:   Mon, 2 Mar 2020 11:22:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <15831727869827@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/2/20 11:13 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.5-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's a 5.5 version.

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
index e54556b0fcc6..eb9e5c76e168 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2179,6 +2179,11 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 
+#ifdef CONFIG_COMPAT
+	if (req->ctx->compat)
+		sr->msg_flags |= MSG_CMSG_COMPAT;
+#endif
+
 	if (!io)
 		return 0;
 
@@ -2269,6 +2274,11 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 
+#ifdef CONFIG_COMPAT
+	if (req->ctx->compat)
+		sr->msg_flags |= MSG_CMSG_COMPAT;
+#endif
+
 	if (!io)
 		return 0;
 

-- 
Jens Axboe

