Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720C34A7C25
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 01:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239658AbiBCAA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 19:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234065AbiBCAAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 19:00:25 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178DAC061714
        for <stable@vger.kernel.org>; Wed,  2 Feb 2022 16:00:25 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id e28so714332pfj.5
        for <stable@vger.kernel.org>; Wed, 02 Feb 2022 16:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Jvpfc8TyBSdMlZWaRLW7PZXxH+/R86zzokSSkJDVc3Q=;
        b=YF++wtnFfqrTlucjGe4GHTZ3Eq9vUvpe3DP2luG+Es5ilC1HuyhE52uT9S7b3UjirP
         mTMl8L9aSVWi+DfUKzhazCnCO/YeqSZw2wxHRr8XU88w6pntl18n8EoYxoC/s8umh4Ij
         f6bkTaAu0o4ww3H69H2wsxBVGLifs4YrtrpyLSIDHhxJLGG0+cCALX97KwqDtZyge0Jo
         XIWtmgBxFUeGA5QHtkkYSYef4f8h65ZXVTMNFsdkOQkmDx1ynXoqUqfsvAar6SPnmfIX
         yUkA72Pql6Ou9qhzJWmcRPt/5u0M2bCewpBeokEi4eBA1qkK78VAtvdJioSMPHsyzARx
         s6jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Jvpfc8TyBSdMlZWaRLW7PZXxH+/R86zzokSSkJDVc3Q=;
        b=Q5joSU70YuWKuwHbeg7jHbn7k2ypUArA+DmZy0U/5ujHY7aTr5czYMWSVN8ZZpUoLF
         HUnvbw3Zv9Kkp+LNuiy6iz5DrNTiC30MDMbWIq1DoiXfMZx4RhMx5vUaDgxdh5XCmivU
         QaQ9SVADNXUl73dcsrAy2AAIwwm0KRTa28Jtu55C/Kht7amcS1oZuBr9iGohlwh6osqE
         hOcaqOGmGSMstUyefbAdmU9yimnqsPQBLuoBzxeedpwPqJhkd3yzuvDtw5Gxvi67SYYM
         ejTTQjkG7GcKNP+4QsCCnIB4reAjikgoPNklWsRdqXFeEVG1283ouhDNqEB66WccnZ6Q
         zASw==
X-Gm-Message-State: AOAM532+DDfGFY4GEzzaemXEkGrxycRycCpQh3Z4+38vhhq7TfsrDuUC
        Wd//13NT7EIiNl/JKrvctXI4vlN/LW+aLZg2
X-Google-Smtp-Source: ABdhPJyMlOwZIfmeHJ853Ygy/+rcKXU7V46vZvxJYww+rMi/+M6+BoKp6XsNNXoi09VOUDTyd1otqw==
X-Received: by 2002:a63:8641:: with SMTP id x62mr26039184pgd.293.1643846424338;
        Wed, 02 Feb 2022 16:00:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k22sm28536658pfu.210.2022.02.02.16.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 16:00:24 -0800 (PST)
Message-ID: <61fb1b18.1c69fb81.d2bb3.9d96@mx.google.com>
Date:   Wed, 02 Feb 2022 16:00:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.301-26-ga0d361cdb5d3
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 122 runs,
 1 regressions (v4.4.301-26-ga0d361cdb5d3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 122 runs, 1 regressions (v4.4.301-26-ga0d361c=
db5d3)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.301-26-ga0d361cdb5d3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.301-26-ga0d361cdb5d3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a0d361cdb5d3a94204a051883dc74dc43523dbdc =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61fae8ffbad7a5baa35d6efc

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.301-2=
6-ga0d361cdb5d3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.301-2=
6-ga0d361cdb5d3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61fae8ffbad7a5b=
aa35d6f02
        failing since 1 day (last pass: v4.4.301-21-gf1b3a01fec55, first fa=
il: v4.4.301-21-g4b4eb3554fea)
        2 lines

    2022-02-02T20:26:17.690708  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/123
    2022-02-02T20:26:17.700228  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-02-02T20:26:17.715664  [   19.137023] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
