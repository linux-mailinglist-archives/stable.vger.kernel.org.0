Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6AF326B03
	for <lists+stable@lfdr.de>; Sat, 27 Feb 2021 02:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhB0BXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 20:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhB0BXp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 20:23:45 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB2AC061574
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 17:23:04 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id 17so6194466pli.10
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 17:23:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PYqoEBs1cdNBJy/uWbhaaDXjBwVlrzy9Wm4FpbYTfDI=;
        b=aNAiRmBGROsrqLTd9jNDmR5LYZqjJayo6nzdLElit2pLgek1dZxmTUeyyvkUCIFU30
         +O5NGwqTWJSGPm/CoWE8r2uSmOC0+ek2N8j8ZIKcFsuzLJROiIYmX1AVSOvtpM/wAgXi
         n7dhskWSxaS/hJQGzj36mfSArxizd4QVj00Z7stqFZ5CUTSh+4E/3lTavRJ9WgIqSR4x
         O3ZpOZkyyAj7xUoHDapyOe6/FQPzcCSPZV2Wt7tjSC3HnMf6oXD7LaneApQvJDz+x5tQ
         yB2BVAd2EgMERAl6duAEfGjhQfgRhueAn1XncikcYLX31tTvryXY+TbZgQbur+t+vYwW
         c2Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PYqoEBs1cdNBJy/uWbhaaDXjBwVlrzy9Wm4FpbYTfDI=;
        b=TfEZ3pOfjfusU/GY0iDF7RiBhRcnYrJhUbeg+6BdDqPHC65+rxXDoG6ld5v+W4uppd
         u77Ep4KcEo8njBQOU2NzgoOhB2zMuqmEn0e5Na1kLPLWkXJUTSizwOLeFoqAyIoseo+y
         0VYIP8SbrXW1moJzBa5vtYqvXQXC+yIwBbuWpDT9beYopa+9o/mXNQz9/tQ8xr2XCQRh
         fMarhHumI+nVKDpkGt4yBDkPiBekLNZX+oNZwfLGwNytb/dsfvd839O+CteYn8JU4XNH
         XJKrzms7xVnDQT5xnqJ9OVXlk9HYTwqrKZF79wyThnfvsE8jZ34dt7kwkNaoA5mjIa4S
         OxeA==
X-Gm-Message-State: AOAM531qFf/OtPEq+giNPdObNCnQqY0Fnb0wsqgIxCRdBB1GixMImbQl
        MTkLY7phxvJRN2HhQQpkAlYya47BxZ4TgQ==
X-Google-Smtp-Source: ABdhPJxlF3PH8CBUWdVo9jHD7PHBcFAQjT71MVJvAxHISOHapDtfjH7Yzjxzp2K/rbL2wu2wORCpug==
X-Received: by 2002:a17:902:f702:b029:e3:5e25:85bb with SMTP id h2-20020a170902f702b02900e35e2585bbmr5437361plo.56.1614388984084;
        Fri, 26 Feb 2021 17:23:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a24sm10902474pff.18.2021.02.26.17.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 17:23:03 -0800 (PST)
Message-ID: <60399ef7.1c69fb81.cd146.9917@mx.google.com>
Date:   Fri, 26 Feb 2021 17:23:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.222-8-g8e97a31cd1cc3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 63 runs,
 2 regressions (v4.14.222-8-g8e97a31cd1cc3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 63 runs, 2 regressions (v4.14.222-8-g8e97a31=
cd1cc3)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =

meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.222-8-g8e97a31cd1cc3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.222-8-g8e97a31cd1cc3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8e97a31cd1cc3a27a1d733a8ff038bc0bf3ee5c9 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60399939782072f7bbaddcc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-8-g8e97a31cd1cc3/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-8-g8e97a31cd1cc3/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60399939782072f7bbadd=
cc8
        new failure (last pass: v4.14.222-8-g03edb35f0ec4a) =

 =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6039801ea03a30ea2eaddcc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-8-g8e97a31cd1cc3/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-8-g8e97a31cd1cc3/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6039801ea03a30ea2eadd=
cca
        failing since 80 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =20
