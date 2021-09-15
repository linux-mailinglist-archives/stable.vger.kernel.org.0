Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC6A40CDBA
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 22:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbhIOUIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 16:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbhIOUIl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 16:08:41 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26ECDC061574
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 13:07:22 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id y17so3671775pfl.13
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 13:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xdGhu4wGHzl7DquBkKtI9gX1UV8nRMwl1qOKuYY3RpI=;
        b=eRH93Q7inO9U5U1M87XZKPF3pb/p6hhElum6Hy8QpWGurkYEdzZqSoKzr1QePO6TgP
         x8iVk3YQwYlLlhGuESQTZeA0Gmkv4U/vptXzoERvKqmoeas+RHuSjNXjQXIXl2QbDYm5
         LKE7Sz+z6NNuYd6bpwq3NanK7JAqXDximrmRvSW+UjOvHHNRC6QEYgUgMPnHQC1OrwAB
         0dLuiMztbi/8NcL4tTn9Asz+vbcNRsODIKqmpj3FjpBgTPQ8G3BmSdQ4Kw8beiGK4F2q
         wGM7abSlw65l18w4QCwdxMKmB/oRagQ5ruTA2xkfecqB77obZP+H6Ew+9thfKxAAkV6N
         Bssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xdGhu4wGHzl7DquBkKtI9gX1UV8nRMwl1qOKuYY3RpI=;
        b=xi5kFVuvt/mIUWevI1XTxgFtFjFnZxSdAMSaDFYSRkRRE+Fp7E68P4j4UiEvyq9s6k
         Lhsc7xdlZvSzvoBXuG+AEV8bN5UPuzDSlpDyELzd8vORB0HvF4TIzemQkzkHI7TXZHc2
         ok4NE69z6FXEDFoCHeJyp+MvPmFg+y0zbtBWnK/pzUGJGHcHEzJym7OKhlrfsWpkyINz
         C2p9ivXroqUrQxo0VmjprTCrMLKJPxEfSQ4CWEy0KCBGUx4sJmo9hXMGpmQXMOiig0yv
         yy/d12L/FslmSO3UDJ43Ni7FPPd1ifib723p/I2BRrDmdFO+6FjjfnF0LaAGlHrykzDD
         NdTQ==
X-Gm-Message-State: AOAM532MopRRBWczl0TCyyw7cXsgEHinpvs7lTQ/ZHtuRwqI61vkXFnC
        QHBopRtuKXL3S/5IBsbGcEVzwY+zIPBrsWlvpTo=
X-Google-Smtp-Source: ABdhPJwnj+Skm5pXhS0oCt0xD0oDTcW39BcAvHIDO0MF/KG8qfPXE2nQqhpbKptqB8R4ZxWB97ZtYQ==
X-Received: by 2002:a62:b511:0:b0:416:30f0:daab with SMTP id y17-20020a62b511000000b0041630f0daabmr1256433pfe.47.1631736441560;
        Wed, 15 Sep 2021 13:07:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y5sm785787pgs.27.2021.09.15.13.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 13:07:21 -0700 (PDT)
Message-ID: <61425279.1c69fb81.c2b73.3a62@mx.google.com>
Date:   Wed, 15 Sep 2021 13:07:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.4-73-gc291807495af
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 176 runs,
 1 regressions (v5.14.4-73-gc291807495af)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 176 runs, 1 regressions (v5.14.4-73-gc291807=
495af)

Regressions Summary
-------------------

platform          | arch | lab     | compiler | defconfig           | regre=
ssions
------------------+------+---------+----------+---------------------+------=
------
imx6ull-14x14-evk | arm  | lab-nxp | gcc-8    | imx_v6_v7_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.4-73-gc291807495af/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.4-73-gc291807495af
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c291807495afbc460e85776f8c287f6f9ca92060 =



Test Regressions
---------------- =



platform          | arch | lab     | compiler | defconfig           | regre=
ssions
------------------+------+---------+----------+---------------------+------=
------
imx6ull-14x14-evk | arm  | lab-nxp | gcc-8    | imx_v6_v7_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/614221409460bebc9e99a2fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.4-7=
3-gc291807495af/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-14x1=
4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.4-7=
3-gc291807495af/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-14x1=
4-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614221419460bebc9e99a=
2ff
        new failure (last pass: v5.14.3-328-g86b6bc3e3300) =

 =20
