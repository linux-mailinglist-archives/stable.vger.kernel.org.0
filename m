Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE0444AEA4
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 14:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbhKINXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 08:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234864AbhKINXk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 08:23:40 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FB1C061764
        for <stable@vger.kernel.org>; Tue,  9 Nov 2021 05:20:53 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id g184so18471213pgc.6
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 05:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=If8SsQt+KBRaIHbdlvNO4uJqKVi+HOEKkwJTTIv00c4=;
        b=pTuVBMSiEGjfbDoNa19wZ2pLGbrume4GnxIBhOeTuTt53F/VYnf2SNs1wzUR0++VBp
         C0WPjqlVuOeSd9BmV3U89jFv/UPl+SomFCjohCFh9jV1qvGFT7dJqCPVmn4w4qAlDNhd
         iBT2u1zXYVGwVyClpSDbFU1qx3koqEvJcfkRsFtV6MdhRcABa7hJ7DIhWOupAgWycbNF
         Qp+EfZStRLzAKWReHJm5aWn67CCz5JUu2Iaq6icLLhkIU0AhIRRM0Tw+IzH4x3fDBOlh
         15yHAhAWysbljXhbqr9UMpTon4iNWuhewzOqeZxvS8dqxobV7yxP2bjLuqO4M+WSCr86
         wShQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=If8SsQt+KBRaIHbdlvNO4uJqKVi+HOEKkwJTTIv00c4=;
        b=SFX9LMkXRgfkyac/09hmmSZZM/UkVpzeQqNV9angkUXw//ysnf7EiAbxEUqX6BTbF4
         pwAaCpgiMnqYP9xAVj9M5iOab68VuZjsQTZXmxXpQepUWXl1WKxaDfQOiG59AePyHDGO
         F1lsHF6jEnQTVrQdpCigWmwXJhWiRewN6uY6lXGr+UNn6xzQ7qNpJ07c+fey2U4A8OiF
         hEAnKgIPQMifZkYgsKOPsBpkKAQD+7giPWTptzKErb3XIflCOyor3KUuF0cURrd8puPA
         pe1TFQ9Ug4WR3V0BfyakHAlZPt0RvooCtX8/tYQPBWGPa0CHPW8+OczVsTTwPl0qbpcT
         0bjw==
X-Gm-Message-State: AOAM533WnDVMJvAN2vMWdMtQD0c8EVhOQElBuu2trwgz/GmELlmAFqDX
        hf9pqCqnk6OnGpt//IwcEdmJ0ghFt5Rfo9b6
X-Google-Smtp-Source: ABdhPJzzGP+Uns4a0tAdv/bEyMNavmW38DEEoVmkYMyjyDPNywY508Z0GET5dR+Y7MmBkeZqFIlMFA==
X-Received: by 2002:a05:6a00:2181:b0:44c:f4bc:2f74 with SMTP id h1-20020a056a00218100b0044cf4bc2f74mr8082282pfi.68.1636464053264;
        Tue, 09 Nov 2021 05:20:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 8sm2657281pjt.46.2021.11.09.05.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 05:20:53 -0800 (PST)
Message-ID: <618a75b5.1c69fb81.8c4e9.79d7@mx.google.com>
Date:   Tue, 09 Nov 2021 05:20:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.254-12-gd0fa8635586f
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 166 runs,
 1 regressions (v4.14.254-12-gd0fa8635586f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 166 runs, 1 regressions (v4.14.254-12-gd0fa8=
635586f)

Regressions Summary
-------------------

platform | arch   | lab        | compiler | defconfig        | regressions
---------+--------+------------+----------+------------------+------------
d2500cc  | x86_64 | lab-clabbe | gcc-10   | x86_64_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.254-12-gd0fa8635586f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.254-12-gd0fa8635586f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d0fa8635586f6fe4b59f23054cccd1f4cf691a22 =



Test Regressions
---------------- =



platform | arch   | lab        | compiler | defconfig        | regressions
---------+--------+------------+----------+------------------+------------
d2500cc  | x86_64 | lab-clabbe | gcc-10   | x86_64_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/618a3951b3d435ce143358f9

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-12-gd0fa8635586f/x86_64/x86_64_defconfig/gcc-10/lab-clabbe/baseline-d2500c=
c.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-12-gd0fa8635586f/x86_64/x86_64_defconfig/gcc-10/lab-clabbe/baseline-d2500c=
c.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618a3951b3d435c=
e143358fe
        new failure (last pass: v4.14.254-12-g923d11bd34b9)
        1 lines

    2021-11-09T09:03:04.187136  kern  :emerg : do_IRQ: 0.236 No irq handler=
 for vector
    2021-11-09T09:03:04.198843  [   11.213943] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2021-11-09T09:03:04.200390  + set +x   =

 =20
