Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8202731871C
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 10:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhBKJ3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 04:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbhBKJ1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 04:27:51 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC68C061788
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 01:27:10 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id o15so2999230wmq.5
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 01:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+4WwBoALHOKBrdlixBkPg+KHvv88oTnZ+YjWHzRfkKw=;
        b=AbuYP+R14pKs/mDvIpSq21DHRdEpW5agxuXoiKKvaD9e7DMWpt7BoVeXAeRez/ovd+
         nnXBPvncxfgoVILtdfmArCpwKNTv8/cLgNiF0RgSGxltk7ZI5aHPuF1TRcVRKcERhYMp
         M4eZzJn0iLOzYwfluetctPS83w8JaBk+l3X8vFChGPIQX99vtWUurUgi2d/ewr61tPYM
         fw3mfqDi9no1p3JrhcOfN1vZXsoZAkMqN3uclIJgSZ34H1L7vQbeIpP58kfiAvkVeMbV
         b99Xpzkk98V9In6pgzBeg9CHI67PZQgFZ+dL+p37BIdf8HFfvjm9uhvkQ7KEEPdeNSZV
         Of3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+4WwBoALHOKBrdlixBkPg+KHvv88oTnZ+YjWHzRfkKw=;
        b=ZWDt0PbOy/4LPNQMg7mz4qEOQe8NqIjppAfusykx9tSeFuUSiyERKL7ZqgNaG9gzbF
         69gUE7WUZe990N94pIKDzQtDwZhTU4D3ejOwFHhvvtyRDVlPYzhQROPTCJrAHf6ZbUNX
         A5YjiA2TVApx47yaYQUTdhJUiMXZuKHdOSYhA4LjBWz3aoEnlRdSaLakchxa2wL++7vp
         wEnXCsazEzhrx578cWqNJJ3bXR38NgjwuZoVOVtwie/rxiTq1/oLDbsqRekN1nJkAd3F
         tQknAV1whLJeQl4zy1zw+F/E1gIQ/8CJ7LAMBsaCF1c8gZ+36n2Udh97osRImYMd/lXX
         LTPA==
X-Gm-Message-State: AOAM531KV0PkIeAygET89IqcgOTmPXt5nUy5uS4HnwhO8XodsbraU5dZ
        ykHj8hCxeoRXmwkLgK3RD0T1wmsGLGvtCA==
X-Google-Smtp-Source: ABdhPJyl3noIR81MZ/Wi0lJ5VZYzZrHPuLSw2zagjYoXXX0cOa4tNDA8va4Gi6czxYe/ftthB4TROQ==
X-Received: by 2002:a7b:c24b:: with SMTP id b11mr4251115wmj.96.1613035629026;
        Thu, 11 Feb 2021 01:27:09 -0800 (PST)
Received: from dell.default ([91.110.221.159])
        by smtp.gmail.com with ESMTPSA id y5sm8335124wmi.10.2021.02.11.01.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 01:27:03 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     zhengyejian@foxmail.com, Lee Jones <lee.jones@linaro.org>,
        bigeasy@linutronix.de, bristot@redhat.com,
        Darren Hart <dvhart@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, jdesfossez@efficios.com,
        juri.lelli@arm.com, mathieu.desnoyers@efficios.com,
        rostedt@goodmis.org, Sasha Levin <sashal@kernel.org>,
        xlpang@redhat.com
Subject: [PATCH 4.9 0/3] Follow-up patch series to update Futex
Date:   Thu, 11 Feb 2021 09:26:57 +0000
Message-Id: <20210211092700.11772-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A potential coding issue was:

 Reported-by: Zheng Yejian <zhengyejian@foxmail.com>

This set should solve it.

Peter Zijlstra (1):
  futex: Change locking rules

Thomas Gleixner (2):
  futex: Ensure the correct return value from futex_lock_pi()
  futex: Cure exit race

 kernel/futex.c | 233 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 189 insertions(+), 44 deletions(-)

Cc: bigeasy@linutronix.de
Cc: bristot@redhat.com
Cc: Darren Hart <dvhart@infradead.org>
Cc: dvhart@infradead.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: jdesfossez@efficios.com
Cc: juri.lelli@arm.com
Cc: mathieu.desnoyers@efficios.com
Cc: rostedt@goodmis.org
Cc: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org
Cc: xlpang@redhat.com
-- 
2.25.1

