Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC5034994F
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 19:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbhCYSPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 14:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbhCYSPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Mar 2021 14:15:43 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15F8C06174A
        for <stable@vger.kernel.org>; Thu, 25 Mar 2021 11:15:43 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id y5so2919389pfn.1
        for <stable@vger.kernel.org>; Thu, 25 Mar 2021 11:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/PF1q8FM4DiJghyvuZ6D7UvSlINpWBqNtn5136NMqzA=;
        b=p/PbUExAO8+FQ1ZdTkcTyF7hh/Gt0xXJ5NPpDdDGHmItdBlI03aUT1DAFbdeOVUdxJ
         lf3XBD/B6tkCfofw40Zac6DiFflhUCciFpflqW9GBd4bxP1ZpOloBrkQgrjltHGcITeF
         zuWhMje19l2YPBl4Cs6SFw+vwil0PClFvLoeQ8c5NwCEy9WP0w1aPqMGzSBdF609nNG/
         d+F4qBKvrhAqcvyGror48+q2LhyU4Xl5PbMHjrD52YOAqzU1ZeQbJVYxiDV5cY4QpdRE
         nKrfzJdH1xQPFTg9i1/uouiHZCXjlltloUOtQZSDaWtPjOLtpVdaXCfadmee3KCLITUP
         BzLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/PF1q8FM4DiJghyvuZ6D7UvSlINpWBqNtn5136NMqzA=;
        b=ubjzxTWaasCuy0olKqycXydT7/w7mVob17f8B+2Oxn5TfZbVGf5ufHJD2eHM+FZnzG
         Aw/kAfylOUZ89Sy9hpdYW9MBJjRrPwAVuW7lxmAcfqjYlaMmG76pt3fzzD9MvbD6Ywaw
         9fJtjXlRaiAEf96+QNZ0kHW7jHvCBuez3fTTxPQVlbkdQjRoqvPnz+ElRC8qhFcQIhPN
         0S3merf7Ou3BMa2o/1luO1mrFW6xuBIz+hufmKkqGkU6g8o8jOJt7z0V7asff9gre69k
         eRERl5E56tmnl+Ye+4SEFZw8CKpZ79RlNBpw8miFxXwpWwvPlSl48HWuVsTa+3WVvwRo
         eyrA==
X-Gm-Message-State: AOAM530GZt3C70Zry4VBzLQ5uPcuXlTaoysI3t31Hq8VtktiolPFPMgr
        dxGhS+7jg4qjiH4qDVSxjVujjNJnVEDd2g==
X-Google-Smtp-Source: ABdhPJyzA8B2WKKRrcb1TG5pbvZfSjmCLqlaU5NAwGL0RFjF48uzZwFsPqKsydzVPCuvXm92ykqbJQ==
X-Received: by 2002:a17:902:ea0e:b029:e4:81d4:ddae with SMTP id s14-20020a170902ea0eb02900e481d4ddaemr11506318plg.12.1616696143067;
        Thu, 25 Mar 2021 11:15:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gb1sm6054879pjb.21.2021.03.25.11.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 11:15:42 -0700 (PDT)
Message-ID: <605cd34e.1c69fb81.714ce.e887@mx.google.com>
Date:   Thu, 25 Mar 2021 11:15:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.26-2-g47ca1b9b720c4
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 144 runs,
 3 regressions (v5.10.26-2-g47ca1b9b720c4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 144 runs, 3 regressions (v5.10.26-2-g47ca1b9=
b720c4)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =

meson-gxbb-p200    | arm64 | lab-baylibre | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.26-2-g47ca1b9b720c4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.26-2-g47ca1b9b720c4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      47ca1b9b720c4f9d660d4b0001cb5a08f9f21885 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/605c9e2b380d601855af02c1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.26-=
2-g47ca1b9b720c4/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.26-=
2-g47ca1b9b720c4/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605c9e2b380d601855af0=
2c2
        new failure (last pass: v5.10.25-150-gd189d68c0ebe2) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/605ca1267224aa53efaf02ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.26-=
2-g47ca1b9b720c4/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.26-=
2-g47ca1b9b720c4/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605ca1267224aa53efaf0=
2af
        new failure (last pass: v5.10.25-150-gd189d68c0ebe2) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
meson-gxbb-p200    | arm64 | lab-baylibre | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/605ca0b1e9b9393222af0314

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.26-=
2-g47ca1b9b720c4/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.26-=
2-g47ca1b9b720c4/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605ca0b1e9b9393222af0=
315
        new failure (last pass: v5.10.25-150-gd189d68c0ebe2) =

 =20
