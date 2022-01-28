Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D85D49FCFE
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 16:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349668AbiA1Pmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 10:42:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349638AbiA1Pmo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 10:42:44 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39912C061714
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 07:42:44 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id c9so6239002plg.11
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 07:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wK/4x9Ei7gmNEHG0Vktv4Mt6dWJ3YiPcj+d89got61E=;
        b=HrjA9C4v8EnvwmvOkQ1nXU4D3XR9XQiHQXv4GHjRmA5Ury+rcMtIzrfhKmm2O3UHDc
         rIVYwsCpnnGBEo67PN1mJnpz2xK2oUL7SNzT6e1d/sk8cmoHIzpQfZIjv+Ji9pZLysHr
         PZ/6bKKLTtkqIoFMeVrFqVl9ydxeU3M66f5nEaoMKC96hYq2MR4b4PtwgP8Clm5Li/Ts
         hm8LfjB2yPMEochvueJdBQu4aFTKZdqW0UmqlIRr8e4665dmknRG/IBVk1QYQ6+GpOsm
         t+TV0/I8Co47DLn65ZaMYOLBkZmMKaNXPw4FRH/s5CibfJINXRxNDWfG2nV9+DZ6Uax7
         9Pqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wK/4x9Ei7gmNEHG0Vktv4Mt6dWJ3YiPcj+d89got61E=;
        b=suMEAixJFV/tJAXiyUG/pg1beZNPNFqBB2g+pSaGcM9dOi1nNa7t4zDVJiH7b6CySU
         xthlxQV04AIj+vWtYmF/A11PHivMhB+cF25DoL/nEbbxtrY1ms9yxJqENfpSW/0msRTm
         ScSINwmmNVIDtvfS4T7MKirnGwnWw3eeXlO22cPjrBOCpnjQ4+9hcL4vFmif7OYbalzr
         4X6xNtOXawNI7hHJ48apzChbS70xoygg797Qn35Eh2HrxYjUgowdL20Ffbq3ZWZY8c8W
         mpEimy0FAJHLyOdMPeoJgYCBHLfXN4rZJmq9lsyAIhd0dKCGwefh2EKLrJpywp+GBGMx
         Al1A==
X-Gm-Message-State: AOAM533U/zOA/wbRMzz8ZrP4Wrxz5NlDSp5WW4E5DQ4orPDGNe25555d
        vaKBBXM9gBRPJsRds89OSEMp+0KwuWeVFHi1
X-Google-Smtp-Source: ABdhPJzZEj/SpRkGXbY2qwmLrCWvwwWcBiCbso2cdJ60E/uuKSZ+kvMQZjbzjZ44WAtXP6XebumbAw==
X-Received: by 2002:a17:902:dac8:: with SMTP id q8mr9228691plx.9.1643384562278;
        Fri, 28 Jan 2022 07:42:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oj5sm3154800pjb.53.2022.01.28.07.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 07:42:42 -0800 (PST)
Message-ID: <61f40ef2.1c69fb81.dbac9.80fb@mx.google.com>
Date:   Fri, 28 Jan 2022 07:42:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.298-9-g33338373a46eb
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 100 runs,
 1 regressions (v4.9.298-9-g33338373a46eb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 100 runs, 1 regressions (v4.9.298-9-g33338373=
a46eb)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.298-9-g33338373a46eb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.298-9-g33338373a46eb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      33338373a46eb5da3c665993f17330582341c9e4 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f3d47111538b0873abbd3d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.298-9=
-g33338373a46eb/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.298-9=
-g33338373a46eb/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f3d47111538b0=
873abbd43
        new failure (last pass: v4.9.298-9-g2d90ef34d565)
        2 lines

    2022-01-28T11:32:46.629841  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, mmcqd/0/83
    2022-01-28T11:32:46.639065  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2022-01-28T11:32:46.661030  [   20.048034] smsc95xx 3-1.1:1.0 eth0: reg=
ister 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet, 9e:9f=
:da:e0:e2:ba
    2022-01-28T11:32:46.667666  [   20.061828] usbcore: registered new inte=
rface driver smsc95xx   =

 =20
