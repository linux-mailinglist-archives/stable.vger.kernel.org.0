Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12068485BCE
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 23:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245138AbiAEWtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 17:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbiAEWtr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 17:49:47 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389A8C061245
        for <stable@vger.kernel.org>; Wed,  5 Jan 2022 14:49:47 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id p14so665006plf.3
        for <stable@vger.kernel.org>; Wed, 05 Jan 2022 14:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uz5HaI6oYqgTcLpxvZDNQCCjdTzJyeipkw7y7sPmY9M=;
        b=g/0wO8WbJ8IOzoHH9SCMD3f1wd3zVSc8sknoy0oG7eSu2d63gjt2yDuopWdwc2shHZ
         FVrFO63FyNI3YgkKdZDqbpOk/DglFZXwdadPDuNkO2Oqeq9kE6yAKvz7p3mw+4naMo4B
         SmVe0OsDFVUjZcG+6mX4q8m6cH592YdMq7M27pmn4aMuSYJ02Dv0Wfbees0+c7v1W6Xj
         JMN9hwvsKpAvqpxLLEYvIiKo+rb8tR4BrlgfSnFykxx2K/O5sqOxFpD5dG+bfVAzmjH0
         eP5PV+9eoj9lwo+oTo18KQwbtANcJePLTDJTh01p0vvqj0UALxaJ7dUNiHq3a8463lAY
         86UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uz5HaI6oYqgTcLpxvZDNQCCjdTzJyeipkw7y7sPmY9M=;
        b=ViMnzP7UAEUAxiVBGfFvrjGoenDD1M+CptZereO9WxWRxWhdv3SOK6CTLhcj0KCCh1
         jzL8CMgje+/VXoM07rEen9Sw4hcmrNX5Bbvs4crH8fR1bZ7pLdmFdJ/6xrrBJyF2u1Nz
         TYc5oSLnX7f/I+VwZilAJfSZtCu7mgMceK27sx6d9cwvRlfcvpGN0GmWEfHhapDG43AT
         AI4Cxwk2XgqtRgAWCfXXgDwpOUVCqWAhsK/nKCUZhy+S7o4S7AnbSUS9GkdAGSgFFsrD
         kcYLXh3aQcVA19dT8/uoG9kLw5l2hivWGS6qWXoXUfXbdRLRelLVVCx7EacL9kGciQaS
         6uYQ==
X-Gm-Message-State: AOAM532OZnwPkIByEEi9nZZ/aiQ2apOHVc6q5wZCOfMTDvXs72HCJmDx
        l2LO6whnvOKb2C/mK9/3jG/GCmZXN4zlJF/5
X-Google-Smtp-Source: ABdhPJzAi//t4NCTJrRqiCvOkgmpPrxCoZz/WL7XzdIlvkFT//+gZaelvflrE10/1EAoDlXVDai25A==
X-Received: by 2002:a17:902:c205:b0:149:5027:93c6 with SMTP id 5-20020a170902c20500b00149502793c6mr54158674pll.15.1641422986571;
        Wed, 05 Jan 2022 14:49:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bg23sm56380pjb.24.2022.01.05.14.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 14:49:46 -0800 (PST)
Message-ID: <61d6208a.1c69fb81.f9408.040d@mx.google.com>
Date:   Wed, 05 Jan 2022 14:49:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.223-27-g13efc105b0f8
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 92 runs,
 2 regressions (v4.19.223-27-g13efc105b0f8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 92 runs, 2 regressions (v4.19.223-27-g13efc1=
05b0f8)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig             | regre=
ssions
-----------+------+--------------+----------+-----------------------+------=
------
da850-lcdk | arm  | lab-baylibre | gcc-10   | davinci_all_defconfig | 2    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.223-27-g13efc105b0f8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.223-27-g13efc105b0f8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      13efc105b0f8cd7796860cb2a28a3f9873d424af =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig             | regre=
ssions
-----------+------+--------------+----------+-----------------------+------=
------
da850-lcdk | arm  | lab-baylibre | gcc-10   | davinci_all_defconfig | 2    =
      =


  Details:     https://kernelci.org/test/plan/id/61d5eae263d9b75b8cef674c

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.223=
-27-g13efc105b0f8/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da=
850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.223=
-27-g13efc105b0f8/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da=
850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61d5eae263d9b75=
b8cef6750
        new failure (last pass: v4.19.223-27-g41037988c76f)
        6 lines

    2022-01-05T19:00:37.341368  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3000
    2022-01-05T19:00:37.341624  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-01-05T19:00:37.341807  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-01-05T19:00:37.341967  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3400
    2022-01-05T19:00:37.342133  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-01-05T19:00:37.342289  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-01-05T19:00:37.380216  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D6>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d5eae263d9b75=
b8cef6751
        new failure (last pass: v4.19.223-27-g41037988c76f)
        4 lines

    2022-01-05T19:00:37.518060  kern  :emerg : page:c6f49000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-01-05T19:00:37.518262  kern  :emerg : flags: 0x0()
    2022-01-05T19:00:37.518432  kern  :emerg : page:c6f51000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-01-05T19:00:37.518584  kern  :emerg : flags: 0x0()
    2022-01-05T19:00:37.585500  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Deme=
rg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2022-01-05T19:00:37.585747  + set +x
    2022-01-05T19:00:37.585924  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 1352221_1.5.=
2.4.1>   =

 =20
