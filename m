Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5AF04731DE
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 17:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237790AbhLMQdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 11:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233962AbhLMQdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 11:33:19 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C32C061574
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 08:33:19 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id h24so12257056pjq.2
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 08:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rXBM6wTpJzIaccfPil4ljsHPSZBd6g643I/t3WHZkfs=;
        b=F0osr4l6vcuQb5LM2tx9aYGdrCajzR9N1Xdj+qZ8hq929DEtGXyz4s3mezKjOJgS1t
         vHcHAEeIFHxtox2B5Ll7vAkkbFgkc9Smf/R8VX8+TM6yC8AEKGCxQVVQufslEoQwBSyG
         b7o2hGiPTZc1ABSXaKZPibL2P28XoQiDujV3jzZo6QpYmAt7D2xHS96OQylmf1cN3YB/
         DT0giQv1XFIO66u7Lctd/mYY7gRP2vfQo1h2t5X6NeKR/pztXuXDUcpWsNW5FgYakJIW
         Llo/tITO7de0hRD6apdnEAiu/KAnMJjH58ukoixuVTwGZWJhvSFKBbY59O92pvtje1FA
         UjBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rXBM6wTpJzIaccfPil4ljsHPSZBd6g643I/t3WHZkfs=;
        b=KKw/xoR0vZg7SKHWLWkdvS3VrVNxQi0/PfMhpA50V5G7OjqEUdJZsjTMP/469ElyP/
         Fw8DBDmjO8mJOLjMcIso+LhqmDv7AUJp4/atu+mbahPrTzaxDQIeQrN3+fbvyB/DVcqP
         mpkTYIY/2su/rQcCwExVXrnrcGspqJUssO0CceUrtfYtiLHoImicuyReeMqd0hsyxqX1
         CZjnQp53hRPX/s/Fe1gYPrrlUZsLuVXQ/Qz2A7frglSo7XjX5BNLdYQRVDySgJjqf922
         2lahopy8zRr8dthKSWRjpLZBfTGKU4thkBmHs4W9klbu1bbm4WqRnFEsCiqTX9Ia67lG
         jyzQ==
X-Gm-Message-State: AOAM530DGbjY2ssMoTXGpZgBR7jYFJ8+o9OZQsYqs+4PuhniWA7cOkv9
        mRJ8OxSC4C1SGgUZSRDwXfmVOp0P+cSiXsBY
X-Google-Smtp-Source: ABdhPJydRMl7a1yelohifif95G73qvbrkqooWElQZAOpI7Lg1z2TCDC7Hl5rYnicv/qXJp+l8+jtWQ==
X-Received: by 2002:a17:902:6b46:b0:142:8470:862e with SMTP id g6-20020a1709026b4600b001428470862emr97170805plt.49.1639413198504;
        Mon, 13 Dec 2021 08:33:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y25sm10680224pgk.47.2021.12.13.08.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 08:33:18 -0800 (PST)
Message-ID: <61b775ce.1c69fb81.ef402.dcdd@mx.google.com>
Date:   Mon, 13 Dec 2021 08:33:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.220-75-gc65e8cddade7
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 195 runs,
 3 regressions (v4.19.220-75-gc65e8cddade7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 195 runs, 3 regressions (v4.19.220-75-gc65=
e8cddade7)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
          | regressions
-------------------------+--------+---------------+----------+-------------=
----------+------------
da850-lcdk               | arm    | lab-baylibre  | gcc-10   | davinci_all_=
defconfig | 2          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.220-75-gc65e8cddade7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.220-75-gc65e8cddade7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c65e8cddade7ba91d6b7438b4746b7b02a83bb72 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
          | regressions
-------------------------+--------+---------------+----------+-------------=
----------+------------
da850-lcdk               | arm    | lab-baylibre  | gcc-10   | davinci_all_=
defconfig | 2          =


  Details:     https://kernelci.org/test/plan/id/61b73b860b3150786c39715d

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
20-75-gc65e8cddade7/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-=
da850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
20-75-gc65e8cddade7/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-=
da850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61b73b860b31507=
86c397161
        new failure (last pass: v4.19.220-51-gab7df26443b3)
        3 lines

    2021-12-13T12:24:24.829103  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3400
    2021-12-13T12:24:24.829362  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2021-12-13T12:24:24.829545  kern  :alert : page dumped because: nonzero=
 mapcount
    2021-12-13T12:24:24.887615  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D3>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b73b860b31507=
86c397162
        new failure (last pass: v4.19.220-51-gab7df26443b3)
        2 lines

    2021-12-13T12:24:25.025536  kern  :emerg : page:c6f51000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2021-12-13T12:24:25.025786  kern  :emerg : flags: 0x0()
    2021-12-13T12:24:25.109451  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Deme=
rg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2021-12-13T12:24:25.109772  + set +x
    2021-12-13T12:24:25.109961  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 1235390_1.5.=
2.4.1>   =

 =



platform                 | arch   | lab           | compiler | defconfig   =
          | regressions
-------------------------+--------+---------------+----------+-------------=
----------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig      | 1          =


  Details:     https://kernelci.org/test/plan/id/61b73d75b92f020c48397127

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
20-75-gc65e8cddade7/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-m=
innowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
20-75-gc65e8cddade7/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-m=
innowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b73d75b92f020c48397=
128
        new failure (last pass: v4.19.220-51-gab7df26443b3) =

 =20
