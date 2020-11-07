Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681262AA7F6
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 21:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgKGUwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 15:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgKGUwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 15:52:30 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986F5C0613CF
        for <stable@vger.kernel.org>; Sat,  7 Nov 2020 12:52:30 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id 13so4631968pfy.4
        for <stable@vger.kernel.org>; Sat, 07 Nov 2020 12:52:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=R5LOgnPKdGeIHfFrgT+XpSveceKXxFXO6MGOs0uFkoM=;
        b=GHdqZmf41PpAteToj4bdHPnIkeEia2fplZStwrJXYmcEtPlJMCtncEhIrsTUF9PqNX
         HvI2pSQLqxHMsVUlMdMDfvZN2ypzozZGtrQM1SgiuR/v6oSQ3yglpxZevyGB/q+CFsJx
         zV8qY/U6G9XtOi6K2IdqDnI5+J/ucfAUqTzIu0cGnsTQA5hxljedcwHlDfDFds7In2os
         bLur0fxkuQplDX9al9C+acbi3RyjPa2u3dzupb1KxxJDmFzMspIqmqHZTSiCuFSjhhui
         uCe8QKLDldnE109iJulHQq7z8FFKlfKbogCiMTpP4416lnHmdTAOcZwUSsrqK26Ptfp0
         J+iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=R5LOgnPKdGeIHfFrgT+XpSveceKXxFXO6MGOs0uFkoM=;
        b=AfX+TKwDijrLzldjrPwZfii7qjaZLaGyxj8JvIuzE+Hg3eZVsI+M9SoxroHSTfTAuA
         xHPp8oaJ3egaRZ80udAkYMtBRDnzivoM64pcu4VWEiD1ZyyZGpAUGwvS7ICJCSx+vwg/
         imKsSdDShCj7XVSz4t57OIRTx1x5Wd7/P38r74n1mKoa/5kMGicT4gU5R2wB2omlNNqk
         gXeBB4BBThWcFA/c5Wpvhq/uwSLaPqSNnybcfDiakaMdzWS15pBWeG5cwgV3GrcObFBT
         V/XOmbfI7/xnMmRQGNRZzv76EnB5mrEn26ZTQ9AqV2Qronk0UcphCJj9GnVILqu1gbtr
         LuaA==
X-Gm-Message-State: AOAM530BVa9MUa4JOBJXp94MwrpZmQN0xg6qRQV9fe/9qj0O2E0wbVaw
        4FWPLQtBCQV5iefyRxZL8kNynLknFW0kcg==
X-Google-Smtp-Source: ABdhPJzbgW8A1tBI+R3DVdsuiUftP6HIjzu/wJuaYA4GN887wub7DKP4KdfvNvcix/OclNCCpdZM4A==
X-Received: by 2002:a63:6c09:: with SMTP id h9mr6744273pgc.214.1604782349702;
        Sat, 07 Nov 2020 12:52:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 194sm6521481pfz.142.2020.11.07.12.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 12:52:29 -0800 (PST)
Message-ID: <5fa7090d.1c69fb81.bacc9.c8af@mx.google.com>
Date:   Sat, 07 Nov 2020 12:52:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
X-Kernelci-Kernel: v4.4.241-69-gdc3d1b2b389a1
Subject: stable-rc/queue/4.4 baseline: 123 runs,
 4 regressions (v4.4.241-69-gdc3d1b2b389a1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 123 runs, 4 regressions (v4.4.241-69-gdc3d1b2=
b389a1)

Regressions Summary
-------------------

platform         | arch   | lab          | compiler | defconfig           |=
 regressions
-----------------+--------+--------------+----------+---------------------+=
------------
beagle-xm        | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 2          =

qemu_x86_64      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig    |=
 1          =

qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig    |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.241-69-gdc3d1b2b389a1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.241-69-gdc3d1b2b389a1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dc3d1b2b389a183cf5b93828204c4acd6bfd71cf =



Test Regressions
---------------- =



platform         | arch   | lab          | compiler | defconfig           |=
 regressions
-----------------+--------+--------------+----------+---------------------+=
------------
beagle-xm        | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 2          =


  Details:     https://kernelci.org/test/plan/id/5fa6d7ba65ddd46243db886a

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
9-gdc3d1b2b389a1/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
9-gdc3d1b2b389a1/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fa6d7ba65ddd462=
43db886d
        new failure (last pass: v4.4.241-67-g2727c0277428f)
        1 lines

    2020-11-07 17:20:11.428000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-11-07 17:20:11.428000+00:00  (user:) is already connected
    2020-11-07 17:20:11.428000+00:00  (user:) is already connected
    2020-11-07 17:20:11.429000+00:00  (user:) is already connected
    2020-11-07 17:20:11.429000+00:00  (user:) is already connected
    2020-11-07 17:20:11.429000+00:00  (user:) is already connected
    2020-11-07 17:20:11.429000+00:00  (user:) is already connected
    2020-11-07 17:20:11.429000+00:00  (user:) is already connected
    2020-11-07 17:20:11.429000+00:00  (user:khilman) is already connected
    2020-11-07 17:20:11.430000+00:00  (user:) is already connected =

    ... (455 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa6d7ba65ddd46=
243db886f
        new failure (last pass: v4.4.241-67-g2727c0277428f)
        28 lines

    2020-11-07 17:21:57.854000+00:00  kern  :emerg : Stack: (0xcb8dbd10 to =
0xcb8dc000)
    2020-11-07 17:21:57.862000+00:00  kern  :emerg : bd00:                 =
                    bf02b8fc bf010b84 cb9cc010 bf02b988
    2020-11-07 17:21:57.870000+00:00  kern  :emerg : bd20: cb9cc010 bf2250a=
8 00000002 cb838010 cb9cc010 bf24fb54 cbb89c30 cbb89c30
    2020-11-07 17:21:57.878000+00:00  kern  :emerg : bd40: 00000000 0000000=
0 ce226930 c01fb3a0 ce226930 ce226930 c0859688 00000001
    2020-11-07 17:21:57.886000+00:00  kern  :emerg : bd60: ce226930 cbb89c3=
0 cbb89cf0 00000000 ce226930 c0859688 00000001 c09632c0
    2020-11-07 17:21:57.895000+00:00  kern  :emerg : bd80: ffffffed bf253ff=
4 fffffdfb 00000027 00000001 c00ce2f4 bf254188 c0407034
    2020-11-07 17:21:57.903000+00:00  kern  :emerg : bda0: c09632c0 c120ea3=
0 bf253ff4 00000000 00000027 c0405508 c09632c0 c09632f4
    2020-11-07 17:21:57.911000+00:00  kern  :emerg : bdc0: bf253ff4 0000000=
0 00000000 c04056b0 00000000 bf253ff4 c0405624 c04039d4
    2020-11-07 17:21:57.919000+00:00  kern  :emerg : bde0: ce0c38a4 ce22091=
0 bf253ff4 cbcab4c0 c09ddba8 c0404b20 bf252b6c c0960460
    2020-11-07 17:21:57.928000+00:00  kern  :emerg : be00: cbbc5840 bf253ff=
4 c0960460 cbbc5840 bf257000 c04060e8 c0960460 c0960460 =

    ... (16 line(s) more)  =

 =



platform         | arch   | lab          | compiler | defconfig           |=
 regressions
-----------------+--------+--------------+----------+---------------------+=
------------
qemu_x86_64      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig    |=
 1          =


  Details:     https://kernelci.org/test/plan/id/5fa6d6f8aaf1f8a630db8873

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
9-gdc3d1b2b389a1/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
9-gdc3d1b2b389a1/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa6d6f8aaf1f8a630db8=
874
        new failure (last pass: v4.4.241-67-g2727c0277428f) =

 =



platform         | arch   | lab          | compiler | defconfig           |=
 regressions
-----------------+--------+--------------+----------+---------------------+=
------------
qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig    |=
 1          =


  Details:     https://kernelci.org/test/plan/id/5fa6d72203e80a4da7db8866

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
9-gdc3d1b2b389a1/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
9-gdc3d1b2b389a1/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa6d72203e80a4da7db8=
867
        new failure (last pass: v4.4.241-67-g2727c0277428f) =

 =20
