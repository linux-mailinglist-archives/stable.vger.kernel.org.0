Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E73A4860EA
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 08:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235250AbiAFHP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 02:15:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234429AbiAFHP7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 02:15:59 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1770C061245
        for <stable@vger.kernel.org>; Wed,  5 Jan 2022 23:15:58 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id g2so1839032pgo.9
        for <stable@vger.kernel.org>; Wed, 05 Jan 2022 23:15:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=a7lghVAOeEc8zEsoTR0YPlzi11VTOU7n+1ZzzUcz9Xs=;
        b=Yb+zVF/uKPrpGTaaPpljL8LKZSByVK8a7+tNqk2BkjuVcG3iIjEUPTAo8qzoGzeMQ8
         Om4jrFDzjezknUYoj+ouWSzLseF0F/TTP7LmfL67+8EVaC76P+CIOto5I/FM09bMb1I4
         FWuBUfdE85fVU6wkLlgWH9Yt7n4gXnO9MKxSByFMAh5cQ0csrB+Fytv9GtKE++dYLwN0
         1uMiiKPauntce4wWkkim32AWY8tI0G6me0NWnkKYXmXqUkE/zJP5vbCiwz6DCoyENiwk
         LJohkhk+salyvJJTHReUqwlZpTMx1seP2rTC0Vd+X9EucaFyNHCyhvDJ662HFJQSo6wu
         umgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=a7lghVAOeEc8zEsoTR0YPlzi11VTOU7n+1ZzzUcz9Xs=;
        b=y4X2H7X2A7MCZtHcbHIzDUvQA6hEXj5G2khN/kPbXuBRSZbE29OQffR30CkmWmR7ou
         Zqkd7cdP9laPuD3LEmXj8CPWugL23COjqgVF1vdL7ftGQ0NjJzUAcCbGgcFDvYmmhq52
         ijomBcxNymDIx67XgXTf/YgIMK7ohdkD5D0IC5XyiQ1NvnbGUNZY6gI9NFxCPZyE/Rb5
         yVFDPmN9dQTNXUBifWYS0JCejd7cYSrOu0g7zUyYQ+NPF32EfYfbR2Jf/X5JmQYonOrU
         QfEstV7zIiOFXntqYGO2CMVzK8mW0kzB8gzA3uCGc8RO3cCjFloaeaRs0VMJs0pW6aMb
         ipMQ==
X-Gm-Message-State: AOAM530vfmuyifpjcoqea8ZBsZycUu+xM09mRM+ww8qA5ohLnc48Scid
        Ee7GampOvHmMld037KD29OEHi9Ug+KHjZmyf
X-Google-Smtp-Source: ABdhPJwQxUmHi7JvK8feysqhvOHglJ/gmictHNUesX2dpDuHCJnZzZ10udwM8uZbadqqfLQDSD7RZA==
X-Received: by 2002:a63:87c2:: with SMTP id i185mr50554201pge.294.1641453357727;
        Wed, 05 Jan 2022 23:15:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l11sm1272208pfu.115.2022.01.05.23.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 23:15:57 -0800 (PST)
Message-ID: <61d6972d.1c69fb81.78fe.3afc@mx.google.com>
Date:   Wed, 05 Jan 2022 23:15:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.296
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 131 runs, 2 regressions (v4.9.296)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 131 runs, 2 regressions (v4.9.296)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-10   | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.296/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.296
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      710bf39c7aec32641ea63f6593db1df8c3e4a4d7 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-10   | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/61d665064a95ddf224ef675f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.296=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.296=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d665064a95ddf224ef6=
760
        failing since 1 day (last pass: v4.9.295-14-gc154c6cb3efd, first fa=
il: v4.9.295-14-gf0356246206e) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61d663f37bde8522bcef6758

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.296=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.296=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d663f37bde852=
2bcef675b
        failing since 2 days (last pass: v4.9.295, first fail: v4.9.295-14-=
g584e15b1cb05)
        2 lines

    2022-01-06T03:37:06.430115  [   20.187835] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-06T03:37:06.471945  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/116
    2022-01-06T03:37:06.481227  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2022-01-06T03:37:06.496395  [   20.255920] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
