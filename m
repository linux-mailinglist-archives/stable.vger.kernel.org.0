Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E9844580E
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 18:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbhKDROZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 13:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbhKDROZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 13:14:25 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8495C061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 10:11:46 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id k2so6448024pff.11
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 10:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HTV3q7TdqnuheBXyEou7wY1Se9V/J2Xvqu6klg2RbCY=;
        b=ZY2CDsJ669JAXZNy9NjNe0Nc2CQ/1KMlm0M4v7vuDFiM4Io/PssBChgswsPJW8Jv3I
         A9o97xGm5XVXbJM0ANRP7PChIX3HjnmuxoIXxRvEAYi3PY54YxV+02C4tuaa6uQIz8Kj
         PElR+M84pum8+aJ2lHrVQgZIee3tEE021wOce4IA1EG/KKCegV+wJ3RvADt8jOzdDU7n
         9dj5hlPYysO3TQn/Wt5soKGeQustoIhgo2lUm4vo03vvnOE0jXcvqjVRswY9NQNGLv6s
         YUPsNbY2Dy9aW4c3FPJ1Zllix5a2ddJXH77PW8GQeSfla0hStub/wr49/p6plH+15Icq
         PohA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HTV3q7TdqnuheBXyEou7wY1Se9V/J2Xvqu6klg2RbCY=;
        b=MEmBuOyV91MPGzYsKv7N1uk3wfWtsr3dD1NXffVTtPYszcU9xiGfZm/emBZ4X4O9lL
         PxLZ2+BVAIxr8hWSlTfXtOAACfzbQLZ2YvPCDrLXcmphh/vdgcxaIoYzESOytRmYX5V8
         3X0lalJq6Qd7+70OXQJyLG73VBm2b0G9RU7lmSIzcZqdDzdDSSjpIxXhdUHVbuQ9z43O
         9LdWIoX3zipjkJU2D5Nt50F+d5XCzqgig0/8KieE8BfvHmJy9pw1LltJMmsSOR5aAoIH
         8xBNMJxshzUSBKt9GuDL7oX1DT9W1Evw9posgDSbtMjnaPmdZP+6XRFOws3tLDKmWRZj
         rYdw==
X-Gm-Message-State: AOAM532jGbg7CZubL0rHtZi6O84J75PluH8DzuiK4/qpzVYwE1pRfaC9
        G2h8peYvMeFj2XCd+nmCEqDrhfTg8jyeHpzJ
X-Google-Smtp-Source: ABdhPJyrQXfp8ll/XZbqK0rzszR2tVQSdi1r8HrEHxwGgeMUC8OWZ+ExrzFDha4IJ21xu0kaVWcu6g==
X-Received: by 2002:a63:4512:: with SMTP id s18mr33680314pga.388.1636045906248;
        Thu, 04 Nov 2021 10:11:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u2sm5279092pfi.120.2021.11.04.10.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 10:11:45 -0700 (PDT)
Message-ID: <61841451.1c69fb81.571a4.1e70@mx.google.com>
Date:   Thu, 04 Nov 2021 10:11:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.254-5-gc9b4934a4d6a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 146 runs,
 1 regressions (v4.14.254-5-gc9b4934a4d6a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 146 runs, 1 regressions (v4.14.254-5-gc9b493=
4a4d6a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.254-5-gc9b4934a4d6a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.254-5-gc9b4934a4d6a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c9b4934a4d6a85e6903cb85105305e527577562c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6183e36bdf5567ed0e33590b

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-5-gc9b4934a4d6a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-5-gc9b4934a4d6a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6183e36bdf5567e=
d0e33590e
        failing since 0 day (last pass: v4.14.254-2-g86b9ed2d25ed, first fa=
il: v4.14.254-2-g116ed5b2592c)
        2 lines

    2021-11-04T13:42:49.560142  [   20.183227] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-04T13:42:49.601132  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/98
    2021-11-04T13:42:49.610333  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
