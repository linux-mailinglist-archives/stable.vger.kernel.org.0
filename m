Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C91536278B
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 20:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244475AbhDPSOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 14:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244454AbhDPSOt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 14:14:49 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89362C061756
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 11:14:24 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f7so7069012ybp.3
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 11:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:cc;
        bh=J0KDa3jTK0DIbbwUod70tP0pr/xuL0WrxnWOY2JT/FY=;
        b=O2eSLkh0VTpG7XgBoiK8Xg0uXG+CjZafZkKiSlwgy+9DE7VYe1z9izV+W+e4onaeJo
         8NHaaFPODSR5tTbfyUkfUtVfdWbJLhJsdWma6I6ZhnRe0cM7X+YWjJY1rMR0l4Re5625
         p3kDM7zZMtP/ElauBvqbIFKtWbToyH7FRxpoiIVt+AGNF5JssYXXUanQjmkoWcqxCiF3
         CDatp48YTmkkqfk6dnZxjuyGFiaRxN3r+76K3t0oUrCAxSrCRdbfCoXT1LSZwcun42tN
         BHRD573h91Rhe97qUN1F38mpexw2PgHIP6fIX4R+JH0EHl+OJF3fggIzcSoyqXKnwww0
         nHMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:cc;
        bh=J0KDa3jTK0DIbbwUod70tP0pr/xuL0WrxnWOY2JT/FY=;
        b=Pm3+M4npPKtKVn5YgO2pizniKEQhqge4Uz1AVjUEqSgFW4FPJnymlDg+ezEij5P33d
         EB39ooAna8OXXF4ZIiKRwJnermE+HPIhuA9phbog3V0N9uir1qo4qwWpr60ewdPf7R6J
         kToYq07CDDht4X0rz3IskHQ/squYTPN2DgUIZwN/8CoNEqH32kzs6qRgG3tKM3VDInt8
         gqJtqRDBCddvKNAgzVsjz/zADMGZdDrPvQvUzoLkkXswkRmyI5EQh3sdr+A09oqkrxzp
         3kcQUC5O2ozhgKIHJcrBCKnBj1XrmtSVEBxCQD4/rnXuK894AKyWUX8HcdAk0Bv2GKyZ
         IHPA==
X-Gm-Message-State: AOAM5310/dWLaiE5DZokeYpehEA6z/DYG+CKF4b5xRywujpk0B8VyvGo
        Yc9G/9ubMejFY6EeaYqyOVC7wLGkNYpom7cucjE0P8eiihNZEoCfzGQl+0xuMwAZeZdBmi4z4SS
        9xYSTflvJWkk6PBRa7fdLPB/9ncg72Rz4g9tAnz1BAa7zcygnkE/hSbRVZcmzhOAt
X-Google-Smtp-Source: ABdhPJw/bVnijCFaidJ8jm5VtIiWn57WG56WIKDEYz29qEqx347nWc2r+j5RCeiNINL66ZpPoqfC0xz+mZfi
X-Received: from jiancai.svl.corp.google.com ([2620:15c:2ce:0:a547:67f6:5e32:5814])
 (user=jiancai job=sendgmr) by 2002:a25:a1c5:: with SMTP id
 a63mr589391ybi.72.1618596863636; Fri, 16 Apr 2021 11:14:23 -0700 (PDT)
Date:   Fri, 16 Apr 2021 11:14:21 -0700
Message-Id: <20210416181421.2374588-1-jiancai@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.368.gbe11c130af-goog
Subject: [PATCH] arm64: vdso: remove commas between macro name and arguments
From:   Jian Cai <jiancai@google.com>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org, ndesaulniers@google.com,
        natechancellor@gmail.com, manojgupta@google.com,
        llozano@google.com, clang-built-linux@googlegroups.com,
        Jian Cai <jiancai@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

LLVM's integrated assembler does not support using commas separating
the name and arguments in .macro. However, only spaces are used in the
manual page. This replaces commas between macro names and the subsequent
arguments with space in calls to clock_gettime_return to make it
compatible with IAS.

Link:
https://sourceware.org/binutils/docs/as/Macro.html#Macro
Signed-off-by: Jian Cai <jiancai@google.com>
---
 arch/arm64/kernel/vdso/gettimeofday.S | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/vdso/gettimeofday.S b/arch/arm64/kernel/vdso/gettimeofday.S
index 856fee6d3512..7ee685d9adfc 100644
--- a/arch/arm64/kernel/vdso/gettimeofday.S
+++ b/arch/arm64/kernel/vdso/gettimeofday.S
@@ -122,7 +122,7 @@ x_tmp		.req	x8
 9998:
 	.endm
 
-	.macro clock_gettime_return, shift=0
+	.macro clock_gettime_return shift=0
 	.if \shift == 1
 	lsr	x11, x11, x12
 	.endif
@@ -227,7 +227,7 @@ realtime:
 	seqcnt_check fail=realtime
 	get_ts_realtime res_sec=x10, res_nsec=x11, \
 		clock_nsec=x15, xtime_sec=x13, xtime_nsec=x14, nsec_to_sec=x9
-	clock_gettime_return, shift=1
+	clock_gettime_return shift=1
 
 	ALIGN
 monotonic:
@@ -250,7 +250,7 @@ monotonic:
 		clock_nsec=x15, xtime_sec=x13, xtime_nsec=x14, nsec_to_sec=x9
 
 	add_ts sec=x10, nsec=x11, ts_sec=x3, ts_nsec=x4, nsec_to_sec=x9
-	clock_gettime_return, shift=1
+	clock_gettime_return shift=1
 
 	ALIGN
 monotonic_raw:
@@ -271,7 +271,7 @@ monotonic_raw:
 		clock_nsec=x15, nsec_to_sec=x9
 
 	add_ts sec=x10, nsec=x11, ts_sec=x13, ts_nsec=x14, nsec_to_sec=x9
-	clock_gettime_return, shift=1
+	clock_gettime_return shift=1
 
 	ALIGN
 realtime_coarse:
-- 
2.31.1.368.gbe11c130af-goog

