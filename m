Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F159396708
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 19:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbhEaR3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 13:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbhEaR3Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 13:29:25 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E1DC08EB07
        for <stable@vger.kernel.org>; Mon, 31 May 2021 09:10:24 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id q16so5445492pls.6
        for <stable@vger.kernel.org>; Mon, 31 May 2021 09:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0wG4xLOIMxCK31zgDHhxQqFwQrQY5HWQ8l4skmTbh0c=;
        b=sOcbxwOnJJ6dC9o2//H3sTjvkW4qbSVQTiaFycjlTFYyKr7JMuRD/M5eoB16mNR5on
         V/mgaZujOni13yBE33TjHi0vbvHoz6sanoHKpYZsj0m5kW3DtwbE360Siw69hDPZLG+1
         HsjJc8rJLo2N1ZJnPTMufTfg2n00eUP8E12Kv2XpfDrsaq/Ja10MC9k+FhvjFBX5EG4D
         52kAduttL3A8vqgyu2SeSZt0SnVFTKb3MJUxclLYzW/pWKV7o+sruqidT2omGjPeQpD2
         j7C9EHsA4j+Y/wRP88AQiftwvf3SEHhGWjQDl6Fjd+zTadagMVcZI/g3auXoVlPZua5t
         NaPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0wG4xLOIMxCK31zgDHhxQqFwQrQY5HWQ8l4skmTbh0c=;
        b=SA1CiAcjHOUQdiQuBepP68W8S/okpYXmd4PJQM7QJbjz4Z7LVWYKLF1+Ly4d6Ks1ck
         wt1PicgFl6ZpKd6acjQWxSq23wOU0tHAoqo3Kwyqw9q2EkeCWVek/LhrjBHhWtasOehL
         7yZlWgVnj3Cvb77lSSstQjZ8zgQXeWyFu91EbuAYrRopv3L6r+1P06OB4hPQshDjtWsg
         GD+qRCjOdQhXtyXnCrwJWv7u9kNvd7jpx2myWOcj5JjkNN/Y8lPZsKDezaPl6hsQ5n7H
         GpI0lAcpDAJZr5uWKWwJBDUJC9vH9/lvqsm351U//NtBmsJYWsx5ZWzDuJa3XQQ8VjTu
         udBA==
X-Gm-Message-State: AOAM532qABK3MhR5r9yjGDEAp1n3oBIqryQ4FYWNwZEBdy/Io2p2reja
        LQyc3B9UtD/R7q5QC8WWqpxegmVHtTL2gl6N
X-Google-Smtp-Source: ABdhPJxDFrb0TYjoO6Olc9MkOFTPTI9P8yS5mLqeWeMQgzE0CwtV2zbe2dBqR/6FuLKwyKDsebXXtA==
X-Received: by 2002:a17:902:ed0c:b029:104:fb4b:453c with SMTP id b12-20020a170902ed0cb0290104fb4b453cmr5506652pld.27.1622477423853;
        Mon, 31 May 2021 09:10:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a15sm11074826pff.128.2021.05.31.09.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 09:10:23 -0700 (PDT)
Message-ID: <60b50a6f.1c69fb81.f99a2.3026@mx.google.com>
Date:   Mon, 31 May 2021 09:10:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.122-183-g09f40ed6b545
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 150 runs,
 4 regressions (v5.4.122-183-g09f40ed6b545)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 150 runs, 4 regressions (v5.4.122-183-g09f40e=
d6b545)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
    | regressions
-------------------------+-------+--------------+----------+---------------=
----+------------
bcm2837-rpi-3-b-32       | arm   | lab-baylibre | gcc-8    | bcm2835_defcon=
fig | 3          =

r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip      | gcc-8    | defconfig     =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.122-183-g09f40ed6b545/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.122-183-g09f40ed6b545
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      09f40ed6b54507db1c13e7575ec906275cd27667 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
    | regressions
-------------------------+-------+--------------+----------+---------------=
----+------------
bcm2837-rpi-3-b-32       | arm   | lab-baylibre | gcc-8    | bcm2835_defcon=
fig | 3          =


  Details:     https://kernelci.org/test/plan/id/60b4cddbfb4dc3480fb3afad

  Results:     2 PASS, 3 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.122-1=
83-g09f40ed6b545/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.122-1=
83-g09f40ed6b545/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/60b4cddbfb4dc348=
0fb3afb2
        new failure (last pass: v5.4.122-179-gb2a3b9ec2565)
        1 lines

    2021-05-31 11:50:24.369000+00:00  Trying 127.0.0.1...
    2021-05-31 11:50:24.370000+00:00  Connected to 127.0.0.1.
    2021-05-31 11:50:24.371000+00:00  Escape character is '^]'.
    2021-05-31 11:50:29.069000+00:00  =00
    2021-05-31 11:50:29.070000+00:00  =

    2021-05-31 11:50:29.071000+00:00  U-Boot 2017.01 (Nov 23 2017 - 03:58:1=
8 +0000)
    2021-05-31 11:50:29.071000+00:00  =

    2021-05-31 11:50:29.073000+00:00  DRAM:  753 MiB
    2021-05-31 11:50:29.104000+00:00  RPI 3 Model B (0xa22082)
    2021-05-31 11:50:29.120000+00:00  MMC:   bcm2835_sdhci: 0 =

    ... (435 line(s) more)  =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60b4cddbfb4dc34=
80fb3afb3
        new failure (last pass: v5.4.122-179-gb2a3b9ec2565)
        4 lines

    2021-05-31 11:51:32.051000+00:00  kern  :alert : Unable to handle kerne=
l paging request at virtual address eaf4a000
    2021-05-31 11:51:32.052000+00:00  kern  :ale<8>[   13.877073] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60b4cddbfb4dc34=
80fb3afb4
        new failure (last pass: v5.4.122-179-gb2a3b9ec2565)
        23 lines

    2021-05-31 11:51:32.057000+00:00  kern  :alert : [eaf4a000] *pgd=3D2ae0=
041e(bad)
    2021-05-31 11:51:32.101000+00:00  kern  :emerg : Internal error: Oops: =
8000000d [#1] ARM
    2021-05-31 11:51:32.103000+00:00  kern  :emerg : Process udevd (pid: 97=
, stack limit =3D 0x69fb39a8)<8>[   13.919743] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D23>
    2021-05-31 11:51:32.103000+00:00     =

 =



platform                 | arch  | lab          | compiler | defconfig     =
    | regressions
-------------------------+-------+--------------+----------+---------------=
----+------------
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip      | gcc-8    | defconfig     =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/60b4d3830f8fa96f2db3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.122-1=
83-g09f40ed6b545/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg=
2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.122-1=
83-g09f40ed6b545/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg=
2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b4d3830f8fa96f2db3a=
f98
        new failure (last pass: v5.4.122-142-gbfc47ae14556) =

 =20
