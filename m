Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE9D4A87B5
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 16:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236346AbiBCPdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 10:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbiBCPdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 10:33:07 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F79C061714
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 07:33:07 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id e28so2525071pfj.5
        for <stable@vger.kernel.org>; Thu, 03 Feb 2022 07:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mMN55JPhhrOLzBqUFQqzYfHgbspDxsqD59kXd3buPfw=;
        b=wVDhHzMXFmXf0bJUw+5oWOhPBd7J18v/EVEZ1dqlkxVg3DSFCWbWXjf6T1ApY8K+95
         0OMSv0Am2qk+DSD6DxVFSx/UViNoC2SQdP+n2BFloTEf1qCB337Fm9uYxHnbQ0G8R0qd
         jAiw/z6kE3vOuql080RnvzVBOQB9qir42er2rC3vhPnN40f4SO+dNwknwmY6Bcnl+Fp/
         ijCsaHC9ngYDlailbvnBVYpPQODU7ZTdZmcGRyH/Ag7XOfWUMTy5ic8M5vV9jACXa7fB
         NG/vW5Y3H6NIKEcWtOsU/MZjUkTFQJcGaBZ4eAMs6GklKoXAHnlb+sreaLnfMAl4TSuT
         N3MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mMN55JPhhrOLzBqUFQqzYfHgbspDxsqD59kXd3buPfw=;
        b=ttu/y3NRh03J9GywtA3LPpsvf0y0kUWAiF4dDwYrnrQ61wYhMHVD+M3Lc3X/zJChbi
         3DQ+jr9z4OOekuEpk2AaG9ZZ6GL3h3WjDw2IChCf/u/Q7JMDWonifHRmIPdEIlNZ0uSw
         UE9GnBESK69WwtPrgH7SjthuAMkkCiZ8O0Q8evoSiYwevgPe5UEAxt+Q002Qz1EeVdHf
         3dkyfqxcIIStUrqNB1OL1puwn8N1tAcUJ8iuox1jekJlrn68GvSXPw5rI1e7AOIPkxrs
         Cs26d+xuEqVHxVao/BJ0wnkgjYBMyVm8gEvTwWA1TrGDOgektS8sG4M4FRZYVrrtHuzz
         eH4w==
X-Gm-Message-State: AOAM5319O/R9Oq8ApuVr7LYV7PrUNaZ8yETpFoKrOz2tWS0XGrrCgcuL
        SBBu8Mmh6xOWpBLFBnYsURKgGfAYzK2J3BA/
X-Google-Smtp-Source: ABdhPJxFTizDFWJooy6n6CzY8SoWMHBmJQoPDsWehvlI8yenJ2Fd0zL1eTit9nsAmx/O2ApnJbwmSg==
X-Received: by 2002:a63:4809:: with SMTP id v9mr28509365pga.316.1643902386479;
        Thu, 03 Feb 2022 07:33:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id om18sm10529208pjb.39.2022.02.03.07.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 07:33:06 -0800 (PST)
Message-ID: <61fbf5b2.1c69fb81.70528.a5bf@mx.google.com>
Date:   Thu, 03 Feb 2022 07:33:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.299
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 136 runs, 1 regressions (v4.9.299)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 136 runs, 1 regressions (v4.9.299)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.299/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.299
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      224d99f50f25ec3234b99556c0076a7130e230c6 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f5531160f12348e7abbd3a

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.299=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.299=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f5531160f1234=
8e7abbd40
        failing since 26 days (last pass: v4.9.295, first fail: v4.9.295-14=
-g584e15b1cb05)
        2 lines

    2022-01-29T14:45:19.657433  [   20.226806] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-29T14:45:19.700673  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/124
    2022-01-29T14:45:19.709651  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
