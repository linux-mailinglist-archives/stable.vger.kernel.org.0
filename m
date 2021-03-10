Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067ED333B87
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 12:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhCJLf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 06:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbhCJLe7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 06:34:59 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD98C061760
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 03:34:51 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id e23so6886421wmh.3
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 03:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A5KJbjpWeXPV1ztdYVA7phS7KIPmeh/e7JH9mctUzOY=;
        b=og4cO+jI4egB+6tuv1smWonhyCaVJ/K/+BlUIUlbSVAA+tzd+v8plGYcdOQDenxuMQ
         4/IcgwkQD3XkjB/z7gPFee48RBm5wOPKK8cRcECsY7qIZyz3b4pJTuU+DkOVZmjA31mQ
         mlFuh5Le9QEvRQ/xlw5hVnTvwNKtAL30mDq4tGrFKm+pkBlLJLppPVbEro5yji3t+t3/
         iQEeP7kKp/EtLpUX0Fu2tXMyB0qhxxH3VAxRWmiCAFwDBdy6GyjgHpOXHP6Ig3b75zlQ
         0cIi3hb21Cnxy9jbKnHDAAjctfYqCrX1PTm+FprAQHSBPFtunQwZ/iB8PkA7tzxZNITU
         x8BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A5KJbjpWeXPV1ztdYVA7phS7KIPmeh/e7JH9mctUzOY=;
        b=kQPJIST+jAT2xl3U/UMxUud91IejVBjo5Ji8S3gSGgKEdDzIJFCt6zNWVUWwOTq0eZ
         j4LtMp/tguD0guHv4gmNey1iDhdiDJfUDI2uc1hjb3h9OLPTECZNSWnHnkVjUhzu36vo
         Ch4PAr5q9A2qIj3ekNNSj9bkdUxb14EgLV5jwDjY2m73kWgFydCj8f+bTeGagP0uuyw1
         Ki4wjoulPVY4RxAKlRgRoEZkTv/gi+YSRggk+p+uq/7MPf+gZYupv+0JtOCrqF+aFGCw
         qhHEPP8XP8VyFT98rmQDPf8Zcp6C2TW3Rj6TGdVfiQh6YySxdIJp2HHHCI52K9aALSmT
         /hPw==
X-Gm-Message-State: AOAM533RLBr/6o8Ujg7fcTqSYXNZyjBmu3J7cdNwLIdr0tvRta7IWpxJ
        GHX9Xe3FB5SjLzxfDmhKjT1rvkcu3phbRg==
X-Google-Smtp-Source: ABdhPJy4d+fRnVdxggWzgY43LyB0A29VdJsqrdCXf3A2JJ/OkcrC/VlcuTs/UBUNsQ3n4Iehskehtw==
X-Received: by 2002:a7b:ce06:: with SMTP id m6mr2854119wmc.38.1615376089643;
        Wed, 10 Mar 2021 03:34:49 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.55])
        by smtp.gmail.com with ESMTPSA id s18sm25179078wrr.27.2021.03.10.03.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 03:34:49 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH stable-5.11 0/9] stable-5.11 backports
Date:   Wed, 10 Mar 2021 11:30:36 +0000
Message-Id: <cover.1615375332.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

5-6/9 were forgotten to be marked for-stable. Others are
5 out of 6 failed to apply + dependencies.

Jens Axboe (3):
  fs: provide locked helper variant of close_fd_get_file()
  io_uring: get rid of intermediate IORING_OP_CLOSE stage
  io_uring/io-wq: kill off now unused IO_WQ_WORK_NO_CANCEL

Pavel Begunkov (6):
  io_uring: fix inconsistent lock state
  io_uring: deduplicate core cancellations sequence
  io_uring: unpark SQPOLL thread for cancelation
  io_uring: deduplicate failing task_work_add
  io_uring/io-wq: return 2-step work swap scheme
  io_uring: don't take uring_lock during iowq cancel

 fs/file.c     |  36 +++++---
 fs/internal.h |   1 +
 fs/io-wq.c    |  17 ++--
 fs/io-wq.h    |   5 +-
 fs/io_uring.c | 241 +++++++++++++++++++++++---------------------------
 5 files changed, 145 insertions(+), 155 deletions(-)

-- 
2.24.0

