Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7BF2AE5CB
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 02:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731657AbgKKBYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 20:24:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgKKBYP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 20:24:15 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA59C0613D1
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 17:24:15 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id y22so114442plr.6
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 17:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IxbWnaHd1JyGeRrHeLDDuPsRFbhRbT1XAMxK3x3chjI=;
        b=JZpnQj9euITc6iUpkFyXEMjnvyGle4aMrgVTptnXzj2unmULVqKdhjQV7aswF0wLi5
         tfFg7azlgymSWIe7aipx1G6VkyzSh7jjTuD3w1E9hsHyvJOdxby47KgzykO0SsFy1oPa
         CcT1MFMpj0UztvII5pqqyWMdMKVPOBaLkIDlANjNyAj6Kbznn7Qcqkmv0Co+MZZxZeSd
         vkxZYSRdGUbgh07lansUOC45MYjMuXHoV+8XYJt9Hr2RVoOa3A1J2l73mwK2N6g6H8et
         fiHIyhzehmD6ldQGshk1XD8n9jsPvna7RX/p1xiaIRZ8hFzxpFK9I7fHwWhiXiNXeqXp
         pmaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IxbWnaHd1JyGeRrHeLDDuPsRFbhRbT1XAMxK3x3chjI=;
        b=hbIsmDwBXW4UB2R6VnrPPxb/Ggkx76AFpFGpGfbg33DQ1zmQu4YdZ4WIL7RN6GkhAl
         oSR17PR9a7RS2JlMWFFN3KmqJRt8gMUxYpMufogzel5lNl2Nt6OJvO5mHXsPvYIlsE0W
         k8Mdqzo0iPkA1JkOj1YkZUfh0QgQSDZ6vhsDKPDuQBEd74gQNkHUnej0aNx7sATaUAc+
         eu5hOhIDPtUOtNjcSJN3roJ9FjRMdPVHdPf47dcxBVR9pa+VvldASltmdOpRXyWd7Y/3
         ugPZM382U4BCzYItOgBK5N8YWyiSiISIib29hdta6qJqjL/+/rb1PDVxEl9wlOhsBwbM
         GBDg==
X-Gm-Message-State: AOAM5331QebHk9rhjhI0qHJVG1FcNMvH/A1lZ1hylQwIi+IuoAORmpF0
        /rokPgX2eu4q+vjVPRGflNbM4+3SW0Fn/w==
X-Google-Smtp-Source: ABdhPJwsreyiosrFb2IPjLXc7MDDU0WSVsWUWgTVPcRiAqhw1mNgWFZOvKSjHqHjFJ/OfUZVoTT3Ig==
X-Received: by 2002:a17:902:bf0c:b029:d8:86aa:eb4e with SMTP id bi12-20020a170902bf0cb02900d886aaeb4emr6512255plb.82.1605057853872;
        Tue, 10 Nov 2020 17:24:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y23sm253759pje.41.2020.11.10.17.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 17:24:13 -0800 (PST)
Message-ID: <5fab3d3d.1c69fb81.74e3e.120e@mx.google.com>
Date:   Tue, 10 Nov 2020 17:24:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
X-Kernelci-Kernel: v4.4.243-13-g3ae0f9dc7816
Subject: stable-rc/queue/4.4 baseline: 119 runs,
 4 regressions (v4.4.243-13-g3ae0f9dc7816)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 119 runs, 4 regressions (v4.4.243-13-g3ae0f9d=
c7816)

Regressions Summary
-------------------

platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
beagle-xm   | arm    | lab-baylibre  | gcc-8    | omap2plus_defconfig | 2  =
        =

panda       | arm    | lab-collabora | gcc-8    | omap2plus_defconfig | 1  =
        =

qemu_x86_64 | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.243-13-g3ae0f9dc7816/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.243-13-g3ae0f9dc7816
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3ae0f9dc7816473968d2c19f4200b8203ed45488 =



Test Regressions
---------------- =



platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
beagle-xm   | arm    | lab-baylibre  | gcc-8    | omap2plus_defconfig | 2  =
        =


  Details:     https://kernelci.org/test/plan/id/5fab0abab0bb22796fdb885c

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-1=
3-g3ae0f9dc7816/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-1=
3-g3ae0f9dc7816/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fab0abab0bb2279=
6fdb885f
        new failure (last pass: v4.4.242-13-g4252bfe26b94)
        1 lines

    2020-11-10 21:46:52.742000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-11-10 21:46:52.742000+00:00  (user:khilman) is already connected
    2020-11-10 21:46:52.742000+00:00  (user:) is already connected
    2020-11-10 21:46:52.742000+00:00  (user:) is already connected
    2020-11-10 21:46:52.742000+00:00  (user:) is already connected
    2020-11-10 21:46:52.743000+00:00  (user:) is already connected
    2020-11-10 21:46:52.743000+00:00  (user:) is already connected
    2020-11-10 21:46:52.743000+00:00  (user:) is already connected
    2020-11-10 21:46:52.743000+00:00  (user:) is already connected
    2020-11-10 21:46:52.743000+00:00  (user:) is already connected =

    ... (457 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fab0abab0bb227=
96fdb8861
        new failure (last pass: v4.4.242-13-g4252bfe26b94)
        28 lines

    2020-11-10 21:48:37.646000+00:00  kern  :emerg : Stack: (0xcb8efd10 to =
0xcb8f0000)
    2020-11-10 21:48:37.654000+00:00  kern  :emerg : fd00:                 =
                    bf02b8fc bf010b84 cba56010 bf02b988
    2020-11-10 21:48:37.662000+00:00  kern  :emerg : fd20: cba56010 bf2220a=
8 00000002 cb838010 cba56010 bf24fb54 cbcd91b0 cbcd91b0
    2020-11-10 21:48:37.671000+00:00  kern  :emerg : fd40: 00000000 0000000=
0 ce226930 c01fb3b0 ce226930 ce226930 c0859688 00000001
    2020-11-10 21:48:37.679000+00:00  kern  :emerg : fd60: ce226930 cbcd91b=
0 cbcd9270 00000000 ce226930 c0859688 00000001 c09632c0
    2020-11-10 21:48:37.687000+00:00  kern  :emerg : fd80: ffffffed bf253ff=
4 fffffdfb 00000027 00000001 c00ce2ec bf254188 c0406f9c
    2020-11-10 21:48:37.695000+00:00  kern  :emerg : fda0: c09632c0 c120ea3=
0 bf253ff4 00000000 00000027 c0405470 c09632c0 c09632f4
    2020-11-10 21:48:37.704000+00:00  kern  :emerg : fdc0: bf253ff4 0000000=
0 00000000 c0405618 00000000 bf253ff4 c040558c c040393c
    2020-11-10 21:48:37.712000+00:00  kern  :emerg : fde0: ce0c38a4 ce22091=
0 bf253ff4 cbc03540 c09ddba8 c0404a88 bf252b6c c0960460
    2020-11-10 21:48:37.720000+00:00  kern  :emerg : fe00: cbc2f140 bf253ff=
4 c0960460 cbc2f140 bf257000 c0406050 c0960460 c0960460 =

    ... (16 line(s) more)  =

 =



platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
panda       | arm    | lab-collabora | gcc-8    | omap2plus_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/5fab0aa679321fcacadb897b

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-1=
3-g3ae0f9dc7816/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-1=
3-g3ae0f9dc7816/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fab0aa679321fc=
acadb8980
        failing since 1 day (last pass: v4.4.241-86-g2fa33648e935, first fa=
il: v4.4.241-86-gdeb6172daf90)
        2 lines =

 =



platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
qemu_x86_64 | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/5fab0c1312227f1696db8865

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-1=
3-g3ae0f9dc7816/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-1=
3-g3ae0f9dc7816/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fab0c1312227f1696db8=
866
        failing since 0 day (last pass: v4.4.241-86-gdeb6172daf90, first fa=
il: v4.4.242-13-g4252bfe26b94) =

 =20
