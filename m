Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2AE67A182
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 19:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbjAXSlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 13:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233852AbjAXSlc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 13:41:32 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB914F86A
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 10:41:06 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id t12-20020a17090aae0c00b00229f4cff534so1955790pjq.1
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 10:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=FGhEw8tDDk4Z/v0o/9LR4bpnxgBjL2ngEPq3+uJJ2aM=;
        b=vscUGTX5JzjsD8TJFQeRN8P6YLvudGdx8iejtlTiYZ2R+oAdsd6sJoW+cO/Tu+vB1Z
         fRg76w5mJBFLTpoNf38OohxLvMRM0MNiCdXZXl9aAu/J1oyyJtnwgoPtCCdc4JY9g7KL
         yPWyo/prsGWvTynmrZ08msZinfvT5K2H2uJsxzV7DqQYHwgESN1+XT8Pt3vzd2WKb25Y
         CWni5QLNR1M1rwLXg1NAZmUlZvnqrPAqOPqiMVjghR/8if+amfCzg/TegWIQN2nranR2
         GaWJiWdx9TZ5y+BQ1dg3qW2YGjto/YOwIKMBsqdSSNNwcgmfGhUR0iZh3fvvXLRUB2Ye
         5E9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FGhEw8tDDk4Z/v0o/9LR4bpnxgBjL2ngEPq3+uJJ2aM=;
        b=dU7RqWPVVuMu2kXlUwXtWHwOB0T5ulbwV2qxbkq8G+fbijWzOixy/khOl2zAnJdLVJ
         /ebfSboyqc2nMhTCsc7LVeaYHnP7tTPlvw2BqFNBY4mO2pxHiYILHIjcCcDCNA6b0wsR
         ZN4Pmq3+aUxyCHguRwxKauEx64/Ejh7y245xNlNI5J9X/9W3ys9gicHwtZARgBlsJMFM
         opdRbH/r7VXTpHOBDG7rXq8XwKRm0+RFt2N5tAp7i3Umsove6/Oj/Yd6JJ/puJgR1c8p
         e9aIrsoo+FUGuwuFGvfIXH9vGQT11BPn3cNpxgnTMWr0lsoRlHRae1b9RKCLn6g0Sypm
         k4pQ==
X-Gm-Message-State: AFqh2kpPEZwmXS3qx7cWQNA1Kf4vbEp3uSehATfHST8KMB3gXcxY7hdJ
        ujyFhG8JnY3F1bRFh8s5BJjZmsOkIs9hTpVR0IU=
X-Google-Smtp-Source: AMrXdXuTguYgLMlYPSd4RgFOhwIx9kKbWYg7ivcV930jQsJ/5Md6FcXY8r27ViVrSP75lAL83kF5VQ==
X-Received: by 2002:a05:6a21:3a46:b0:b0:2b4f:a9d9 with SMTP id zu6-20020a056a213a4600b000b02b4fa9d9mr31975199pzb.5.1674585663788;
        Tue, 24 Jan 2023 10:41:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y7-20020a1709029b8700b001929dff50a9sm2016563plp.87.2023.01.24.10.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 10:41:03 -0800 (PST)
Message-ID: <63d0263f.170a0220.2116.3c34@mx.google.com>
Date:   Tue, 24 Jan 2023 10:41:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.87-341-g37212d32e1be
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 90 runs,
 1 regressions (v5.15.87-341-g37212d32e1be)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 90 runs, 1 regressions (v5.15.87-341-g37212d=
32e1be)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.87-341-g37212d32e1be/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.87-341-g37212d32e1be
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      37212d32e1be279f6a215919dd53cb08f1e75fc3 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/63cff5845bcdf406d1915ec2

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
341-g37212d32e1be/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
341-g37212d32e1be/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cff5845bcdf406d1915ec7
        failing since 7 days (last pass: v5.15.82-123-gd03dbdba21ef, first =
fail: v5.15.87-100-ge215d5ead661)

    2023-01-24T15:12:45.592264  + set +x<8>[   10.043853] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3201457_1.5.2.4.1>
    2023-01-24T15:12:45.593743  =

    2023-01-24T15:12:45.707414  / # #
    2023-01-24T15:12:45.809686  export SHELL=3D/bin/sh
    2023-01-24T15:12:45.810651  #
    2023-01-24T15:12:45.912553  / # export SHELL=3D/bin/sh. /lava-3201457/e=
nvironment
    2023-01-24T15:12:45.912964  =

    2023-01-24T15:12:46.014414  / # . /lava-3201457/environment/lava-320145=
7/bin/lava-test-runner /lava-3201457/1
    2023-01-24T15:12:46.016073  =

    2023-01-24T15:12:46.020664  / # /lava-3201457/bin/lava-test-runner /lav=
a-3201457/1 =

    ... (12 line(s) more)  =

 =20
