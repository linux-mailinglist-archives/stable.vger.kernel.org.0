Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6EB45DF9A
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 18:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349085AbhKYR0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 12:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243108AbhKYRYj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 12:24:39 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43048C0619EF
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 09:13:24 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id 8so6470784pfo.4
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 09:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VNt/l34ff4xEvPH+w+BYI+V33CRKrgOYGlD8o1iStio=;
        b=LFr8hlswUde8zCI8A3aJPuNG8G3GgajkUUF71hy+jS/Plr5ZowcK+JYzndFTAyaFyb
         xu+ZIj9SeRE0J/K85Wr9aXubZSS4v88WHNPKDj1oVeMwxQu0F/yhiJoZ3/oXOQpKmcrA
         AbvPr8rZ6++VO6JRCFSj5JZo8sAnwq6sTKBXkt86Ob2gRRvjN0rC802yyHQ02l/AQpX8
         yzJNgM0Oseacy41tHq4fvWiQl0mhvodOe2/SWP/y/yQneXOkaWlETcoTdund+/wbtYaS
         rEZT7Rksp1thArilL76i6r+aLDNLir3vk+aUsmAA8hHH4c2INRpeZ5BJR3VF/8bQYLg7
         LHhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VNt/l34ff4xEvPH+w+BYI+V33CRKrgOYGlD8o1iStio=;
        b=ZCqwGDhQHQ4fHAGw/L0+5FfAHeF8zPy0LJ4m7JKdLH0Dzoq6X2Sq1xoMKGN9kF8dES
         aTI1oQllK1beliTgaxjDMUfylNZgCfASX0o7IQBgTj0vT1iLkY8oL+mOu+vV7McrVYJE
         k5aPxuhy31M+w/gKAJfRZRmlO47aH207NWGwpV9WeqRwf9UlGGDrTu89tMl4dQ1ci8sk
         hb5VFwHdPtL/I5p/pszCoHRchrQR9OC3mMoIa/pwyOQb60FCaZOU1KsEu4g0l67J8ySE
         37RYP28nY8Y+IT8kuYwuHnLAqdJoddePZQdxSgmBcUzFbzRrqiebaOfc32lY0SfQrIQq
         Xxtg==
X-Gm-Message-State: AOAM532wdWosMN7RyFXufKOmtKigxIkLv9OKuHeuv8sZRp9/6geKCudu
        I2dN/WlQVQZGzRBK/yC1bJb1CES88CiOu4fqBsU=
X-Google-Smtp-Source: ABdhPJzfBY++OG95bvw5II1P2KS5Rtcb++AMAPdylRGPpvl6fxfRlmgRd0GUBMHmMmqjUp+1f35J5Q==
X-Received: by 2002:a05:6a00:acc:b0:44b:ff29:621b with SMTP id c12-20020a056a000acc00b0044bff29621bmr15332071pfl.32.1637860403670;
        Thu, 25 Nov 2021 09:13:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mz7sm8262094pjb.7.2021.11.25.09.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 09:13:23 -0800 (PST)
Message-ID: <619fc433.1c69fb81.8bf34.4737@mx.google.com>
Date:   Thu, 25 Nov 2021 09:13:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.161-100-g2d3a7eb04e890
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 129 runs,
 2 regressions (v5.4.161-100-g2d3a7eb04e890)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 129 runs, 2 regressions (v5.4.161-100-g2d3a7e=
b04e890)

Regressions Summary
-------------------

platform               | arch   | lab     | compiler | defconfig           =
         | regressions
-----------------------+--------+---------+----------+---------------------=
---------+------------
qemu_i386              | i386   | lab-cip | gcc-10   | i386_defconfig      =
         | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-cip | gcc-10   | x86_64_defcon...6-ch=
romebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.161-100-g2d3a7eb04e890/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.161-100-g2d3a7eb04e890
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2d3a7eb04e890380dc5c73a6082c4ab516e924cb =



Test Regressions
---------------- =



platform               | arch   | lab     | compiler | defconfig           =
         | regressions
-----------------------+--------+---------+----------+---------------------=
---------+------------
qemu_i386              | i386   | lab-cip | gcc-10   | i386_defconfig      =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/619f8bc56d06216713f2efb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.161-1=
00-g2d3a7eb04e890/i386/i386_defconfig/gcc-10/lab-cip/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.161-1=
00-g2d3a7eb04e890/i386/i386_defconfig/gcc-10/lab-cip/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619f8bc56d06216713f2e=
fb5
        new failure (last pass: v5.4.161-100-ga259c941e4de) =

 =



platform               | arch   | lab     | compiler | defconfig           =
         | regressions
-----------------------+--------+---------+----------+---------------------=
---------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-cip | gcc-10   | x86_64_defcon...6-ch=
romebook | 1          =


  Details:     https://kernelci.org/test/plan/id/619f8cb3083fb22f59f2efbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.161-1=
00-g2d3a7eb04e890/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-cip/bas=
eline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.161-1=
00-g2d3a7eb04e890/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-cip/bas=
eline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619f8cb3083fb22f59f2e=
fbf
        new failure (last pass: v5.4.161-100-ga259c941e4de) =

 =20
