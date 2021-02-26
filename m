Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374CC32699D
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 22:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhBZVf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 16:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbhBZVf1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 16:35:27 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0B0C061574
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 13:34:47 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id w18so7123275pfu.9
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 13:34:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ybv/kGyMsL9x9RQgctjJwwJDtFECe/RwspAQ/epr0mc=;
        b=ZfQDjp/LAQ0UmzY3VR2nrwFiVAWAqEvkoeiFpvupk9aG+LVSMtE6/Pg8bF6jkgeqM0
         UsmTUYaM/hbvO7ZDAKCecErB2pu3gR3kPBV6g5Vvpk+Vf/7mciIqajUt3VTkQjEuOxTt
         rKfDaI0AgdIDcSngBMu5mCMa5Di6Srdni4YvlBfWfagVlARlQjwAvu+4yK0W4dH3WWb0
         Z2SFl5YVi+truA4oSln6eEQSm181YwdiLuEtzQCRbBJuFRbxF173PzrmLYZbhaD99ydJ
         NCMzY770ZRLdaYctLTo3chlzakTHTSZKCCaXxd3BTnB+Noa9J4V7YcRRFuFAhFaPK5CO
         coag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ybv/kGyMsL9x9RQgctjJwwJDtFECe/RwspAQ/epr0mc=;
        b=DEsL9w5mbs5GqZwASxzThovkRwJeFkv+wjwHTgdWdXucktOCYJxyrveefX0P1eCeqz
         jdl4NyipoEApqi4sk/Wq8eThUTzAzqf7x3BkrZUA+dbPgKpSyfCpPASyCOV0UTuh7bP+
         PnKQCWaSpB80ZZy8wiKV4AMnMsfyT0yIal3gBejk3hxStQbdGTBqaDpaw0pdVhxQcywZ
         LF6kJHKHWXsCfwtVH9C9K2joPsbRKHlVsD1UqUWBP2RszgWsCKII97eLcpG5jN7tnKTi
         KSREErNDup/hSch2/HH4AaPLy06O+xWCQbmcc8X0Ynf2p3dpdSZL4+oIEwYwCC8YYTeS
         /ZIg==
X-Gm-Message-State: AOAM531z6I5diNL1u4MaFHJZ8c9TtzT2Zu6+TX5SY4O2I+dIrUJqmJHS
        ZYz+py7G0JVEmSYenZzqBKu90eQquz8pVQ==
X-Google-Smtp-Source: ABdhPJywIYKWAkBXzdRvjynNe2bOF03DRpUwNegAfSU3AGMCkt8+ksYkd3UoL4m0X4kEUklSq9qEvg==
X-Received: by 2002:a63:a22:: with SMTP id 34mr4590325pgk.328.1614375286846;
        Fri, 26 Feb 2021 13:34:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s15sm10778058pfe.108.2021.02.26.13.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 13:34:46 -0800 (PST)
Message-ID: <60396976.1c69fb81.aa969.893f@mx.google.com>
Date:   Fri, 26 Feb 2021 13:34:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.101-2-gdbf277cedc872
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 100 runs,
 1 regressions (v5.4.101-2-gdbf277cedc872)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 100 runs, 1 regressions (v5.4.101-2-gdbf277ce=
dc872)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.101-2-gdbf277cedc872/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.101-2-gdbf277cedc872
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dbf277cedc8728cdcecf1f424d39950e61f3417a =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6039353f1539fdbb17addcc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-2=
-gdbf277cedc872/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-2=
-gdbf277cedc872/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6039353f1539fdbb17add=
cc9
        failing since 98 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =20
