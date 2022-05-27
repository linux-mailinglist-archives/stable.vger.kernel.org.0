Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87802536353
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 15:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238768AbiE0NbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 09:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233006AbiE0NbL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 09:31:11 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D5A13F90C
        for <stable@vger.kernel.org>; Fri, 27 May 2022 06:31:10 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id bo5so4356738pfb.4
        for <stable@vger.kernel.org>; Fri, 27 May 2022 06:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lH549LIaMSCLspmiDDFDNqE5WLgvwa/tS0ZDjbciT7A=;
        b=4xF+KM1qi3IT3D+xLAL9jNjOpafsOqVm3j8XeeWD3xEgG6HjpPN9NRymd5VR4j2/xJ
         o6CLm7kMkIefNm1OUnEBwUvAdiLAMixLTT+Q4pO803w3z5bvLd7Rrdm+VFKk/rc4WM7U
         +twKnbbPFB5gT8molLV0mt9jUfye0j2s1UkalpFVJOPg/9TYp66NsIdd3FYyjuWY/UvY
         K0gYm4m4RbYOZatecIS3VIBZuTpC7GSPWVCC86ZuxYMBkIlKfhLPDxBL98+uaMg+7J5z
         Bo40WkX5lnWypMaSdLm307OiHW9g5RRJdkGX4txQrGmbySkHQpkxjtjofjeKJLqn31Ot
         2UoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lH549LIaMSCLspmiDDFDNqE5WLgvwa/tS0ZDjbciT7A=;
        b=DfLDSVkS6JZeKyDMjA4wLHACdA4nI18rc7cZsul/cG4d5srghtdDkV8J2lYWkE+Rop
         xASIUiJPiPyzjxBp+G76N9tgeWKoo5N0FE6R3reNtA4sTsEERukxPeI/qyerjmJ6dCb5
         jPDeE6c8Ip2WoHbFn/LNNfKROyxYtQcjr1RCTKEIaGRWVfJmo3Jj1uLszToqdHnPjwFi
         Z+ADiMsOiWxh1UhBjas1tkhTtx9vntxHtpaR5Mcvmo9oCcfMSs19HYrBDJPPklUjXJEC
         kCToqW+fKMhxQROCjnUkZ1GQ2Rc4FnYtAyxNwtfUECJ55Ip58TLJMJzdbYDNc8W2UvDg
         3rKA==
X-Gm-Message-State: AOAM533CSBrtmfe3n0bWhwvSJPPgCHw1jQKNoGSfli22mGRRKAYywlhv
        aoatTnlkchuVJ1FO7fdQhsLEYP3kxwePzH9FJF4=
X-Google-Smtp-Source: ABdhPJxDPw1Na8YTUhx3zkQm/IuAFCQXZKFi4OEmG10ZsrM1g1Fwk07WmpOTxEIGpuTx7/5i8UWwzg==
X-Received: by 2002:a05:6a00:234a:b0:519:c7c:e58a with SMTP id j10-20020a056a00234a00b005190c7ce58amr9883763pfj.14.1653658269532;
        Fri, 27 May 2022 06:31:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y9-20020aa79429000000b0050dc762819fsm3443555pfo.121.2022.05.27.06.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 06:31:09 -0700 (PDT)
Message-ID: <6290d29d.1c69fb81.8600c.75c2@mx.google.com>
Date:   Fri, 27 May 2022 06:31:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.11-111-g6b856e34b3203
X-Kernelci-Branch: queue/5.17
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.17 baseline: 116 runs,
 1 regressions (v5.17.11-111-g6b856e34b3203)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.17 baseline: 116 runs, 1 regressions (v5.17.11-111-g6b856=
e34b3203)

Regressions Summary
-------------------

platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.11-111-g6b856e34b3203/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.11-111-g6b856e34b3203
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6b856e34b3203ae8382bf259bc87de23c2ddc3f8 =



Test Regressions
---------------- =



platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/62909f44cfe411e9c1a39bf5

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.11-=
111-g6b856e34b3203/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx=
-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.11-=
111-g6b856e34b3203/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx=
-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/629=
09f44cfe411e9c1a39c08
        new failure (last pass: v5.17.11-110-g16e9bf68158f9)

    2022-05-27T09:51:46.282514  /lava-121665/1/../bin/lava-test-case
    2022-05-27T09:51:46.282825  <8>[   13.481187] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2022-05-27T09:51:46.282973  /lava-121665/1/../bin/lava-test-case
    2022-05-27T09:51:46.283111  <8>[   13.500935] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy-driver-present RESULT=3Dpass>
    2022-05-27T09:51:46.283249  /lava-121665/1/../bin/lava-test-case
    2022-05-27T09:51:46.283380  <8>[   13.522214] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy0-probed RESULT=3Dpass>
    2022-05-27T09:51:46.283513  /lava-121665/1/../bin/lava-test-case   =

 =20
