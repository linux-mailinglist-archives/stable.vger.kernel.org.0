Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6193408727
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 10:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238143AbhIMIjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 04:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238781AbhIMIjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 04:39:22 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71984C061155
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 01:35:34 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id r2so8755129pgl.10
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 01:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yf8sVeflu7klc2zsulzdsENhIwVjdQOXSdPwT2ygwj8=;
        b=IFKYjfImTOKalYH9AW6mP1aIXqit2SZkJGRU7hThN8ERQ7BHz/Q6ejSMS+EormF+Mw
         8YdKVBy590rqu31NBTQjsEnNSW1wIXxcoM9o8hWaLU9RuIIpL5VAO5qe6jkJvNCH8sFH
         50A2gxYEFcvYWj9Cde9LXrLoyCwNT6yWx5XRpsqAmkauO4dKYrMlvHdG8lkuJ6qJLqty
         ccrlw/w0u8WtbCous6z+uJK3h8rHjY2i5VaAvIJsQsu8yTn7Djt9XCDGGMhJEomugX2X
         QTEPajF0PPAOWM0wRe0qRDj4vI8TVtzPjl+ABhHNxzjLGrnhtuy17QF1uGZKqYRKOidN
         N9DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yf8sVeflu7klc2zsulzdsENhIwVjdQOXSdPwT2ygwj8=;
        b=MFCfh51+7RsR7BS4pim7NrsBloS1vUuTo2V0sFyaMcjCB0PuY0wp7VkRKZtQMd08ma
         8t5nnIJqh69dlQex8+75DME2ugfcy3vKzrBCPEQNLB5JI/fKb5VUAn1q1z1KIevpvU9g
         yG0QKTQtUsFRQykJY62nCUTfkQ/V/cIMIod2EFjKLh6r7kDbclTJNM6qQaLfxB6U75/x
         mzCDJNpsgVSfVtLMeWbYhPTAAyHL8zl5pFsF3vjad4tzvbqcGIrco/6fdPxrASo0obZX
         TlshkG3+mtss6mmi3RKVp/P08k/P7YyObKlsOetc0UY+1RCgURGMLo+y5hcyi+LUHZI6
         csUg==
X-Gm-Message-State: AOAM532/Sd/NLz9LA80LWfbqpDyZY4wWtNhtjN6EA8vHnPhVUcYZKlzN
        yT+W0VKGDB6QVHvcPT1lSxxBJOyeB+/pBTkt
X-Google-Smtp-Source: ABdhPJw6hg4y+MK3bwc68xG5+vikeREitzQy3pgq2zJew7Bf9OyqIC5JoPeZMXISRbwMgGp1vBuujg==
X-Received: by 2002:a63:e24b:: with SMTP id y11mr10092923pgj.452.1631522133844;
        Mon, 13 Sep 2021 01:35:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w67sm4116550pfb.99.2021.09.13.01.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 01:35:33 -0700 (PDT)
Message-ID: <613f0d55.1c69fb81.de5d9.ba62@mx.google.com>
Date:   Mon, 13 Sep 2021 01:35:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.3-294-g9d35f37c1067
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 161 runs,
 2 regressions (v5.14.3-294-g9d35f37c1067)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 161 runs, 2 regressions (v5.14.3-294-g9d35f3=
7c1067)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =

beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.3-294-g9d35f37c1067/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.3-294-g9d35f37c1067
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9d35f37c10676c19b63338f3027df31d12a1618d =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/613edd78e3783d832dd5968a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.3-2=
94-g9d35f37c1067/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.3-2=
94-g9d35f37c1067/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613edd78e3783d832dd59=
68b
        new failure (last pass: v5.14.2-23-g3e6e24d4af82) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/613ede05dab6c97135d59679

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.3-2=
94-g9d35f37c1067/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.3-2=
94-g9d35f37c1067/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613ede05dab6c97135d59=
67a
        failing since 2 days (last pass: v5.14.2-23-g1a3d3f4a63ad, first fa=
il: v5.14.2-23-ge6845034189d) =

 =20
