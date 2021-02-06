Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59BE312073
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 00:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhBFXWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 18:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbhBFXWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Feb 2021 18:22:19 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76670C061756
        for <stable@vger.kernel.org>; Sat,  6 Feb 2021 15:21:39 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id u15so5548255plf.1
        for <stable@vger.kernel.org>; Sat, 06 Feb 2021 15:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ymje0WtZCydBEeKOWur4BXUAzUTFXk1Oc3mKV5hqzTk=;
        b=1iKW1PJBgikpJWcn5R3O5hiQZwC5eIf21USpz5ND/d3CmG6WXUCwlB0ifbElYLaJyj
         zBWwlkvVXIJm62qtQtF36skw6kTEbaGia4W7E0+Hy7Yfv11iP/pTcSUYqjxWLtQHUKxr
         G/uqsRljlRDZczN46xaOwBvVd01SRO8xsalTXN+LCAxEtUl86GYjb/wgnqQFZa1yovz8
         +tJCPRwLDQuktLjEqJXCoaEkyATz2aZYpKlhy+I5kViqksyzY0MRpQCwhQwVVunSV7E1
         YfBviQna6uALFJgKNeST2vSzDY4kPwImt0QU+4aso4tacGteNebHLhyKXxAVjZT+MB8H
         b/jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ymje0WtZCydBEeKOWur4BXUAzUTFXk1Oc3mKV5hqzTk=;
        b=pmjU2GIoKMp2kG1iHvn5sQ42jAhgGSM5RBdKb/vVHPDsj2/wm3dTG5u5qs+yCwTa4k
         Rsa6ryu+SDNrioNUyzGdUWXno3JPXJP1WAQ+yZMNo20S2R8f7UEVCV6VyrfVbKJ+9Tf8
         vvpzbMF3v1eU8hVbw4JDDBA14zGT8c8gEEwQ/S31EyrUrs8zRMJHGTcv7B2JYBw1RyTP
         79CRZU/hJI7JTA4nLTHiFDojY8MR9EnFhs//6TEnXdYzEseL+3xOHAtRGae6JNzFvk+0
         V0GGKVXlOdNzdAZhG8jg/koID/4PLCW78yx4Og1kbx/qxZ0SqKSeaELbu3tmYTMf5QX3
         cMFw==
X-Gm-Message-State: AOAM531u9eTtpaU8UVITO921TDz1JqdGzWrDWWf7XA63X3YrQ9W0AGXC
        UKGF0mCDMErClXL2KQ6bkbl7WePKeV8z7g==
X-Google-Smtp-Source: ABdhPJz42eA2T2G31NB+uEo0PJkOGeAWDvbAPObxlg9oUX5SP3yKYJ+1gnRduyD9+ojrKJKv30nPuw==
X-Received: by 2002:a17:902:e750:b029:de:8c17:fd64 with SMTP id p16-20020a170902e750b02900de8c17fd64mr10168355plf.54.1612653698683;
        Sat, 06 Feb 2021 15:21:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e76sm12432488pfh.102.2021.02.06.15.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Feb 2021 15:21:38 -0800 (PST)
Message-ID: <601f2482.1c69fb81.6b8ab.a3f5@mx.google.com>
Date:   Sat, 06 Feb 2021 15:21:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.13-57-g1231f5f0cde54
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 183 runs,
 3 regressions (v5.10.13-57-g1231f5f0cde54)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 183 runs, 3 regressions (v5.10.13-57-g1231f5=
f0cde54)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =

imx8mp-evk               | arm64 | lab-nxp      | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.13-57-g1231f5f0cde54/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.13-57-g1231f5f0cde54
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1231f5f0cde54ff1b2a211d2fb8121f569049eb9 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =


  Details:     https://kernelci.org/test/plan/id/601ef457059319fa3b3abe6d

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.13-=
57-g1231f5f0cde54/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.13-=
57-g1231f5f0cde54/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/601ef457059319f=
a3b3abe73
        new failure (last pass: v5.10.13-57-g815bee96eacc2)
        4 lines

    2021-02-06 19:55:32.794000+00:00  kern  :alert : Unhandled fault: align=
ment exception (0x001) at 0xcec60217
    2021-02-06 19:55:32.794000+00:00  kern  :alert : pgd =3D 8cea3f4c
    2021-02-06 19:55:32.795000+00:00  kern  :alert : [<8>[   11.264831] <LA=
VA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASURE=
MENT=3D4>
    2021-02-06 19:55:32.795000+00:00  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/601ef457059319f=
a3b3abe74
        new failure (last pass: v5.10.13-57-g815bee96eacc2)
        26 lines

    2021-02-06 19:55:32.847000+00:00  kern  :emerg : Process kworker/1:1 (p=
id: 53, stack limit =3D 0xd03b55d2)
    2021-02-06 19:55:32.848000+00:00  kern  :emerg : Stack: (0xc244feb0 to<=
8>[   11.312014] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail U=
NITS=3Dlines MEASUREMENT=3D26>
    2021-02-06 19:55:32.848000+00:00   0xc2450000)
    2021-02-06 19:55:32.848000+00:00  kern  :emerg : fea0<8>[   11.323310] =
<LAVA_SIGNAL_ENDRUN 0_dmesg 691491_1.5.2.4.1>
    2021-02-06 19:55:32.848000+00:00  :                                    =
 c2001e40 c3971600 ef86ae20 cec60217   =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx8mp-evk               | arm64 | lab-nxp      | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/601ef5854b22318b5c3abe74

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.13-=
57-g1231f5f0cde54/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.13-=
57-g1231f5f0cde54/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601ef5854b22318b5c3ab=
e75
        new failure (last pass: v5.10.13-57-g815bee96eacc2) =

 =20
