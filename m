Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54BDF23D5B8
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 05:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730146AbgHFDUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 23:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730137AbgHFDUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 23:20:04 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7DEC061574
        for <stable@vger.kernel.org>; Wed,  5 Aug 2020 20:20:04 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id p8so9849645pgn.13
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 20:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=J1Y29ItJoP21e0FKYPWdn5WtBeJcYxO0IfQhpHnIOdA=;
        b=XiX6coiTdfbiJuV+ya3uSGORx55tiI1KT0DF5GJnL9sUjej9KAommo8ET9SLaPJIQ1
         kb8cJ1A0OEvEsPfH24WCF7GiQt1cHfRrJiV++djFyWI9FHxyXLBlOgNzJ2yslB1Sznqp
         vy6/Gm/AQURWi939r6HQN5OJuG2Q9vXfY6mw2JtQR1CffBejLGguyfGxS/h0UDqwJ5YR
         RcAtl3XVXkat28vZGLqloXWICSyhtXqdzliYw7yS38/1k2NAZtQNWcoQOWp6eSPp+Yvw
         bcr8o0We6H2hVT7H5N21bLKdGydD/eCeGmnJHo+Fp84gtkzYG4WkTKgq51WXYJEjcXuE
         IO/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=J1Y29ItJoP21e0FKYPWdn5WtBeJcYxO0IfQhpHnIOdA=;
        b=qUaO+/r+KgYd+toXHEuTQftBXYyDBtaTrPWIQiVxqZgKTIu585K3XnLPIVou3YMkuv
         7OxfQ7qX7xaWZALAzOKmRpmUk3YRPg+JyR52HQFoccEqjan1CUT+Dxn47qsTT8L830Vd
         onEKUQwAd2uK705J1OdtsUdhfaVs/JxjeNBKUnNYQ9M7t885ryNOJE5frjy8ORTuJaGV
         3iD1DHHzxYo67U46bnTC14a61gs/vIASxwXkzEkjkZpLveMSpI1DcZP/qr0MS2GKm85u
         VMXL3jHzHEeOlpUqv1IvEFc2Co1T5kbU3A+lAYfai5zxgK963zVhIjobc9VR9epSDAPa
         ZDdA==
X-Gm-Message-State: AOAM533uyAzGmlv6FP2xMYkiSLiXnBBzsv4kFM2hTD3P61zdr3PRrEDS
        5kGwffu+qAOqhe5/RPrPRHbtFdAcKRc=
X-Google-Smtp-Source: ABdhPJx4dTbxA7RWAXBeCBGP4FBuwO7+JvQcC0g0F9raVpSChajMkEDTJ25o6ajY0rP+Ji2Qgd74/A==
X-Received: by 2002:a62:1a56:: with SMTP id a83mr6171368pfa.314.1596684002115;
        Wed, 05 Aug 2020 20:20:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l1sm2364142pgi.51.2020.08.05.20.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 20:20:01 -0700 (PDT)
Message-ID: <5f2b76e1.1c69fb81.5b3fa.77ed@mx.google.com>
Date:   Wed, 05 Aug 2020 20:20:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.136-60-g2f4ec68a8dc8
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 135 runs,
 1 regressions (v4.19.136-60-g2f4ec68a8dc8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 135 runs, 1 regressions (v4.19.136-60-g2f4=
ec68a8dc8)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.136-60-g2f4ec68a8dc8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.136-60-g2f4ec68a8dc8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2f4ec68a8dc81295799b14aaebf6dd12aec9a2fa =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2b458a4c80a4342c52c1e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
36-60-g2f4ec68a8dc8/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
36-60-g2f4ec68a8dc8/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2b458a4c80a4342c52c=
1e6
      failing since 50 days (last pass: v4.19.126-55-gf6c346f2d42d, first f=
ail: v4.19.126-113-gd694d4388e88) =20
