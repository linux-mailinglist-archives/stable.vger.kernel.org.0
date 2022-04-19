Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B699B506C99
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 14:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349066AbiDSMmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 08:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbiDSMmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 08:42:05 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E1736145
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 05:39:23 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id ll10so15256606pjb.5
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 05:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BTXnlBTavzcKdME9oJggPJD35nFmYh4HEuw8dritzH4=;
        b=eoW370GgwBAXBerbxn8uc4P5lTui9Fh4jB5F43sH8FS0r4onOUN5XP7wkstCfXr2s1
         dmOkM+cjehGh0049SiR+4qPl/GfzsbTIRDUyt6n0YiwvvCMqI7cDqdVe4R9uIJVXlBat
         Tydp5zkjePHK+cT5lOOIZrCRrNO1TaN6OV73f7Tk2QD7rKiYgLd2vYfMohXTAqZiHn9j
         u12bQZ9IBmWVmUbeiz7n+wPdkQ+X5Sj3Yd8YWJCcAJ19aDomW1lQfSNejEXk0lo9CsBL
         g0a4esp4FF5yEohzG3pE3eJSAeM9kvGF0wQsk4RgyZhfx3AhyT/R6xmxZ4CTebRL/yye
         n8Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BTXnlBTavzcKdME9oJggPJD35nFmYh4HEuw8dritzH4=;
        b=yHH5eCuBya6qz17tMQziABvPD0ECqPcAm13A+Ex84YMCn0rdNCHfP4gMs7/p9amigC
         7WcULy/X6yMBauwFpy2WwWM2TNmFzsx5zuDxi4yF4Ff+5tzSLyVnbHqSy0jky1Sxd7Sg
         M/FB/giS14464dwi9jUr3Sho2B2UJKYn2LKu+tu+kY3fdMndmA5SWUa73gN5t2O9Crvs
         WCyE+9qag8/v6UUo23A/ZERW78bHyOss0HARy5XLoBvveCTYYFDHgGsqa9ZlLeMW3kmz
         bY6NmxmPaMmSGvD6lf//P6CJbjN1B3LFrceyvqPLLy+muxX/zxEeUMBeFhMHPL7KDZU1
         ZvOA==
X-Gm-Message-State: AOAM5304cp7aMDzVcQ0vbpQpRJDq2i6aSTyU6jY5h16aZaDtFT0y7U2G
        ciw+FqzmQNMG2jp0/AJlh257OKpaCCi6kBe4
X-Google-Smtp-Source: ABdhPJxzUgiw0oY7Zi7f0bDrcFiL77nl9n81OqQdHDQ+OFiXBTdObtUPJXA0RByS/FFTdcufXzG5LA==
X-Received: by 2002:a17:90a:b396:b0:1cd:44cc:15a9 with SMTP id e22-20020a17090ab39600b001cd44cc15a9mr18130045pjr.77.1650371962888;
        Tue, 19 Apr 2022 05:39:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ml1-20020a17090b360100b001cd40539cd9sm15988425pjb.1.2022.04.19.05.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 05:39:22 -0700 (PDT)
Message-ID: <625ead7a.1c69fb81.bead3.610d@mx.google.com>
Date:   Tue, 19 Apr 2022 05:39:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.275-284-gdf8ec5b4383b9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 87 runs,
 2 regressions (v4.14.275-284-gdf8ec5b4383b9)
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

stable-rc/queue/4.14 baseline: 87 runs, 2 regressions (v4.14.275-284-gdf8ec=
5b4383b9)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-gxl-s905d-p230         | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.275-284-gdf8ec5b4383b9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.275-284-gdf8ec5b4383b9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      df8ec5b4383b9fe9685984a8dcbe7f7109c06978 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-gxl-s905d-p230         | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/625dacb9f439699222ae0681

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-284-gdf8ec5b4383b9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-284-gdf8ec5b4383b9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625dacb9f439699222ae0=
682
        failing since 12 days (last pass: v4.14.271-23-g28704797a540, first=
 fail: v4.14.275-206-gfa920f352ff15) =

 =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/625dac1f6636614dcdae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-284-gdf8ec5b4383b9/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s=
905x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-284-gdf8ec5b4383b9/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s=
905x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625dac1f6636614dcdae0=
67d
        new failure (last pass: v4.14.275-277-gda5c0b6bebbb1) =

 =20
