Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C032906FA
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 16:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406070AbgJPON7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 10:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406069AbgJPON6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 10:13:58 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5757C061755
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 07:13:57 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ds1so1457702pjb.5
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 07:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ifvlvHW/R5TWpLvCstQOEDtvvAm7Ihj7/Y57jd2jRv0=;
        b=ki+OPWrAQoAUtViXmBnTBYaQ+07UJYMW/zwxMIgrZcn7FocXpGFTOlf077W8A5GalY
         icAJ+y4LnRH/GvViRdHp/Vj3rLRQUqtohkFXxMFLZZ5kezLJC0RjXB08nU+tZYcEfywn
         F7i/H4JdAyC9GNkkh1yyRlCIMtyQacNhYdsxzb3xB0uKqGJYM5HeOQ3Alx4U+fCDEdUg
         U6FHyTJmzoL8rmUp4lffRx4UbFYlKw6G5vKkUn1gw8iaXD1gjm+NJ4g+p12PbgitH7hi
         /1s0P0TqmY+tUpXi+qCS9HLPAUy79dyljBY6CSRX9ZOqDP0R4mlSU+rFFFCkA1oDaALP
         Q1Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ifvlvHW/R5TWpLvCstQOEDtvvAm7Ihj7/Y57jd2jRv0=;
        b=YXFeJJc1GDOTwBkWSuODiEsscgBH20FTHHL4VAjsDmrVwqCTuzn8ik9MtBdhGuCKoB
         JDmIq9XSS/Dggxo2lf9fmnO9kDRZnH+zFcie3OYhtSbs56ZYMvy6SklJff3v/6cismOy
         NgtakBqQ49KavviwXLHjFT2yKzftIgbgLqQMW5QLlA+pjqOolUJilYbqdTB4U4IkRQQ4
         ew9fk6TfZ/5twYkpVUqL9tN8sIoeejC15orAev+LYmoUUVR3bciY/KJ7xsMsm4PVYH7u
         X8f+3DJHuMesvROyr5SVat9swzxNOFzl6y4KuwIGVf2VdgTrwkMmmXriIhb21vOAP6Ke
         yE/A==
X-Gm-Message-State: AOAM531l2jGiiLixmNjddcqnWK+JFrq6xwf3BiY9T0P5kHVSBPNAN8w8
        CZqmompHramDQUMBe9KhpKLfAONdyRF3Vw==
X-Google-Smtp-Source: ABdhPJzw6s02Ly3t83LjUEU1mMqnxIEm3Uzu0wU+r0bnKkzO1QGgForDjU+IJVa52rIcAa0QOiK/2g==
X-Received: by 2002:a17:902:d909:b029:d3:d52c:b98b with SMTP id c9-20020a170902d909b02900d3d52cb98bmr4308196plz.54.1602857634270;
        Fri, 16 Oct 2020 07:13:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i17sm3036541pfa.183.2020.10.16.07.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 07:13:53 -0700 (PDT)
Message-ID: <5f89aaa1.1c69fb81.3774b.5ec5@mx.google.com>
Date:   Fri, 16 Oct 2020 07:13:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.239-16-g1d6d5935a9bb
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 118 runs,
 2 regressions (v4.4.239-16-g1d6d5935a9bb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 118 runs, 2 regressions (v4.4.239-16-g1d6d593=
5a9bb)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | results
----------+------+--------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.239-16-g1d6d5935a9bb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.239-16-g1d6d5935a9bb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1d6d5935a9bb524f6edb76af33aa54c545fc9a26 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | results
----------+------+--------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:     https://kernelci.org/test/plan/id/5f8974ba2d24ebe2c94ff3fb

  Results:     1 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.239-1=
6-g1d6d5935a9bb/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.239-1=
6-g1d6d5935a9bb/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f8974ba2d24ebe2=
c94ff3ff
      new failure (last pass: v4.4.238-39-g1779016429f0)
      1 lines

    2020-10-16 10:22:03.187000  Connected to omap3-beagle-xm console [chann=
el connected] (~$quit to exit)
    2020-10-16 10:22:03.187000  (user:) is already connected
    2020-10-16 10:22:03.187000  (user:) is already connected
    2020-10-16 10:22:03.187000  (user:) is already connected
    2020-10-16 10:22:03.188000  (user:) is already connected
    2020-10-16 10:22:03.188000  (user:) is already connected
    2020-10-16 10:22:03.188000  (user:) is already connected
    2020-10-16 10:22:03.188000  (user:) is already connected
    2020-10-16 10:22:03.188000  (user:) is already connected
    2020-10-16 10:22:03.188000  (user:khilman) is already connected
    ... (457 line(s) more)
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f8974ba2d24=
ebe2c94ff401
      new failure (last pass: v4.4.238-39-g1779016429f0)
      28 lines

    2020-10-16 10:23:49.937000  kern  :emerg : Stack: (0xcb975d10 to 0xcb97=
6000)
    2020-10-16 10:23:49.945000  kern  :emerg : 5d00:                       =
              bf02b8fc bf010b84 cb999e10 bf02b988
    2020-10-16 10:23:49.953000  kern  :emerg : 5d20: cb999e10 bf2050a8 0000=
0002 cb839010 cb999e10 bf247b54 cbd0b390 cbd0b390
    2020-10-16 10:23:49.961000  kern  :emerg : 5d40: 00000000 00000000 ce22=
8930 c01fb3d0 ce228930 ce228930 c0857e78 00000001
    2020-10-16 10:23:49.970000  kern  :emerg : 5d60: ce228930 cbd0b390 cbd0=
b450 00000000 ce228930 c0857e78 00000001 c09612c0
    2020-10-16 10:23:49.978000  kern  :emerg : 5d80: ffffffed bf24bff4 ffff=
fdfb 00000025 00000001 c00ce2f4 bf24c188 c04070c8
    2020-10-16 10:23:49.986000  kern  :emerg : 5da0: c09612c0 c120da30 bf24=
bff4 00000000 00000025 c040559c c09612c0 c09612f4
    2020-10-16 10:23:49.994000  kern  :emerg : 5dc0: bf24bff4 00000000 0000=
0000 c0405744 00000000 bf24bff4 c04056b8 c0403a68
    2020-10-16 10:23:50.002000  kern  :emerg : 5de0: ce0b08a4 ce221910 bf24=
bff4 cbbdb040 c09dd3a8 c0404bb4 bf24ab6c c095e460
    2020-10-16 10:23:50.010000  kern  :emerg : 5e00: cbcce040 bf24bff4 c095=
e460 cbcce040 bf253000 c040617c c095e460 c095e460
    ... (16 line(s) more)
      =20
