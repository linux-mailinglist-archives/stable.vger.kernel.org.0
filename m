Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E82365398
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 09:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhDTHzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 03:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhDTHzA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Apr 2021 03:55:00 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D798EC06174A
        for <stable@vger.kernel.org>; Tue, 20 Apr 2021 00:54:26 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id e2so14918429plh.8
        for <stable@vger.kernel.org>; Tue, 20 Apr 2021 00:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UaiF7disJxiSpnh5PkAj6KrpLB8rsFL45b39Kl3pGIM=;
        b=FklaK93xL4k3TVZc+beS9p93Y8mHyYbypz9ZkuVnaheAlRLh4Dz3xYAStAG5ul5Cn8
         y6i5t6zRxlHfuta92ojNb/DEOqeTR04vPompbyrfJECti58XFzkDxaEvQumUmQracGqi
         nDxaBkgU+J51IpNG28J4mShEtwUY2tZLxbZoa22Pmvn494jEvsxCdzn06edV7pjo3LIo
         o3rJsBRY92RrPZgr9CkSDThDoMxn4s61l2bR7SyQcPwUvdatRH53Yew292w2yBRckEtc
         nrrvf7VSrdNYycff7NFjDpvlOAlpNZJCgs3eKylpg7IbK47RjXsEUJlS/Ng7EM7TvQH4
         Zjqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UaiF7disJxiSpnh5PkAj6KrpLB8rsFL45b39Kl3pGIM=;
        b=Wt9uloufZ2xP5Y2/qo0iKrJD5zQgV+rPBk2BxxeaVpfGvBsW9Hv/Qohu528m69Uz9W
         J528g9KPwrs7yyDxDNUpMkmLmvPJotjKZG3uc5dD6N0NS0IvMCde034YEFY/vKIVLIba
         MPXrtOhH5cAgY+eEcQWIlOim2nNQB+VgESVesJmqycd5xV4UAVSG4ski0aaFFvp+Pt2M
         DqOyXqWEhmEka5TXm9jvpoSlBrTnaslJfOrHPACTGl6QAzFi+Laneb9fwach5J8xzMQ1
         Oi1ziMvJNn6ezp29ndl+RKmkvK87BZfetTJmHBaHMCWm0+tj8IeRZkOl1XxZEudlbIbt
         i91w==
X-Gm-Message-State: AOAM5333kBmI75PAMx/+X/MCHyu7bQOQOS/ZA2TGztNlhisbpP1xp3No
        HNdf2EJSsjmc0ngXNKluhg0PQaGQeCPrUCgT
X-Google-Smtp-Source: ABdhPJw7GmfDycge3pJRU0WU/eD8FBqz4eu59AWNMH4QyI5JbCgOVLoFpdfBLs5B8uXq7S3VIv4EEg==
X-Received: by 2002:a17:90a:cb10:: with SMTP id z16mr3563477pjt.106.1618905266258;
        Tue, 20 Apr 2021 00:54:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 132sm10324766pfu.107.2021.04.20.00.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 00:54:26 -0700 (PDT)
Message-ID: <607e88b2.1c69fb81.860ae.a266@mx.google.com>
Date:   Tue, 20 Apr 2021 00:54:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.31-104-gbcedd92af6e5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 146 runs,
 2 regressions (v5.10.31-104-gbcedd92af6e5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 146 runs, 2 regressions (v5.10.31-104-gbce=
dd92af6e5)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.31-104-gbcedd92af6e5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.31-104-gbcedd92af6e5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bcedd92af6e5899132429d20a9322b12afec2188 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
          =


  Details:     https://kernelci.org/test/plan/id/607e54b059ea2a94219b77a1

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
1-104-gbcedd92af6e5/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm28=
37-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
1-104-gbcedd92af6e5/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm28=
37-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/607e54b059ea2a9=
4219b77a7
        new failure (last pass: v5.10.31-86-g6e26851a4e8f)
        4 lines

    2021-04-20 04:12:10.100000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00<8>[   14.247584] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>
    2021-04-20 04:12:10.101000+00:00  0002c0
    2021-04-20 04:12:10.102000+00:00  kern  :alert : pgd =3D 99efe3c5   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/607e54b059ea2a9=
4219b77a8
        new failure (last pass: v5.10.31-86-g6e26851a4e8f)
        67 lines

    2021-04-20 04:12:10.148000+00:00  kern  :emerg : Internal error: Oops: =
17 [#1] ARM
    2021-04-20 04:12:10.149000+00:00  kern  :emerg : Process udevd (pid: 10=
4, stack limit =3D 0x16c28f1d)
    2021-04-20 04:12:10.150000+00:00  kern  :emerg : Stack: (0xc424bc18 to =
0xc424c000)
    2021-04-20 04:12:10.151000+00:00  kern  :emerg : bc00:                 =
                                      00000051 000002c0
    2021-04-20 04:12:10.152000+00:00  kern  :emerg : bc20: 00000000 000000a=
0 bee9f488 000000a0 00000000 00000000 c03ea700 c424bf48
    2021-04-20 04:12:10.153000+00:00  kern  :emerg : bc40: 000000a0 c424bc6=
0 c424bc54 c03ea744 c03ea6d8 c424bcc8 c424bc64 c03eca4c
    2021-04-20 04:12:10.191000+00:00  kern  :emerg : bc60: c03ea718 c424bc7=
0 c010c578 c0e04248 00000360 c424bc80 c0420474 c010c564
    2021-04-20 04:12:10.193000+00:00  kern  :emerg : bc80: c0f24bf0 c069d06=
4 c4248000 c424bd0c c4248094 00000040 aa2af46d c424bca8
    2021-04-20 04:12:10.194000+00:00  kern  :emerg : bca0: 000000a0 000000a=
0 00000100 000000a0 c4248000 00000040 c2cff000 c424bce0
    2021-04-20 04:12:10.195000+00:00  kern  :emerg : bcc0: c424bccc c069ce5=
8 c03ec71c 000000a0 000000a0 c424bd38 c424bce4 c069bfc8 =

    ... (38 line(s) more)  =

 =20
