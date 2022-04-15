Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED941502EE3
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 21:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347785AbiDOTEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 15:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347623AbiDOTEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 15:04:44 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CF3DA09A
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 12:02:15 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id s14so7757827plk.8
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 12:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oF0fF8OSkV/nsr3UUXFTOq1vTd6locDeAU3HEyL3w/w=;
        b=eh09NOnBlx2sjx73azJW0jJvgPif6qmOtY416w9OPoRY0xAe8bs4eGlTgbOnbUeg0P
         jv0bQysuU0tbSTuEr+KvTALLeGpRsvAXLgvffwCJQNS4kSCe3nE8CJym8AjiXnmrs5tR
         xl/fum+SiSV2lrYqUkes6jF0TRcLnlOl0P2iw1vbxzk7ZfO2uHpmG8wHtJ6MS6lXYba6
         o3VzVAz0rN6L7KcfHKaGlshC1icagZFuAnsK/UZFgIQdFlf0ypePfQTcJregXSWRmSqM
         Qq4/2SKWGiu+OqGov82KdWZuRmts4pWJhK7mVfTfvSvnlw9cYbvqeGVmev8qvxhSCsuB
         pedg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oF0fF8OSkV/nsr3UUXFTOq1vTd6locDeAU3HEyL3w/w=;
        b=hl/2Mba1UU+L9v7uhq2y181eFjlt1kmPsWs3bfqZR+dd8f3g/FSWLE4B7imN0TbUXk
         1ZFbM/tSKNhupbU27qrOVMn0whGZy6D7IrfaxKfRbICWXZox319X+gjxon+iReS+3/Xj
         rtnkI+PJcUPjHNGqenRciVifyNaLp64m/NIqt0iwCsAz+nydF3BjxyTAMA5Q8GkYxpTt
         ANZ901ZA75JK3TszpN1DsD+hknM3wH81PrFJ4t3Xe27VjHhITlk5UHc5nL+JMWKX+P0I
         HFv/2opSSfYwBVJhgAXwUiuVnwuuWz5VUzOTBCu7l6mWM4lr7EGR/X+WqNVUReM3DCSs
         wQtA==
X-Gm-Message-State: AOAM532ClthXqppYoEzLfK7pAJEBca7mEa0tuhq22O42n0ryb8EoWmQv
        3TX0ETqjIlTt/EPI0v+s7P8xBMhIyoEy2+qj
X-Google-Smtp-Source: ABdhPJw7xkANz7pk2lToyaB/Wu6VK337sIMXEmUCqcw+v2TOpEzwesRdY/dBV7C4fyRJ4hSEl2Nu5w==
X-Received: by 2002:a17:90b:3e85:b0:1c7:7eab:2649 with SMTP id rj5-20020a17090b3e8500b001c77eab2649mr305713pjb.232.1650049335293;
        Fri, 15 Apr 2022 12:02:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d8-20020a056a00198800b004fab740dbe6sm3796254pfl.15.2022.04.15.12.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 12:02:14 -0700 (PDT)
Message-ID: <6259c136.1c69fb81.fa07.aae2@mx.google.com>
Date:   Fri, 15 Apr 2022 12:02:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.275-260-g418b7627bcd28
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 98 runs,
 2 regressions (v4.14.275-260-g418b7627bcd28)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 98 runs, 2 regressions (v4.14.275-260-g418b7=
627bcd28)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
 | 1          =

meson8b-odroidc1     | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.275-260-g418b7627bcd28/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.275-260-g418b7627bcd28
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      418b7627bcd28d3c7e88e2da73ef4065631dfe00 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62599172abde0c58b9ae067e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-260-g418b7627bcd28/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-260-g418b7627bcd28/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62599172abde0c58b9ae0=
67f
        failing since 9 days (last pass: v4.14.271-23-g28704797a540, first =
fail: v4.14.275-206-gfa920f352ff15) =

 =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson8b-odroidc1     | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62598f769567bc82b9ae0681

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-260-g418b7627bcd28/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-260-g418b7627bcd28/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62598f779567bc82b9ae0=
682
        failing since 61 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
