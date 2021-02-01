Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F75C30A4D4
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 11:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbhBAKCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 05:02:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhBAKCu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 05:02:50 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53896C061573
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 02:02:10 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id e15so12604641wme.0
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 02:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=satAsY03zW6R5YGnBLV3TjHl6zkThHDUsg1nDEtdP0Q=;
        b=hd0ZryI0654awXJX1gRoPWtGzZfiH93IPwU3DM01nQBR/a/DnQnF0FydmxPuUfbdBE
         +Nc62DUHNymaU82H6c6gQN4mcLYiKkLH6+1WMx8rAzOjMRZ/+oCOcf65vbGAQQkvvt7p
         OxvK+yjykbrktKbvUH/T3IriBPdjW97hvRxYC+50NSvLYzUpDu+X4JrMHrI1dUrEOKbu
         4X7tmXTLdu5qAN/NeLO4FDsmRif47l1vNm4EFwO93K7/IZrdhXzKC60tfix6awAwiIVr
         OM3T6a0NiDlRfrIVv+op3nPMtUtZ07O1XYqqbATa04m9DmCWZDsdySeMuSr6QSgsEUB9
         Rr8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=satAsY03zW6R5YGnBLV3TjHl6zkThHDUsg1nDEtdP0Q=;
        b=tN53cVtWhBP5RmTvV1VH2lHZjWUUpUn3I3/nlVuqMwJmXbDkfNQjJS/8rrrYx2CA74
         7xj3WRLiNvurMFdSbwYPb4sdkHclQEEyJwqdDz26StBe8lRqKMI7CkCyATIS25Vhy3I4
         4QYQYj9BZFdGgDxFZasHbm1LJL6c09ApITtdZjIikFL3YIKsBC6TZOKbhAdwyLQf1H2G
         CRz3ZCTkC0iw0DxbhT+cvF7+JIJnkMm5KIbK6HFca7Jc48FsLtwfwqpvUEUBvHFAN125
         kwjZpufJ1/T4YMg9JkfmKjAzWLyzaWCnAT5bKCorVlF/1dimH0bGIPV7/RXgotk92bZT
         Fb8w==
X-Gm-Message-State: AOAM531WH5m962jNO2nKcvVdNRzDVd/zGluMNflvjRSK4H0jsAITvxN1
        5Lg5IxRnaOcAS5ZrZ2LlPrHZyhE+CfBlxWfc
X-Google-Smtp-Source: ABdhPJyLn4cbMpvoA6Q9T+BUbhf6xtRORukCcdBmLg6N39Dmso0fzX+203i0OyjppIEFHRrAI8qOag==
X-Received: by 2002:a05:600c:4f50:: with SMTP id m16mr14034882wmq.175.1612173724577;
        Mon, 01 Feb 2021 02:02:04 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id p15sm26151387wrt.15.2021.02.01.02.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 02:02:03 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 00/12] Futex back-port from v4.14 
Date:   Mon,  1 Feb 2021 10:01:31 +0000
Message-Id: <20210201100143.2028618-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ref: https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/pending/futex_issues.txt

This set required 1 additional patch from v4.14 to avoid build errors.

Arnd Bergmann (1):
  y2038: futex: Move compat implementation into futex.c

Thomas Gleixner (11):
  futex: Move futex exit handling into futex code
  futex: Replace PF_EXITPIDONE with a state
  exit/exec: Seperate mm_release()
  futex: Split futex_mm_release() for exit/exec
  futex: Set task::futex_state to DEAD right after handling futex exit
  futex: Mark the begin of futex exit explicitly
  futex: Sanitize exit state handling
  futex: Provide state handling for exec() as well
  futex: Add mutex around futex exit
  futex: Provide distinct return value when owner is exiting
  futex: Prevent exit livelock

 fs/exec.c              |   2 +-
 include/linux/compat.h |   2 -
 include/linux/futex.h  |  44 ++--
 include/linux/sched.h  |   9 +-
 kernel/Makefile        |   3 -
 kernel/exit.c          |  29 +--
 kernel/fork.c          |  40 ++--
 kernel/futex.c         | 446 ++++++++++++++++++++++++++++++++++++++---
 kernel/futex_compat.c  | 201 -------------------
 9 files changed, 466 insertions(+), 310 deletions(-)
 delete mode 100644 kernel/futex_compat.c

Cc: Stable Team <stable@vger.kernel.org>
-- 
2.25.1

