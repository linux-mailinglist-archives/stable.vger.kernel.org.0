Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E724330AABE
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 16:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhBAPOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 10:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbhBAPOP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 10:14:15 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7E8C0613D6
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 07:13:34 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id y187so13508359wmd.3
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 07:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PNvAHWezDlO2EZkA05aqapBUD6WpfeG1wR32jh3SfHk=;
        b=EOqzpClh10PN2tTixjerD88gX3aCViMj8m4x4Gid+rGaqb3HTwkGNSGdvS0IPDt4DN
         q1btTwEdQwHxfemasy549I7J3bHK0onVo+yjKZXIR5Ipe5m7knG8J+si9iqSkSwDLU+j
         Twdid+gvxrNqZNG2F2uuJ58UrUnr3v9sOe+2IWzMDVSXFig0SoA8Sp9BrRmBFmZmBzdb
         nEmKpJNqx7iB5j1x6SRYqDn9qiOp6P/XP+lNeBqcEv11CWnSQwr6InaWL1ssvFXRX3Il
         dj7LDftNgvEjaOzNZDdSUdN8KH5mWzEV5OAqVLXCLXfS/3g0EAzPD6YwGNYPdtASKzMY
         V5qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PNvAHWezDlO2EZkA05aqapBUD6WpfeG1wR32jh3SfHk=;
        b=r3ETagdxAtjuAWKgESMJkpwuwbuMtqUX5E/L9tCLa7nyhUJGfqCVZp/WBgljNjYxRW
         wAbAJPy2qmrHcGuOP+6n1nyzX7uadmwuNmNqOMLgbuQ/cFW3iMUYo8m8RQgbzQnyOkZJ
         JkeHD/ibgtE6Jo3001IrG5nzTHWc0NRoN7plcNOaEx6iyLmuPc1SeuKzUlg6KVDVGSod
         hCwScXGsXrVHdbnltnsx63PEv2hVFyHWY11Dzeocov141pRtaPM6ONPCol8Y2MT+rgWr
         SWjOUzPqSlPyEwaw+kLh16mtBxC0oC+smGOPFOos8DlbZo5/jN7FAN9WM5kS4sUkr5uE
         x+7A==
X-Gm-Message-State: AOAM5336qyIDgINx1EQD/1oUZH44igHxvvNDSu2IoGTDpFPgQTuXegSc
        CuKNiXOeMQ1klw3KkZrO/55f0njedBgUxUx5
X-Google-Smtp-Source: ABdhPJyFlkhJhRTCwFGeXChPK1zCfjFgyMDTOOdmTdCKCdnube0wEQ1tpjxdEHU9z5dXNmdJWLw1eA==
X-Received: by 2002:a05:600c:2a4b:: with SMTP id x11mr15224378wme.58.1612192413086;
        Mon, 01 Feb 2021 07:13:33 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id 192sm23323381wme.27.2021.02.01.07.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 07:13:32 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 00/12] Futex back-port from v4.9
Date:   Mon,  1 Feb 2021 15:12:02 +0000
Message-Id: <20210201151214.2193508-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ref: https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/pending/futex_issues.txt

This set required 1 additional patch dragged back from v4.14 to avoid build errors.

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
 kernel/exit.c          |  25 +--
 kernel/fork.c          |  40 ++--
 kernel/futex.c         | 446 ++++++++++++++++++++++++++++++++++++++---
 kernel/futex_compat.c  | 201 -------------------
 9 files changed, 466 insertions(+), 306 deletions(-)
 delete mode 100644 kernel/futex_compat.c

Cc: Stable Team <stable@vger.kernel.org>
-- 
2.25.1

