Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB5948A003
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 20:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241896AbiAJTRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 14:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbiAJTRu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 14:17:50 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36BCC06173F
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 11:17:49 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id n16so13464700plc.2
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 11:17:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vkvXjOqqtkMA46fzHxb19pq+/FJvvA94H565Iquj3M0=;
        b=rRf8OXuq1qXwJbJCofIXyf9qUBAcPrlPZ+IkxlUchXaq21JfQGud+PsQyBZO0XwQSo
         Vgn0NrPwt6/XWes78D6BKWCkvTnEx6o3VOQ/+jRgMbMcsXw4pZ6oZ+AnUiUEMzUy1moV
         FvLSBOIzmyVh/S1RpO6FcS0th0J9lX98N69wBSgPtNqvlUuss5gWZJiuQCs0FgLgCzgG
         qPSX+jkVh+d6dtZxcbk6mTyQmMxvQAO+/SKDvhP5hjp4K+/eQJZoy/mWdH7FP3p3Ewb1
         J4p0rDJ4MVP0Yxfn0VPaLa/E/ypEfd46aVkU9iyp+BrdBohvUj7WeuOfsiDBajd796C2
         ERCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vkvXjOqqtkMA46fzHxb19pq+/FJvvA94H565Iquj3M0=;
        b=sHrtnXE6lnbBHHrBBl/EolTNF7msrRekHGRoEaH/ceRsAYLrVtVb048AKJbaos1HAW
         xZY2l2hLw6LvtnxHpTd1iqEbVdjVUHkKsuukABp5Unyfe3MSUO6ft6C/e04N99NwE8IO
         mqQhfHFqp747jxZ2PUDHKRUU7TI4/ruHDGr3FJMid8wLYetmPPfCQNOBOaHU78V0CRRv
         mF9k3XD6flqN3yhoDA/NwdnSryn8nSN2xIPeYh0TukTVvzTYlriFPfZuhwV5tGYIWeqJ
         lQz7s4dUvBp/YkmoChEo3WLDtSFor9wcMQuERWYYdPGjDmnt1ZV4uaI6yWCCJ5VgsFcM
         Qd/g==
X-Gm-Message-State: AOAM5325JFmyaI4/Ki9RfFFAsaAJ5+ZKlN6Z3uh11FBp10WDbkj8agJU
        3WTJBtd8TcnsFT/GhB5WUjfPg2m9HBPbeTr1
X-Google-Smtp-Source: ABdhPJzDZWdYYbfOnHKck33G4GUNAZucxhFzXKnxYaNsbGTZIH0MbWLTAyTapNJcqHnx4+DW5uphSw==
X-Received: by 2002:a63:3716:: with SMTP id e22mr979359pga.567.1641842269299;
        Mon, 10 Jan 2022 11:17:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d1sm4353323pgd.66.2022.01.10.11.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 11:17:48 -0800 (PST)
Message-ID: <61dc865c.1c69fb81.5ffae.b2f5@mx.google.com>
Date:   Mon, 10 Jan 2022 11:17:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.261-23-g96488a6934b1
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 89 runs,
 1 regressions (v4.14.261-23-g96488a6934b1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 89 runs, 1 regressions (v4.14.261-23-g9648=
8a6934b1)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.261-23-g96488a6934b1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.261-23-g96488a6934b1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      96488a6934b1280ad419a37de3385c2503e04710 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61dc526a64f9f984d0ef6750

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
61-23-g96488a6934b1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
61-23-g96488a6934b1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61dc526a64f9f98=
4d0ef6753
        failing since 18 days (last pass: v4.14.258-46-g5b3e273408e5, first=
 fail: v4.14.259)
        2 lines

    2022-01-10T15:35:55.297385  [   20.309204] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-10T15:35:55.338722  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2022-01-10T15:35:55.348341  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
