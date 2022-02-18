Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41BC14BB8B2
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 12:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbiBRLvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 06:51:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbiBRLvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 06:51:37 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8108C1B0601
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 03:51:20 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id q11-20020a17090a304b00b001b94d25eaecso8274456pjl.4
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 03:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Suz0vuxqg9HWZzCljLQMjGf32Pw8Jd7Ik354FZ3klZU=;
        b=KF93zgFTS70wLdliKfidVNm02wEXBZs+5WeYr9Mwo57Wa9yBw8EfetvRYPMQ00f4q6
         YKb2m0CqWswAyM8KalKCKSjmVMLIfGZ3NWUquh3Wortjr4J2fUE+u+1QbesC2H3dsTuj
         sDNkkqmoC3YaIZYlkKYzt4mU5MrZ3iatCN0RQ9Fz1CfamXw+wMroYOjnIGxYNtNvaY8Z
         IAMEZDkioXuqWFAdmrsUipE7lY4up5PSqdqSKcosFiCeKn3AYX5owJpw1xxVnaTckN/d
         aqLcbKNWaKuwWdIR6GFVJbBZFWz0qUV5QgL1J1hLyQ3GH4RINX7eM10yjw2oth/7jQMI
         mYUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Suz0vuxqg9HWZzCljLQMjGf32Pw8Jd7Ik354FZ3klZU=;
        b=RC+dQeCxFREj1sIrZn0wb/rBOL1IRTxxMVb/PhUGFNZhCZdldzV7DaT3oDTpRdf/Xa
         aQ3ccFRb3dC0LMLrVUADWCgchz6u8ilv+Kk8JD+eQ1EnGwuajC1OdsNRNA092pi9AF52
         TLq6CHTrpqw/R4557WS8xsh570MQNic4jiiwLeLLBaiMz2107FOEmNw8KH0x4SNhxkCW
         t4LLacSrCOyud69kuasLiV/u4ZawuVCFTfhCMJvZH8zSjDFXhb2ku/v77z4JWux/Nzlr
         hNnnFgmfReCmiR2gvuyy6QG5YtBWm88VK9vtS6I0U59uiZFM9wVyITRC6VWHrdfuFDio
         Mxcg==
X-Gm-Message-State: AOAM5307YtSG514hhL0YHY+KTZDRwwP/wmSRVzUeIhw+dBTamKlWkqUh
        a8aPvSqU14N5OwJdvTibSNiyJbEJf2E2dIeL
X-Google-Smtp-Source: ABdhPJxywdNmtNma2V9pTYwfFnZmjrO1LpitsP+1jFNnYJSuNWhMosBgyrFVgU+g70Exi5zcHgJUcw==
X-Received: by 2002:a17:902:db05:b0:14d:2df1:2610 with SMTP id m5-20020a170902db0500b0014d2df12610mr7252609plx.73.1645185079818;
        Fri, 18 Feb 2022 03:51:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z9sm10753554pgz.32.2022.02.18.03.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 03:51:19 -0800 (PST)
Message-ID: <620f8837.1c69fb81.aabc0.c5da@mx.google.com>
Date:   Fri, 18 Feb 2022 03:51:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.180-22-g3a1703cdfe49
Subject: stable-rc/queue/5.4 baseline: 86 runs,
 8 regressions (v5.4.180-22-g3a1703cdfe49)
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

stable-rc/queue/5.4 baseline: 86 runs, 8 regressions (v5.4.180-22-g3a1703cd=
fe49)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.180-22-g3a1703cdfe49/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.180-22-g3a1703cdfe49
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3a1703cdfe4956422f7c3a53d64cbfa14329d033 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620f50913327f1586cc6296a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-2=
2-g3a1703cdfe49/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-2=
2-g3a1703cdfe49/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620f50913327f1586cc62=
96b
        failing since 9 days (last pass: v5.4.177-44-g60a800bc1417, first f=
ail: v5.4.177-44-gd87bb386a4e2) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620f50a1f7f38c0897c62976

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-2=
2-g3a1703cdfe49/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-2=
2-g3a1703cdfe49/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620f50a1f7f38c0897c62=
977
        failing since 9 days (last pass: v5.4.177-44-g60a800bc1417, first f=
ail: v5.4.177-44-gd87bb386a4e2) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620f508e5fe5ffc78bc6296f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-2=
2-g3a1703cdfe49/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-2=
2-g3a1703cdfe49/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620f508e5fe5ffc78bc62=
970
        failing since 9 days (last pass: v5.4.177-44-g60a800bc1417, first f=
ail: v5.4.177-44-gd87bb386a4e2) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620f509e09e2d2a480c6296c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-2=
2-g3a1703cdfe49/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-2=
2-g3a1703cdfe49/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620f509e09e2d2a480c62=
96d
        failing since 9 days (last pass: v5.4.177-44-g60a800bc1417, first f=
ail: v5.4.177-44-gd87bb386a4e2) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620f5090b77eeaf523c62969

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-2=
2-g3a1703cdfe49/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-2=
2-g3a1703cdfe49/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620f5090b77eeaf523c62=
96a
        failing since 9 days (last pass: v5.4.177-44-g60a800bc1417, first f=
ail: v5.4.177-44-gd87bb386a4e2) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620f50a009e2d2a480c62972

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-2=
2-g3a1703cdfe49/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-2=
2-g3a1703cdfe49/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620f50a009e2d2a480c62=
973
        failing since 9 days (last pass: v5.4.177-44-g60a800bc1417, first f=
ail: v5.4.177-44-gd87bb386a4e2) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620f508f0c1d802c65c62969

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-2=
2-g3a1703cdfe49/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-2=
2-g3a1703cdfe49/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620f508f0c1d802c65c62=
96a
        failing since 9 days (last pass: v5.4.177-44-g60a800bc1417, first f=
ail: v5.4.177-44-gd87bb386a4e2) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620f509f3327f1586cc62975

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-2=
2-g3a1703cdfe49/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-2=
2-g3a1703cdfe49/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620f509f3327f1586cc62=
976
        failing since 9 days (last pass: v5.4.177-44-g60a800bc1417, first f=
ail: v5.4.177-44-gd87bb386a4e2) =

 =20
