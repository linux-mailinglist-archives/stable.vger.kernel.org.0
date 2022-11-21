Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11A87632C3A
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 19:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiKUSnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 13:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiKUSnO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 13:43:14 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99705E3C4
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 10:43:13 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id b11so11202813pjp.2
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 10:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=SAbFWKhVXyCKTJt+kQxRgX2stirhvVjRYijDBb3VE7E=;
        b=txE3Fo5badqXoEHcEnOIukgMH82fKOrfq/9G82VbhNkPNw3k3UReP0ShbpsNRZ4wu0
         ZbZMAXnEG8I766eLOIqaKzGJCFvSf1SyqrVR7T3eFjJjl2mmJAHquSzrH8SCnZB/LmX8
         DxrGI97QvVKNnGfqHfcLxlGWRVvqOPVWze90PzZbxJr0v44t7ZPi87OwF/BYJv9hSe5n
         j1CcUhr7kj06bFZSft2Oe159Y2Z2oB7DnhP8OLTvFPA+RW2dFI0UXED4tnanbMy/rrDf
         A9sZdhUCK3KwmZS1bsj4OJ0MBy/8PyoC2U8ExlZDm5/Gc7kzi5uAypKNhvOd11cye+Rb
         P03Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SAbFWKhVXyCKTJt+kQxRgX2stirhvVjRYijDBb3VE7E=;
        b=maoXPN4zDHoYWYBl2C7JqHrbrjNRZlffJdjaEa6up8j42T6TW4iZO4qnn4OqVSRpwc
         dh2W9L5UGlDCLOkoE/sgY2eVfCFdjbIKfF6Ac3VTE/GXGG04+DjpxMFgMt7vSu9RThIu
         rjXsy6Wl2Ekgt1iyuIzFWMUHmIfVS0bf/QuAQSTqVZ2j9vFhUsVOPdgu+jJJ+bpAgMZ6
         0jYeo6USrk7FqKaEUIWDhCTdYJM/+UDNqoNzV2JQ+GVdxOehhAOsuRQKHj+HOpeLTLji
         p0aYUbvIGRk5kAtj/B6FAOJt3s9j6hzgAPKIg9O9Te9GVcwwM6u1p5Ju4k7cyVmASQI+
         yEdQ==
X-Gm-Message-State: ANoB5pnqxkpobqnh1yNJFDr80l8aZZB3KTj2/eQ6GaTtSo4r6tHOgtQi
        lMuuYkfoQI8oJHznyTFMxTm5TU2lmM+F6m5vrtQ=
X-Google-Smtp-Source: AA0mqf5Te+nY6K/b9qArYACfoW8GpY5DlWu999zL9E4i3JaEbKVXeIMNerdAAJmnpNvC1eKIBSMlYQ==
X-Received: by 2002:a17:90a:d255:b0:218:afd0:a3c7 with SMTP id o21-20020a17090ad25500b00218afd0a3c7mr6540193pjw.195.1669056192855;
        Mon, 21 Nov 2022 10:43:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h17-20020aa79f51000000b0056c2e497b02sm9333533pfr.173.2022.11.21.10.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 10:43:12 -0800 (PST)
Message-ID: <637bc6c0.a70a0220.2f9e6.de6d@mx.google.com>
Date:   Mon, 21 Nov 2022 10:43:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.155-126-gc1a10e1f62eb
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 144 runs,
 1 regressions (v5.10.155-126-gc1a10e1f62eb)
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

stable-rc/linux-5.10.y baseline: 144 runs, 1 regressions (v5.10.155-126-gc1=
a10e1f62eb)

Regressions Summary
-------------------

platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.155-126-gc1a10e1f62eb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.155-126-gc1a10e1f62eb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c1a10e1f62eb53026d012ef78d0a4832cae8efac =



Test Regressions
---------------- =



platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/637b8d688a2f74397d2abcfe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
55-126-gc1a10e1f62eb/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
55-126-gc1a10e1f62eb/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637b8d688a2f74397d2ab=
cff
        failing since 7 days (last pass: v5.10.154, first fail: v5.10.154-9=
6-gd59f46a55fcd) =

 =20
