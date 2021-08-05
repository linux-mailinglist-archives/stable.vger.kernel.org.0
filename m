Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21EE3E12A1
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 12:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240091AbhHEK1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 06:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239963AbhHEK1Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 06:27:16 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796F9C061765
        for <stable@vger.kernel.org>; Thu,  5 Aug 2021 03:27:02 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id dw2-20020a17090b0942b0290177cb475142so13614801pjb.2
        for <stable@vger.kernel.org>; Thu, 05 Aug 2021 03:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JludiCXgZ9xa4hV0jCqyma/H6ra3XMe+R/e7w4MbI4g=;
        b=Aj6CdJeTk9Wu3W3p/99dczbi1NO8UCDGSeCc008dlJX7rqoukA2YM1EQXMb1HrdEy6
         Sz681knndB5+Suq+72ZnXQiJX/eRv9lEZE/aGPL/BL1amIokVe1ZigfGbDpBQNpBlRKb
         mHu2j4M2Bqt8+eziICjUQv00XGZh0hP9xZdPB8zes7HgnEnuWGag8M83Nm35dNndmQ8S
         dJ4PK2P9UJKblCt5destG85zy5GavxRqZfUCxPbtrvd5OfHfeEZQkpifMlL1SkmqS+TN
         ZJFPilaxGpgqj7TYkZYiOTZOzUlTx35nDZK/wZWOV+R/6E/RFqtaQMo6OBt3Yab/+i6g
         axqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JludiCXgZ9xa4hV0jCqyma/H6ra3XMe+R/e7w4MbI4g=;
        b=Pe2yS7mj9R4uZFLJ8k2SREW073Ns/5Dr37f7LCXyHt38p7FRUbG7s3gbvB9ul2PEIU
         7FustHqKl3JMODJkU8QGYS75RG6IaE3rzMwq47FFbQ9ChrWUqWFt0uI4bT5hLGE3o2bg
         7QpkjQweeXht8rJj4FIZJJ7Cr59NYOoT1BvTxmHG1bwR26Flx2oLlYzUK7S/75Chz2MJ
         2eRo2HXkVUlhGbZV0gAtWZbbhEpyIpVLt6L7QP/hdCvLpskPfJubnfFK5VUUjU2cim9C
         r9ilh7c2RNZuubrEIYGpazBn5MXj0D4ZixOzu2CIIAQVLK3JvPT0bWXzKiE2oQNJx3vL
         ccEA==
X-Gm-Message-State: AOAM533TeYJNhwXfqRoSUA8XPe2Z4Pi6vP49CfSPEOh7uSc3oOt6zfjD
        g+HTSrFE/3kfAnGfSQAJTiWZ6Cbw+whzP6xvkDU=
X-Google-Smtp-Source: ABdhPJxBH8gXOXCipaIGUmKLtedjw5/kLzzoW4tOUqO1rZePKSvKZauw4/FYcZ5R+0Jk11ZxoqTDKg==
X-Received: by 2002:a17:90b:4b50:: with SMTP id mi16mr14802899pjb.55.1628159221340;
        Thu, 05 Aug 2021 03:27:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ci23sm5377264pjb.47.2021.08.05.03.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 03:27:01 -0700 (PDT)
Message-ID: <610bbcf5.1c69fb81.7051.009d@mx.google.com>
Date:   Thu, 05 Aug 2021 03:27:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.56-19-g64ac3b65bc37
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 121 runs,
 2 regressions (v5.10.56-19-g64ac3b65bc37)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 121 runs, 2 regressions (v5.10.56-19-g64ac3b=
65bc37)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig          | =
regressions
-------------------+------+--------------+----------+--------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig  | =
1          =

imx6sll-evk        | arm  | lab-nxp      | gcc-8    | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.56-19-g64ac3b65bc37/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.56-19-g64ac3b65bc37
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      64ac3b65bc37a71f5abefbcd1091bd29be1dce72 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig          | =
regressions
-------------------+------+--------------+----------+--------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig  | =
1          =


  Details:     https://kernelci.org/test/plan/id/610b86bc7177b9fbfab13670

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.56-=
19-g64ac3b65bc37/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.56-=
19-g64ac3b65bc37/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b86bc7177b9fbfab13=
671
        new failure (last pass: v5.10.56-4-g7057d5a05593) =

 =



platform           | arch | lab          | compiler | defconfig          | =
regressions
-------------------+------+--------------+----------+--------------------+-=
-----------
imx6sll-evk        | arm  | lab-nxp      | gcc-8    | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/610b8dd61aa17f25f1b13671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.56-=
19-g64ac3b65bc37/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sll-evk.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.56-=
19-g64ac3b65bc37/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sll-evk.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b8dd61aa17f25f1b13=
672
        new failure (last pass: v5.10.56-4-g7057d5a05593) =

 =20
