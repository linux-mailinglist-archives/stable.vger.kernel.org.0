Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB3C4E7D2A
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 01:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbiCYTpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 15:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbiCYTot (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 15:44:49 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF90736BA24
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 12:16:08 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id b130so5755618pga.13
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 12:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jk6bGCyF4GVW68w/s7A7kNI0INbKOYaxFz1jSLv6xVs=;
        b=2/BU4GjDCbaATUEn7kou3aBFkLbKgGuavx5M+C3712DGHZjsbPWKyBlujvGwzVA28q
         SjNC1QR+AUganS06rVvSuWYshNwzx0LWOKPqUiCT5wPmpBlH9wghB7pY+p5tvqws1w43
         HBiBEigboxTELKvyC5PfeNc75I9oJzoe9xBgAu0mgKe/syU56urEbJ85z+uKHvkuq1eZ
         cm6SjX+mmDp79v1aSLOGHnI2hEEh/WD+4oGwXPAfKLvZkWpSAC161lIZtwnIo7zHEEVD
         R1KTSyZAMhCvt+21bkSBF8fNF87B0l/4jzFlT4npfd4isiuaKKFBiWP+nhKbVIDXBHT3
         TA6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jk6bGCyF4GVW68w/s7A7kNI0INbKOYaxFz1jSLv6xVs=;
        b=rVlJgInaU6pxQhsDX+7Nj5uv5G69lKN+AduZFE3v1AZI/Ovrj3zCFzTR9HWGl5KHEE
         t1hbwzU4UNw1JK8YuqikfWhN7QzsXRgeqP+ykUry92paJrVUW9sET6/5EoBJfWMJ3PNv
         0/x8LUNePImbIonlZevh43k/w3lp3lPDczPYkwdTwWr43pe5Yl7GcmHsSR9e0Xy016JU
         Su9wNZdXoCTWwfPCLxwZL4tuBbBNIQomJjTu6aeQk17RNMj1eujJsNPO4J8poihm7WX7
         xRaNf/NzjhN4g49AZhk3ilEzytoGhA+XOmTNAyYikhqIzr5gSIleVlk/oo0SCBEJXiTm
         DOjg==
X-Gm-Message-State: AOAM531PxtSVTxZIEnR0Bj2VMLFVwNxX30+QsyiMDAomZX4XNL0xa+Dl
        FxlWOfEA1HYdYbM6gbWO9oMfiqqID1SM00POg9E=
X-Google-Smtp-Source: ABdhPJyvG/x26tPlHUpaC9DtcFOO6GgHxlntgGrkh77pdhqBC0S8p+B6YhkHVeullJ4ZWQsay/EyOA==
X-Received: by 2002:a05:6a00:15cb:b0:4fb:266f:b187 with SMTP id o11-20020a056a0015cb00b004fb266fb187mr1200862pfu.28.1648232323047;
        Fri, 25 Mar 2022 11:18:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h12-20020a056a00230c00b004faf2563bcasm6524722pfh.114.2022.03.25.11.18.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 11:18:42 -0700 (PDT)
Message-ID: <623e0782.1c69fb81.2ba93.0cc4@mx.google.com>
Date:   Fri, 25 Mar 2022 11:18:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.187-28-g12df16ea8f0b
Subject: stable-rc/queue/5.4 baseline: 63 runs,
 2 regressions (v5.4.187-28-g12df16ea8f0b)
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

stable-rc/queue/5.4 baseline: 63 runs, 2 regressions (v5.4.187-28-g12df16ea=
8f0b)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.187-28-g12df16ea8f0b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.187-28-g12df16ea8f0b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      12df16ea8f0b0bc245b2028232e2d9e68a234f60 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/623dd85dc164037cf6772504

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.187-2=
8-g12df16ea8f0b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.187-2=
8-g12df16ea8f0b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/623dd85dc164037cf6772=
505
        failing since 99 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/623dd886f8531bd72e772518

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.187-2=
8-g12df16ea8f0b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.187-2=
8-g12df16ea8f0b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/623dd886f8531bd72e772=
519
        failing since 99 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
