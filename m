Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B3828B4CC
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 14:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729672AbgJLMoW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 08:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbgJLMoW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Oct 2020 08:44:22 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2760C0613D0
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 05:44:21 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id c20so2790862pfr.8
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 05:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Nmom0lTHh2PEiz1pCp/kCmnGgsC3wJ5xdddXehbs0Vc=;
        b=ld/8bovS1UMPP3W9Usm3q3OGzOvyo5AD8t6qkCZrKHDzEQjJCenuASzGVQ9t5INFDa
         que2lfHVSZF6vGeGL0+jR3yJCWYmeVjApDfeXWuNgp6+KBCPC5J0E9pGBIKjMz1JvJSu
         dVqDNQWT2QQ0SsSNy5W8/tyPXY2mY6fEOdeAqxU55J0W0rkdmrWeJvsXZ/WmESHx+cK6
         c0XqMNLYoH7rfVoZDDCsKrsDhRWsL30E0EIai39XNEJFlw3+bMh0HDlf9odh4XO1lt0O
         LZlHgI4N4Y1qKjbi60IM6TIXPRXAWCeJd7L3tsZeVaB3RMzkOYt/W7PEa9OgrtH5UtCI
         n/gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Nmom0lTHh2PEiz1pCp/kCmnGgsC3wJ5xdddXehbs0Vc=;
        b=l/nhbrritj5TdVplR0CFXTpoYJ1OtAxO351t/4g0DNAckyHE2c4Hspj1BAaBVlqF0/
         qvB2Nx88iVuGDajwtTIxvKZeMURp6JV68Q2ZqChfhkgF3L5JfiM7O8PrwExYD3UA8AfE
         MlS54JgRTLlSYpAjz6NEbxt5bcZgPJmKHJnnn1gewZbPJkQkjpkc6SdUdgB9PL1SzW2P
         givoVL1Yjpxpmjonbi5hQNM99oDuT12blqmWCiIwiWh/Un3f6YECN3Tdde+0rW1ySuaR
         ABSvZYcDrEpnHxNtXf5InVZ6Q/qzag51HAX8YRvAptJa5Tq0ZfAuWbVhj4G7BKhjoRME
         hhhQ==
X-Gm-Message-State: AOAM533OeokvNZcIgsq++2weqYf2u6t7reX1YgXAysalXO4RkCdRLBqz
        jj5Id3vs7B6Jyofuy9cnsuiJpPdRlPX/Ag==
X-Google-Smtp-Source: ABdhPJxJexJKWkWCVf58u6eOyBbz9akVw2mD7bT2/FoMM70AHF/ztt3MmxvpMajJz3Z9EeVAi85TGQ==
X-Received: by 2002:aa7:84c6:0:b029:155:d56e:5191 with SMTP id x6-20020aa784c60000b0290155d56e5191mr8110657pfn.41.1602506660836;
        Mon, 12 Oct 2020 05:44:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 189sm19902136pfw.123.2020.10.12.05.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 05:44:20 -0700 (PDT)
Message-ID: <5f844fa4.1c69fb81.b95c8.67e0@mx.google.com>
Date:   Mon, 12 Oct 2020 05:44:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.238-38-g473dc135aa7d
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 86 runs,
 2 regressions (v4.4.238-38-g473dc135aa7d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 86 runs, 2 regressions (v4.4.238-38-g473dc135=
aa7d)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | results
----------+------+--------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.238-38-g473dc135aa7d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.238-38-g473dc135aa7d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      473dc135aa7d0ffb254d7d91e9aff12c9a8d2969 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | results
----------+------+--------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:     https://kernelci.org/test/plan/id/5f841237c99a66beb54ff3f9

  Results:     1 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-3=
8-g473dc135aa7d/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-3=
8-g473dc135aa7d/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f841237c99a66be=
b54ff3fd
      failing since 0 day (last pass: v4.4.238-27-g1d9c092d06ca, first fail=
: v4.4.238-29-gceaee0491313)
      1 lines

    2020-10-12 08:20:24.233000  Connected to omap3-beagle-xm console [chann=
el connected] (~$quit to exit)
    2020-10-12 08:20:24.233000  (user:khilman) is already connected
    2020-10-12 08:20:24.233000  (user:) is already connected
    2020-10-12 08:20:24.233000  (user:) is already connected
    2020-10-12 08:20:35.981000  =00
    2020-10-12 08:20:35.988000  U-Boot SPL 2018.09-rc2-00001-ge6aa9785acb2 =
(Aug 15 2018 - 09:41:52 -0700)
    2020-10-12 08:20:35.992000  Trying to boot from MMC1
    2020-10-12 08:20:36.181000  spl_load_image_fat_os: error reading image =
args, err - -2
    2020-10-12 08:20:36.422000  =

    2020-10-12 08:20:36.423000  =

    ... (449 line(s) more)
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f841237c99a=
66beb54ff3ff
      failing since 0 day (last pass: v4.4.238-27-g1d9c092d06ca, first fail=
: v4.4.238-29-gceaee0491313)
      28 lines

    2020-10-12 08:22:10.241000  kern  :emerg : Stack: (0xcb8ffd10 to 0xcb90=
0000)
    2020-10-12 08:22:10.250000  kern  :emerg : fd00:                       =
              bf02b8fc bf010b84 cb961e10 bf02b988
    2020-10-12 08:22:10.258000  kern  :emerg : fd20: cb961e10 bf21d0a8 0000=
0002 cbbd1010 cb961e10 bf24ab54 cbca0390 cbca0390
    2020-10-12 08:22:10.266000  kern  :emerg : fd40: 00000000 00000000 ce22=
8930 c01fb3d0 ce228930 ce228930 c0857e78 00000001
    2020-10-12 08:22:10.274000  kern  :emerg : fd60: ce228930 cbca0390 cbca=
0450 00000000 ce228930 c0857e78 00000001 c09612c0
    2020-10-12 08:22:10.282000  kern  :emerg : fd80: ffffffed bf24eff4 ffff=
fdfb 00000028 00000001 c00ce2f4 bf24f188 c04070c8
    2020-10-12 08:22:10.291000  kern  :emerg : fda0: c09612c0 c120da30 bf24=
eff4 00000000 00000028 c040559c c09612c0 c09612f4
    2020-10-12 08:22:10.299000  kern  :emerg : fdc0: bf24eff4 00000000 0000=
0000 c0405744 00000000 bf24eff4 c04056b8 c0403a68
    2020-10-12 08:22:10.307000  kern  :emerg : fde0: ce0b08a4 ce221910 bf24=
eff4 cbcde4c0 c09dd3a8 c0404bb4 bf24db6c c095e460
    2020-10-12 08:22:10.315000  kern  :emerg : fe00: cbbfe300 bf24eff4 c095=
e460 cbbfe300 bf252000 c040617c c095e460 c095e460
    ... (16 line(s) more)
      =20
