Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEC6383A72
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 18:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240504AbhEQQuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 12:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240591AbhEQQtm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 12:49:42 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00123C0611B5
        for <stable@vger.kernel.org>; Mon, 17 May 2021 09:31:51 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id t4so3457183plc.6
        for <stable@vger.kernel.org>; Mon, 17 May 2021 09:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kwX9AnsQu8cGoSP3T1xKkoSpIlykVfuHKxoOCmnIzlM=;
        b=SnGJIXHaQQDVPdgNPzguBWbX+W+lRpB1L4EgLbXbbGYKJFdsZ8ZL7+32D9et6qA5jq
         TPRsuokeLLT0mwqeDtpNKQcvDVOD96mv9wBkIedl3vytZXVYzen36vD9DZgL4fHOkdfC
         PtPdnhlYEc3Ug7T6JBSDRWS64WG/YeSSWA50JUld9v/RuzhASpJzhTFBLD2ynhmtCEX8
         /5P6zQVyC/FYcOKCscItO6vvF4BKHFJ+ljKxZ+NvfG0IGhtNOOfUzwIG4vtO8H9H3ffX
         MgYOIVTnSS1dw5B0UomhQsiHyAPeEIQriHTHDpF7+XLYxZluFGNyUmPdLtkc0K4Z50fM
         b5ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kwX9AnsQu8cGoSP3T1xKkoSpIlykVfuHKxoOCmnIzlM=;
        b=imrcpyuV46XvetcDkxRdH1O3YaWPGU/Xzlc6+oWIAUeiYo/Jldiysd5Mqww3zktAo3
         hM+0AUf29vgRdoji6mQyfqmac/T66bDEBB9bDwuhOPYRhdmNvehibGD6gBmZKaIGM9uz
         yT5VyQO2ko3Eul1Bf2J5n3OIacAJNtzQsa1KA0/9kthvUV5S/zSpSxKGIn04rFjRlvFA
         ZPXITtqnwNPHKTm2OhD0ktQ4HPHRHu/4YONkibO/0dMY1Re6E67gE/zegWg2O39yU8sd
         v3EALxk17FqYR33Hr+wDZlrFDK0DDnLrxJqZuhKj7g7EG7ezZTGdk3q8w6hNVCSDzOqh
         mdPw==
X-Gm-Message-State: AOAM533fnY8hVBcdkqjMUmgtNydhXDQu3HEd0X/5mQAynTFZSPI92r1D
        yYqUR9XohAvtulCBNQ5NMTPDxCjVoX2RR74S
X-Google-Smtp-Source: ABdhPJwnnmHeyjLORqoIxkY6Tf+Ku+4FE+85C7B7Ax7Xmz1X6p8YtmUQYb8ULWQjldRGpzj9AsJk6A==
X-Received: by 2002:a17:902:7c03:b029:f0:bbde:fc1e with SMTP id x3-20020a1709027c03b02900f0bbdefc1emr845660pll.57.1621269111284;
        Mon, 17 May 2021 09:31:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u12sm10011936pfh.122.2021.05.17.09.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 09:31:50 -0700 (PDT)
Message-ID: <60a29a76.1c69fb81.8df1.1f1f@mx.google.com>
Date:   Mon, 17 May 2021 09:31:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.11.21-311-g7cfd36cbe8c6
X-Kernelci-Branch: linux-5.11.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.11.y baseline: 134 runs,
 4 regressions (v5.11.21-311-g7cfd36cbe8c6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.11.y baseline: 134 runs, 4 regressions (v5.11.21-311-g7cf=
d36cbe8c6)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
bcm2837-rpi-3-b-32       | arm   | lab-baylibre | gcc-8    | bcm2835_defcon=
fig  | 1          =

imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =

imx8mp-evk               | arm64 | lab-nxp      | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.11.y/ker=
nel/v5.11.21-311-g7cfd36cbe8c6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.11.y
  Describe: v5.11.21-311-g7cfd36cbe8c6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7cfd36cbe8c6664a72537c5151f00c3f6d6e71b9 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
bcm2837-rpi-3-b-32       | arm   | lab-baylibre | gcc-8    | bcm2835_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60a26503b759e5b929b3afac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.2=
1-311-g7cfd36cbe8c6/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm28=
37-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.2=
1-311-g7cfd36cbe8c6/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm28=
37-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a26503b759e5b929b3a=
fad
        new failure (last pass: v5.11.21-229-gd46f592c4fca) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =


  Details:     https://kernelci.org/test/plan/id/60a26958c21eef1e45b3afb5

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.2=
1-311-g7cfd36cbe8c6/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6=
q-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.2=
1-311-g7cfd36cbe8c6/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6=
q-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60a26958c21eef1=
e45b3afbb
        new failure (last pass: v5.11.19)
        4 lines

    2021-05-17 13:01:37.392000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00000004
    2021-05-17 13:01:37.393000+00:00  kern  :alert : pgd =3D (ptrval)<8>[  =
 43.214288] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D4>
    2021-05-17 13:01:37.393000+00:00  =

    2021-05-17 13:01:37.393000+00:00  kern  :alert : [00000004] *pgd=3D0000=
0000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60a26958c21eef1=
e45b3afbc
        new failure (last pass: v5.11.19)
        49 lines

    2021-05-17 13:01:37.451000+00:00  kern  :emerg : Process kworker/0:1 (p=
id: 30, stack limit =3D 0x(ptrval))
    2021-05-17 13:01:37.451000+00:00  kern  :emerg : Stack: (0xc226dd50 to =
0xc226e000)
    2021-05-17 13:01:37.452000+00:00  kern  :emerg : dd40:                 =
                    c20133d0 c09c3af0 c2013060 c09c82a4
    2021-05-17 13:01:37.452000+00:00  kern  :emerg : dd60: c3a51db0 c3a51db=
4 c3a51c00 c09cdf70 c226c000 ef86d380 80200016 c14390f8
    2021-05-17 13:01:37.452000+00:00  kern  :emerg : dd80: c19bb040 fee9d20=
5 c19bb05c c2001d80 c326f800 ef85cde0 c09db8d8 c14390f8
    2021-05-17 13:01:37.494000+00:00  kern  :emerg : dda0: c19bb040 fee9d20=
5 c19bb05c c3a9cd80 c3ab3180 c3a51c00 c3a51c14 c14390f8
    2021-05-17 13:01:37.494000+00:00  kern  :emerg : ddc0: c19bb040 0000000=
c c19bb05c c09db8a8 c1436d3c 00000000 c3a51c0c c3a51c00
    2021-05-17 13:01:37.494000+00:00  kern  :emerg : dde0: c22db410 c3afd4c=
0 c3a85700 c09b13d0 c3a51c00 fffffdfb c22db410 bf044134
    2021-05-17 13:01:37.495000+00:00  kern  :emerg : de00: c3a9c380 c3b9890=
8 00000120 c3afd4c0 c3a85700 c0a0ba84 c3a9c380 c3a9c380
    2021-05-17 13:01:37.495000+00:00  kern  :emerg : de20: 00000040 c3a9c38=
0 c3a85700 00000000 c19bb054 bf099084 bf09a014 0000001b =

    ... (34 line(s) more)  =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx8mp-evk               | arm64 | lab-nxp      | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60a2689d802c50a0e6b3af98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.2=
1-311-g7cfd36cbe8c6/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.2=
1-311-g7cfd36cbe8c6/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2689d802c50a0e6b3a=
f99
        failing since 2 days (last pass: v5.11.21, first fail: v5.11.21-229=
-gd46f592c4fca) =

 =20
