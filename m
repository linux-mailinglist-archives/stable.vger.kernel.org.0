Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A14447F72
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 13:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbhKHMYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 07:24:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232912AbhKHMYq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 07:24:46 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF39C061714
        for <stable@vger.kernel.org>; Mon,  8 Nov 2021 04:22:02 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so6454829pjb.1
        for <stable@vger.kernel.org>; Mon, 08 Nov 2021 04:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1WVZcWEyn2QOx5d+5NApITM5NUDdQo0JQ3Y+U4AhbM4=;
        b=8BpC9QJZ+3UCK3F3/ort+uWmxK89qsx+TvL0knTNN3VGxM5Z+sPgZnE4H5vABpJA55
         lStk2/3jNHHbyRc6+6tX1+VtfW5FxB3WGpvT9zSfIo1HyafbobPNQzcWT3DmUIDBqF/j
         pHGaqXsbQAcjM6POuyzVP8RgxH2PJr++esvm9zf1/MStvp1iZKrZDpKtQbmLMjJiOk+U
         0k+MjqEzWwidX7Sxrn9hJg17p7TKNN+KhMTqkyLCR3FORhS7g4XISDnAFTmZeZE6uyGi
         98wQjLeB8KerELOwL8qPzuMcbD5fDbaPQ6vakFrHLdyK9szS7Qo4UkhkGHy1393g8XQ1
         CeQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1WVZcWEyn2QOx5d+5NApITM5NUDdQo0JQ3Y+U4AhbM4=;
        b=FYD5862kEpijpkThd2FjVIyPSShxskk4kfEr94O42snT+bfZFjzTJm49KzPO0EyGP0
         KzgoKbSFDR/spe9jQcGH2N7fAXIqN+Dgly35850FR1rRtXwDghHbwzcEdUaCplXNjoG6
         6ZJqwyhHRlVPLs5PRFoRO7mLIsPRTUp6x3n/zazl8PZMRT37RWZGV8Zr39TLdY69pEoN
         MxpuxrJtHaTj/1CAJe8XWd77AY7F5v7aqyqeeGGj+vONHpLTUovA6fzk/KcTKviQRO2R
         dyQBw8WQ7T18htf5+T5KJfE9C/n91eLP0ogp+ytVdtSrNRmPvQZPHGphMR9REkjlfvNy
         6Z0A==
X-Gm-Message-State: AOAM532oqDrhbcOt81z9A4zwsaeU1bJnAu3XcgKc2b69Zy8ial2zNV3Z
        KrhflQ30dVyuXdtk/sZwg69wCBHq8McOZD8V
X-Google-Smtp-Source: ABdhPJyDVOpdtZrMQwj6PJ1Jb5OrDI/c9uCT3QwaryrRftjsS9BtETiCJ8nbT9BJabN7xc7gxIq6FA==
X-Received: by 2002:a17:90b:38c9:: with SMTP id nn9mr38953261pjb.192.1636374122134;
        Mon, 08 Nov 2021 04:22:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mv22sm13139583pjb.36.2021.11.08.04.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 04:22:01 -0800 (PST)
Message-ID: <61891669.1c69fb81.72e92.7f48@mx.google.com>
Date:   Mon, 08 Nov 2021 04:22:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.291-3-gec781d93e42c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 129 runs,
 1 regressions (v4.4.291-3-gec781d93e42c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 129 runs, 1 regressions (v4.4.291-3-gec781d93=
e42c)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.291-3-gec781d93e42c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.291-3-gec781d93e42c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ec781d93e42ccc20e630a50f0333f7f40b3887c5 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6188db5759f21604b43358dd

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-3=
-gec781d93e42c/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-3=
-gec781d93e42c/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6188db5759f2160=
4b43358e0
        failing since 1 day (last pass: v4.4.291-3-ge1223ca4fb61, first fai=
l: v4.4.291-3-g4b7696b55f5d)
        2 lines

    2021-11-08T08:09:42.670094  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/110
    2021-11-08T08:09:42.679639  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-08T08:09:42.695050  [   19.758819] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
