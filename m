Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA304475137
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 04:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239538AbhLODFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 22:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239518AbhLODFQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 22:05:16 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFEDC06173E
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 19:05:15 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id d11so10276344pgl.1
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 19:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CKbdxsqOdrsvFkRUFTNfZu4HCUulVdGdMfw0Ui37lk0=;
        b=k6oobvpRQyGzLTOgfWfzBZr7Xce5VpHK8WuqEMtpgc2wVDyn52yvqmVBs1vbCLDJIt
         dHqLsYdL0gsKzWZc3tkAmbg2CsUL2cIqrHXzMsv04aXjTACybDBzjSiNWTYTtJzhIkD4
         xrS4dO2qrTD42853z5Apqpn7v6HcKq13KdeRuCxut3WFgqmz5+V/Y4C01zy+dILuqM66
         ephO2YAsIqEj0bZ2Axd/AMm1fdgHVwqHBOndEoyks8jflUcr+8s0bDVp+LIV5CI2sWXx
         fQGk+yYuCy2yRlMrnCzkFheZOcGQr1bzZpOea+moDlzrdZWFjXNzoSrlVWnXQM6O7F0/
         mjxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CKbdxsqOdrsvFkRUFTNfZu4HCUulVdGdMfw0Ui37lk0=;
        b=1dOITx0RzIC3C9+sX2XVNKp9Iq4D2mhqDXuz/acceLJLGfvGJOiPKz/cCmFUnRmqfc
         GTBkyaDgcLO8hrkLZ0ILBaoU3FjZFZ1KR7fQ2Uv4rkwix63smDH+xBBkZ0cqnV9XsXYE
         L7Q8htDoAzoKP7rYFxvsZB8LHtpTzBjVdYd5onBo1CCSwrc3dWbC9VXBqU/2IVkm3AIo
         PkCXdOY8eaY5gaxmb/4qgLZzHkCR+N9ARWUYLpX0W0rY+vxAG1O40HNqfCWcke3fmvQH
         O0LavwdiKJG83q0RLthJoxt8LaVe+m/hZmxFTARzviSwQPm9m0lRqOwNGPaZJXav0ig6
         2wjg==
X-Gm-Message-State: AOAM530ZYA40yvHzq5CelMSN3Uho4PpZzVNFpsU/D5yhiUtR4wDMJGou
        SDQ7TTwzbn7faXmTjANx35t4Qs/lmDyTS4w6
X-Google-Smtp-Source: ABdhPJx5pzrBOnvWkqtolbHQhEyW3jQBmgV/6GvK6CjCl+DBFqoyuxoo5vZMjCtCfDGpug6y269/Mw==
X-Received: by 2002:a05:6a00:216f:b0:49f:dcb7:2bf2 with SMTP id r15-20020a056a00216f00b0049fdcb72bf2mr7181266pff.19.1639537514892;
        Tue, 14 Dec 2021 19:05:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id pj12sm3703250pjb.51.2021.12.14.19.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 19:05:14 -0800 (PST)
Message-ID: <61b95b6a.1c69fb81.fe3e4.b0cc@mx.google.com>
Date:   Tue, 14 Dec 2021 19:05:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.295
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 93 runs, 2 regressions (v4.4.295)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 93 runs, 2 regressions (v4.4.295)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.295/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.295
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      87ae08ae6ba1f4d6ca8cb134899d87737700be15 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b9220f0bce3666d6397144

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.295=
/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.295=
/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b9220f0bce3666d6397=
145
        failing since 2 days (last pass: v4.4.292-160-g026850c9b4d0, first =
fail: v4.4.294-28-g4af7e373e6fb) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61b9207a499699d88039715e

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.295=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.295=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b9207a499699d=
880397161
        failing since 1 day (last pass: v4.4.294-28-g4af7e373e6fb, first fa=
il: v4.4.294-38-g597c1677683a)
        2 lines

    2021-12-14T22:53:27.347729  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, swapper/0/0
    2021-12-14T22:53:27.357184  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-12-14T22:53:27.372894  [   19.223571] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
