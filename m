Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016CB3147AD
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 05:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhBIEwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 23:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbhBIEw2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 23:52:28 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868FEC061786
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 20:51:46 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id w1so29203953ejf.11
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 20:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eWVxxNukDqMBDNVznxdHMM8FEcaHHR/DhJV+8iHZgrg=;
        b=c2hS9h4SwgFSN6SpJb6VK2o/KCOq180OFfFCiIsHhOIqwu9EtKq2nwMS3M2+2fW+xp
         rS1F/bx+2l0L3CpES8WIJjTWma43VEct4QLTKGkfxWE3l/pUZ5HFMuEuurQT642gjaxu
         i0cWEo/aeTwXODIWcdSxIty6zhfIAZn0ie7v2jaqDomygUJy5Tmd9K0a5r3qWP3hwgQH
         m2MVgGEz8tTsF0wfFIr47xsj6AwS+b7ZYPdJ4ClQwT84OMQ4IkTIEJcY64jJB/Lu21eQ
         fBmfGCRXWolxU/RsaVB3fotIN0U8uBCGGkd5IdsNixUzzsUwfXadY7Bqh5mH1SgGzPyV
         W0rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eWVxxNukDqMBDNVznxdHMM8FEcaHHR/DhJV+8iHZgrg=;
        b=YiN8yGEnhSVQAE/U34T90QbrIFGkGS+MPyDcIrzSWAyFnq1AbZDRX9JoAUvrphOjFQ
         VXKuD9bukeLPaNJgF+l3UCWabSvEWj2S1afMV4y7RfDqnqDQu27XCFDQrsrmkOttD9xP
         1k6hdGFKpmeUPL6J1xyM7b7LdV8SWtwCpvFX2y73DlYUrwBTc4JWOCCcBQ8vP2S2rzLb
         PuosKQCiVWJ6h8LDWlHhDbfvOlcO7yEqFmYJJ7Tf4zYiAGIbvn1YG+xjJcI3khiujYnj
         yCshT3IBqNMvffR0gNmdad3jJqfTPaWdHEm0BEHLYXLJzIbz44mmnAizLUMP4YJ9d9fr
         2JrA==
X-Gm-Message-State: AOAM530MhSP9JEtBlOFhEOTNrqZ6w8D6SzY69KUH5ntXqUXFXWjoo7qU
        yh7khwEhFUsc0ZQSXhLMmltnNULdxuc=
X-Google-Smtp-Source: ABdhPJwtWL0I7mZb46pDALQa85SkP+FWIavhvGQQXAJJ/R2M8E2/5rOF94nt4Utr6cKVFVcQqxDung==
X-Received: by 2002:a17:907:2d92:: with SMTP id gt18mr20736914ejc.330.1612846304134;
        Mon, 08 Feb 2021 20:51:44 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.244])
        by smtp.gmail.com with ESMTPSA id g9sm9973445ejp.55.2021.02.08.20.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 20:51:43 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH stable 5.10 00/16] stable 5.10 backports
Date:   Tue,  9 Feb 2021 04:47:34 +0000
Message-Id: <cover.1612845821.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A bit more than expected because apart from 9 failed-to-apply patches
there are lots of dependencies to them, but for the most part
automatically merged.

Hao Xu (1):
  io_uring: fix flush cqring overflow list while TASK_INTERRUPTIBLE

Jens Axboe (2):
  io_uring: account io_uring internal files as REQ_F_INFLIGHT
  io_uring: if we see flush on exit, cancel related tasks

Pavel Begunkov (13):
  io_uring: simplify io_task_match()
  io_uring: add a {task,files} pair matching helper
  io_uring: don't iterate io_uring_cancel_files()
  io_uring: pass files into kill timeouts/poll
  io_uring: always batch cancel in *cancel_files()
  io_uring: fix files cancellation
  io_uring: fix __io_uring_files_cancel() with TASK_UNINTERRUPTIBLE
  io_uring: replace inflight_wait with tctx->wait
  io_uring: fix cancellation taking mutex while TASK_UNINTERRUPTIBLE
  io_uring: fix list corruption for splice file_get
  io_uring: fix sqo ownership false positive warning
  io_uring: reinforce cancel on flush during exit
  io_uring: drop mm/files between task_work_submit

 fs/io-wq.c    |  10 --
 fs/io-wq.h    |   1 -
 fs/io_uring.c | 360 ++++++++++++++++++++------------------------------
 3 files changed, 141 insertions(+), 230 deletions(-)

-- 
2.24.0

