Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1379627B942
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 03:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgI2BV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 21:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgI2BV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 21:21:28 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E69C061755
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 18:21:27 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id b124so2865759pfg.13
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 18:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kU+IYPa248nwqLuqr/mChq9VgslgBW+PHfoqov0NB1o=;
        b=iYpiAM5GHu8nzChTf147rsX40ysKsmeulYvZzAfvhf5D2+HRhrTKlW4z98FnMTYN9o
         gKxrT/hyS7rNQYFJQi92HKPMsx/8jQJRlpgxSkE6eL4SRMr1YAAbR9nWbPQlfYBByC2i
         hxr9IUZBU2EMPR4LHM72mkr2Y3qEWjEVWHvi1krQ69P25rL2GK6OR+YrL2qTqoMv2fdz
         NLY1eLNFo29ICKdZfeB+mATF5DaLNetjwq+xigq3Ek8v4/VNMxg+UtEDES6bYMeZF7UO
         9iwOcirbWY52xjz9T3i3Az1FZpPR5yxswsba6YTgNsmk+3k4bcgD03jMgNLaUY59thV+
         YVzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kU+IYPa248nwqLuqr/mChq9VgslgBW+PHfoqov0NB1o=;
        b=WftJ40YKMtEMZn10UluexqF7tbwb2LKC8B5c4JadY3doqwIpaIsjhMSUxTcI5XIakV
         C8REqK6PLlzKo/QUBFstOGahcxT+oSaVjio/dodFCPmCE7Yp0IXIzlxme7NGCDfjwwOE
         E3RnACKkQZr9THlPzdd/fwF7g18R65ib6AN6gwmMV84GeoO81EJQ9ZjfCnHmolcBmG6E
         FT5QnfG35eG4PoPXIcvaBZmnkxCVK03R4o2+AtYXKtN/gtfiu+RLSBSrE1IbNoaTJzmh
         buQGEnPWOak5xzsqDEZANg4nnV6Do2bYIoBtJyqA76PJH6KfU0TjaarBWcxOuLejZ+B3
         7lVA==
X-Gm-Message-State: AOAM533dMD06P2GaNQk4KN+F/cCVabSqdFy7iTAyG7f0EuyV760UYhXL
        zXZRSSpNGEDia+VQnAxdvSjF/ubkeic9Kg==
X-Google-Smtp-Source: ABdhPJxvpHSq8jg6PXCYyzzFTD4oGZINxojve3Q6drwgj/rwWAgjcX+prY4o3e25ve6RUy2gqUZrOw==
X-Received: by 2002:aa7:9565:0:b029:13e:d13d:a057 with SMTP id x5-20020aa795650000b029013ed13da057mr1770447pfq.29.1601342487008;
        Mon, 28 Sep 2020 18:21:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h10sm2725864pfh.217.2020.09.28.18.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 18:21:26 -0700 (PDT)
Message-ID: <5f728c16.1c69fb81.bad72.611d@mx.google.com>
Date:   Mon, 28 Sep 2020 18:21:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.199-166-g1952e8058e35
Subject: stable-rc/linux-4.14.y baseline: 153 runs,
 3 regressions (v4.14.199-166-g1952e8058e35)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 153 runs, 3 regressions (v4.14.199-166-g19=
52e8058e35)

Regressions Summary
-------------------

platform                   | arch  | lab             | compiler | defconfig=
          | results
---------------------------+-------+-----------------+----------+----------=
----------+--------
at91-sama5d4_xplained      | arm   | lab-baylibre    | gcc-8    | sama5_def=
config    | 0/1    =

imx27-phytec-phycard-s-rdk | arm   | lab-pengutronix | gcc-8    | multi_v5_=
defconfig | 0/1    =

meson-gxbb-p200            | arm64 | lab-baylibre    | gcc-8    | defconfig=
          | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.199-166-g1952e8058e35/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.199-166-g1952e8058e35
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1952e8058e356b4426be9e52987998db5774e38e =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
          | results
---------------------------+-------+-----------------+----------+----------=
----------+--------
at91-sama5d4_xplained      | arm   | lab-baylibre    | gcc-8    | sama5_def=
config    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f7254c46c5f1510dfbf9dba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
99-166-g1952e8058e35/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
99-166-g1952e8058e35/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f7254c46c5f1510dfbf9=
dbb
      failing since 66 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189)  =



platform                   | arch  | lab             | compiler | defconfig=
          | results
---------------------------+-------+-----------------+----------+----------=
----------+--------
imx27-phytec-phycard-s-rdk | arm   | lab-pengutronix | gcc-8    | multi_v5_=
defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f72560c442925b13cbf9de3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
99-166-g1952e8058e35/arm/multi_v5_defconfig/gcc-8/lab-pengutronix/baseline-=
imx27-phytec-phycard-s-rdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
99-166-g1952e8058e35/arm/multi_v5_defconfig/gcc-8/lab-pengutronix/baseline-=
imx27-phytec-phycard-s-rdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f72560c442925b13cbf9=
de4
      new failure (last pass: v4.14.199)  =



platform                   | arch  | lab             | compiler | defconfig=
          | results
---------------------------+-------+-----------------+----------+----------=
----------+--------
meson-gxbb-p200            | arm64 | lab-baylibre    | gcc-8    | defconfig=
          | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f7254f4c5bb5e9614bf9db3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
99-166-g1952e8058e35/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
99-166-g1952e8058e35/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f7254f4c5bb5e9614bf9=
db4
      failing since 181 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =20
