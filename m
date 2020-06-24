Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F77206A17
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 04:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388102AbgFXCW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 22:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387719AbgFXCW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 22:22:29 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FBDC061573
        for <stable@vger.kernel.org>; Tue, 23 Jun 2020 19:22:29 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id g17so355947plq.12
        for <stable@vger.kernel.org>; Tue, 23 Jun 2020 19:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CC3IiVsXnK50W2NE3Ix5RRLhcdBRXNPDGqVh/vpl9Qw=;
        b=NNtuJilUf6zvBIkgVzQ0Y3dey6XbPRAJepF21ZxxrVuqCTbleXhk0oopoHs6+PNCmP
         hx0i5mhKPN1B6tF5XpTPbqpJtVcQEC915D2E5idADIezYc2xKtMlLksrF39ScuofdDcD
         27x+32h8kMny0VFobwZatI4IY9aV9MSMmKo4XKLpeHA5ddcUpi19LtmkjjpvMJMtMIYP
         snWHtliZH3kOEF/DUDtN2nzAGJJLIcUVl7YfCfoeIqqnFJZycLYZLGfg5VYmT74+SYhU
         5ksaFamWIDaXDExKn5rU/ue1FZs9uaRUaP4945qIyjcxV4BKhrGsqnDoXijAlwhG1dqx
         zYNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CC3IiVsXnK50W2NE3Ix5RRLhcdBRXNPDGqVh/vpl9Qw=;
        b=KGy1COMHD3EUtW60oR/1xUsayQziOqic4N280QhgzF9jHQXORNfC2bVpEIV5xu0/G8
         coIxW+SSkvReBOaR1rV8uBZsMTMbx+2M3MayHk44YXLw3C0XmlR7Z70K48R3n0QTHbW3
         63ngrgu/dsDTWIQjIU/WBGYQqfw2DQQFbuG71ZPh/9VWgVMoCjWMWxOv4DShYpmxMVWP
         bv4v92gMmXxmtHzGPkV+2SOsFRhv/QIRbfH0jKS++0XazE70T2pRmPssT2FBe202QfRx
         49/0bMwjN8ZZbC1OIw3RBpRgssrtyNKu+Ko3WeyjXu3Tfox70qlXAT2lem8YmZfIf69c
         kK3g==
X-Gm-Message-State: AOAM531HQRhUpKn52JxDXjhcE5QbEc+ls+d6jWalQkuz7PzLG3R/k13P
        G2zOewV9BEgH3oRQzGymQ9ctRMF1E+M=
X-Google-Smtp-Source: ABdhPJykT2UD9MULjECw8B0+rfAaTCxuAt15I+fO+F3x1ZjDojKiCPZRPB6+Hx+I0s+b1rukfVVeqQ==
X-Received: by 2002:a17:902:d203:: with SMTP id t3mr4567415ply.168.1592965348398;
        Tue, 23 Jun 2020 19:22:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m2sm13080456pfb.164.2020.06.23.19.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 19:22:27 -0700 (PDT)
Message-ID: <5ef2b8e3.1c69fb81.e4b4b.86f2@mx.google.com>
Date:   Tue, 23 Jun 2020 19:22:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.226-219-g2ff318e63314
Subject: stable-rc/linux-4.4.y baseline: 28 runs,
 2 regressions (v4.4.226-219-g2ff318e63314)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 28 runs, 2 regressions (v4.4.226-219-g2ff31=
8e63314)

Regressions Summary
-------------------

platform    | arch   | lab          | compiler | defconfig        | results
------------+--------+--------------+----------+------------------+--------
qemu_i386   | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 0/1    =

qemu_x86_64 | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.226-219-g2ff318e63314/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.226-219-g2ff318e63314
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2ff318e63314dfe903876e2b1306f08ccdd7ef7b =



Test Regressions
---------------- =



platform    | arch   | lab          | compiler | defconfig        | results
------------+--------+--------------+----------+------------------+--------
qemu_i386   | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ef286c70ed8513daf97bf09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.226=
-219-g2ff318e63314/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i38=
6.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.226=
-219-g2ff318e63314/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i38=
6.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ef286c70ed8513daf97b=
f0a
      new failure (last pass: v4.4.226-202-g97fdbef74916) =



platform    | arch   | lab          | compiler | defconfig        | results
------------+--------+--------------+----------+------------------+--------
qemu_x86_64 | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ef28449a73fdc3bdb97bf3c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.226=
-219-g2ff318e63314/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.226=
-219-g2ff318e63314/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ef28449a73fdc3bdb97b=
f3d
      new failure (last pass: v4.4.226-205-g47365a65ad5f) =20
