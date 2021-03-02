Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799F332AECF
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235885AbhCCAGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347859AbhCBGqr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 01:46:47 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AE8C06178B
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 22:46:03 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id t9so1268276pjl.5
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 22:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8pllo4DdAbROCXti6Saf5BTUq1RAHkYJLD1LyIkd1Fc=;
        b=li9KFpc5+sH63aUhm/KwZnuPQOn4H798+KCS+o42jhPnz2K5ea7BAYt6wHo2LOufL+
         T8J7qL2qe8a/BK7G4uDGLhPLBN3EQFQm/NKmd57EoGS3Hag82to7kO36f1avh5CbQ5A1
         vL1LGo0zNJY191tVORGj2LjqqyZK2Jg/YrZ40JYQUXnTunRBW5mkKaJC7nt3ZH9DJMDF
         FVcctzfXB3SGZ8W0IXpviANE7f/LmbHAZhBEMmBoArs2GrsPFUFxPCiNRsrdd8JEl055
         hwhdk4QGMeXN9MtkDeXmZLd1KQBNkctHfFaIFVTgYJivqZYXR7VZq3dV0dAnyP7G9ncr
         Rr8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8pllo4DdAbROCXti6Saf5BTUq1RAHkYJLD1LyIkd1Fc=;
        b=iluBwxX5ExqIaP9ZJ7U0e64npDdYFsZXTFmBFkblgO3xzMiGqLwqG7uqcYa72lMNAB
         bcxH8ZSS8ve7cIbOjlkfniXlm+Yqerx8eBx6ux7x674Jg9gKtJBcpBbaMh4gyD2GC5or
         eIPkuI8uQkvK40sHRVssTWwSy9vI4hs6CigvxP3EDOtKuBaZyqZ9gAR8pCFejTsOjQsy
         ++htxtss87IfJ82fq0NB2FixO5n+bOfJQd0yoTEK1jBaV9rs2mVpB3XztDUm5gCx3PfP
         msQOX9Y6qSS++ZW4FNtynTjEbNFFQAwIsaoN/ET/lf9g9JN/+5UfMlIr/NzEKE5hg7Mq
         OzuA==
X-Gm-Message-State: AOAM530dsGA2ZnXAqjzy2LNl2q/F5M+KOhCU2nLsuA30mW4S5YgU7wfj
        3WXoq8xc/+CHGEQC5biTcDCfcq1oMqxcfA==
X-Google-Smtp-Source: ABdhPJyef70E0Z9f/rFmcMK/vK4YRTfgYJKTw2b//hk35JjUOd5HrYVjU137q5qcdytAVYwS7ONXbg==
X-Received: by 2002:a17:902:a985:b029:e3:8796:a128 with SMTP id bh5-20020a170902a985b02900e38796a128mr2065466plb.81.1614667562316;
        Mon, 01 Mar 2021 22:46:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v1sm1740648pjt.1.2021.03.01.22.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 22:46:01 -0800 (PST)
Message-ID: <603ddf29.1c69fb81.983c9.4ce7@mx.google.com>
Date:   Mon, 01 Mar 2021 22:46:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.101-338-g7730b625139f9
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 151 runs,
 2 regressions (v5.4.101-338-g7730b625139f9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 151 runs, 2 regressions (v5.4.101-338-g7730b6=
25139f9)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.101-338-g7730b625139f9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.101-338-g7730b625139f9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7730b625139f970962ef543ee38b528aad563576 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 2          =


  Details:     https://kernelci.org/test/plan/id/603dadaa0be37b4e62addd23

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
38-g7730b625139f9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
38-g7730b625139f9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/603dadaa0be37b4e=
62addd26
        new failure (last pass: v5.4.101-282-g43a77c32683b6)
        1 lines

    2021-03-02 03:13:42.749000+00:00  Connected to meson-gxm-q200 console [=
channel connected] (~$quit to exit)
    2021-03-02 03:13:42.749000+00:00  (user:khilman) is already connected
    2021-03-02 03:13:53.950000+00:00  GXM:BL1:dc8b51:76f1a5;FEAT:ADFC318C:0=
;POC:3;RCY:0;EMMC:0;READ:0;CHK:AA;SD:0;READ:0;0.0;CHK:0;
    2021-03-02 03:13:53.950000+00:00  no sdio debug board detected =

    2021-03-02 03:13:53.950000+00:00  TE: 311720
    2021-03-02 03:13:53.950000+00:00  =

    2021-03-02 03:13:53.950000+00:00  BL2 Built : 11:58:42, May 27 2017. =

    2021-03-02 03:13:53.950000+00:00  gxl gc3c9a84 - xiaobo.gu@droid05
    2021-03-02 03:13:53.951000+00:00  =

    2021-03-02 03:13:53.951000+00:00  set vcck to 1120 mv =

    ... (562 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/603dadaa0be37b4=
e62addd28
        new failure (last pass: v5.4.101-282-g43a77c32683b6)
        2 lines

    2021-03-02 03:14:39.971000+00:00  kern  :emerg : Code: f9401bf7 17ffff7=
d a9025bf5 f9001bf7 (d4210000<8>[   16.331707] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2021-03-02 03:14:39.971000+00:00  ) =

    2021-03-02 03:14:39.971000+00:00  + set +x<8>[   16.341096] <LAVA_SIGNA=
L_ENDRUN 0_dmesg 775150_1.5.2.4.1>
    2021-03-02 03:14:39.971000+00:00  =

    2021-03-02 03:14:40.077000+00:00  / # #   =

 =20
