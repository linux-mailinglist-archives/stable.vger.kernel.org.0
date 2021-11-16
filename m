Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8212B453875
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 18:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238472AbhKPR2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 12:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238402AbhKPR2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 12:28:47 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98B4C061570
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 09:25:50 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id r23so2383365pgu.13
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 09:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wznWSDotMhd69JtgYMO+uM31N2fHN5KNnKkaDaQvBnQ=;
        b=t6ygZc09EFpS0CinlQ1m015A6otxuznd34xThE/7a28wU+2NxMcaNHNL/Kd+fQJCww
         SL/M3KkVNLN/YzRMdrxujU3kYpubXtmTdaGZ74KzlU13rnTB1+7ZpXF1bQjhn72To+57
         5FnxD8ICQxOhtoR+xnoDZw59K+fxLmzBsyEMU1uz7CDiazfIh3qwrcLz1Yb9GXMYAt7y
         ZmXXuWj7rINNDTrabC4R5+zkDjJLn9ALgYbaZ/Vl5yCi758u6S5WVwIBQ5OZ4Aq/dzIi
         kX04+Fs/Dij+b9S3j+EG2atrNKYGqE59u51Wnwh4S39ykz55i/hE1AfRdCdt3E5nMhve
         rUAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wznWSDotMhd69JtgYMO+uM31N2fHN5KNnKkaDaQvBnQ=;
        b=qnfsqTYU6T/+5JVCUHt5Yf3JDpynMCY/luRBdCObX24p67giPePosfhaNN7yBgHhcX
         fdxpw8kvVSbwAxmd6xCpOmF6pkVVjtBFMfJAjIZ4eWNNdmYoDAN5FubMH/OnxvGzxk6o
         sJ1fP/Zcq2HnFbhtbuXVHnomhzD1m08+urJjFh2ZN+OLNqcz1siBOTXJqg4PPdn7MBeS
         5ReDy3uHtFZLV8x1P2//pOecFsPg39mFDEuJ8OCya1esSRjPSMXHxNrxHNu0bG/qp9dy
         UWfczw18aGYSDkqnsv7hBW8jM52d6Wz87Cl+dKuwu/wm5J/dtI2e5OGnmIqgNkPed4MD
         /MfQ==
X-Gm-Message-State: AOAM532bGWmlJnQAIHdningN1XY22EMcQTfBtx7X+NFOlgP+LjIMqukx
        kDwHcHDkhV+8LOHTHnPiFY65AMW9Xs3fHYbd
X-Google-Smtp-Source: ABdhPJzCHHgz5F04ix2z4xdIKext3OVMZy93JPQjEyuVAdf1IatI9CKjoypFVzxUYBQz4UrYIxVQYg==
X-Received: by 2002:a05:6a00:1946:b0:44d:8136:a4a4 with SMTP id s6-20020a056a00194600b0044d8136a4a4mr775100pfk.46.1637083550261;
        Tue, 16 Nov 2021 09:25:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f7sm18431760pfv.89.2021.11.16.09.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 09:25:49 -0800 (PST)
Message-ID: <6193e99d.1c69fb81.33816.2c7b@mx.google.com>
Date:   Tue, 16 Nov 2021 09:25:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.217-251-ge141087d871c4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 109 runs,
 1 regressions (v4.19.217-251-ge141087d871c4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 109 runs, 1 regressions (v4.19.217-251-ge141=
087d871c4)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.217-251-ge141087d871c4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.217-251-ge141087d871c4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e141087d871c454a8f11ca5f8ed7643316e005fb =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6193b51816d61ffe1f3358e9

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-251-ge141087d871c4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-251-ge141087d871c4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6193b51816d61ff=
e1f3358ec
        failing since 1 day (last pass: v4.19.217-72-gf6a03fda7e567, first =
fail: v4.19.217-85-g1a2f6a289a70)
        2 lines

    2021-11-16T13:41:25.302183  <8>[   21.280426] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-16T13:41:25.347155  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/100
    2021-11-16T13:41:25.356685  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
