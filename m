Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A970A30FA1E
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 18:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238530AbhBDRqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 12:46:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238512AbhBDR3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 12:29:48 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737D6C061788
        for <stable@vger.kernel.org>; Thu,  4 Feb 2021 09:29:08 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id t142so1670149wmt.1
        for <stable@vger.kernel.org>; Thu, 04 Feb 2021 09:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s/pbPSUytg8IxSeaIJyRZtRFiAzzy2DBtzxbnOe1Sz0=;
        b=dOAjPm46Ugxq5tPwMxy/CycInufzyiq01vi1+3lyedowqXp5ZKQR9nhAe3oz3e9jI4
         i5uDJazBLBFgHHaGEW1/1toDb2a616cXvhXP+wS7IKRLGSpd1Bovw2bYQUy/FqYXktE7
         iJrYi3Rl+HRRnEx1YzxIJ9dhhrV8ZzWfzGkhVq6UB7Qk7+wCOC2N++7nXNS7U1TrT4QP
         xYXXHJ/AHRdRoJK+inMh96qrcJFkthH+ZvKwdmk4fkVOQhwf4uLNiDLIb32oSHIkm3vK
         J+e25Hc7n/8yoNzYA29aVIa/jHmegGAU25u8Q5+v3Knt9Q5dHXm4DdjNWhKIEeveDimN
         RiQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s/pbPSUytg8IxSeaIJyRZtRFiAzzy2DBtzxbnOe1Sz0=;
        b=kVH+R5R/zGe/ISC5xWjOKHdOSOhRI9TrFt9lO/oIuwTmwlrZAFKa2HODY+BAKzfEmB
         UzpsSzCuopKdJiK+lcluh/L7sMRSEzKHt6H0HP6ILML5nmPc+wponrpdyo8EPswlBF6m
         M7nHDLEzV7qFx+8XPKGsPNboqWaODWBBqWSw2Xx5hlJVQdN0lw372vUsc6bUPMuM7UT/
         v+lO9EHI7zmw02p5swLOw37BtRPTGBTAHCqcdWPuxQAfuFnUFbGdjIzaU/mQDsVpKV7V
         RtQIRggjZmfnursB/lD3L0eSYkMMz+vGTWYJjIHUBP4BIHRj/ScN8lo5Dxc723nglVj/
         c+kw==
X-Gm-Message-State: AOAM530Wj6tjDOvTWdtPvoS8lKLxaDmxfpf4UbDdE8fz1cWdv4zclDoF
        PpddlQJzuyQatLPf0WA/wPvAGYC2LqSZBg==
X-Google-Smtp-Source: ABdhPJwaSZ9ABd0DnaYv9MFc+qhb60HyT6Q0nHDxGG5k9IbYBskFH2tdtpEmv1q/a5ZfjgCeS02p3g==
X-Received: by 2002:a1c:5f54:: with SMTP id t81mr224909wmb.160.1612459746935;
        Thu, 04 Feb 2021 09:29:06 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id j7sm9641334wrp.72.2021.02.04.09.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 09:29:06 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>, bigeasy@linutronix.de,
        bristot@redhat.com, Darren Hart <dvhart@infradead.org>,
        jdesfossez@efficios.com, juri.lelli@arm.com,
        mathieu.desnoyers@efficios.com, rostedt@goodmis.org,
        xlpang@redhat.com
Subject: [PATCH 4.4 00/10] [Set 2] Futex back-port
Date:   Thu,  4 Feb 2021 17:28:53 +0000
Message-Id: <20210204172903.2860981-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This set required 4 additional patches to avoid errors.

Peter Zijlstra (4):
  futex,rt_mutex: Provide futex specific rt_mutex API
  futex: Remove rt_mutex_deadlock_account_*()
  futex: Rework inconsistent rt_mutex/futex_q state
  futex: Avoid violating the 10th rule of futex

Thomas Gleixner (6):
  futex: Replace pointless printk in fixup_owner()
  futex: Provide and use pi_state_update_owner()
  rtmutex: Remove unused argument from rt_mutex_proxy_unlock()
  futex: Use pi_state_update_owner() in put_pi_state()
  futex: Simplify fixup_pi_state_owner()
  futex: Handle faults correctly for PI futexes

 kernel/futex.c                  | 278 ++++++++++++++++++--------------
 kernel/locking/rtmutex-debug.c  |   9 --
 kernel/locking/rtmutex-debug.h  |   3 -
 kernel/locking/rtmutex.c        | 127 +++++++++------
 kernel/locking/rtmutex.h        |   2 -
 kernel/locking/rtmutex_common.h |  12 +-
 6 files changed, 244 insertions(+), 187 deletions(-)

Cc: bigeasy@linutronix.de
Cc: bristot@redhat.com
Cc: Darren Hart <dvhart@infradead.org>
Cc: dvhart@infradead.org
Cc: jdesfossez@efficios.com
Cc: juri.lelli@arm.com
Cc: mathieu.desnoyers@efficios.com
Cc: rostedt@goodmis.org
Cc: stable@vger.kernel.org
Cc: xlpang@redhat.com
-- 
2.25.1

