Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D6A2B3CF4
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 07:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgKPGUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 01:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgKPGUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 01:20:13 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA58C0613CF
        for <stable@vger.kernel.org>; Sun, 15 Nov 2020 22:20:13 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id e21so12303802pgr.11
        for <stable@vger.kernel.org>; Sun, 15 Nov 2020 22:20:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PnaPXpSuEjFZuwGErLxd7RjY+z+HgJB+ugmEVNcs3mE=;
        b=Ia6FL45UEPN7WkyXqK1R9f32+pgUyCED3djHuJclzSVgepCxcc89lqFCHuWpBPQBlS
         Bq8EeuG9BESjW+tPcLOiWY2KSygncUsllUN843SA+GasH8yBK9gDvUwk2BhCJkSJ5ZTI
         vhvCkBeQhxGcOCcEKbJ+50zTr7ZhnVwC1N/Ku/YbEwbrsTNA85EKg6vH5mhrRo6Nsg26
         Wu+5TcYR6VRPMA+XHBKdSOtuO/F1O0++LjRqrkTzFEK7Lnqqds80r3ZdZrsC4xKEE6u8
         zoGCi/CLAUnzggWnhqN1MrliKgYCjFKP39UemFnaDHRBnUnG8rTfSDThu/MdxSmHNb4k
         57xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PnaPXpSuEjFZuwGErLxd7RjY+z+HgJB+ugmEVNcs3mE=;
        b=niez7/rPBPa2h1ZveG19GY2P0Bkm8JBaDFpcZRKzPAqxSITQI/4d6f97VpxLjBNugn
         0/SYE0k7Izr7L3vUKy6zkhvvxYkUfJpQEBya5GeXwq9AYqoNwmJB8QWwEA0BnNphRHhf
         2mEnyiX3zVeshMu35J2fjtY2/8HSQ5cS95hs8E+J8XqOYZhD139PwjCxYPcG/+Lu7Dzt
         eS321lUkhIsP364Gt0Kb6rzTSLVPyxmCBUPFm5uL8pgSKBwDlslXkC8rqyRzQO1eIl6q
         pApU0WQVkTk/JRM2UMtJYHB1OSWNxatheYwPieG9fsnSq1q2Ikk9aAsIwYmErDKybgGR
         r1EA==
X-Gm-Message-State: AOAM531xfk1IJBbBzjSN3H2L255cr+jK2VxIHW/hYlr3qUvHgskmb4H+
        Hdl9AZ9ByeftSU8gNAJ7UyCre4NzelEDFA==
X-Google-Smtp-Source: ABdhPJz8Y9WvtZOEcZyowwBVo//jst31xCM2mj90Efk31QzkCMM/bd6/JP4G11KxHcnjV9PvnKW34g==
X-Received: by 2002:a62:158f:0:b029:18b:79b6:1f66 with SMTP id 137-20020a62158f0000b029018b79b61f66mr13030400pfv.46.1605507612161;
        Sun, 15 Nov 2020 22:20:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z17sm14937706pga.85.2020.11.15.22.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 22:20:11 -0800 (PST)
Message-ID: <5fb21a1b.1c69fb81.dbe70.08dd@mx.google.com>
Date:   Sun, 15 Nov 2020 22:20:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.206-33-g99cf73992291
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 1 runs,
 2 regressions (v4.14.206-33-g99cf73992291)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 1 runs, 2 regressions (v4.14.206-33-g99cf739=
92291)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig             | regre=
ssions
-----------+------+--------------+----------+-----------------------+------=
------
da850-lcdk | arm  | lab-baylibre | gcc-8    | davinci_all_defconfig | 2    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.206-33-g99cf73992291/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.206-33-g99cf73992291
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      99cf73992291b24d13a83fb360b7f940d411f73e =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig             | regre=
ssions
-----------+------+--------------+----------+-----------------------+------=
------
da850-lcdk | arm  | lab-baylibre | gcc-8    | davinci_all_defconfig | 2    =
      =


  Details:     https://kernelci.org/test/plan/id/5fb1c7b288d00690e679b897

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-33-g99cf73992291/arm/davinci_all_defconfig/gcc-8/lab-baylibre/baseline-da8=
50-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-33-g99cf73992291/arm/davinci_all_defconfig/gcc-8/lab-baylibre/baseline-da8=
50-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5fb1c7b388d0069=
0e679b89d
        new failure (last pass: v4.14.206-22-g2ec7a9bf443b0)
        3 lines

    2020-11-16 00:28:29.987000+00:00  kern  :alert : [00000000] *pgd=3Dc309=
7831, *pte=3D00000000, *ppte=3D00000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fb1c7b388d0069=
0e679b89e
        new failure (last pass: v4.14.206-22-g2ec7a9bf443b0)
        37 lines

    2020-11-16 00:28:30.157000+00:00  kern  :emerg : Process udevd (pid: 69=
, stack limit =3D 0xc30a2190)
    2020-11-16 00:28:30.157000+00:00  kern  :emerg : Stack: (0xc30a3bf0 to =
0xc30a4000)
    2020-11-16 00:28:30.157000+00:00  kern  :emerg : 3be0:                 =
                    c30a3c24 c30a3c00 c024d954 c046003c
    2020-11-16 00:28:30.157000+00:00  kern  :emerg : 3c00: c7ef1dfc c5e481e=
0 c3360340 c345dbc0 00000000 c024e870 c30a3c64 c30a3c28
    2020-11-16 00:28:30.158000+00:00  kern  :emerg : 3c20: c024eb7c c024d90=
c c33a9ac0 00000008 c33a9b20 00000001 c30a3c64 c345dbc0
    2020-11-16 00:28:30.200000+00:00  kern  :emerg : 3c40: 00000000 0000000=
0 c33a9acc c3360340 c3360320 c3360300 c30a3ca4 c30a3c68
    2020-11-16 00:28:30.200000+00:00  kern  :emerg : 3c60: c024d0d0 c024eaa=
4 c05dc9e4 c33a9ac0 00000000 c04fc748 c00d461c c05dc9cc
    2020-11-16 00:28:30.200000+00:00  kern  :emerg : 3c80: c78c9410 c78c941=
0 bf2c970c 0000000a 00000001 00000028 c30a3cbc c30a3ca8
    2020-11-16 00:28:30.201000+00:00  kern  :emerg : 3ca0: c024d27c c024ce4=
0 c78c9410 c33a9aa0 c30a3cdc c30a3cc0 c024d2e8 c024d1f8
    2020-11-16 00:28:30.201000+00:00  kern  :emerg : 3cc0: c78c9410 0000000=
0 c33a9a60 bf2c970c c30a3cfc c30a3ce0 c02cbed4 c024d2c0 =

    ... (26 line(s) more)  =

 =20
