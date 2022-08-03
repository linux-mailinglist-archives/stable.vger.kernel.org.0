Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDCAF5892E7
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 21:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236240AbiHCTv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 15:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233409AbiHCTvz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 15:51:55 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5E93206C
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 12:51:52 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id f28so9153005pfk.1
        for <stable@vger.kernel.org>; Wed, 03 Aug 2022 12:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rYsXC0td3K8VXXiG32Qi6cpUSG2e/Un8y6y0/v454E4=;
        b=ob/NyoqHOSDaeiY3NhcbrgPvGd2NvTyhkja4gD6fl1AZ/i1gS5NZMr9AQJnmfte62E
         8HF3KRdqbUI4RD41yIyrm68wpTkLhIXgRSh4l/G+EJbd8C05yVbNHhLcb2L9M7tXn/S0
         iaI0M3vfh2iLyOmxN0EBoTRZoak2vYjcY5NwYYD0UjMAMg8C7L5g6UO59/RHASu2+MS0
         RrtgNP+e1mtHDR0hOAiMnFus0/RMXHE3OERUt2KWJ7zVlQ5TH/YDdE8KSnpj3lzXuujR
         Ki3VGGsBD+F1od/ziQGI/6gOqtFfMsqzebHBunQ55EDLfBcr1iDsoK4C6UnI8esea/07
         j84A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rYsXC0td3K8VXXiG32Qi6cpUSG2e/Un8y6y0/v454E4=;
        b=o44+jB8ytXV1PT1HRkpX7MC+Uc2X+VJRdzs2UEFBfa73em5GM2S0mGemnb84zOyw1z
         HaRpPP6Modm/YOlm+uhm6BRhBH3YOijM9vMHMChsHLgtthdpKKcti0PB3XHhE/IzTV+2
         JN4ENC2xRtQIenEM1ZQ9UOdULDBNyotIqS/jracHiF6tQkohV700aI+5ykIX9r9dAdHX
         sk0mG0phPRw6kBA3lm8x81bHBtGhXei2G3QC3eehP0Osw9sxsNqtnZE8Pd1n46pt0CZG
         d6kMMqdXJoAs5ZixOBRONutGKyb7gWHdD6mismFGsDiJBfzvSH0n7gAuia1Bms3tR43r
         k8YA==
X-Gm-Message-State: ACgBeo3NEVVeIBubA32IHjPA+sHQcLJIh/zS2ZaXhr8DCBoAScVTGJRB
        4Jse5KiX+ciV/5OBVwZFZUS5RlDvrfC3BU5ViQ0=
X-Google-Smtp-Source: AA6agR4jLA+f3JwRFgU1osjofDi4WQUvY4k4qbRfbzx8grDsa/Pr6+mSw2jv4DEy+/wkzc+sQYSdUA==
X-Received: by 2002:a63:8049:0:b0:41b:e8db:d916 with SMTP id j70-20020a638049000000b0041be8dbd916mr14781400pgd.40.1659556311805;
        Wed, 03 Aug 2022 12:51:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cp6-20020a170902e78600b0015e8d4eb1dbsm2334284plb.37.2022.08.03.12.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 12:51:51 -0700 (PDT)
Message-ID: <62ead1d7.170a0220.f8248.4096@mx.google.com>
Date:   Wed, 03 Aug 2022 12:51:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.135-10-g65f4e573176ad
Subject: stable-rc/queue/5.10 baseline: 124 runs,
 5 regressions (v5.10.135-10-g65f4e573176ad)
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

stable-rc/queue/5.10 baseline: 124 runs, 5 regressions (v5.10.135-10-g65f4e=
573176ad)

Regressions Summary
-------------------

platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =

sun50i-a64-bananapi-m64    | arm64 | lab-clabbe  | gcc-10   | defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.135-10-g65f4e573176ad/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.135-10-g65f4e573176ad
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      65f4e573176ade79be60010d10f562500e6677b4 =



Test Regressions
---------------- =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/62ea9adafae232e57adaf065

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-10-g65f4e573176ad/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-10-g65f4e573176ad/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ea9adafae232e57adaf=
066
        failing since 85 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/62ea9aeff3a9092466daf058

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-10-g65f4e573176ad/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-10-g65f4e573176ad/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ea9aeff3a9092466daf=
059
        failing since 85 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/62ea9aee04c55d2349daf07b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-10-g65f4e573176ad/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-10-g65f4e573176ad/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ea9aee04c55d2349daf=
07c
        failing since 85 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/62ea9adb04c55d2349daf069

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-10-g65f4e573176ad/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-10-g65f4e573176ad/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ea9adb04c55d2349daf=
06a
        failing since 85 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
sun50i-a64-bananapi-m64    | arm64 | lab-clabbe  | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/62ea9af27657876077daf059

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-10-g65f4e573176ad/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-10-g65f4e573176ad/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ea9af27657876077daf=
05a
        new failure (last pass: v5.10.134-65-g75999114eee65) =

 =20
