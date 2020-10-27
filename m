Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881EA29CA95
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 21:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373306AbgJ0Utx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 16:49:53 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:40303 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S373196AbgJ0Utp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 16:49:45 -0400
Received: by mail-pj1-f44.google.com with SMTP id l2so1357546pjt.5
        for <stable@vger.kernel.org>; Tue, 27 Oct 2020 13:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rXBSZe9BJxyt7itfAVrQGV613MNAQ01B9gn7a81ubiY=;
        b=yvDWJZenxfdmgNk1zYMZLPv6zQxFiUedqyylIkdjiThfT+sqXd4swCtZA5ahVmUcwV
         GH/6akgw3hNJwj0CiXSm3t0Uo4yBPPMUNY4QFCAENQlIa/TzDp9vI8RcGVqB6o8hjr4K
         m1vu6aoRlovQPobz/s3LK305fIoRWHNnvpSOeYESzAgDw/5lewg1eVhVHPT3NCmlqZHb
         PPlK/B71EWkSa+rFzzT75E9Wx3U575nYx4RMA0ETnnbNlVsYfyDV0+yZiTYmyXfoqTGz
         t9Qa0Vg5zK7E1opJxy34vAXfWZhGkH+i2wHrKfzSRqV9yGidUJZKL33P7f+Qd77N/3Wg
         eIQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rXBSZe9BJxyt7itfAVrQGV613MNAQ01B9gn7a81ubiY=;
        b=a3HfpieBjs3O33xHBMxUCuz3dSdGxaQ0/ksUsuTVNEY337OQyfD7Xmd64bigaoDZ0m
         tcZcrzcXZVVAF1qnAWPMbvLJVp0HS5ioqX+jd/jnxivEfcNz3ET+RtzVkI1wwt9hYGih
         AMr/8o+KVYGtJ7aHcpK8uGQ+aTXJe7wqnZAjfSVEC9sPJbNpVIF85cJsyuSaiasbjS0z
         jFcHrLo2hr0upJ/G9Ue5gQhsG5FGkvOkvVyWswssV1FcMwVddUOd8YrpoD7pSjtJOwi+
         ogHFKU/zTpDZ0AeUG+WpVOQP96NLghr0y8+c5ouzdk+LwjZ5ZnrKUk9QBLxImqhIv609
         Ncdg==
X-Gm-Message-State: AOAM533jdQNLecYoSMaVWxRhgeKq2diZlhsecLEWFz081BymLFQu3hiF
        oGLv/MYVRY6j8spQEYjS4XuW7L6MsgV2Jg==
X-Google-Smtp-Source: ABdhPJw67Q3kT+WyQcuPxn/LK/eJZHKiRNlvhYfrIdpcdygW+pXC8zjafh409knSMN2Zy308vF4vCA==
X-Received: by 2002:a17:90a:ec13:: with SMTP id l19mr3742366pjy.51.1603831784016;
        Tue, 27 Oct 2020 13:49:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a3sm1444237pfa.126.2020.10.27.13.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 13:49:43 -0700 (PDT)
Message-ID: <5f9887e7.1c69fb81.739db.348e@mx.google.com>
Date:   Tue, 27 Oct 2020 13:49:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.72-409-gbbe9df5e07cf
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 187 runs,
 2 regressions (v5.4.72-409-gbbe9df5e07cf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 187 runs, 2 regressions (v5.4.72-409-gbbe9df5=
e07cf)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig          | 1 =
         =

stm32mp157c-dk2 | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.72-409-gbbe9df5e07cf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.72-409-gbbe9df5e07cf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bbe9df5e07cf0daea84b138805847c86fd8b0fcf =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig          | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5f985388af41f45afc38101c

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
9-gbbe9df5e07cf/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
9-gbbe9df5e07cf/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f985388af41f45a=
fc381021
        failing since 1 day (last pass: v5.4.72-402-g22eb6f319bc6, first fa=
il: v5.4.72-402-ga4d1bb864783)
        2 lines

    2020-10-27 17:03:51.483000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-10-27 17:03:51.483000+00:00  (user:khilman) is already connected
    2020-10-27 17:04:07.140000+00:00  =00
    2020-10-27 17:04:07.141000+00:00  =

    2020-10-27 17:04:07.162000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-10-27 17:04:07.162000+00:00  =

    2020-10-27 17:04:07.163000+00:00  DRAM:  948 MiB
    2020-10-27 17:04:07.178000+00:00  RPI 3 Model B (0xa02082)
    2020-10-27 17:04:07.265000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-10-27 17:04:07.300000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (381 line(s) more)  =

 =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
stm32mp157c-dk2 | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5f9855977c4e9cd034381024

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
9-gbbe9df5e07cf/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
9-gbbe9df5e07cf/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9855977c4e9cd034381=
025
        failing since 1 day (last pass: v5.4.72-54-gc97bc0eb3ef2, first fai=
l: v5.4.72-402-g22eb6f319bc6) =

 =20
