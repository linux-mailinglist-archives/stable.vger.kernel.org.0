Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808F347D865
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 21:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbhLVUxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 15:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhLVUxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 15:53:20 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BFFC061574
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 12:53:20 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id s15so3410297pfk.6
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 12:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4+TFf8mXLPY1L0UTGXYKkIhWrTGMphwM3+fluMvaIRY=;
        b=daZLf+NfxBSZ37EQGwiSx1oCAou0AwMY2ppNTjFHIyXpqdmz1yv22Xk2vx7vmMiRsI
         b5zBoS1X3BpGZppmirEaOCMjTP6WgrHcD8stJHRe7ILSLXFao/Nc3ZZr0A4+klvVSKi8
         ajHwyAMx4CrdbG76IBazHZwnTfGZXks9r18RQYpOwRPGtu5tEUYLSY2GLy+YizAyfoC5
         k5v/tV4bIWlo3LhSx4WEZ2K5WqLWsKqOGPwSxWlUQoh5xtXaNOvIz3eW37hXZxbP0XdE
         SAF2QTtUxgE0/RQcfMMYFYV6vNCnPuJFBxhWG2SgR29N5cc+WrBLaX2cxXZDTPnO8Jl9
         Ab4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4+TFf8mXLPY1L0UTGXYKkIhWrTGMphwM3+fluMvaIRY=;
        b=wlVtO2qPEGmNo8s8mkomtGJZofU4FLN4G/stdkoeVbagkdGqTZp9Dk5fhd053GkZ6+
         yKf540z4ww+yRTeA/YnLsX8H/VOJwDM13vfz5nBLDA6u7HdglBzIGHhUCcg9yFGKGBjI
         ld2Ytv5uhwlS0Ie3+iboxkIOBNq3cm9juyCLUrjgOHjb/5iFrcIZucaHlKnjniLbkDoN
         PR1/6QiyYvcqhdG8AUT8L+Bak8b9WwtCYYpJkXPUW50WtB2/XUxP3I1VJPDdAvFNwF4d
         U7L/qdntUeiKyl+nNb19bN/Xq8kIQuFkuwJ00mCbGdHZYzv8tdK9RV1m7SHLvsJFxr4E
         cLBA==
X-Gm-Message-State: AOAM531gz1hM/v+DkTiDH4LXA+alq4di51OmaIxTpQu28tVEaM34UsZX
        oIBLG8YwlgtprtybXXTQIdpjDhYNhVbu7U/eGZ4=
X-Google-Smtp-Source: ABdhPJw+UVv7HP2S2zocYd+e8hhxpPIoFjf3vo1OwFDQr7YV8fEC+pzde90nzfu3WPW9x6tBcmgKDA==
X-Received: by 2002:aa7:860d:0:b0:4ba:93fc:ca87 with SMTP id p13-20020aa7860d000000b004ba93fcca87mr4610038pfn.6.1640206399621;
        Wed, 22 Dec 2021 12:53:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bg23sm3082548pjb.24.2021.12.22.12.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 12:53:19 -0800 (PST)
Message-ID: <61c3903f.1c69fb81.e1385.8650@mx.google.com>
Date:   Wed, 22 Dec 2021 12:53:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.296
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 111 runs, 1 regressions (v4.4.296)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 111 runs, 1 regressions (v4.4.296)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.296/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.296
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3d70a885819277a1c81c31f200059f35983911d1 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61c35605c3016abe95397127

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.296=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.296=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c35605c3016ab=
e9539712a
        new failure (last pass: v4.4.295)
        2 lines

    2021-12-22T16:44:36.398651  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/117
    2021-12-22T16:44:36.407899  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-12-22T16:44:36.423803  [   19.218566] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
