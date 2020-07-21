Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7BD227369
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 02:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbgGUAEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 20:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbgGUAEA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 20:04:00 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5705C061794
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 17:03:57 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id m16so9444806pls.5
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 17:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2l9PC30oJ+liHfq4BX2zvA9yParBkKs0JelfEO/xTpg=;
        b=Y9nfdhfrPOMJklR8fUlUl0JQS9/nXL8SKIKoZLwyPe517MQRhX4sr4067MCGjuainJ
         bFPhim0ghR4jfs8mk2FltMGM8YSH+w/zQ4QF7MBANi6Yk26kirxsPmz/pl7NFVbIfZqt
         w0SRrWAp04q8ySR1geVrdJIJsk4pvDI7eAY/iXmMqgDRLMM1RER77S2vFTmrqm/uxHzu
         m+ehQKr4yD8ApkoewC8k4pFVTyKztLJaeoq9SZNnc1iBTFMfmIt+vGVR6YHbbeu2u10d
         4wKA4OcVKqy+SnD5y7FR6fzOHLwSKBpwIX3WAzH8ulwJDK8p2LAVbZzQl5DruPIO05cO
         R2Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2l9PC30oJ+liHfq4BX2zvA9yParBkKs0JelfEO/xTpg=;
        b=DuDLiLCHd6DSxziu+GnNq7WLwT1Jt9zR1qObocXGc6JxUyYlGfHdcuKlg4ZnmVwVbK
         ZHB6ORMjSe2xv4R/y12EvyQblo5rXTmvJM1XflHq7ji2LOv7oD0wgFyxT11wbl4w3UCV
         ILJt4txmRgnroqbBT8C005iPuLMkzrGN7LpMRZxpnt4ckpcAgCgWiE4hDABkcjbNS0AS
         qFFHKFnFhrFKOKCPhk4oVN9nmj/WwhwsdDNfADT1yHeDCDmWN4yq+y83ZT5rxtRmi6NI
         2u8Rx4sEldmgArieOIrdEdwhuv0mIBSHrR8ZY4G5b3lpbqkXZoW+v5oyX8E1XyCAtXLZ
         uxNg==
X-Gm-Message-State: AOAM533l2bo78iNaF3YCrn0Ti6q4Fu9b6s3PjMidfKGGZ/SieLs28Z1q
        XL5IfGypXFR7+W91XGKMz+hRWpnzPZg=
X-Google-Smtp-Source: ABdhPJzzrSWvzCbtsh9mWDpdLNwJ7ndKw9NPhAm/zGtXb2E1KtCeKm+1S4XqSrUQUQw9MXJUQO3gZQ==
X-Received: by 2002:a17:90a:6509:: with SMTP id i9mr1883987pjj.104.1595289836832;
        Mon, 20 Jul 2020 17:03:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n9sm692531pjo.53.2020.07.20.17.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 17:03:55 -0700 (PDT)
Message-ID: <5f1630eb.1c69fb81.50619.33ad@mx.google.com>
Date:   Mon, 20 Jul 2020 17:03:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.230-59-gecea46f88646
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 46 runs,
 2 regressions (v4.4.230-59-gecea46f88646)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 46 runs, 2 regressions (v4.4.230-59-gecea46=
f88646)

Regressions Summary
-------------------

platform        | arch | lab          | compiler | defconfig           | re=
sults
----------------+------+--------------+----------+---------------------+---=
-----
omap3-beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 2/=
5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.230-59-gecea46f88646/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.230-59-gecea46f88646
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ecea46f8864653c4a4fa6c4f0b690500ba217149 =



Test Regressions
---------------- =



platform        | arch | lab          | compiler | defconfig           | re=
sults
----------------+------+--------------+----------+---------------------+---=
-----
omap3-beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 2/=
5    =


  Details:     https://kernelci.org/test/plan/id/5f15f7dfe312b8bd5b85bb30

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.230=
-59-gecea46f88646/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-omap3=
-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.230=
-59-gecea46f88646/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-omap3=
-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f15f7dfe312b8bd=
5b85bb33
      failing since 0 day (last pass: v4.4.230, first fail: v4.4.230-59-g9c=
d3125d70c0)
      1 lines* baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f15=
f7dfe312b8bd5b85bb35
      failing since 0 day (last pass: v4.4.230, first fail: v4.4.230-59-g9c=
d3125d70c0)
      28 lines =20
