Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF0C4F6C90
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 23:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235705AbiDFVZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 17:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235759AbiDFVZE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 17:25:04 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F01269341
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 13:20:15 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id i11so2945518plg.12
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 13:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZF0eScGUqDVzaUV14hIJuXwWl/hkbArHH7k8ed+b62k=;
        b=6U25Vbb2myOxnOiwhFF2h0U/BkiyuKaTaqowGoq341eTRxwoAc8DwJHnIc5E3/YBKu
         KY9Jaum3FV5+CD9CN4fOzVvRteziBXP98VDf9kNeO1rchMv/PeShXPS/iKsx/qyKTMR9
         WTFoAH9mM+peniKpf9WTJVfFkEzI35LRz56icCzE8Np6vDjiszGtmL1MiL8DO+XMtCty
         ysKsSWdWlMisexXijs8PdHnajG6WH1dwjqXQsSGn9q4mJYFe97gv7uVAK0YizZURxPD3
         psJM8LJkllcfp3qdL04xdnevwHDTkthAUtL57fd0r7FlvZnEjLYdw/HAH3q7xYpW4ceA
         OU7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZF0eScGUqDVzaUV14hIJuXwWl/hkbArHH7k8ed+b62k=;
        b=agVYTlVBIRTfbPHi9xFHZE+CZ/kwizzURdHIAjtDCZ5O0fhHX4Urv8JlAB2p+tgQ0Y
         SEXWnGCrFKOC96TTXgYy7akvKvzuENrJAm6SlYhYdll4DJCH4hI4v5cEy+sAv6MoDSOQ
         85kaj3aIDS2BQrBMxwIjMzdH8PeBKE1JCzyxJXXXwT3oEshL87dRB90lAxtXib5nvYrN
         LCsLhLjUFdMYJgxCQXUdxGoSyXAX9iz+QfByeTFJwSSkg8AubWmHiNvrO2rHGIBTa4UB
         TwyhSq+fepL3z7EXQ0zFoSFt2nxUAbEfQVSx+XeZez4QSHUWuhi+peWfpuOylXNEhr+L
         fXow==
X-Gm-Message-State: AOAM531q7Dr5tPh2EzAYkz2fetzVqRg6j8Nx35ffvbDatyytU0w4a4cl
        IcAsrwGdE+cAhg1xRtvAxyAzSzaY9JWP+IvUW1s=
X-Google-Smtp-Source: ABdhPJyOsgBkgjO3dcPDjh5PzAWjUxnnBmkA614rK3rm+Z3o34mmZ6iB0bk9C+l8uzq7wkki7VmIYQ==
X-Received: by 2002:a17:902:ef50:b0:156:486f:b593 with SMTP id e16-20020a170902ef5000b00156486fb593mr10259485plx.104.1649276414216;
        Wed, 06 Apr 2022 13:20:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t34-20020a056a0013a200b004faa8346e83sm21425445pfg.2.2022.04.06.13.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 13:20:13 -0700 (PDT)
Message-ID: <624df5fd.1c69fb81.2c63d.8458@mx.google.com>
Date:   Wed, 06 Apr 2022 13:20:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.275-205-gc2f822ce793d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 49 runs,
 2 regressions (v4.14.275-205-gc2f822ce793d)
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

stable-rc/queue/4.14 baseline: 49 runs, 2 regressions (v4.14.275-205-gc2f82=
2ce793d)

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
nel/v4.14.275-205-gc2f822ce793d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.275-205-gc2f822ce793d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c2f822ce793dbee60f3c8ffbc3e19fcfeb30e56a =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/624dc6ce76e96b4b58ae06a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-205-gc2f822ce793d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-205-gc2f822ce793d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624dc6ce76e96b4b58ae0=
6a3
        failing since 0 day (last pass: v4.14.271-23-g28704797a540, first f=
ail: v4.14.275-206-gfa920f352ff15) =

 =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson8b-odroidc1     | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/624dc4430ddf986de5ae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-205-gc2f822ce793d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meso=
n8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-205-gc2f822ce793d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meso=
n8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624dc4430ddf986de5ae0=
67d
        failing since 52 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
