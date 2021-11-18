Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D048455E3C
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 15:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbhKROic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 09:38:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233331AbhKROiY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 09:38:24 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00441C061574
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 06:35:23 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id n85so6189783pfd.10
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 06:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RBsMOUHMX9XyjZT/g6JvMh3mjSzd3UNbx9PY3y0H4nI=;
        b=1/OMgh++b1YLdVVu6ort9d1tOAh7F/mCWt94ZaMdA/Y7gYDhNNTp68sYo/GvXTqGog
         NNkOch6GO8UTRXf9HRDTuOUSYbPkpPIKHfxgkimD/d8IrKR2xn1YosXg7pBbKFtMk2t3
         i7Dxe5HLs31Nl8V780UiWdQSdrD2QIkil6f/21dRQXS69eDawAd5TSRxuDQI7OO0QUoE
         wBA/oeqF25Q1qxeTX9LFclfHF1Sg+AC3R/lyT3/w4H1cZ8J9gceaRViBABzieNZP0COP
         YVTFujyoPrcWvy+WylIbYPYJiOQaqrzYOeP5TD4gO4ankXlS1utERIOZ27oReWiQ4Z1G
         MpBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RBsMOUHMX9XyjZT/g6JvMh3mjSzd3UNbx9PY3y0H4nI=;
        b=48Z7cL70od2XywczmZSXYv2GhzPyY0356QY2V7cX9Fdft5HF6fgz1z/stACdRuF3gB
         POSnuuonYFhvB88uQfKpAccKZAW/tAww9qsbvlEXgmpXFLQJsKUN3AjxXmeYGYUqZyKs
         5Uc+ZnLVF3KHSsAGSFY/hdKywi6FsjCpzgnzBI51yXdNp2daGFXLxJIULJQkcXHNv5T5
         dXeqxFYLpz+afT9bjhXYNCiYf+daZkohTgP6ttczoWaGGed7R/7kyH36R3dDirUxLNfN
         9Spe7O75nX3OZX2M8GGH5vOP19vZFoLFxuX+0j6oWAyX2VAcMnbv1WmXBVKdMx+F/Z0i
         o+Pw==
X-Gm-Message-State: AOAM530zuTVjMt1i23c00eilAk5pOpaYOeTnE4UTGPuKQ9g08tf3H8ua
        ldeANmbcSGRgTofdrGH690LApInRr8eHOvvM
X-Google-Smtp-Source: ABdhPJxnzdFTkSVlaCDVD38JB0nBCn/m1OGhHajWw7ndA0jjlqi3qY6iGVBkqkcWKsY/5l8fciFx2A==
X-Received: by 2002:a62:3107:0:b0:4a2:63ad:8aa8 with SMTP id x7-20020a623107000000b004a263ad8aa8mr49520383pfx.83.1637246123433;
        Thu, 18 Nov 2021 06:35:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id qe12sm9429373pjb.29.2021.11.18.06.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 06:35:22 -0800 (PST)
Message-ID: <619664aa.1c69fb81.11d1e.9c3e@mx.google.com>
Date:   Thu, 18 Nov 2021 06:35:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.290-159-gbf72a0fffb43
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 113 runs,
 1 regressions (v4.9.290-159-gbf72a0fffb43)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 113 runs, 1 regressions (v4.9.290-159-gbf72a0=
fffb43)

Regressions Summary
-------------------

platform    | arch   | lab         | compiler | defconfig        | regressi=
ons
------------+--------+-------------+----------+------------------+---------=
---
qemu_x86_64 | x86_64 | lab-broonie | gcc-10   | x86_64_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-159-gbf72a0fffb43/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-159-gbf72a0fffb43
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bf72a0fffb43800edcf9b73df2c96f7c14978a38 =



Test Regressions
---------------- =



platform    | arch   | lab         | compiler | defconfig        | regressi=
ons
------------+--------+-------------+----------+------------------+---------=
---
qemu_x86_64 | x86_64 | lab-broonie | gcc-10   | x86_64_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61962ee2b9cf85527ce551df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
59-gbf72a0fffb43/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
59-gbf72a0fffb43/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61962ee2b9cf85527ce55=
1e0
        new failure (last pass: v4.9.290-159-gc2e93e98e6478) =

 =20
