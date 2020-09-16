Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B44826B99A
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 04:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgIPCCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 22:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbgIPCCp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 22:02:45 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E333C06174A
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 19:02:44 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id v14so718400pjd.4
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 19:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Yd+3DM+szJyxjJI9IB1FacGvbasThNo1Gw+DcZYJRY8=;
        b=l96YIwgwX75C6HSuR5ZO2sUqe9YKqVOLabx5TkMzl37+ggXLwxZaX4yEkncWT9AJfv
         i39lik8EeOpV5U7iQhjnDApPps2JTjFtsoCV2C01Z7kXPMy1YPkOg5gaSBtjNVeRJfKM
         /f7CFDMnLBWljYelSmB4AMY4xUsqGxpEHMYfRyCur3rOq59tWexOB1ndWVORWbP4IjPd
         1wfrGOqByYhq3N1T6sTQT6jvgrwnIupHbettTpom/d2JbJtPD5uVJP8bop3BPFDIwb3o
         EQ4cD779KL8X3Vtmg4DRNdJa7vNAoCi86lHOYPBZDvCFV0nUGWH+LGPucf3jx/AejwkK
         3WeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Yd+3DM+szJyxjJI9IB1FacGvbasThNo1Gw+DcZYJRY8=;
        b=jHlbXL5tnjiVyNme3dF4VwJXzgb1lAgqEbariyjhAlSH5jqvioXSaQAIyLVjtCsPDs
         eark5h/XisAf8PWVRaOGXnD9HzBIyJGJTUcI7S4STq+NsgCIwTqObcsXsIR3qBDjI1If
         YHraqQvPTnvGWBniKX2AlYnRTG+vUsG+F2ACBfyhM7OIHna7cdqAnegDlj88D5Vy6nF5
         lH1mWu4Fop25iu83OwEcJF4L49ZcGcDw/3pyYH/lbxIDhtXYr5Wf6R+Ta+2HPYGhpi3k
         0dwztYXRO2x0lvhFS1tRecYg8uuq2VgjoQRRfH+cMvy8uM696SJJtyDX8I6vIEIwT3Ib
         WMvg==
X-Gm-Message-State: AOAM531gp0A++fUZK7b6nXJA+y7UCEDbHglzbuUhNlCiU7tzMnTpdWQ4
        UpdG8m/fMfOiNLsLoIHSPz5tGcSRLYt+Hw==
X-Google-Smtp-Source: ABdhPJyBoY5j+5vc2Z+M1ZvN2lWe/rpW1LrWRctvOmT2gfehCMXRgNfAijGh/zuC/+MquGF1ddd90A==
X-Received: by 2002:a17:90a:e795:: with SMTP id iz21mr1914020pjb.8.1600221763489;
        Tue, 15 Sep 2020 19:02:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c4sm699707pjq.7.2020.09.15.19.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 19:02:42 -0700 (PDT)
Message-ID: <5f617242.1c69fb81.5f090.2763@mx.google.com>
Date:   Tue, 15 Sep 2020 19:02:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.65-131-gd2bb900f3d08
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 64 runs,
 1 regressions (v5.4.65-131-gd2bb900f3d08)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 64 runs, 1 regressions (v5.4.65-131-gd2bb90=
0f3d08)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.65-131-gd2bb900f3d08/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.65-131-gd2bb900f3d08
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d2bb900f3d08e54169edc77dfab7486813dac908 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f613b525b45f6ddf4bed954

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.65-=
131-gd2bb900f3d08/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.65-=
131-gd2bb900f3d08/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f613b525b45f6ddf4bed=
955
      failing since 157 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9)  =20
