Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A625B6C47
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 13:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbiIMLTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 07:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbiIMLTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 07:19:00 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31A058099
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 04:18:58 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 29so17072050edv.2
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 04:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=P6wave/tXDncPIKF3r+8WNt1F5X9ewnQjiJNZ7NO2Ps=;
        b=Lv9+gMXSGKRy4Sj6m2IRkOZaVJQCIcuhNKv04VCsDFXJf01jluUPejgXV2kLhoXi31
         gg74Pz45CEqpLv4Gt8JIvRtmRFHdKv7nfbJ9xaWtbuseXKffS5DhuUoQpLtXueIeITdC
         tiU1PDBYR6D+ELmiN+FEYxcrjzy9tzWszQUh6S9UTtU8SkZGXWfMm1gOi6NJPYxiIxQ5
         wcmb3i8B9AimvXNGSewdNlYAGjB2WVtOBNGIGqDa0HBOKhEX8aZpz6eqg7htRwGR507R
         1MWCW08Dv3bFc9xyVx3R/QdrZIiDPjiIMHSKPwcq3PUAeIr/1kfithuPeq5PT5/JfQoN
         wKIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=P6wave/tXDncPIKF3r+8WNt1F5X9ewnQjiJNZ7NO2Ps=;
        b=g4eDnDDm8+Ll0OB0M2vRImNWk3HylcOzB1ze+Y5LMiStup7LPdfEoR/G/PAn9IyCgZ
         0HX+aM8/FjqQrk2ozT8g4NHBEMbZK6GU1L24CSuxfI3cyNNxvfMUJg8A77NSZtvi15RH
         x5S4niCrKizgdrcbXldHFlKIaQKlOHYA8Hu9VcKqq4Wv4/+juZCiV4w8w9uHN4aeGc/q
         R5CC79Xr8Y3ToCiYVesoJA+5/YFvXSIa2inhx6j3mUNtaCrTHxxdzYZ7fx6UOhOIutJd
         zW/+jLcVLxdv0HCdmonkfcKM5puNL2X/OQhGWueKMj8u/HnHDuJZTFFyKuaxgYquvw9t
         TjOw==
X-Gm-Message-State: ACgBeo2L73wH+Rb3z3upBZwCmFHg28ZVmSF6S0M8M8dL8os+JuZaHHIl
        sOeqLffBGbSAJrXIIWNi7U/Ybut0KXmQ+WhBoyte1gJJboP8dg==
X-Google-Smtp-Source: AA6agR5FvaIQ4v3Dl7zkSFjzAh4HRviiUaXdsekzrHpTq+6/EaKTwiaM0L/jrhYpTMVw0q9ai4ory/2UGYQtfMPMeo8=
X-Received: by 2002:a05:6402:2989:b0:44e:90d0:b9ff with SMTP id
 eq9-20020a056402298900b0044e90d0b9ffmr25379489edb.110.1663067936248; Tue, 13
 Sep 2022 04:18:56 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 13 Sep 2022 16:48:44 +0530
Message-ID: <CA+G9fYtro2f2u3Wug7YS7kC=iVGWsee+Vnvm4U20+xXsYVjK5w@mail.gmail.com>
Subject: stable-rc: 5.4: cgroup.c:2404:2: error: implicit declaration of
 function 'cpus_read_lock' [-Werror,-Wimplicit-function-declaration]
To:     linux-stable <stable@vger.kernel.org>, lkft-triage@lists.linaro.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Tejun Heo <tj@kernel.org>,
        Imran Khan <imran.f.khan@oracle.com>,
        Xuewen Yan <xuewen.yan@unisoc.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On stable-rc 5.4 arm and arm64 builds failed due to following errors / warnings.

kernel/cgroup/cgroup.c:2404:2: error: implicit declaration of function
'cpus_read_lock' [-Werror,-Wimplicit-function-declaration]
        cpus_read_lock();
        ^
kernel/cgroup/cgroup.c:2404:2: note: did you mean 'cpuset_read_lock'?
include/linux/cpuset.h:58:13: note: 'cpuset_read_lock' declared here
extern void cpuset_read_lock(void);
            ^
kernel/cgroup/cgroup.c:2417:2: error: implicit declaration of function
'cpus_read_unlock' [-Werror,-Wimplicit-function-declaration]
        cpus_read_unlock();
        ^
kernel/cgroup/cgroup.c:2417:2: note: did you mean 'cpuset_read_unlock'?
include/linux/cpuset.h:59:13: note: 'cpuset_read_unlock' declared here
extern void cpuset_read_unlock(void);
            ^
2 errors generated.

drivers/gpu/drm/drm_lock.c:363:6: warning: misleading indentation;
statement is not part of the previous 'if' [-Wmisleading-indentation]
         */     mutex_lock(&dev->struct_mutex);
                ^
drivers/gpu/drm/drm_lock.c:357:2: note: previous statement is here
        if (!drm_core_check_feature(dev, DRIVER_LEGACY))
        ^
1 warning generated.

Build link:
 - https://builds.tuxbuild.com/2EfrNYbejRQczhhqndawRkHARHZ/


Steps to reproduce:
-------------------
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#

tuxmake --runtime podman --target-arch arm64 --toolchain clang-nightly
--kconfig defconfig LLVM=1 LLVM_IAS=1

Following patch might be the reason for these build errors:
---
cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock
[ Upstream commit 4f7e7236435ca0abe005c674ebd6892c6e83aeb3 ]

Bringing up a CPU may involve creating and destroying tasks which requires
read-locking threadgroup_rwsem, so threadgroup_rwsem nests inside
cpus_read_lock(). However, cpuset's ->attach(), which may be called with
thredagroup_rwsem write-locked, also wants to disable CPU hotplug and
acquires cpus_read_lock(), leading to a deadlock.

Fix it by guaranteeing that ->attach() is always called with CPU hotplug
disabled and removing cpus_read_lock() call from cpuset_attach().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-and-tested-by: Imran Khan <imran.f.khan@oracle.com>
Reported-and-tested-by: Xuewen Yan <xuewen.yan@unisoc.com>
Fixes: 05c7b7a92cc8 ("cgroup/cpuset: Fix a race between
cpuset_attach() and cpu hotplug")
Cc: stable@vger.kernel.org # v5.17+
Signed-off-by: Sasha Levin <sashal@kernel.org>
