Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B22C4590C2
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 16:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239864AbhKVPDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 10:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239869AbhKVPDe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 10:03:34 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81C7C061714
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 07:00:27 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso78604pjb.2
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 07:00:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=f1tz57qlajQFvmdjMUvuntghg8HhaaZuW4VTWl6CDf8=;
        b=oelRkUn11v1LOi/1FwJd8/qhsWoOldczlzIqlicYfWsQxrhenhuP8tvD19K7bRhvkg
         fiJvvsUEeVk7erjLD1+LWySo6HIoJk6H7oAhMHJF8pbr/hak12LAjmkRPyah3d7gVzzT
         9G31UI7or1vlCpKxFtjlL/6TmBVjQibEyBmLaYotJsJAKaHITfWsAY4IWUpoIPx+MbxQ
         B5GJ4+HCPXHlc0Mly4UZNbvP1E8l2+vieOsB7eUaIr1zMKxuQKeE3dkmd45fS38XZo8n
         qAxcD4EysdkMoxLbtE1kjsQxb+l331viOZKFryVLT2uaLf0mAFZJC+ab2UJKUCiuLgQS
         /7WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=f1tz57qlajQFvmdjMUvuntghg8HhaaZuW4VTWl6CDf8=;
        b=ZIOY3wqOPgeOAmGkNexh09LvHaf7MqanjWX31iRhq6ue4o7ILSXotNrGaJ3zd29JoA
         XCI4guQZsTSqFCbxYAjc+c6q7D1UgrEEn2YLpCTFtdsvEf7oL8boz2ZMw46Jdnyq/uH/
         mGPf4HR1AMuMOV8FrdXgM/yrzDVZS39T60F2xlzko5ki13sfXxfbfyxXML+i5FPzb2gP
         BIVhZ8DWt4gKCcJqKF6cCCrIhwh/xp7XG0+oId+cfDvJLX04a3zuPy58QY+fzvlQbv3c
         XlbmveeLWJjPH/+QUvJdl9axYDsbFnuHwYtJjIh5fT+WCRiTo2pS9TphMtagpfw1cUP5
         7RHA==
X-Gm-Message-State: AOAM530WOFVSJRm1G0df0EtuBCEKhrx4SdC7oNdDw3+zodFniJvjF5vD
        tc6Z9zMmxQUdMRfl4MA5JI8CuDV4Y+sT8UpB
X-Google-Smtp-Source: ABdhPJwwKDRYhz5+KhqGypTxcWIq6NLyWlJZZrGaFvk5PIgnfqOLdifB+VU6t5k8XDdS8ETLT5wTMA==
X-Received: by 2002:a17:90b:4b0d:: with SMTP id lx13mr32875644pjb.146.1637593227085;
        Mon, 22 Nov 2021 07:00:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j15sm9358874pfh.35.2021.11.22.07.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 07:00:26 -0800 (PST)
Message-ID: <619bb08a.1c69fb81.7cd79.ab22@mx.google.com>
Date:   Mon, 22 Nov 2021 07:00:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.255
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 170 runs, 2 regressions (v4.14.255)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 170 runs, 2 regressions (v4.14.255)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
| 1          =

qemu_x86_64-uefi | x86_64 | lab-broonie   | gcc-10   | x86_64_defconfig    =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.255/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.255
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5f9f3b0057d5c5782985784ba0159b05b4083055 =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/618f9e149171338eb73358dc

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618f9e149171338=
eb73358e0
        failing since 5 days (last pass: v4.14.255, first fail: v4.14.255-5=
4-gb6f4d599e1d3)
        2 lines

    2021-11-22T11:08:46.622119  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/93
    2021-11-22T11:08:46.631839  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-22T11:08:46.646633  [   20.064636] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_x86_64-uefi | x86_64 | lab-broonie   | gcc-10   | x86_64_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/618f9c374b2b8f627b335907

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618f9c374b2b8f627b335=
908
        new failure (last pass: v4.14.255-202-g0d2c672c3819) =

 =20
