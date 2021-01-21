Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE8E2FF3F1
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 20:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbhAUTLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 14:11:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbhAUTLm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 14:11:42 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6644C06174A
        for <stable@vger.kernel.org>; Thu, 21 Jan 2021 11:11:01 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 15so1970279pgx.7
        for <stable@vger.kernel.org>; Thu, 21 Jan 2021 11:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jNHEhfeQDCn2ydw0vvpDDQ9k0H06ufsPQo6jJ6hHF6c=;
        b=lALZvdEvhsQ4Ze5+Vx7i6d0g2e4aYjGgY+mPOTz1VV7GsF2B6wPPTRhtWf8s3VNsPU
         K4k81h+5S3vSuiF4Beg902jGBjq52tV89ItV9LtV8QtgR0PfmXTmJrY/Du6CucpTBhek
         ixPaoCX7eisNyDELGl8R2WxlVJ1AXXkVEoPYbXo4oSDkPRyau3hgMLHefnif3K6qVuXm
         EF1SpvRHteHSPYnUpbZhpBp6AwoScoWNTmOMO/t6Aoi03P4Tuie1VWeBmcfZq3kQz07w
         MIO/vyb2RM+HCLKuv1157vJ4OS3U7Vysc0r1zE9BSCWzm84DN14Qu/hERuuhbJqFw8rQ
         qThw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jNHEhfeQDCn2ydw0vvpDDQ9k0H06ufsPQo6jJ6hHF6c=;
        b=L0GDPneBehbIvVL9JaUzmynYgX+9EURr4hEdLwmSLO+ZJ5byAW66KSDYj/RwqIfTD0
         UIIUGsTaYpRlXudj8ea/gKzr/se4MOsF5eaq2BG6hhjwVUN73QiYTZs3ewQtOJ8LlyB+
         x3cSIR0um/BukRBYZ25fwownUb/Oht0VtcFPbsmqj8TdV1uX6z6sP1Mh8xYYkot2PU6i
         U8h1/T47yrVbjNL64PXaTp1atAAnsGnAsSZovsl6Uh0oglshnH9BWLG/9khoClulHCBl
         4UY8X41dZjlhReKxXeMSIR8V8SWSmz+JHr2NjFhcwKmTu64t//0TIALeASm9uQW52+7t
         ePQw==
X-Gm-Message-State: AOAM531j4v48N0A35+8zcbl1sz8/kNj21r+avIecoJ43yOqjUgmuuvJw
        KstljQlCqjPiZhyiieByP4BAvxom5b0kjfyz
X-Google-Smtp-Source: ABdhPJyTNGF7vWPdof6k9ic90S3NFrhAmKlBwtkR+nmu2J8HTorPP/gWTCYPJ0TN33B7mekWNBLM6Q==
X-Received: by 2002:aa7:804f:0:b029:1a9:5aa1:6235 with SMTP id y15-20020aa7804f0000b02901a95aa16235mr819790pfm.1.1611256261117;
        Thu, 21 Jan 2021 11:11:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z16sm6238263pgj.51.2021.01.21.11.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 11:11:00 -0800 (PST)
Message-ID: <6009d1c4.1c69fb81.2d48c.ea54@mx.google.com>
Date:   Thu, 21 Jan 2021 11:11:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.9-10-g566369ccd746
Subject: stable-rc/queue/5.10 baseline: 183 runs,
 1 regressions (v5.10.9-10-g566369ccd746)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 183 runs, 1 regressions (v5.10.9-10-g566369c=
cd746)

Regressions Summary
-------------------

platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-8    | defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.9-10-g566369ccd746/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.9-10-g566369ccd746
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      566369ccd746b22461ce3133cb30eb1ac235e214 =



Test Regressions
---------------- =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-8    | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6009b1103e3b5a0529bb5d3b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.9-1=
0-g566369ccd746/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-virt-=
gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.9-1=
0-g566369ccd746/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-virt-=
gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6009b1103e3b5a0529bb5=
d3c
        new failure (last pass: v5.10.9-2-gc763deac7ffa) =

 =20
