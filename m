Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948234C5317
	for <lists+stable@lfdr.de>; Sat, 26 Feb 2022 02:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiBZBnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 20:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiBZBnM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 20:43:12 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA8E24F5B6
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 17:42:35 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id s1so6165730plg.12
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 17:42:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=P0nr4dUPz0VDv6e/bhCnAqVuw420EtT0pnarMTMsHEw=;
        b=RIeOMQ0H1vjXvFf2HPWV2oQmzI7Sqr/k29pdkTiBrLnAlFU04EsM7mKIDjHEzxkp5U
         FChQtUGtR/WSzhsFlVYduwSgMS9Fq3QniyKljiJgD87Gy8mjeDxL4QmWURxEjyqciGzn
         mqpnlhuRIm7TXt29a0el8HXxSfJ1PWUDqZL7nGoaCCGhekRWYR1vxJ3jf0L8VqRhDoQL
         j5IapfXvwey3S9eV7hp7r3875nRRo66pkqGa362M0OuhaklvbNTH6aA7jMJYUzKMpRJz
         kSczhvrNTGpzknzMvCs2Go4LggFjX3Q0UN07PvBEQeQ/ANyC1ju9Lv/3PPEl5k0wjpNr
         vL8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=P0nr4dUPz0VDv6e/bhCnAqVuw420EtT0pnarMTMsHEw=;
        b=xj35VxXNLOvaStodwpXMffJIG15PjtUjDkU5S/OzzD8HJQSXGQdsuHWYbM4EmPtdF8
         Axucv8l5TyPuHBIo/XmhcsbokniikhzrpHvtBPHpQl6FYyqw7bqyEFOH7z4bup/0CCJ9
         IUeVEG0NS3A/RVB4sjJt7uUmALgAk2jyxuilX+EtuSJNvbmY/dNG6wdFs6XOS1OtHW3X
         3fA/OnIf1Qz54Tk8s5lZEtMzgRDCtRrFedTh4Z5xrig9nK6OxmkDHNcZRRVFHfD8VF3+
         VQjpLofnKtn/JcimTPC5LtybTT6qw+W+V51UVrfFSI6qP5+OQv2Rp8UzQ1WvP/vXVTLJ
         yfIQ==
X-Gm-Message-State: AOAM531GrtWJo6wR0rW+HiIbakeSvOyLiBuVgq6kQ5+Pnuagi/7iOA4K
        hb30PSXKo8KGlKI7eekS6zMvR/rfRFPB1dsaxrA=
X-Google-Smtp-Source: ABdhPJz9rH12UiU/v3qUavKSV8Bej52z6HqGQKmfbf0gJwO812gu0ufp2s/t+z9Hejj9kF2Goig6vw==
X-Received: by 2002:a17:90a:4604:b0:1bc:8bdd:4a63 with SMTP id w4-20020a17090a460400b001bc8bdd4a63mr5857980pjg.147.1645839755059;
        Fri, 25 Feb 2022 17:42:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k12-20020a056a00168c00b004e15818cda3sm5102850pfc.114.2022.02.25.17.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 17:42:34 -0800 (PST)
Message-ID: <6219858a.1c69fb81.ade95.e23a@mx.google.com>
Date:   Fri, 25 Feb 2022 17:42:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.268-13-g1e51fcf5c2ca
Subject: stable-rc/queue/4.14 baseline: 74 runs,
 2 regressions (v4.14.268-13-g1e51fcf5c2ca)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 74 runs, 2 regressions (v4.14.268-13-g1e51fc=
f5c2ca)

Regressions Summary
-------------------

platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
meson8b-odroidc1 | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig  | =
1          =

panda            | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.268-13-g1e51fcf5c2ca/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.268-13-g1e51fcf5c2ca
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1e51fcf5c2ca1a4bb27e43bd6765bacbecefc0ef =



Test Regressions
---------------- =



platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
meson8b-odroidc1 | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig  | =
1          =


  Details:     https://kernelci.org/test/plan/id/62194e065f41d1432cc62968

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.268=
-13-g1e51fcf5c2ca/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.268=
-13-g1e51fcf5c2ca/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62194e065f41d1432cc62=
969
        failing since 12 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =



platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
panda            | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62195087fc8be9b897c62998

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.268=
-13-g1e51fcf5c2ca/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.268=
-13-g1e51fcf5c2ca/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/62195087fc8be9b=
897c6299b
        failing since 7 days (last pass: v4.14.267-16-g29c6a7cc89b2, first =
fail: v4.14.267-19-g5de9d8e4b432)
        2 lines

    2022-02-25T21:56:08.165127  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, kworker/0:2/52
    2022-02-25T21:56:08.174215  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
