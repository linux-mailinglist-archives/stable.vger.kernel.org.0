Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C371A48B8A3
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 21:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbiAKU1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 15:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242786AbiAKU1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 15:27:08 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F1EC06175B
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 12:27:00 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id rj2-20020a17090b3e8200b001b1944bad25so860997pjb.5
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 12:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TnOY316Kmi8lKmu3OaT+AD8IpMMNwp29AWGXwoFwo8o=;
        b=APRRwyVqjk5+M7C40/6Ae9lcvvl5L5AuVCnn+YLGQS9io0NfdJKl+QitVMaUGt6tIi
         6Gj3P9zaDzVatArZaRZtO4ZDtx9RwfGzutK86V/6zXZEt0ZziHkreYNd3iBjrg30PfKL
         VmxKp4VkH4Zrc8FBSScZJbq6d8GgbVEwkwE+xmQgJf4Iw5w/fHFMBBixf03fDg/RJKGY
         oFz23Ep0UTiSK7EmfNUv6UuG/xn0vDoT4ct5m261gwgWFV+glS0LHwV3KjjpOeSbiNg6
         yFYJhZ8HWQBHbPZgific/xRAol6Ca5xPVF+Ev9i8UNQQWolYvBZWj7m5Ab7lPeU5APmv
         /axQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TnOY316Kmi8lKmu3OaT+AD8IpMMNwp29AWGXwoFwo8o=;
        b=qfjuCD1k22gchpmhhXJbMM1Uh+hMUJXBnBcCay3KLqeylFKVqJp4RWOTy43J+t/Ui2
         uhqKso4pCGp9jV0nfHPl2GXp6vxMy8lc3daMxlmiuZxJ7FzEyZvKu/w+H6gSQXPvTsj5
         5WblP5MBnMjZANBKJqDITrqshr5tuzeBHay0XNhpfD8pj8qusMjJlkq31nxD15Pbt9sF
         WRRb8I39Alk7vus5uQiHmxhjwLdmgXAaorhdoPYcNSLVIR8kf9gjdXHpBRiqDqav7h1S
         Oz34R849yrvShzHdKmq7mvblP4V+B5y4eQpJbvYnomMQx9l5evBhc8TJxG1XC7zEiX/E
         ncbw==
X-Gm-Message-State: AOAM531X8AvJMqplZtSr3Rnvp5+BccmB1c0DVDH2QGIpm3tf5E1DEneT
        46ZgM5KWt0bNAck336wZae+6h0bZCMwkkSLb
X-Google-Smtp-Source: ABdhPJyR/MHWP9wjZuxK/I50Gr4cNG5SZKENQu+u9RsZbcJvKx9kzPeNL1PtUDR+qjp917t2Xm7LDw==
X-Received: by 2002:a17:90a:b281:: with SMTP id c1mr5076793pjr.221.1641932819720;
        Tue, 11 Jan 2022 12:26:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w13sm213999pgm.5.2022.01.11.12.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 12:26:59 -0800 (PST)
Message-ID: <61dde813.1c69fb81.960bf.0e3f@mx.google.com>
Date:   Tue, 11 Jan 2022 12:26:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.225
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 174 runs, 1 regressions (v4.19.225)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 174 runs, 1 regressions (v4.19.225)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.225/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.225
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      5e0cdb245b7c83cfa2939071bf0cb7a2ecd31abe =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ddaf5d8190dd2067ef6740

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.225/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.225/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ddaf5d8190dd2=
067ef6743
        new failure (last pass: v4.19.224)
        2 lines

    2022-01-11T16:24:44.827552  <8>[   21.306762] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-11T16:24:44.878172  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2022-01-11T16:24:44.884166  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
