Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120594A8CF0
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240826AbiBCUG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:06:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242169AbiBCUG5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:06:57 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928A4C061714
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 12:06:57 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id d186so3165136pgc.9
        for <stable@vger.kernel.org>; Thu, 03 Feb 2022 12:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=S3caNq8yiZGGr/FUv9eQxzNs+8trbosRhMQJQbDrNqM=;
        b=V/fok4OCCSeVyp2yb1VIvl9pDArzv9pLNPUt07H7WyDM1cU+uUKfQiEM7Mmn1J9mRe
         kFOnrlUrEGD7l9ua0pN+PAc1z/mDPumOuIRLxiIpOu5m995gCj91jGNHMcuUDmL9YT1Y
         cWNrmhRf+PX3nFw/nVRVdMZtHdyUOjDm1PPWx1xAPPg9Db8lGrDoc+G2/cuJ/UcCON5C
         UFLMlYNlCzuEG+KkQxJ54d5x5lhpAYZhcWThKCYP8AgYwN68/dmDMhscfg10FXy1NGvX
         fausqtELmM315AuGNNwnxaV4o9WjM9v583t2yTiA3IBQtIZQyjzwKgiKDfc0cUp5sMaa
         ZKDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=S3caNq8yiZGGr/FUv9eQxzNs+8trbosRhMQJQbDrNqM=;
        b=EZHSmY19hR7h7mXl6HZwXXb6zQO0I8R+PETm7fKRlVc0FigTAT9wnTPsHYKBAhqNx0
         m5Xc1xDuoM6ONwNjTSJinG/9J4QoV0LJgkv54Ak5vyEGkRtWTsGjkPnNhAjfnngGSA/M
         czi8eDUUYIQj+giriabsCcRhbkl5NKx0dXFRvj/T9SIunuiJAWEeqhv1WNcx7BZxqQQg
         NoVpznmaFlBJR1hBDc/jpq3CDzkB2N6obC895zYv4HJOuMcnyPWilzIXtFzdTyCw8fHK
         NkBnH3IBgoAI8++PZyPef+n/fUMGFay7N+asN8cSfcwsdazLRHvH6uMgMHyavAGdZfsE
         7f8g==
X-Gm-Message-State: AOAM53010k7IIVuWs1gLHb3HK8bxDz0Oo43+bmNyQCFyd28Dv8xtzNUg
        dJen2W4ILGYN74htC20t3GBsBOCheDvuf8Ax
X-Google-Smtp-Source: ABdhPJxo+oukJv92Drcuf0GY80sAUUNYI+0yPp9kam98uoarZmN4hp9tPSRTKZI+25S2n2o2W1oH6w==
X-Received: by 2002:a63:69c8:: with SMTP id e191mr12948208pgc.412.1643918816939;
        Thu, 03 Feb 2022 12:06:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t1sm30042259pfj.115.2022.02.03.12.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 12:06:56 -0800 (PST)
Message-ID: <61fc35e0.1c69fb81.25585.e2db@mx.google.com>
Date:   Thu, 03 Feb 2022 12:06:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.264-37-gb96afa2028a1
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 90 runs,
 1 regressions (v4.14.264-37-gb96afa2028a1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 90 runs, 1 regressions (v4.14.264-37-gb96afa=
2028a1)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.264-37-gb96afa2028a1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.264-37-gb96afa2028a1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b96afa2028a168dc8132d413b0646562dab53287 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61fbfd0830cb3c5fef5d6eea

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-37-gb96afa2028a1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-37-gb96afa2028a1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61fbfd0830cb3c5=
fef5d6ef0
        failing since 2 days (last pass: v4.14.264-38-gda1a5053b8f1b, first=
 fail: v4.14.264-37-g88d20e7b4411)
        2 lines

    2022-02-03T16:04:06.479407  [   20.133880] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-03T16:04:06.524040  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/107
    2022-02-03T16:04:06.533153  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
