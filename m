Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B822830DBA0
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 14:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbhBCNqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 08:46:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232179AbhBCNqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 08:46:31 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9EEC0613D6
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 05:45:49 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id v15so24396738wrx.4
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 05:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l51u7EqcQEcx9+KXZhaeIMfDjprxiFX9d1vyuABKz48=;
        b=pY617uC0lJwT9ras9URHSwi8i6mjb8jcQqqxBx6rfuDQqcKmo9XQXDBKDoYBZxjuMR
         qOZ/fHuX3g+IWQ+T4N0orv+ZkR4bh4B03m0PTJt4wpIP7xVpSrVmyp/Ka4m3tyUjq1D0
         hCTiewXlNCgM8mQsbQiuxjviGm8nLwQCVAPhNqGljGQhEIqehtXCHUUIt/pZ/XLVGy4h
         QeIS8izLki65DPRZnpSyvCiVdIJR7LRiICp0iRWb1Em3Gbq45+30WVZMi6ZZnyeP3rn5
         hpbRN9ptjXsx2rPddpcOQL4fCl7JI3bARY8hAu9pFKuIUtvvrcEU6M1vslisMrAtxhfu
         wDtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l51u7EqcQEcx9+KXZhaeIMfDjprxiFX9d1vyuABKz48=;
        b=rU4MGT6s1MO2OaSYYVHUPnIOx66d5/R1Se06Siy1pAomucgtlvy5kRzfZDNwoyj1Ek
         rlpxwL7ngWCw1r+SC+f+NJtmleVWLvasr+OsOYklzUk/x6xgV4+oa1mXp1P6JyYY9U+X
         Zd0lCUnrRPToK+glbvcsnA2NRG8T0IGrrOSixMGCJ97FKfvM0QQGXDMMsWJMLltDSuCd
         YmGV2mkrFVMFY3vVbn4JWTz7+CYMF9+x1Wee7kpSvlLIDXi+1BIDV471+e7TQE4T0fCC
         /ORW5fv7hzFhUsKLy9gM8WyC600/va7UJY9MuFHQR6+KvWJnh9UHP1q/xpCgXOYDvJI5
         2nNg==
X-Gm-Message-State: AOAM533D5aWVE29sPvhNJlLkYIiJ6X3dnZMol4SJwVMHCwWnZq5qv6mf
        Iryqef6fPvSpolBBmh2Pj7sxUMrU0Ev/Fg==
X-Google-Smtp-Source: ABdhPJycLzO5IXjvaVzS8/LmnBTeJPlNm2Hu/cm3wm5hYreuZl7sySiEpakU6lH0JUpOHhJ4P/LwEg==
X-Received: by 2002:a5d:610e:: with SMTP id v14mr3710740wrt.336.1612359947291;
        Wed, 03 Feb 2021 05:45:47 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id r124sm2867900wmr.16.2021.02.03.05.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 05:45:46 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>, bigeasy@linutronix.de,
        bristot@redhat.com, Darren Hart <dvhart@infradead.org>,
        jdesfossez@efficios.com, juri.lelli@arm.com,
        mathieu.desnoyers@efficios.com, rostedt@goodmis.org,
        xlpang@redhat.com
Subject: [PATCH 4.9 00/10] [Set 2] Futex back-port
Date:   Wed,  3 Feb 2021 13:45:29 +0000
Message-Id: <20210203134539.2583943-1-lee.jones@linaro.org>
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

 kernel/futex.c                  | 276 ++++++++++++++++++--------------
 kernel/locking/rtmutex-debug.c  |   9 --
 kernel/locking/rtmutex-debug.h  |   3 -
 kernel/locking/rtmutex.c        | 127 +++++++++------
 kernel/locking/rtmutex.h        |   2 -
 kernel/locking/rtmutex_common.h |  12 +-
 6 files changed, 243 insertions(+), 186 deletions(-)

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

