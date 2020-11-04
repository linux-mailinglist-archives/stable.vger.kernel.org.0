Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB93E2A5D16
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 04:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgKDDXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 22:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728759AbgKDDXs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 22:23:48 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45A9C061A4D
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 19:23:46 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 62so8063948pgg.12
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 19:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mVK2W2ZvcgGKDBedXMEWSpeaRBrgFccbxFY5CX+VQRQ=;
        b=nfCePsSfGViPShr3zxkm2wJun+PSgm5DED9y6RjcunPllF1SciiQjyOrnyMIzwI5DN
         zSxbFMRfEE3CMkmUFVmdq+9j1NkrzJKrfZcvDJzx9Dzhp++cFzMQWNZZzK7tLO6Apg6j
         sDSqzEfeIj3wgOQKGTievmLaGzqT5oEL/7NkNOiV87Fvxo1rjQrMu6qtY1pWLQfIdUcn
         chm3YPKC+mU/1cDqPc6rByJU98QwzHZFl5Ir5tG93KwlLWvcSFqQfbMZZpqGFjgTAXjj
         4pepF0LN1Z3reyvxZxpEsBLj3cdPqlW0czz7dneJeX8KCIt5GKQ1WQvSsIYtTEHsChjS
         WRIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mVK2W2ZvcgGKDBedXMEWSpeaRBrgFccbxFY5CX+VQRQ=;
        b=otWvcBfer8lveQ57ar6AUApMlblVY2BGiP9/j3K0oRJAV2tgs4XnxrQJRxGiqUxtW8
         R3SdncbRICsJbhalgtfLaX0sA9I+xwfFUdxKnZ+/1wF2f/R9Kcv8Iz+cFfu3D/y4GkTz
         +2lSWZLsBhygtMCMCoou3FyWwpM8EfVZkiv9+LDcHFsXM0MI3azKxmbbmpjHQFPagTME
         AwQufvTz0zpFikbREDDk/aL4bqTB4ehGvxwvifIyhdwdfPkc3OzPvF+DIRBXNFw8zxp7
         fGgsf6ReQcudHnF92dBRVwiUCp1XT3AD3PMW+6vnKyRBZxv9PzjTJDWS9aQhNKm5yxav
         J6cA==
X-Gm-Message-State: AOAM533Eyx+pLUqAG/Nv1GGt6CNiVKEo8Sx8xmo+C7JR1zyP3PxCjjzZ
        0bxrPuIyQmOwYYuDbxeq5kBDEV5efWL6dA==
X-Google-Smtp-Source: ABdhPJzTfunroz5OLJUrJxl3uPcsOeiV5TmZFa6eSrlDd59IHRYRfSSI9Zb6GwpmCegI5UIQzh+Mlg==
X-Received: by 2002:a17:90a:c917:: with SMTP id v23mr2263702pjt.235.1604460226062;
        Tue, 03 Nov 2020 19:23:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k7sm524641pfa.184.2020.11.03.19.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 19:23:45 -0800 (PST)
Message-ID: <5fa21ec1.1c69fb81.426e9.2300@mx.google.com>
Date:   Tue, 03 Nov 2020 19:23:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.74-213-g67dd1e38607a
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 192 runs,
 3 regressions (v5.4.74-213-g67dd1e38607a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 192 runs, 3 regressions (v5.4.74-213-g67dd1e3=
8607a)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 1          =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 1          =

stm32mp157c-dk2       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.74-213-g67dd1e38607a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.74-213-g67dd1e38607a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      67dd1e38607a4db0f61a6b6bcc75f9f3da2db945 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa1ec1579b0ea111cfb5338

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-21=
3-g67dd1e38607a/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-21=
3-g67dd1e38607a/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa1ec1579b0ea111cfb5=
339
        failing since 5 days (last pass: v5.4.72-409-gbbe9df5e07cf, first f=
ail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa1eb040deaba28defb535f

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-21=
3-g67dd1e38607a/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-21=
3-g67dd1e38607a/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fa1eb040deaba28=
defb5364
        new failure (last pass: v5.4.74-95-g49cb9af04b0c)
        1 lines

    2020-11-03 23:40:18.057000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-03 23:40:18.058000+00:00  (user:khilman) is already connected
    2020-11-03 23:40:32.808000+00:00  =00
    2020-11-03 23:40:32.808000+00:00  =

    2020-11-03 23:40:32.808000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-03 23:40:32.808000+00:00  =

    2020-11-03 23:40:32.808000+00:00  DRAM:  948 MiB
    2020-11-03 23:40:32.824000+00:00  RPI 3 Model B (0xa02082)
    2020-11-03 23:40:32.912000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-03 23:40:32.943000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (379 line(s) more)  =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
stm32mp157c-dk2       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa1ec33988227f0fafb5332

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-21=
3-g67dd1e38607a/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-21=
3-g67dd1e38607a/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa1ec33988227f0fafb5=
333
        failing since 8 days (last pass: v5.4.72-54-gc97bc0eb3ef2, first fa=
il: v5.4.72-402-g22eb6f319bc6) =

 =20
