Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC8047D87B
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 22:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhLVVCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 16:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbhLVVCQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 16:02:16 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E72C061574
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 13:02:16 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id x1-20020a17090a2b0100b001b103e48cfaso4846686pjc.0
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 13:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wL53niASArKBniCPzBGyUL3ytul4koV/yptyAG26I5M=;
        b=EI11cQRFl9eH0845FKrjmdK3JtOCuMDAktiS247SE5M5DTvD5Lx5xktteJnZO+simb
         /08KZJF2yPrf6RClE6QmGTu+0zi1JPJjs2HRRI9UHvmVITS3ZDUhWF8mNBr5M4w2Hwv2
         hKa9DRz5QNpKE2M76oysvsSMxLDzvTZ6If0UrzFh6wJjCoo2dLm+N/lPf7XI3RJESBJB
         bxegWlY3LD4JkDqj/pXGrMDNd0rs2Q+aLSA8yPq7fvpaaFa8MplsYMIBn0WjGnFDTnxF
         I1QG/KfXjeUsPhEhE2DhYzCQDlGrihhIUVSSRliLS6c3dOKoisHPTg2dfCB+veDxf1G6
         twUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wL53niASArKBniCPzBGyUL3ytul4koV/yptyAG26I5M=;
        b=2FRsX6rThr5sqpCfgRnwfJ58/0Si8V3xWk6VFMWsCELkz40NnbEuciIfDy9LEI6696
         JD0Ef5HOV0KUa8BILYZJdPUtuSuRFdNk7jc3P3pjKEz4VRHEWvL3EnR0x4qyWFA7tcku
         ABnut8HCtTR4bBR9fDwg4riSpc+nd1rTlHTjd8+5c9xNirQXGWrjHv0OvAKiph5CZlId
         OpLcFJN+sy0eglfdLZjVYXye0LXyI45c/BNIzVSdqzkqUm5/y9cXYA6j/nTycvWMLbPe
         ErDvbgzeeQRdTsWg3nHV28eQ0/bSOseeviW7aVnfxAWeHFjcaTWvz+lvOQ/a1nwJV5bV
         /PPA==
X-Gm-Message-State: AOAM530OMPTsmNT3CcBKciERdJWL9mdZhDTHPb4wZsIysE73WbjP9tHk
        hgOoPPVCQdc7W8a6+B8DrPRTsCYO1g/wyRmJDS4=
X-Google-Smtp-Source: ABdhPJyOBjyDt6l6+YgwJ/hfqScqtoDlMxcRhG34sz5sBM3/5L30plBZ2CLs4KrbG/uGPVIBnPdYbQ==
X-Received: by 2002:a17:902:ab43:b0:148:b295:60e3 with SMTP id ij3-20020a170902ab4300b00148b29560e3mr4232368plb.131.1640206935379;
        Wed, 22 Dec 2021 13:02:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 72sm3346778pfu.70.2021.12.22.13.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 13:02:15 -0800 (PST)
Message-ID: <61c39257.1c69fb81.f4d4.9796@mx.google.com>
Date:   Wed, 22 Dec 2021 13:02:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.259-3-g939915040d24
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 120 runs,
 1 regressions (v4.14.259-3-g939915040d24)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 120 runs, 1 regressions (v4.14.259-3-g939915=
040d24)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.259-3-g939915040d24/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.259-3-g939915040d24
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      939915040d24b72dfc41d6f0724be41241ba0792 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61c359c64fcb049eb639712a

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.259=
-3-g939915040d24/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.259=
-3-g939915040d24/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c359c64fcb049=
eb639712d
        new failure (last pass: v4.14.258-44-ge424e12a40b3)
        2 lines

    2021-12-22T17:00:35.120076  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/102
    2021-12-22T17:00:35.128921  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
