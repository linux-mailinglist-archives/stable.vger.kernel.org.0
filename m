Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6A3D5129E7
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 05:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241656AbiD1DWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 23:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbiD1DWi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 23:22:38 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1145D189
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 20:19:25 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id j8-20020a17090a060800b001cd4fb60dccso3264175pjj.2
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 20:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xrWCqZV1v4HzbZpkxrF6UcORgq3d34GxxjeMhM4B2h8=;
        b=AC4Y/eSLqk3pfz/fHAUIkhcePP9fr585IhKMuirrkiGGvrmf7t1QI+PN0m0pTuQvTX
         t4XJibp0dTGFQvp0dz/STlYdevA1qRLzo26n4UUYxMQheEb7WrwPKQPf1agO0Ho2iH/l
         UoC/8l+9jgmFhP1MSiwqn1ocFOx+AUt7DtAIYJF2WUDLq+KkKptDsogKJ6sOFDFYhKPa
         Xz1n7Vu19hhmlGCm8nFzyG094Z/x2MTpMuYzQtMHcoBjyTKsIIdRDPnId9sd9gx+W9h/
         gl4/KgokMBWgdDr36sDfJYEFEtgJ7GXnxlLj62FB+qUSF9orq7u0gZkYCQvU2zpGBBuG
         /Lzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xrWCqZV1v4HzbZpkxrF6UcORgq3d34GxxjeMhM4B2h8=;
        b=PRPq7b/M6zrXh2lurAfE7pTWin/OqacNLtQpjCmFVgObXR061w0dhSK+M+GN8Zj8vy
         jJ+zCGdrn3KLuw8mh8Fq8/2PAQ4gqu1/jj6shDoAw6HkbW4cdCXAjJusVrHWW28dPf77
         179NGQiKlIkjazgZleKcEAaC6R3E2owfSKW203bydNM8kjQ+EjjPO+bUqXag4DZoayCO
         o5GpojIQ8oo5yWIv4kFB7lQzAkSbjjbAS8w5BbTCrCszlM22bRRbLbmORkUYLhkXW0I9
         Q4BibS3UpallSIVF5iCGgtV4mVlJ26aOdTksRRXwnQb4e9gi6CI8VR9AwnXZeNnhiPDn
         a+5g==
X-Gm-Message-State: AOAM530G1PO50ubrv8vSoYJ7g5ioUwF7gCnbh7n3SCc/dF5tehxOJqXz
        YqARTzyR/q7qWsoitfLUk5NsMqVuS3QTeDsmWfM=
X-Google-Smtp-Source: ABdhPJwAfhHivuf0Wm++I3wWVlZITrU1jTH3V9VhRpObUjnFGftU/DTq2/NYp1uc73EBSNUEc7jncw==
X-Received: by 2002:a17:903:2290:b0:15d:24d6:4ff1 with SMTP id b16-20020a170903229000b0015d24d64ff1mr15611017plh.126.1651115964379;
        Wed, 27 Apr 2022 20:19:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h124-20020a62de82000000b0050d3020bda0sm15066077pfg.195.2022.04.27.20.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 20:19:24 -0700 (PDT)
Message-ID: <626a07bc.1c69fb81.3de4c.2ef0@mx.google.com>
Date:   Wed, 27 Apr 2022 20:19:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.17.5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.17.y
Subject: stable/linux-5.17.y baseline: 121 runs, 1 regressions (v5.17.5)
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

stable/linux-5.17.y baseline: 121 runs, 1 regressions (v5.17.5)

Regressions Summary
-------------------

platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.17.y/kernel=
/v5.17.5/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.17.y
  Describe: v5.17.5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      2731bd17017d4a0e2180a1917ab22d7820a07330 =



Test Regressions
---------------- =



platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/6269d6fc62a155eba9ff94b3

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.17.y/v5.17.5/ar=
m64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.17.y/v5.17.5/ar=
m64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220422.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/626=
9d6fc62a155eba9ff94ca
        new failure (last pass: v5.17.4)

    2022-04-27T23:51:15.229035  /lava-113264/1/../bin/lava-test-case
    2022-04-27T23:51:15.229342  <8>[   13.512913] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2022-04-27T23:51:15.229522  /lava-113264/1/../bin/lava-test-case
    2022-04-27T23:51:15.229692  <8>[   13.532903] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy-driver-present RESULT=3Dpass>
    2022-04-27T23:51:15.229861  /lava-113264/1/../bin/lava-test-case
    2022-04-27T23:51:15.230025  <8>[   13.554178] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy0-probed RESULT=3Dpass>
    2022-04-27T23:51:15.230188  /lava-113264/1/../bin/lava-test-case   =

 =20
