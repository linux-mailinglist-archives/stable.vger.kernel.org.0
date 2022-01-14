Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5061A48F1EE
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 22:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiANVMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 16:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiANVMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 16:12:34 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B51C061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 13:12:34 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id n185so3841300pfd.2
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 13:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EY5wONFdRbukpQMzwumNvv3Sw8hHPYBBzL5qYzPfYCU=;
        b=qZ1ZkseSYrvesqGZ0ZNeaE34ArgVz4Lldk5BVaon4n+zCOuIzx2NVmv060aLTZLNIX
         mlzBSh6OUoi8bBMldLZIyaPq8yM60HLK6eeHj37h1wHsdFsqG/+nns1HzAb+88NgPt9U
         mQJrB8EzjThTdkiyOO0eZJfZfdrAeeXewpYLfxdy9iwhn5YJSccMRcMtBgY2T3HKlIvR
         ujCxx4PQIsTJ4iMWSqZ8IT1Yw4zU3Ciw19N5q0hNfkA07M8uc+bgoxdbsB74HX1nIPHT
         7pBsnVfbeqWAkNI+AuNLQGet60I4hIBo3WGHIbYyW0U1+Qprn8r/0qiqwIejlXNhJAGg
         /Hkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EY5wONFdRbukpQMzwumNvv3Sw8hHPYBBzL5qYzPfYCU=;
        b=zOJXx7iWJNQLOOh6LrNDcetQBet8li6UDqwDNoxZFx6XADtUuS2nQhvMtvrdLqdM+Q
         DxaX2uv2G9F2Ibl++ujykxcokSDU9Br/uPAotfbKekk5TrrKpgDwv1cXiXnYgflh4wPF
         ZirwxYHW4hjOVmNTcNlDXuF1TVrfdktlgrfZwJtOWiVZlShqsw53FFyvcgqJ1S0bpT1d
         HlC1wSQzBxKz79KBy7fmVKORIa0ZeK+gTPtdOlBM6pdYU+/zKzLX45RucdQmIBOOmEw5
         jBRzok547M9+XZM/Q82yU4zDyQZQhEs/hZXWMY+XaMn09U5dOupbBMTX0c2hrbXOzCgT
         dmjQ==
X-Gm-Message-State: AOAM531gK5EpHB3kJV9JUuPTd4/x1b2tqjXZ7ncFRZP1MVgOXARTAD4r
        X9fjJaITAKu0YbRtnIVoSJJ0CVDRHKJ4rxfM
X-Google-Smtp-Source: ABdhPJx00TfPd5qMIZMPPe57RipFziQsTGnlpYGMP2HugCclr9wYJPF4dLmvlOcrZ/kooT4TXLtN4g==
X-Received: by 2002:a62:cd02:0:b0:4bd:8f59:dc4e with SMTP id o2-20020a62cd02000000b004bd8f59dc4emr10740511pfg.64.1642194753636;
        Fri, 14 Jan 2022 13:12:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b11sm5195591pge.84.2022.01.14.13.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 13:12:32 -0800 (PST)
Message-ID: <61e1e740.1c69fb81.2b9a6.eaaa@mx.google.com>
Date:   Fri, 14 Jan 2022 13:12:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.225-13-gc761af51b2b5
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 137 runs,
 1 regressions (v4.19.225-13-gc761af51b2b5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 137 runs, 1 regressions (v4.19.225-13-gc761a=
f51b2b5)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.225-13-gc761af51b2b5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.225-13-gc761af51b2b5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c761af51b2b54b268f9a7756d6393e67e2b1d9a6 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e1b2e70bdbd06efaef678e

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-13-gc761af51b2b5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-13-gc761af51b2b5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e1b2e80bdbd06=
efaef6791
        failing since 2 days (last pass: v4.19.224-21-gaa8492ba4fad, first =
fail: v4.19.225)
        2 lines

    2022-01-14T17:28:55.534062  <8>[   21.234100] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-14T17:28:55.582888  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2022-01-14T17:28:55.592238  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-14T17:28:55.609172  <8>[   21.310882] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
