Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C74547F52D
	for <lists+stable@lfdr.de>; Sun, 26 Dec 2021 06:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhLZFSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Dec 2021 00:18:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbhLZFSG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Dec 2021 00:18:06 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4108C061401
        for <stable@vger.kernel.org>; Sat, 25 Dec 2021 21:18:05 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id f8so752346pgf.8
        for <stable@vger.kernel.org>; Sat, 25 Dec 2021 21:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TBkzGdTP7kxGy/54eptBvhHIDAB9Rt940Wx7xtTVCxQ=;
        b=0oSXpVcWMLd3s9/qzT5xQcYsVVeEowFkagqf6XjaVDUH+KOqMX3PwTbXIIdHrwvhH5
         M0M1ybQ0vKuPJKak7uMyW8njumYvs7laHu/zi55DSl5x/XV6WNxgXngK/NEbXoJsLGHp
         iE2KIP6I+W7w2CVltti+h2V73gmV9/P9NMR7xUXzGQ1pEDp0VVrMyuk+gK1KrOMqE8p0
         sE8bMc3YIQkWZsv3kjCZGwkrwWXG09FdeJqFxtBU7Jhsw5Cz65jMvyOgJDPhcRqM6QUz
         /rEAmnZ6ZMmOyWx0oBIR81stYXN+RWm2xcu7LopyGtlVnqy8M5JPvd6qsKPoHXfn+WEP
         XMLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TBkzGdTP7kxGy/54eptBvhHIDAB9Rt940Wx7xtTVCxQ=;
        b=llQP9fYd4Q/60UtmEFvI4rfZE/wmVuJRssxXPGWmjyr9u0GzgjI4dETFzN6wHxx14h
         ur1OXDSQGbwje0bKDBp0x+2bxd4W4SIilohcxf80ndb4JZKPBp0ZVTHogWo21HbYHf3Q
         yyQ50T6o5PqEaMuB+36LKouHv6yXC0xRma/I1luanLGMfdNWVWUdFNv6cEqEaa2FN8Xj
         cM6aslaSLFlCkAB7XqYtD/sl3/Pmnt+414cocrDwXM2LI9/BUmAEE5USuQZ5WkehZTD+
         8/vn0/AY3XI+elo/8x22fwKMjmWkjaXsw1WdQMMZJV1PQr7gFO9/lFE1eMDb2y4Fsxv2
         bdmw==
X-Gm-Message-State: AOAM533icvdPjpu12N+j5Fb7ffSDlPPLzxg3B/qTTF9rdKTn9son5H2C
        1I2k+Ygyk1DA5jy/u3GQC1nrRhIM05bliUfc
X-Google-Smtp-Source: ABdhPJxe09/0HHvGrt2e9v32Pz4k3okQgdhPhGfCD8oPho0GUjY4p6YA0tgMOKscmIDjpBkdpV8lyw==
X-Received: by 2002:a05:6a00:1a4f:b0:4bb:113a:677c with SMTP id h15-20020a056a001a4f00b004bb113a677cmr12786698pfv.63.1640495885349;
        Sat, 25 Dec 2021 21:18:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o17sm10803992pgb.42.2021.12.25.21.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Dec 2021 21:18:05 -0800 (PST)
Message-ID: <61c7fb0d.1c69fb81.4239f.f7cd@mx.google.com>
Date:   Sat, 25 Dec 2021 21:18:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.88-27-g01a20d2f2f31
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 217 runs,
 2 regressions (v5.10.88-27-g01a20d2f2f31)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 217 runs, 2 regressions (v5.10.88-27-g01a20d=
2f2f31)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-10   | defconfig+=
arm64-chromebook | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.88-27-g01a20d2f2f31/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.88-27-g01a20d2f2f31
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      01a20d2f2f3187c6ecb4bf40413ab277191a28b0 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-10   | defconfig+=
arm64-chromebook | 2          =


  Details:     https://kernelci.org/test/plan/id/61c7c3dbf83209cfc139713d

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.88-=
27-g01a20d2f2f31/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-meson-g12b-a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.88-=
27-g01a20d2f2f31/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-meson-g12b-a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61c7c3dbf83209c=
fc1397141
        new failure (last pass: v5.10.88-8-g724ee70700b6)
        7 lines

    2021-12-26T01:22:23.763761  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address 0053b00000000000
    2021-12-26T01:22:23.764002  kern  :alert : Mem abort info:
    2021-12-26T01:22:23.764175  kern  :alert :   ESR =3D 0x86000004
    2021-12-26T01:22:23.764328  kern  :alert :   EC =3D 0x21: IABT (current=
 EL), IL =3D 32 bits
    2021-12-26T01:22:23.764505  kern  :alert :   SET =3D 0, FnV =3D 0
    2021-12-26T01:22:23.764649  kern  :alert :   EA =3D 0, S1PTW =3D 0
    2021-12-26T01:22:23.764790  kern  :alert : [0053b00000000000] address b=
etween user and kernel address ranges
    2021-12-26T01:22:23.891043  <8>[   22.731764] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D7>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c7c3dbf83209c=
fc1397142
        new failure (last pass: v5.10.88-8-g724ee70700b6)
        2 lines

    2021-12-26T01:22:24.205976  kern  :emerg : Internal error: Oops: 860000=
04 [#1] PREEMPT SMP
    2021-12-26T01:22:24.206214  kern  :emerg : Code: bad PC value
    2021-12-26T01:22:24.361275  <8>[   23.201221] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
