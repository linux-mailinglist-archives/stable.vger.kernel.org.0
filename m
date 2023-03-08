Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAACA6B0E7F
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 17:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjCHQW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 11:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjCHQWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 11:22:23 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93AD3B5B6D
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 08:22:21 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id p16so10148592wmq.5
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 08:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1678292540;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jPbTBABffykwNpjD5DlqeBRZvRIXf+MDtHqIgUM308s=;
        b=Pn/HViKHBVbqUl/VM9Vz2yPtraw2hqM0i/zEWgt+a5XpN6GMlK7FbYF4Ul/6u+4eRB
         R21Udf9RznZulVqpox6o8XLIJ2cLmMBea1WzYJKh4YxaM5M6GPjqQ3Inb/uTUKeM7SGY
         GQTKeCIWDtgK6R2XmqK+r0VFsiwjuLxVeplV2z2OIFiqDFHAN67HHU/o29r5EYwVQLGm
         QoQiCbvXBCMYYEOHIX8zi07gN/Wth+ACGfEfS/l6WsxByHwPOjztg01pSrFpxpOJSo2q
         T3uQGBzy2Cko0+n/fXDw9mgMa/NxfaOW6E1sL8UUjKzqazI1EJNOgU5+rRFTDohYlJWv
         nXiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678292540;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jPbTBABffykwNpjD5DlqeBRZvRIXf+MDtHqIgUM308s=;
        b=jeBUUu16adc0lXuLYf1YnnD8VRjqktS63QuQzf+6pe089HUBwYXDU+KyjyBb+7uQs1
         /A7o/h8/Llp+HTzbp8DKrxsrmOei3SVphYI3pibTrUObBey6/89bn0mJTfJ317mrtLSS
         UWUZse/0j9Og0auRz5FDTsf93iNijdvec8jl48F8dZJ3scr7OXGAoqur+NxI4nGg9p1/
         C9cgBcGnYcZkJQ7xXigjcv3srrYcSzIBeQOo/pPAHYZbNMEbsM5VYZQtOR1qf+2lVSjk
         bKubRYY2x7lTB24EXPfzRQvmWcHNxLu1jbBW10LLazkL9UYd+DJih1pOLwmopv0QECht
         Jjtw==
X-Gm-Message-State: AO0yUKWykup+1LnEGCLkj0+Z72o/8Iga9i0zciBDl3wufyPX3CF661JO
        xCfKblDiX3fECM7EJZWE1p7UOcFjaMsEA9JqRlQ=
X-Google-Smtp-Source: AK7set/T7sUTo6jH0BWdpugKn7yUznKiqUXTIg1SUYeMdgTDSHKCicXy63k6/u6xuLZL3xefMx0hxw==
X-Received: by 2002:a05:600c:46c6:b0:3e2:1368:e395 with SMTP id q6-20020a05600c46c600b003e21368e395mr16842443wmo.33.1678292540009;
        Wed, 08 Mar 2023 08:22:20 -0800 (PST)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id r8-20020a5d4e48000000b002c5d3f0f737sm15786015wrt.30.2023.03.08.08.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 08:22:19 -0800 (PST)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qyousef@layalina.io>
Subject: [PATCH 0/7] Backport uclamp vs margin fixes into 5.15.y
Date:   Wed,  8 Mar 2023 16:22:00 +0000
Message-Id: <20230308162207.2886641-1-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Portion of the fixes were ported in 5.15 but missed some.

This ports the remainder of the fixes.

Based on 5.15.98.

Build tested on x86 with and without uclamp config enabled.

Boot tested on android 5.15 GKI with slight modifications due to other
conflicts there. I need more time to be able to do full functional testing on
5.15 - but since some patches were already taken - posting the remainder now.

Sorry due to job/email change I missed the emails when the other backports were
partially taken.

Qais Yousef (7):
  sched/uclamp: Fix fits_capacity() check in feec()
  sched/uclamp: Make cpu_overutilized() use util_fits_cpu()
  sched/uclamp: Cater for uclamp in find_energy_efficient_cpu()'s early
    exit condition
  sched/fair: Detect capacity inversion
  sched/fair: Consider capacity inversion in util_fits_cpu()
  sched/uclamp: Fix a uninitialized variable warnings
  sched/fair: Fixes for capacity inversion detection

 kernel/sched/core.c  |  10 ++--
 kernel/sched/fair.c  | 128 +++++++++++++++++++++++++++++++++++++------
 kernel/sched/sched.h |  61 ++++++++++++++++++++-
 3 files changed, 174 insertions(+), 25 deletions(-)

-- 
2.25.1

