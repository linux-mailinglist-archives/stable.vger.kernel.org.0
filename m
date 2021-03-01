Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E733282A2
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 16:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237317AbhCAPhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 10:37:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237324AbhCAPg5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 10:36:57 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838E0C061788
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 07:36:15 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id i14so9879892pjz.4
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 07:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=e1rFb5goE9CuzT6Bx6yxAfrd4k0Lxo8EG0EuJVRaQx0=;
        b=RRlEQXyi43fN5m2W2Uty6kpeL37RDSgr2kS+AkK9ARL3eN29/bj8wh/eaHo/oBEr2L
         r4iW7E2giGmhi2fMLpaGjSTZTNOb4zyHrk6herCoWZWQVXTqtmflloaR1At21J/5Tg9R
         fQgq0ng0PM6NMf3Hqquiqm1H6yC2xiZvp2KWp2oy9rME/o85Lv5B9XcTcqU55yr3OFeA
         jdTqI+qM8NWouUIkKgyz12I5iPTfhSby64z2E2SLkcnAxPB8Ih5fxIrYFj/qzjqGv1FS
         phkvyxInOljGe3V11QTsMCAanrPonHRKUauXOaL7Yb3Hxkxpxv+zzTACwKTAGAyTFzGU
         hQMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=e1rFb5goE9CuzT6Bx6yxAfrd4k0Lxo8EG0EuJVRaQx0=;
        b=PwM5yVTbu6JYOZWMC15KQgtN38koIwMaKilYnJaKVMk+Le3dZtq0iMIAxQ6JD+5rp7
         pPLr7jKd0OYxi6CBCyTyK+wjflK3jt9p2HTnKeLHPOFhKUhsXhRZWNwIBPkZNgJY3X10
         mvHpiqSUygX59aWaJirYtzEoAnIY51IgMmBFABtPDYvwQ21RVKmE/EsmndWOUjk5Bel8
         FMxGKdDcTwRkPhk9Md1C+jIUE/DpZjiHu/uDZKrlC2KGmUpSgIun6leN5GXnMqtEaWcb
         bRWqz4OU/fu4qDXe1BGCj5CYymky5eLHJbQeWqbNTxq9kp8h9O8ekrjsHvq+ZDqJn25J
         11VA==
X-Gm-Message-State: AOAM533fDVzBipW27C859DXF3MM/VG9vQBQUgIg/zA6MjGB2SjN7P8Nj
        a8RgwWGAeNJHKZEcEkEsX58g7wOAGhR+nA==
X-Google-Smtp-Source: ABdhPJzuS6bYmTnGSYVSohtdSaPOPrGD8F2L5fv7rS7EYafoeTArM7UFEvu25kBMt2Kns36QyJEm5A==
X-Received: by 2002:a17:90a:3489:: with SMTP id p9mr6513989pjb.68.1614612974875;
        Mon, 01 Mar 2021 07:36:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 4sm19347838pjc.23.2021.03.01.07.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 07:36:14 -0800 (PST)
Message-ID: <603d09ee.1c69fb81.4143d.c8e0@mx.google.com>
Date:   Mon, 01 Mar 2021 07:36:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.258-107-g203569ee3896
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 48 runs,
 1 regressions (v4.9.258-107-g203569ee3896)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 48 runs, 1 regressions (v4.9.258-107-g203569e=
e3896)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.258-107-g203569ee3896/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.258-107-g203569ee3896
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      203569ee38962f14e2ad98c986950a1309b0405a =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/603cd8eae466fcbdeeaddcc1

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
07-g203569ee3896/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
07-g203569ee3896/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/603cd8eae466fcb=
deeaddcc6
        failing since 0 day (last pass: v4.9.258-12-g80c6cbdf1f84, first fa=
il: v4.9.258-88-g9173936eb9805)
        2 lines

    2021-03-01 12:07:02.580000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
