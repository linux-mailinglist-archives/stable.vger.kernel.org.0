Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01B1426527
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 09:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbhJHHVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 03:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbhJHHVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 03:21:42 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89831C061760
        for <stable@vger.kernel.org>; Fri,  8 Oct 2021 00:19:47 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so8786918pjc.3
        for <stable@vger.kernel.org>; Fri, 08 Oct 2021 00:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7+g7lz1ipmRCKU1OiwvvBACzQBwvbIcjF+h0ftThR38=;
        b=HynzP9EONAAL7NuMgpsIodOm/GQU/91Axg3BpDvfpk/uXcz7pkM6CYIXc9JgrK+bIE
         L4bJWfnJgEkko1c/TbD9GgomaTeiqjQcyKgDapDOVqrdzgOZgDgng1Ip/UImZyvN3CHQ
         AKxkCcEws7LQjRjjgXCbw0hMiumLiECB073xGA/CAD4h9RY7Xv68XyeuQp9+SfcqjRhl
         DVe+Odep4Kcw2gAFalCBzedxYL3ybSEeIK8rQ8oZR9xanmfYRmUvK3bM6C83OBQ85Mo5
         UNo08YZP1XiSH6Wpd7yF0SVIh/GZn5k+UBXbPusVQhnpmggGoVUScl3uHpltYoOmUU50
         uBGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7+g7lz1ipmRCKU1OiwvvBACzQBwvbIcjF+h0ftThR38=;
        b=DZ2Sa4wMgJf9L03wrj+c7vu5M73xFLxKniLOGIBX+wTwDjbDGoCd2JR9vwAI1C4Qqu
         9vRhtIISlwwFeAS6AWwUEzLFi3urkKADJEdyswBX+cS9SxA2XXP11oyB1PYrecJoZKSj
         5DNt/954e7vxrf7ijr8EMdKNSvS7y61QmucMzYPKVvWuJrn9wZroH2QvfJzkCXtyRo3x
         3NTl3qt/Sf4mZ62/fr7ZUZtS91ish6OxZBJdNARCFz3PkkvibknxLgWStvQETIfEA67z
         8w0uOtJ+Hyf6+mSMT2WCt9awg6sVPQcBhWmnJ4NAqaW7FTtP+ysZIAStVfS5C2aLdJ6J
         JGpw==
X-Gm-Message-State: AOAM532t/kLY0QleVRwSqgAbP1xEHtVQ/MoFTuBW0aE4sTwBbIc09WT2
        XD7oSNMG7ZRaKFar0q0/9rjCfJ5ylcPq226h
X-Google-Smtp-Source: ABdhPJy/0XlqEnC0WM8tnqYT9NZlWITYmgnlLfg5lo8wFBhXYSCgDg5mISwoXwjWn80eI9e8KefnLA==
X-Received: by 2002:a17:90a:dc81:: with SMTP id j1mr9946900pjv.155.1633677586952;
        Fri, 08 Oct 2021 00:19:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 184sm1567949pfw.49.2021.10.08.00.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 00:19:46 -0700 (PDT)
Message-ID: <615ff112.1c69fb81.ecf35.526e@mx.google.com>
Date:   Fri, 08 Oct 2021 00:19:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.71-27-g0503cdd00c93
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 145 runs,
 2 regressions (v5.10.71-27-g0503cdd00c93)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 145 runs, 2 regressions (v5.10.71-27-g0503cd=
d00c93)

Regressions Summary
-------------------

platform    | arch  | lab           | compiler | defconfig      | regressio=
ns
------------+-------+---------------+----------+----------------+----------=
--
hip07-d05   | arm64 | lab-collabora | gcc-8    | defconfig      | 1        =
  =

i945gsex-qs | i386  | lab-clabbe    | gcc-8    | i386_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.71-27-g0503cdd00c93/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.71-27-g0503cdd00c93
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0503cdd00c93cd43022c0f86563ac6c27aac7ca2 =



Test Regressions
---------------- =



platform    | arch  | lab           | compiler | defconfig      | regressio=
ns
------------+-------+---------------+----------+----------------+----------=
--
hip07-d05   | arm64 | lab-collabora | gcc-8    | defconfig      | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/615fbc40d8c70d455999a336

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.71-=
27-g0503cdd00c93/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.71-=
27-g0503cdd00c93/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615fbc40d8c70d455999a=
337
        failing since 98 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform    | arch  | lab           | compiler | defconfig      | regressio=
ns
------------+-------+---------------+----------+----------------+----------=
--
i945gsex-qs | i386  | lab-clabbe    | gcc-8    | i386_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/615fb9dc980a6699df99a2e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.71-=
27-g0503cdd00c93/i386/i386_defconfig/gcc-8/lab-clabbe/baseline-i945gsex-qs.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.71-=
27-g0503cdd00c93/i386/i386_defconfig/gcc-8/lab-clabbe/baseline-i945gsex-qs.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615fb9dc980a6699df99a=
2e5
        new failure (last pass: v5.10.71-28-g2f55a27c87e9) =

 =20
