Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41CB9285E41
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 13:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgJGLfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 07:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgJGLfa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 07:35:30 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5F4C061755
        for <stable@vger.kernel.org>; Wed,  7 Oct 2020 04:35:30 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id s19so859714plp.3
        for <stable@vger.kernel.org>; Wed, 07 Oct 2020 04:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xiSWh6o0JVFbRT4dr1e74gtH+t9pXG0Y62mRnuMJ8uQ=;
        b=yoDbu+yNKx9Hb/gwrEfQMrS16Sc28clpJpCbyo6iAoM2YZeTOQAf/QyDou36/ALBgA
         6KKQXRLRGSawWTVQUUY6n20lIclvzKo5sUxcpiv7GCPr5l/ZDyCEJZODxQjPNq65zXuL
         koWdRgsUSYvfaiCroUnStE7O07N0WTUAeHhGRffDZbG4a4PuFk+Y/8fU7/l5SAHDwKaX
         lOEuZkJXqjOWiAnpkFy0CCOTFekbymQMgzeJDxMv39Y4MU5Aoc8U7TnQlMSCz6QA23J+
         6kHHlMZRZ8qMuHr7bO6EhkNvXUzIWuIkLGLTBXINtSayOUUrVdB6He/4aMXTNlz/R+SZ
         PHdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xiSWh6o0JVFbRT4dr1e74gtH+t9pXG0Y62mRnuMJ8uQ=;
        b=gw38WrUu5Pr14jpGZS7tMBie5Wh2KcIBXwjdRAe4ROe0n3laXYgec6/pF2C7GYIURQ
         Q/pgjdvSQxbGAeP2OpfKpcG2HsxfTuBB0eUsdy1vxqb5MUKK43b0R2X6iCGetb6J04jw
         eJNqel0CSeFxsC3ZyzaAtaNTUrzAeCCDXJ/ytnxiTXcSEQLhi3mYB8Pn5r3RoaHq5H3T
         UUJ17UqugrXk2jb0uc9HEHhdMELhT9c53C2nJbyrdnRcAmuDYeSybtVnV47F9z7tPWzJ
         43BHNQuQqOJISVMyV06YaKDmYMm/rLVCXQuRdlsxheRvGZ0gs0aFQ0PCzmbCaH1Q6sun
         UqlA==
X-Gm-Message-State: AOAM5333VSXymdn1JbhtyhqbgseWU0f7vY5F6SwDhR8CHox2Xgra3NiP
        f7AZc8e2zsnHOYXON8SC2FDGQzBqkvoY0g==
X-Google-Smtp-Source: ABdhPJz77AolN+fokbeWUoG7CI0tWCYnnlmM5LWLLPFn5SO0jdsxF21Y5CXsvvo7QFpq4MsP5XUOEQ==
X-Received: by 2002:a17:902:aa44:b029:d3:8b4f:5083 with SMTP id c4-20020a170902aa44b02900d38b4f5083mr2388829plr.78.1602070529325;
        Wed, 07 Oct 2020 04:35:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j19sm2745487pfi.51.2020.10.07.04.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 04:35:28 -0700 (PDT)
Message-ID: <5f7da800.1c69fb81.f1f1c.52aa@mx.google.com>
Date:   Wed, 07 Oct 2020 04:35:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.8.13-85-g17678e549cde
X-Kernelci-Branch: queue/5.8
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.8 baseline: 132 runs,
 1 regressions (v5.8.13-85-g17678e549cde)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 132 runs, 1 regressions (v5.8.13-85-g17678e54=
9cde)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.13-85-g17678e549cde/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.13-85-g17678e549cde
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      17678e549cded7f3794050c656dd4edc8b91bbc2 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f7d6695c90da9639f4ff411

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.13-85=
-g17678e549cde/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.13-85=
-g17678e549cde/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f7d6695c90da963=
9f4ff415
      failing since 3 days (last pass: v5.8.12-99-g7910fecf197e, first fail=
: v5.8.13-3-g58c57ca2b2dd)
      2 lines

    2020-10-07 06:54:06.707000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-07 06:54:06.707000  (user:khilman) is already connected
    2020-10-07 06:54:21.918000  =00
    2020-10-07 06:54:21.918000  =

    2020-10-07 06:54:21.918000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-07 06:54:21.918000  =

    2020-10-07 06:54:21.918000  DRAM:  948 MiB
    2020-10-07 06:54:21.934000  RPI 3 Model B (0xa02082)
    2020-10-07 06:54:22.021000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-07 06:54:22.053000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (385 line(s) more)
      =20
