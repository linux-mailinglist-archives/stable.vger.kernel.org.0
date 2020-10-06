Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA3F2854EA
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 01:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgJFXWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 19:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgJFXWC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 19:22:02 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2642C061755
        for <stable@vger.kernel.org>; Tue,  6 Oct 2020 16:22:02 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id b19so62221pld.0
        for <stable@vger.kernel.org>; Tue, 06 Oct 2020 16:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2Cb7hTShS2DKRIS0xoFd8G6aiOfnPxZjOayRzDkJTwM=;
        b=PO2MwTjcFysFJED2QgnoGlDILTnVyRvyXqGIOeA5DFiHbOCmk3UbQXm2x2XZVqZvoL
         1zDxPKBJCOtWNKJ2jkDPXpHCSOlc53kGEtnI39yriDeuLM1WCb01WJzlcMuPekEzNrH+
         /GekKPxgZjIdBFvWMzR9gGjQXqykZWSi93frQ/ormV7fYvtKLEzf8lvbBcPzXqVA5O1E
         84qxmm709aVCIfznMlrDp/jQgpwEYA8K8o2upiHqRfb/mWNr9mLvdzIP1bHqLVfXwUua
         8vdGo4Hi0xFEL6lx4dUPR4Bopwhwh2vecuw3ueeEO2OkTSVyQ0Jwdo6t3nT+M8o2oOji
         R2WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2Cb7hTShS2DKRIS0xoFd8G6aiOfnPxZjOayRzDkJTwM=;
        b=QPKWz3ZOmfQYL7G9lW9smP1rnoT3W08hc7jUO4RJTaWJ8dzVSul6wN9mW5MLLa6uu0
         0lSA0w3CkxFIDJX8K3nvis5Phpz9qENILMND8yY53UmiXSSUnYDOY6eH43Z55xlJuYlw
         VArMADpN1+ZBqJxncn62rnC+EeG9qrkvAvyxh6Pyb5nkJIPxLPgEJGCHf7guDGkiILwn
         VoP5dgTDSelYrYmPCST2x/Fs2UmlKIc15lRTe91DqyNkJ0OJ9Pe6NWpHWPPrM02JQg7j
         I54B/G1FMlEC9GjG94t6sVAwUvJxJTHvFEZ2Yi0pehEmEol0MEdnIWSa0ZqY+8au8ZRA
         eOTg==
X-Gm-Message-State: AOAM533HfhC9q2IgrWIQe22dXacTqQUSy3vLgQfj0KgSY/LIoYuOGR/Q
        1grnE32DRo0qo3rBUooWlnIhdm4XXNHtUQ==
X-Google-Smtp-Source: ABdhPJwGKQvXmDHRRRy3Xw+E2nzP/b/E0d3ticN0sOyUh3Sc8RrvHXWnk8T9uUNei4EUb3NFKqM72g==
X-Received: by 2002:a17:902:59d8:b029:d3:d115:66d9 with SMTP id d24-20020a17090259d8b02900d3d11566d9mr253050plj.84.1602026521835;
        Tue, 06 Oct 2020 16:22:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k128sm294427pfd.99.2020.10.06.16.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 16:22:01 -0700 (PDT)
Message-ID: <5f7cfc19.1c69fb81.40c36.0e63@mx.google.com>
Date:   Tue, 06 Oct 2020 16:22:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.238-16-g3b5792495950
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 73 runs,
 2 regressions (v4.4.238-16-g3b5792495950)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 73 runs, 2 regressions (v4.4.238-16-g3b579249=
5950)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | results
----------+------+--------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.238-16-g3b5792495950/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.238-16-g3b5792495950
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3b5792495950eb0871869e5332fa3956d0756c34 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | results
----------+------+--------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:     https://kernelci.org/test/plan/id/5f7cc25cf76b78a5b74ff3e0

  Results:     1 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-1=
6-g3b5792495950/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-1=
6-g3b5792495950/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f7cc25cf76b78a5=
b74ff3e4
      new failure (last pass: v4.4.238-16-g98ec56901158)
      1 lines

    2020-10-06 19:13:49.553000  Connected to omap3-beagle-xm console [chann=
el connected] (~$quit to exit)
    2020-10-06 19:13:49.553000  (user:) is already connected
    2020-10-06 19:13:49.553000  (user:khilman) is already connected
    2020-10-06 19:14:01.336000  =00
    2020-10-06 19:14:01.343000  U-Boot SPL 2018.09-rc2-00001-ge6aa9785acb2 =
(Aug 15 2018 - 09:41:52 -0700)
    2020-10-06 19:14:01.347000  Trying to boot from MMC1
    2020-10-06 19:14:01.536000  spl_load_image_fat_os: error reading image =
args, err - -2
    2020-10-06 19:14:01.777000  =

    2020-10-06 19:14:01.777000  =

    2020-10-06 19:14:01.783000  U-Boot 2018.09-rc2-00001-ge6aa9785acb2 (Aug=
 15 2018 - 09:41:52 -0700)
    ... (449 line(s) more)
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f7cc25cf76b=
78a5b74ff3e6
      new failure (last pass: v4.4.238-16-g98ec56901158)
      28 lines

    2020-10-06 19:15:35.391000  kern  :emerg : Stack: (0xcba23d10 to 0xcba2=
4000)
    2020-10-06 19:15:35.400000  kern  :emerg : 3d00:                       =
              bf0388fc bf01db84 cb9ac010 bf038988
    2020-10-06 19:15:35.409000  kern  :emerg : 3d20: cb9ac010 bf23e0a8 0000=
0002 cb8a6010 cb9ac010 bf28db54 cbcac030 cbcac030
    2020-10-06 19:15:35.416000  kern  :emerg : 3d40: 00000000 00000000 ce22=
8930 c01fb3c0 ce228930 ce228930 c0859648 00000001
    2020-10-06 19:15:35.424000  kern  :emerg : 3d60: ce228930 cbcac030 cbca=
c0f0 00000000 ce228930 c0859648 00000001 c09632c0
    2020-10-06 19:15:35.432000  kern  :emerg : 3d80: ffffffed bf291ff4 ffff=
fdfb 00000026 00000001 c00ce2e4 bf292188 c0407070
    2020-10-06 19:15:35.440000  kern  :emerg : 3da0: c09632c0 c120ea30 bf29=
1ff4 00000000 00000026 c0405544 c09632c0 c09632f4
    2020-10-06 19:15:35.449000  kern  :emerg : 3dc0: bf291ff4 00000000 0000=
0000 c04056ec 00000000 bf291ff4 c0405660 c0403a10
    2020-10-06 19:15:35.457000  kern  :emerg : 3de0: ce0b08a4 ce221910 bf29=
1ff4 cbb74040 c09ddba8 c0404b5c bf290b6c c0960460
    2020-10-06 19:15:35.465000  kern  :emerg : 3e00: cbc000c0 bf291ff4 c096=
0460 cbc000c0 bf295000 c0406124 c0960460 c0960460
    ... (16 line(s) more)
      =20
