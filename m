Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2086A49E814
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 17:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238661AbiA0Qwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 11:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234331AbiA0Qwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 11:52:40 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2075EC061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 08:52:40 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id z5so2969940plg.8
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 08:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yKeE3+xvwQTm24w15gZFC47Fy2CLGKqdBXCBzGadcuY=;
        b=qJzuw2yfetVMmA7kM1/+YA0H1j4TFxOsH+d8ef1b02yzT7/IXB37FfSYlsfBjHq+3P
         O22OVLmn5NsmfF7DxAk5xDIGyeTFd5ZFmgYJ7tKU95WHorBK728LF0WaRjmHJ1boLNYL
         CPI6RZ0Ls9/HI1Jdj+Ic0d4oQJYajwLQpYdytTq7gpyelZKlkMN8wYipQ1vGdnBKKpk/
         S2UV3Sz26wsGAkTzkeeg6XfR7AAJJw5ySFLJVjEq54dASVxQ+3//AWJLFuVqvEgBZNiB
         /YcJuKmhUdiTvmAR02bJS3ZGgOMfruJY5DXOD9m/K5A0Rau0FoU83rnZ/M0x7mVngR7m
         /+FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yKeE3+xvwQTm24w15gZFC47Fy2CLGKqdBXCBzGadcuY=;
        b=00AbqHY/fYw5swypJHbIPcLuhe4+wMfkpG4UBq5fTjp8VGM9RGG4ze6EMh/lgzwDP/
         4oLXNOxFBN2jWIqPFSIMOnhKhQTXWlm+MEq//NQ32/VO2EiiFV6pipJYBePOzXwJqsGb
         pi9+I2n4Pz793hQqW+qiSjvsl1+qrFdi3Lu8YyOQohGwBQ10YnHenGHxPq0AWSXasEn6
         MHT+G6mfawyNBABfTX3zis0obA/CIQ2FcaoxwiiJLeT2WkJsZkWzvBwCOOAWVLFOotjN
         KIlsBqbtty1fAQuHTZ6iSE2aldTOAUAuGbsFwIO9TO0ggvu0LI57tl1WGQSFZo2JclIU
         6jBg==
X-Gm-Message-State: AOAM530+JFlb+dtFl6uWZBcV8TyD+DXbTQVTedLjC3KcFH2SmH14ACVC
        SCbiLwE6x/qwO1N7MlbDfmO/Hcu0xxypLZLjBAY=
X-Google-Smtp-Source: ABdhPJxSexXh7/VrTBkklByft5tzbiCdkTqMurrc98Poap15i/RMIA2sN4f/3ZuXrGxMHPZvh+gx7g==
X-Received: by 2002:a17:902:e5cf:: with SMTP id u15mr3866325plf.76.1643302359171;
        Thu, 27 Jan 2022 08:52:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a4sm3217195pjs.24.2022.01.27.08.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 08:52:38 -0800 (PST)
Message-ID: <61f2cdd6.1c69fb81.3cfde.832a@mx.google.com>
Date:   Thu, 27 Jan 2022 08:52:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.225-237-g9f7b626b7229
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 167 runs,
 1 regressions (v4.19.225-237-g9f7b626b7229)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 167 runs, 1 regressions (v4.19.225-237-g9f7b=
626b7229)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.225-237-g9f7b626b7229/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.225-237-g9f7b626b7229
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9f7b626b722981d16b29e5e6a5526cda666f4a62 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f294c27246760038abbd11

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-237-g9f7b626b7229/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-237-g9f7b626b7229/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f294c27246760=
038abbd17
        failing since 2 days (last pass: v4.19.225-239-g087a7512e40c, first=
 fail: v4.19.225-239-gdd903a45b8a3)
        2 lines

    2022-01-27T12:48:48.652619  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/108
    2022-01-27T12:48:48.661905  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
