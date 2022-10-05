Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF4175F4D13
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 02:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiJEAe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 20:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiJEAeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 20:34:25 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CE15A2F3
        for <stable@vger.kernel.org>; Tue,  4 Oct 2022 17:34:24 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 8-20020a17090a0b8800b00205d8564b11so349253pjr.5
        for <stable@vger.kernel.org>; Tue, 04 Oct 2022 17:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=sVL2+b+bOsV8FCmeML47XhXOZNQPT4v/TT1f2O4RMpo=;
        b=qwZ2FuIZa6bwOrRRYE/zkPBr3P4LTcdz6PcLpxTtD/ngr0U3L/jgnzsZxSDL0lBILi
         5WtN4L2+UMavXp9SDWPou4k81Mr2xbPlNdxLgdBpx+Hxvw0AyTMF2dwtYybGbqCLjcI0
         NMfxVmQAF0EO4KtI29y44UuoUv1p7jdWkn5Qc81z3zhpCHgtQh5kgdcimFM0wLdUITrZ
         U0vPXSiNFFmKgRpWvmH+rMTPoamNJ9wVW4CLLRGCdWLptDvfrsGPnigC2XJBIXuYHqVF
         7rOURmar8MWLUchfmD/A5/xEqxsWVYASQa8WbsioZf+R58m0NkgaevYltjfZHYJSORah
         kJTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=sVL2+b+bOsV8FCmeML47XhXOZNQPT4v/TT1f2O4RMpo=;
        b=jmsEZmw/Aub3K+yuItlSoLpIr+HHnk+JGtKVL50UY7lQIFyfaSgU/fxBzO7b8cvQpo
         Wv7AnA7NdfyToiljXNHuhN5+x8VBtCNj+pHaSwA5l+zrVLeQO673DnKpBp83DQ2lr/36
         csy+KIC+R9mUAmwMKHQIJqLn/e01f583b/khMzfdIjMsNW/pziDeCLgpK3TdS8TUkQCz
         kYsjVEZjhNOadoZLryqca3xP3ZQyUz9YRPRbG6C84Px4nmtirg3lCB67djvRq/FdxY1m
         jnY50UIDBPqI+rUBh9UMxWAmcw9Mw1lJl3wg6JiDfng9FAdfu2Zb6RFRa0YDG/fDNI3i
         oUnw==
X-Gm-Message-State: ACrzQf3b32oH/R+6z1nXUMkFRBX1AUryS/2nGZkufYZYuE+0PFeYIM0+
        ndsG5WDivcBKe6q4StzadC2owxYugoGj8Oc9kjU=
X-Google-Smtp-Source: AMsMyM5fJhLdhuJhsnXN1Q3RjHTOWLf4MDecRjfGt1IkVutWWDQtXY4VoKU/EhS5BmtLHRz/s0vmXw==
X-Received: by 2002:a17:902:7794:b0:17f:72bd:74f9 with SMTP id o20-20020a170902779400b0017f72bd74f9mr6267361pll.117.1664930063801;
        Tue, 04 Oct 2022 17:34:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d18-20020a170903231200b001728ac8af94sm9497922plh.248.2022.10.04.17.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 17:34:23 -0700 (PDT)
Message-ID: <633cd10f.170a0220.8bedb.0bf3@mx.google.com>
Date:   Tue, 04 Oct 2022 17:34:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.215-30-ge6505b242ad76
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 87 runs,
 1 regressions (v5.4.215-30-ge6505b242ad76)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 87 runs, 1 regressions (v5.4.215-30-ge6505b24=
2ad76)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.215-30-ge6505b242ad76/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.215-30-ge6505b242ad76
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e6505b242ad765659ed590d2f887565553ed4d2b =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/633c9fd6aa9b6ab905cab5fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.215-3=
0-ge6505b242ad76/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.215-3=
0-ge6505b242ad76/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633c9fd6aa9b6ab905cab=
5fb
        failing since 70 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =20
