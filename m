Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77DCA2AAF7A
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 03:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgKIC34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Nov 2020 21:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727979AbgKIC34 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Nov 2020 21:29:56 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407F9C0613CF
        for <stable@vger.kernel.org>; Sun,  8 Nov 2020 18:29:56 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id w14so4011069pfd.7
        for <stable@vger.kernel.org>; Sun, 08 Nov 2020 18:29:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=E4e6ZGAVuJakwmXIaxFLenyuUmpWvsAE/xFp58Q1a1c=;
        b=jtah9/bY/auPJdsWLdQI/yo8KHRQeqH0HSqD4cO7NGSvr1uqqpdW6nMBUyA+FHHEyi
         +yLwLxb0QH96RTZPJIBPJB+LlHCJ7wCSkbf+5Zgs22Kga9KBxv5eOtp2Uh2K1lPMZWRE
         rDPOdo5FVW6yP8T7+jCaMYZkLOfE+bscuSBbzFPM+UXHprC0lWoPX0A/AyNDPFY0KZMp
         QhCkc36mr2RqRTZQc5aQ29YHrJx/Bdjr5HilKPuydiFiDllwhlbZi0EeiCe22Dka6Ico
         u15VlCd5E932z2Ced73ZxolAWV3KFJJNCNEDKK2TcBb5v7Lot288fqeLhH1sHg6uNPmy
         597w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=E4e6ZGAVuJakwmXIaxFLenyuUmpWvsAE/xFp58Q1a1c=;
        b=BE1AbLK1z6IAqDjgQcGpGvdVbBmkPFdLR4JX5knKJd+Ng0OnruhWNshe+NMpCLMiM4
         rtYvwcrZ3JPgfjtZneDkmLuT7Dtri0GOOHtSnjkp0IKC+5UTmwna2ls9O4Gv0kiwfnCP
         IAz+qiJxKywkHCVqcQ8Reg/mTL74MlE+MCLxES4KXWBOqqVcWYsBnh72t8Pq4a2Oy9mC
         DLz++2zVZQu2asstYUXltOjL803V0vcvpGoYrSmLqNFwCVD1Z8koAaAjJtfHBVL/Fce1
         VDUQzhTY6p4L3TIpKsv1txQPwvkquPVqpA/Ni1lZuaaY9PdSsihvsXICa143jfb+EGc4
         yutA==
X-Gm-Message-State: AOAM532v0O2UYk9VqrD+9fV3eLvSUgEWcn7r75SsmVx/t3n8dTjRRJwM
        dC9UkYLk/NPChMdX6lgZm4n9UMxXpH41XQ==
X-Google-Smtp-Source: ABdhPJzAY5sXnRf0ABESs+6FzfHw5A388gsEElh0Zjgd16gKeDnFgMJXrPJunNIcAg7PpFxJYxweFA==
X-Received: by 2002:a05:6a00:134d:b029:18b:2cde:d747 with SMTP id k13-20020a056a00134db029018b2cded747mr11376197pfu.60.1604888995384;
        Sun, 08 Nov 2020 18:29:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j184sm9652684pfg.207.2020.11.08.18.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 18:29:54 -0800 (PST)
Message-ID: <5fa8a9a2.1c69fb81.8451c.4dd9@mx.google.com>
Date:   Sun, 08 Nov 2020 18:29:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
X-Kernelci-Kernel: v4.4.241-71-gf370af230490
Subject: stable-rc/queue/4.4 baseline: 125 runs,
 3 regressions (v4.4.241-71-gf370af230490)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 125 runs, 3 regressions (v4.4.241-71-gf370af2=
30490)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 2      =
    =

panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.241-71-gf370af230490/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.241-71-gf370af230490
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f370af2304908dd8a08f17281a7233cf254a0eaf =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/5fa872a54e1dc87baedb888c

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-7=
1-gf370af230490/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-7=
1-gf370af230490/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fa872a54e1dc87b=
aedb888f
        failing since 1 day (last pass: v4.4.241-67-g2727c0277428f, first f=
ail: v4.4.241-69-gdc3d1b2b389a1)
        1 lines

    2020-11-08 22:33:21.498000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-11-08 22:33:21.498000+00:00  (user:) is already connected
    2020-11-08 22:33:21.498000+00:00  (user:) is already connected
    2020-11-08 22:33:21.498000+00:00  (user:) is already connected
    2020-11-08 22:33:21.499000+00:00  (user:) is already connected
    2020-11-08 22:33:21.499000+00:00  (user:) is already connected
    2020-11-08 22:33:21.499000+00:00  (user:) is already connected
    2020-11-08 22:33:21.499000+00:00  (user:) is already connected
    2020-11-08 22:33:21.499000+00:00  (user:) is already connected
    2020-11-08 22:33:21.499000+00:00  (user:) is already connected =

    ... (456 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa872a54e1dc87=
baedb8891
        failing since 1 day (last pass: v4.4.241-67-g2727c0277428f, first f=
ail: v4.4.241-69-gdc3d1b2b389a1)
        28 lines

    2020-11-08 22:35:13.036000+00:00  kern  :emerg : Stack: (0xcb98fd10 to =
0xcb990000)
    2020-11-08 22:35:13.045000+00:00  kern  :emerg : fd00:                 =
                    bf0328fc bf017b84 cb9a1810 bf032988
    2020-11-08 22:35:13.053000+00:00  kern  :emerg : fd20: cb9a1810 bf2050a=
8 00000002 cb8cf010 cb9a1810 bf24bb54 cbc2f9f0 cbc2f9f0
    2020-11-08 22:35:13.061000+00:00  kern  :emerg : fd40: 00000000 0000000=
0 ce226930 c01fb3a0 ce226930 ce226930 c0859688 00000001
    2020-11-08 22:35:13.069000+00:00  kern  :emerg : fd60: ce226930 cbc2f9f=
0 cbc2fab0 00000000 ce226930 c0859688 00000001 c09632c0
    2020-11-08 22:35:13.078000+00:00  kern  :emerg : fd80: ffffffed bf24fff=
4 fffffdfb 00000027 00000001 c00ce2f4 bf250188 c0407034
    2020-11-08 22:35:13.086000+00:00  kern  :emerg : fda0: c09632c0 c120ea3=
0 bf24fff4 00000000 00000027 c0405508 c09632c0 c09632f4
    2020-11-08 22:35:13.094000+00:00  kern  :emerg : fdc0: bf24fff4 0000000=
0 00000000 c04056b0 00000000 bf24fff4 c0405624 c04039d4
    2020-11-08 22:35:13.102000+00:00  kern  :emerg : fde0: ce0c38a4 ce22091=
0 bf24fff4 cbcb2740 c09ddba8 c0404b20 bf24eb6c c0960460
    2020-11-08 22:35:13.110000+00:00  kern  :emerg : fe00: cbbb9240 bf24fff=
4 c0960460 cbbb9240 bf253000 c04060e8 c0960460 c0960460 =

    ... (16 line(s) more)  =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/5fa8729d4e1dc87baedb8880

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-7=
1-gf370af230490/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-7=
1-gf370af230490/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa8729d4e1dc87=
baedb8885
        new failure (last pass: v4.4.241-69-gdc3d1b2b389a1)
        2 lines =

 =20
