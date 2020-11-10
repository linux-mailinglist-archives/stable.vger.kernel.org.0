Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DD52ADE2D
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 19:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgKJSXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 13:23:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbgKJSXi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 13:23:38 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEB8C0613CF
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 10:23:37 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id c66so6467138pfa.4
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 10:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+Ft2BtmZYV4d0NHp3LrmIxSEBPKLjSZwuH4ZSLWQbcI=;
        b=f92vx1ChvgJq/qnvzH+hqlXgpVnUJTTuKDSwacRsmC2GTHQ3juqb4r1kci+OXxtAU0
         rB8zKZhTveFVA9CqADafny7F3Unl6Aaerjb9jko3GM5eDJo6oZTEZJz1FbOD3bKZ1B41
         Potgr/HgJqz3Z9hDuKGtVjSfHXcn9aZmC81C4Bqdjoj01aDGAD6RN8nwrEqGXVYPBTqb
         Ug+ounL58FICtNLFDvTXv2Zm51HEMcXc30cCD1L5DdXdreVlqPSGfvIgCTWbTVKj8wuq
         cMZGY8uM8BpAWWj6AhnbztfKDV90kLNpKtjcti4sJPfz+8ba9tBZojE0a8Vd2kvDwLxF
         ZfEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+Ft2BtmZYV4d0NHp3LrmIxSEBPKLjSZwuH4ZSLWQbcI=;
        b=VwMrxW2exo23dq43h85yRdBgLhnHdl+esykhi7abZmt33SlhFes26qfS9QtjED9jOu
         TJeeDEEtS72XyBhgucMfYAWbEAVSJ5P2V6KaWMwZvzIAC2iIB69MjSd0dUlNy8XTQNgG
         7wRrGlEJk8wXTZiEf/NbiQTDLIm2NOgCZ7kMlleOxN7yA16niOfMM9flWlrJ4hIVEW8P
         xe/E7Apbs6HyCsiidk0FijbW2qGQsPjY8JQBikAZfO2vzes5Cxe0TiPDBnP2aJtVWsc3
         pdw97wv/F3Ii8+dC5rlQ1KYh5W79lmyp77YLZHJ5adeaG81WvKKKO9MjQbQ8JwDzFfsg
         1oNg==
X-Gm-Message-State: AOAM532oIdBP42xaSkf3ZHJGNcXUS6DlW6ErDzsXPZdF/My+5ZUjdQgb
        zCWUd6NKW8m2Qm4Em2oWV0fHrAhVeyReCg==
X-Google-Smtp-Source: ABdhPJzDy8qf9jxxWyNFhN3MoAsMxE/vxSsbektB2mhYjZhFkFkmNZCVTJzMFpD+ZJUqpWsYc6ytXw==
X-Received: by 2002:a63:5963:: with SMTP id j35mr17598452pgm.55.1605032617187;
        Tue, 10 Nov 2020 10:23:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l7sm4452164pja.11.2020.11.10.10.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 10:23:36 -0800 (PST)
Message-ID: <5faadaa8.1c69fb81.bc8a6.aaae@mx.google.com>
Date:   Tue, 10 Nov 2020 10:23:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.75-85-ga124c798ed9a2
Subject: stable-rc/queue/5.4 baseline: 202 runs,
 1 regressions (v5.4.75-85-ga124c798ed9a2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 202 runs, 1 regressions (v5.4.75-85-ga124c798=
ed9a2)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.75-85-ga124c798ed9a2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.75-85-ga124c798ed9a2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a124c798ed9a238e1b363ba704d4ebefb3fe6348 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faaa77caaecc12b82db8872

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-85=
-ga124c798ed9a2/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-85=
-ga124c798ed9a2/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5faaa77caaecc12b=
82db8875
        new failure (last pass: v5.4.75-85-gb7b9e5d4d607)
        1 lines

    2020-11-10 14:43:08.176000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-10 14:43:08.177000+00:00  (user:khilman) is already connected
    2020-11-10 14:43:24.531000+00:00  =00
    2020-11-10 14:43:24.531000+00:00  =

    2020-11-10 14:43:24.531000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-10 14:43:24.532000+00:00  =

    2020-11-10 14:43:24.532000+00:00  DRAM:  948 MiB
    2020-11-10 14:43:24.547000+00:00  RPI 3 Model B (0xa02082)
    2020-11-10 14:43:24.633000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-10 14:43:24.665000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (365 line(s) more)  =

 =20
