Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9C840D190
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 04:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbhIPCMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 22:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbhIPCMG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 22:12:06 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288F4C061574
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 19:10:47 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id f129so4713765pgc.1
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 19:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1ng/Shq+2ImxqsnCk0SUu+PK+I+/5m5xscnE4pPIs38=;
        b=prifdtJWJowAWCoRdzCP/g0cP8FUHq+m6j/bTO8WLZWZfnO0x51+EmuAdlHyjoIGou
         9FF40fvZC+OyHMV5BJG2oirAyoLrysySqY5B/N213iXr71eq2ishSCcnFARk8eFhspie
         m+VUKkADwp8Xf3m1/5w4WP0JFI3Eskh8IK2th9nAiH6cakqHq9BgF3kIJZa4CprRmLWb
         T8QoE2qfZwFOekslq9ksQiLhAi7u9wQ5Ere2ptp4K8pdbsfEFNd8RtZxwyzj/9vsQ8TW
         IcOUgnlC/hP/KL41RHEgT8FGm58wMnI7CD7LjrWEcDIjAVEWlJAulg4t0lUduztz7JI6
         b02w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1ng/Shq+2ImxqsnCk0SUu+PK+I+/5m5xscnE4pPIs38=;
        b=VwmsvygOd9SlnptntLjfgCrtytPykw2l5kUwC1Q7bvv5Kp+IC9LvnHHpCsB8n73aY4
         I3MkQJ2srE5Wxv1DMnMMR24iIK1NBD1unHXOP754KHErw/acOeTvB4cbHSgYxw7JcE4m
         W3XA+I0y+c08ImfQIghOeTzp/bcyZgTG3TCUgZk712dSHBFVzCbBK/mfssjsPlp8vVQa
         bpEwvq15V9tlOEiYzR8fpLRnRhVYNQzMBQiolsgrTePv5gSROL4iGulY+x0UgEjq2l/d
         tJZh2nnvp4ZuJDS5IecUj/dNtvt06Ls0caw8I1klFhLYjQ8nUoAI8imCpTSiw5BUvrxq
         yZ5g==
X-Gm-Message-State: AOAM5326sMIXde4cexiBhhpvzssimysVeVrd0rm17zvrypy1R1cAlCue
        hHz2EWj4YT5qmBEyu39iQfcGNdIVKLBTJuqn
X-Google-Smtp-Source: ABdhPJyUyn6EMfHCFE/506g/jGCcC7v8usbsZoYUpZhm54CbpHKFjOCmACzAXhCJx0Rd0w3SN4iGWg==
X-Received: by 2002:a63:f62:: with SMTP id 34mr2677144pgp.159.1631758246447;
        Wed, 15 Sep 2021 19:10:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m18sm791511pjq.32.2021.09.15.19.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 19:10:46 -0700 (PDT)
Message-ID: <6142a7a6.1c69fb81.9140f.487f@mx.google.com>
Date:   Wed, 15 Sep 2021 19:10:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.65-55-g84286fd568e7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 131 runs,
 1 regressions (v5.10.65-55-g84286fd568e7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 131 runs, 1 regressions (v5.10.65-55-g8428=
6fd568e7)

Regressions Summary
-------------------

platform               | arch  | lab          | compiler | defconfig | regr=
essions
-----------------------+-------+--------------+----------+-----------+-----=
-------
meson-sm1-khadas-vim3l | arm64 | lab-baylibre | gcc-8    | defconfig | 1   =
       =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.65-55-g84286fd568e7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.65-55-g84286fd568e7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      84286fd568e73b4ac1ab556fabc54f312be9c40d =



Test Regressions
---------------- =



platform               | arch  | lab          | compiler | defconfig | regr=
essions
-----------------------+-------+--------------+----------+-----------+-----=
-------
meson-sm1-khadas-vim3l | arm64 | lab-baylibre | gcc-8    | defconfig | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/6142728d2a787af3c199a2ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
5-55-g84286fd568e7/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-sm1-kh=
adas-vim3l.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
5-55-g84286fd568e7/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-sm1-kh=
adas-vim3l.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6142728d2a787af3c199a=
2eb
        new failure (last pass: v5.10.65) =

 =20
