Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D935EB75B
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 04:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiI0CGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 22:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiI0CGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 22:06:49 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6374895E7
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 19:06:47 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d24so7845893pls.4
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 19:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=B6sEix5hSiEdzWza8iMi34oW2+EJc51tkmKdtULrHB0=;
        b=qqjR3baoIz6T0jmjy0WcXNw8yj85vfArL1ug/9Qkwd/OqJkEBfrcLQUxu9YbomICcX
         gKDyni+hJpkRvnspeN6RSurtMXAZoflfjuSd4N05VXtnpR3XnZvX+PTd2T4iRgE0zJDC
         QQNudSX182xhfUZdOyyf5sKNGubX3pbMQFQmEtDNuYtAJ1H4wEFaMoEsI2OFQAninm+O
         9z4Jyn8zvzwfF1G4Z4KrN9CdosmqTea73uVmVNcWGqAgX4oqVdMfcJuInp7J6jKFpCGH
         t6EwgfbA+P6OyPMUkk0yTRg+L8xV2pHrzybiH0/8hMYRx+T7nnlSMGDyLidyTaAEXjhS
         B7rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=B6sEix5hSiEdzWza8iMi34oW2+EJc51tkmKdtULrHB0=;
        b=XF0XNOReZfUI+DeAo1t2wk3Z6PNqFtdgepzyRP+ZvxJhjOEOKO94C6BmFBt/U50YKw
         paSC04dnlGowstR8oCB9Rw32u4F+3V0SKCwNm2QMFPX39yi1mkb8kt3RJ42fjjIEHLsa
         BBHCvvRArLpBwJF+2dspA7WOOagaeFvHtQQ3bkiqvV86Gr5PWYKrJWDuESAfYy38fhg8
         RybnflGLXJ1VGgCaA1PHWHOemhDddgOFclXsEwPxJuztFz0HCGRT7vEEaerzJndwdLi5
         MqfpeFAi7yzjBisiTYlxSDHp5kbUqsTMalBvzje4egeeH7DmKrmqNuujoDy83wV2jptv
         OiFA==
X-Gm-Message-State: ACrzQf1IVO0//QOiadVm+wQMivCngr8kehX90Bsw46tmZ8DArYPg9pvK
        JXzPt2cGj1KIBhgzlMsgY/Isb1WH89dxNRBZ
X-Google-Smtp-Source: AMsMyM5Ix5fVULrlI9zL5r9eHWdp4BgWmprUBi2D9WMSkv4tnI3WwmHzwDtGeqk0AmcNVCEq9mdQhQ==
X-Received: by 2002:a17:90b:1bd2:b0:202:56b2:4f35 with SMTP id oa18-20020a17090b1bd200b0020256b24f35mr1801897pjb.65.1664244407000;
        Mon, 26 Sep 2022 19:06:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j13-20020a170903024d00b0017541ecdcfesm101718plh.229.2022.09.26.19.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 19:06:46 -0700 (PDT)
Message-ID: <63325ab6.170a0220.918f9.04a2@mx.google.com>
Date:   Mon, 26 Sep 2022 19:06:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.11-206-g444111497b13
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.19 baseline: 182 runs,
 3 regressions (v5.19.11-206-g444111497b13)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.19 baseline: 182 runs, 3 regressions (v5.19.11-206-g44411=
1497b13)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-11A-G6-EE-grunt           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

imx7ulp-evk                  | arm    | lab-nxp       | gcc-10   | multi_v7=
_defconfig           | 1          =

meson-g12b-a311d-khadas-vim3 | arm64  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.11-206-g444111497b13/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.11-206-g444111497b13
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      444111497b13bd7be06d8bc14a2646007a4f9b9f =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-11A-G6-EE-grunt           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633225f4eacc0e739eec4eea

  Results:     18 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
206-g444111497b13/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-11A-G6-EE-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
206-g444111497b13/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-11A-G6-EE-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.tpm-chip-is-online: https://kernelci.org/test/case/id/6=
33225f4eacc0e739eec4efd
        new failure (last pass: v5.19.11-158-gc8a84e45064d0)

    2022-09-26T22:21:17.498127  /usr/bin/tpm2_getcap
    2022-09-26T22:21:17.522518  ERROR:tcti:src/tss2-tcti/tcti-device.c:286:=
tcti_device_receive() Failed to read response from fd 3, got errno 14: Bad =
address =

    2022-09-26T22:21:17.532918  ERROR:esys:src/tss2-esys/api/Esys_GetCapabi=
lity.c:307:Esys_GetCapability_Finish() Received a non-TPM Error =

    2022-09-26T22:21:17.541590  ERROR:esys:src/tss2-esys/api/Esys_GetCapabi=
lity.c:107:Esys_GetCapability() Esys Finish ErrorCode (0x000a000a) =

    2022-09-26T22:21:17.546056  ERROR: Esys_GetCapability(0xA000A) - tcti:I=
O failure
    2022-09-26T22:21:17.549080  ERROR: Unable to run tpm2_getcap
    2022-09-26T22:21:18.544548  ERROR:tcti:src/tss2-tcti/tcti-device.c:286:=
tcti_device_receive() Failed to read response from fd 3, got errno 14: Bad =
address =

    2022-09-26T22:21:18.553169  ERROR:esys:src/tss2-esys/api/Esys_GetCapabi=
lity.c:307:Esys_GetCapability_Finish() Received a non-TPM Error =

    2022-09-26T22:21:18.563171  ERROR:esys:src/tss2-esys/api/Esys_GetCapabi=
lity.c:107:Esys_GetCapability() Esys Finish ErrorCode (0x000a000a) =

    2022-09-26T22:21:18.567683  ERROR: Esys_GetCapability(0xA000A) - tcti:I=
O failure =

    ... (43 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
imx7ulp-evk                  | arm    | lab-nxp       | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/633229d10e0897818fec4eee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
206-g444111497b13/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
206-g444111497b13/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633229d20e0897818fec4=
eef
        new failure (last pass: v5.19.11-158-gc8a84e45064d0) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6332254ec6eec9eb35ec4ece

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
206-g444111497b13/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-=
a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
206-g444111497b13/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-=
a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6332254ec6eec9eb35ec4=
ecf
        new failure (last pass: v5.19.11-158-gc8a84e45064d0) =

 =20
