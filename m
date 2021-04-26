Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FE036B53A
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 16:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbhDZOuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 10:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232575AbhDZOuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 10:50:16 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B61C061574
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 07:49:33 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id c17so4470904pfn.6
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 07:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7A/gkV5iSj4zkOeQtDcLKmsZp9djef4m0bFplvPWWjc=;
        b=tAE+oyhaTQdrN81LAjsSRu9Zi30Sgmma62GWXM81kM8Y/1uqFj33DJx9hT7t69wAwj
         +QzRG0urVLjZBzsdygbDNOKa3jTIFcVH/Q2f04xltKfV9BUcq3TFKAfgz4l2j6EhV9fm
         FI/6FWGkarK/PHjCBRP32haZAQF+2Xmqj9rJ0Jwd9P7CnvF/6UAVWTfibGYtwpyi3OXw
         PBZVGJrfqh64X7Giw3WeOuLKfWbnkyJF3V1ULekeHrjzdcbLibxjdAiv7OJSehA0J+FR
         otiXaxR2Sk/gEKIgeSbO1Pzezo0YwJPnuwRR1kmjRaws9ld1+lwrgch43hXLtfXwLTIu
         0CiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7A/gkV5iSj4zkOeQtDcLKmsZp9djef4m0bFplvPWWjc=;
        b=SONf9Hco7Xtstx6+ZXDkulyHm9JQeMAVvCyfZu9RIUOKOOdwCCEQXtlQOxpFzJC7Ee
         SYWb5256wWpsG0bHGYudNzD0CU4QVbxZNtF5o9VUeSSNGd9LBqeWQbk9J79cQjw0EPFc
         IWKJsGl6BkSlNqUfsU7zXWVwDtaAMv/J4KYnDOE34YZH6FV1A7iX9cjXvRSv59XFtqjk
         w1Ss/TekQ3IZLqhkFSmLuWt2YP9hOgKIqhAS4rkqC9EzyhpB7BBeE2pBraBN8/hA9rCN
         g2Pxt265rkrj0KLfSdQdsrQDVtwWxpmlrtoDWpCtyIpjSL6WlUFPsBROn/4ZX/Mp22lh
         NaBA==
X-Gm-Message-State: AOAM530ZYAcOBPzmONkoHJaebgVl3gob2lGe06UWAQTpc7PmY2H+hn5J
        csnQFmeD19tEJ9rKZHxu8vOlgnRzjHkRkW+h
X-Google-Smtp-Source: ABdhPJy7nTAoqHGiN+kDILEGlezhnG1kH0j2tnZA91S8kQvHR6UM4qnbo6n04U6lM1l47W1E1evkTw==
X-Received: by 2002:a63:9e02:: with SMTP id s2mr17769221pgd.134.1619448573252;
        Mon, 26 Apr 2021 07:49:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i10sm61289pfo.37.2021.04.26.07.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 07:49:33 -0700 (PDT)
Message-ID: <6086d2fd.1c69fb81.49d1f.030d@mx.google.com>
Date:   Mon, 26 Apr 2021 07:49:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.32-37-gf52b4f86deb4f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 147 runs,
 3 regressions (v5.10.32-37-gf52b4f86deb4f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 147 runs, 3 regressions (v5.10.32-37-gf52b=
4f86deb4f)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =

meson-gxl-s905d-p230     | arm64 | lab-baylibre | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.32-37-gf52b4f86deb4f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.32-37-gf52b4f86deb4f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f52b4f86deb4f6bcd54159dfce2303f4928de80c =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =


  Details:     https://kernelci.org/test/plan/id/60869c4aff9e9b1bd99b77c3

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
2-37-gf52b4f86deb4f/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6=
q-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
2-37-gf52b4f86deb4f/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6=
q-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60869c4aff9e9b1=
bd99b77c9
        new failure (last pass: v5.10.31-104-gbcedd92af6e5)
        4 lines

    2021-04-26 10:55:48.134000+00:00  kern  :alert : Unhandled fault: align=
ment exception (0x001) at 0xcec60217
    2021-04-26 10:55:48.134000+00:00  kern  :alert : pgd =3D (ptrval)
    2021-04-26 10:55:48.135000+00:00  kern  :alert : [<8>[   43.605440] <LA=
VA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASURE=
MENT=3D4>
    2021-04-26 10:55:48.135000+00:00  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60869c4aff9e9b1=
bd99b77ca
        new failure (last pass: v5.10.31-104-gbcedd92af6e5)
        26 lines

    2021-04-26 10:55:48.187000+00:00  kern  :emerg : Process kworker/3:2 (p=
id: 79, stack limit =3D 0x(ptrval))
    2021-04-26 10:55:48.187000+00:00  kern  :emerg : Stack: (0xc33e3eb0 to<=
8>[   43.651983] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail U=
NITS=3Dlines MEASUREMENT=3D26>
    2021-04-26 10:55:48.187000+00:00   0xc33e4000)
    2021-04-26 10:55:48.188000+00:00  kern  :emerg : 3ea0<8>[   43.663363] =
<LAVA_SIGNAL_ENDRUN 0_dmesg 139317_1.5.2.4.1>
    2021-04-26 10:55:48.188000+00:00  :                                    =
 c350b800 c38e1854 00000000 cec60217   =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
meson-gxl-s905d-p230     | arm64 | lab-baylibre | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6086a73fc22307bcb39b7799

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
2-37-gf52b4f86deb4f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s=
905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
2-37-gf52b4f86deb4f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s=
905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6086a73fc22307bcb39b7=
79a
        new failure (last pass: v5.10.27) =

 =20
