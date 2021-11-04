Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D307E445C91
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 00:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhKDXMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 19:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhKDXME (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 19:12:04 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786F2C061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 16:09:26 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id r28so6764744pga.0
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 16:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CFZSpyAX067SQeEpVPLo3qAKIRQSyRIJ+CKYTdRaaVE=;
        b=y4IXhQbjl3cSkjH6/VE6LCC07CByff61n8ur9J649Wsry5kbPl5aEBhVhd6hEwJc30
         i/twrRbgys52hu1c2ixAIUTvmK6Lf+LX030lS4J4eRLqCDWenXM/bah6lslOvLsWvfFP
         0ntePM+KDWIT0f0vIaSwkC3q9cKz5MD+SdCHCMrDyrrDNDtWstJInqDWwbxFdXcRFLtx
         0BeSKtUPtaLa96ifn931bkvTykLsSGUp5S3TX6jDLNWe9eAcvC2FIwoGPyuwbh63/lZc
         YkExAw1bMIzwXH1Q9bFPQQWIGexrb/mehSjdFvAlnlFK/lWmwvLNcUBINQSaY/PPAlAH
         irEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CFZSpyAX067SQeEpVPLo3qAKIRQSyRIJ+CKYTdRaaVE=;
        b=3biFS60VFPeMLntSq8RlYoQGacE5hrbUySXtvrlmO4iIepzVlryLns+x1TRP+3S/Iu
         XA81NjXAaWiTebUhEX9UxeRFXjcodj0+1BwxQuvL3D+B82AVEIMRKcMo5ZVpFkZ03iZP
         /6gKisng/sjfrLnmSP8bK8UcKLxrxxEccdW4tfU3Ef18Ml5Yc0fd4TkOzHuFpavCE8BT
         xoiV8FN7kYtOc8lzHTfFncGfO0J3U2zY80M2DREE2tIFW/hvhSz4LgYKhaWRkrLj2EFq
         GhBnPs/1pt9NhjAJl4Lbat4vkd/eNU0bTGOgnH8ECT9hHXE4yE2L0a1a6sDo+xHg8CbD
         /50Q==
X-Gm-Message-State: AOAM530o4vZYq3T3JJH+t56jQ0BnXbkDahRxCPX2CoFlXMDLUZ3NydJS
        CkMaQjY0GgXiZoB6WaSjnIlrekERZt8z7500
X-Google-Smtp-Source: ABdhPJxIV2Qtr0+CXuo/jYBMc+GwLnzCmCC9qOn9HDi0xk+bh/3AeUcWPjo+27b5zHDu2WtgrWwwlg==
X-Received: by 2002:a63:d644:: with SMTP id d4mr29961910pgj.360.1636067365549;
        Thu, 04 Nov 2021 16:09:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i11sm4741037pgp.18.2021.11.04.16.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 16:09:25 -0700 (PDT)
Message-ID: <61846825.1c69fb81.7e5ed.05ed@mx.google.com>
Date:   Thu, 04 Nov 2021 16:09:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.254-7-g54e49ba3a341
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 115 runs,
 1 regressions (v4.14.254-7-g54e49ba3a341)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 115 runs, 1 regressions (v4.14.254-7-g54e49b=
a3a341)

Regressions Summary
-------------------

platform    | arch   | lab         | compiler | defconfig                  =
  | regressions
------------+--------+-------------+----------+----------------------------=
--+------------
qemu_x86_64 | x86_64 | lab-broonie | gcc-10   | x86_64_defcon...6-chromeboo=
k | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.254-7-g54e49ba3a341/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.254-7-g54e49ba3a341
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      54e49ba3a341b44ca9d2e54710b10d2230450965 =



Test Regressions
---------------- =



platform    | arch   | lab         | compiler | defconfig                  =
  | regressions
------------+--------+-------------+----------+----------------------------=
--+------------
qemu_x86_64 | x86_64 | lab-broonie | gcc-10   | x86_64_defcon...6-chromeboo=
k | 1          =


  Details:     https://kernelci.org/test/plan/id/618436911cea064f5d3358f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-7-g54e49ba3a341/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-7-g54e49ba3a341/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618436911cea064f5d335=
8f4
        new failure (last pass: v4.14.254-5-gc9b4934a4d6a) =

 =20
