Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81C0297D56
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 18:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762150AbgJXQVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 12:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762146AbgJXQVP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 12:21:15 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E4FC0613CE
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 09:21:15 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id w65so793191pfd.3
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 09:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jH4xoc0DV/PWcchD5hqdfCUIJ88riKXWJWAa8AfqDQg=;
        b=Mmyahq48BHZ0ZKkTqLPyclH3lnhOGQMPRpVqhTNflNNcLdXpbtNJ9DLHfu8/XIuJw2
         luHsNoLT3gJbUccZePanCt7QPSffF4z2/PstNvs92mVfGYXSFFDXAzMM02DvpDDSgnL0
         7m7cFIvyjjxwpOC6Gty8xuNNokSPeE7FlWIxcV6LFTlvTPrOBDv+ylvtwns7OHCSnKvm
         7EH79Ow8iSptI9rD5ZCMF+zkfdvcSyH05KPAXJC6zP0E6k+z2nL+W7Pm6jjkImc8na2t
         APdco78B8NlJE6VYYvvaSSeBuzijYjG7P0uB2UYq8EMd2AS78ovregWbdESiwJXpN8UI
         +Xdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jH4xoc0DV/PWcchD5hqdfCUIJ88riKXWJWAa8AfqDQg=;
        b=FIeeQdZ1RdCEVlAPQEwPv4M4h2YtGQK/Q/QXaz4xzarGiebuO/zhNCNiuocZ90ClJm
         1tPVRSebyDNeolqgWRkgLIfgI7je0aaRO1+nFOewLnj+9HUF2NkLlPPcxqm/lrhZP3uH
         byNCCnkx0+7fJs+Zj9vJf7WrD4wuyUJ5sgudmToxaEZ26jhPneIiXq/GWs9STSj7N7zD
         kBAjZkd19am8uXWoE6WI7u59g/+4qdyBH8kHsNWsHfHv369PculDV/JfNg8l3TreSiIE
         6D5975WWRn7vRo0GEKcJWXWo3ZrjKe7haB55CVJyCgzcdGLPTbyO8j8ypzhPo8bQvWOm
         b4kA==
X-Gm-Message-State: AOAM530Gp+NDn+TokeGAcXu1qovmN+njRrIPDAKXtbIbvTfYPbY76/Ql
        705m0lZUgdFPTLt/GWM/EMm0oMSgrqu6Kw==
X-Google-Smtp-Source: ABdhPJxavJuLl6Nerg6I9S/DOWVtlo3LX7Ml5QiHahT3TLg67ICXcHm4tnG9wSjd0bgyDAoBoEyktg==
X-Received: by 2002:a63:e:: with SMTP id 14mr656833pga.253.1603556474511;
        Sat, 24 Oct 2020 09:21:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v125sm16149pfv.75.2020.10.24.09.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2020 09:21:13 -0700 (PDT)
Message-ID: <5f945479.1c69fb81.367e8.0061@mx.google.com>
Date:   Sat, 24 Oct 2020 09:21:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.72-55-g1cab8730ace6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 193 runs,
 1 regressions (v5.4.72-55-g1cab8730ace6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 193 runs, 1 regressions (v5.4.72-55-g1cab87=
30ace6)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.72-55-g1cab8730ace6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.72-55-g1cab8730ace6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1cab8730ace606ca3247435fd03a23467027dbca =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5f941f070c69f58a8a381020

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.72-=
55-g1cab8730ace6/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.72-=
55-g1cab8730ace6/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f941f070c69f58a=
8a381025
        new failure (last pass: v5.4.72-24-g5d35a1803455)
        1 lines

    2020-10-24 12:31:13.847000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-10-24 12:31:13.847000+00:00  (user:khilman) is already connected
    2020-10-24 12:31:29.112000+00:00  =00
    2020-10-24 12:31:29.112000+00:00  =

    2020-10-24 12:31:29.112000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-10-24 12:31:29.112000+00:00  =

    2020-10-24 12:31:29.112000+00:00  DRAM:  948 MiB
    2020-10-24 12:31:29.128000+00:00  RPI 3 Model B (0xa02082)
    2020-10-24 12:31:29.216000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-10-24 12:31:29.248000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (375 line(s) more)  =

 =20
