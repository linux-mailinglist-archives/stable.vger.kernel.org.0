Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42282A6B91
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 18:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729794AbgKDRXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 12:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbgKDRXf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 12:23:35 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15E8C0613D3
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 09:23:35 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id k7so1310437plk.3
        for <stable@vger.kernel.org>; Wed, 04 Nov 2020 09:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EQPdOguSTvaL6j5jYKKtzuNoOl38devs4NIdPi9xCUg=;
        b=XBFkq8WTeSqH3+/9tv0CVgKf3aQDecwV3e54yDD4Y+RAsHhI5ZJE1mZsHv0MtazOwb
         eVUNK6+KtcrjffkE1ZOBMbu6KDGFnYV0YJUlUQIdN4zHfIYepoKO6v/ZXoz7824bSBTk
         i/0ye9f3ZvdFOY4toACO9ed8lp4tbmrBSPLQg4O0fjPUS0Bjc6ADvVLhEhKMkYQyAXyz
         h8PfTdsin8FsQkouE6uRxsXiOC64W9jGzyfBjd3cuEn73P2cNfQKhczT1zp7rw2wykb+
         SOEocxBmybqK/8rSKem2cYnl24ZikVykem1La5nETXB35XKgIbJ13zQzsP6BALdEcFs9
         s8IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EQPdOguSTvaL6j5jYKKtzuNoOl38devs4NIdPi9xCUg=;
        b=Tw9QqpmPZZP6FwT9Gi42b7h6uaifXwt2WCY2KvDIb5Cq5gxgyL03+XkQ6A4lmMx5ku
         xZ6YZI7kkSUHJE9ESTtOzdIR119sspVebtl0pOFwmRUqFeyy8Ee3d8BFfSWaNfq3PNuu
         cxZJbebU4lxEV429p1Vo5e6to6BI28hJR4RRBwEtpZ3pfQymrIZ9qNHHt3MtLX3eJHy9
         aHTp4Wn8xokUx7SuBr7nY3Zu9vve7YOTHTUv4tG7hENbk5hzGwFGk53oHRqMvCgo2IkB
         FtXL4izm1/UgY2WcWWt5PqKJsHUY9yvGBjPZQsO2F++mFwOLH2trIZUbLfrpdPjbkUOD
         K7bA==
X-Gm-Message-State: AOAM532kxKx8N8o2sZyPcj49Fuc5CR09EA+7WWCITZ08KZSe/oqCaKyq
        HI4vNsD8NLzIZytu2sig6AuwtDYJWIUDlw==
X-Google-Smtp-Source: ABdhPJwxpiQ1jAJs3KYXmvKMuY1JynsJAhVr3+Ffk/qe+KIfj1wIEkixrgqtM5blnGP3kYGoAPXfgA==
X-Received: by 2002:a17:902:bd03:b029:d6:89e2:5b5e with SMTP id p3-20020a170902bd03b02900d689e25b5emr29308089pls.70.1604510614907;
        Wed, 04 Nov 2020 09:23:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mm23sm2924981pjb.31.2020.11.04.09.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 09:23:34 -0800 (PST)
Message-ID: <5fa2e396.1c69fb81.a6fa4.6716@mx.google.com>
Date:   Wed, 04 Nov 2020 09:23:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.241-91-g303dfca2bd68
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 128 runs,
 1 regressions (v4.9.241-91-g303dfca2bd68)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 128 runs, 1 regressions (v4.9.241-91-g303dfca=
2bd68)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-91-g303dfca2bd68/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-91-g303dfca2bd68
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      303dfca2bd68dbfcd4e98c9f001b2f47a3214227 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fa2b094ba2aec2427fb5331

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
1-g303dfca2bd68/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
1-g303dfca2bd68/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa2b094ba2aec2427fb5=
332
        failing since 6 days (last pass: v4.9.240-139-gd719c4ad8056, first =
fail: v4.9.240-139-g65bd9a74252c) =

 =20
