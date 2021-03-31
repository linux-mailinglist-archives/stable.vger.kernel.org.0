Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D2434FA48
	for <lists+stable@lfdr.de>; Wed, 31 Mar 2021 09:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbhCaHbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Mar 2021 03:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234158AbhCaHb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Mar 2021 03:31:27 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C2DC061574
        for <stable@vger.kernel.org>; Wed, 31 Mar 2021 00:31:27 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id h8so7453340plt.7
        for <stable@vger.kernel.org>; Wed, 31 Mar 2021 00:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QeT1z44W33/lYy10EM9xmoT0V258b/MVXPoJy8OvvTg=;
        b=lSy8eWgQpmRrkM1pOFGG7UuKdqgKxM5fVTfhNyRyN4HXQyWXy/QRK0tirD2dPdMZFj
         8siY3OYuQc1QOVh5pQolhaweBEgRHq0Sm3o+vurWvGVfxzVfiXopqS+apKXrHIGS3DTV
         VNHS61B9xarsr8YHHGRl8mBXU7omOWpSUMO16POAfbCb+2kXZV7TdZ+EaTcIyAfsjqSe
         +75C3UFxL/Xzkh10JMRxUTRuWAd7rAFKHTfufmZa2M2xp+VxN7PVzTgA1L2cVcYK/5CI
         qvk0cZTpDzirQ31kYuojvudqSMsgB9EzBbq7uKisjMo5tJNYOdwfCcGTkdGQFgNSmt1x
         ZgLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QeT1z44W33/lYy10EM9xmoT0V258b/MVXPoJy8OvvTg=;
        b=PZhpughdCobS7Q08Abr5/hMfUj7BCjJLpVfQ2gAu7PwgWQfLCnqAzTVv+hrcSFXhGl
         qNscJ9KFDbogIzrXW6qOSmhc8PwVydagIJ7s+Vp+hG4/iH5J8F4s6kpfkdSfJqmQ+xe/
         CeGxtiyIFOcP6yZuNyggqjAE1J+98+W5y9gd/fBD1+Bmje2QAipObvT+nAwoKNDXO3Fx
         Zy0WnaXRv7k+f1+d+ktN+wIUjGAvqGcq5voGGdn1bYNyA+NYGzSrYDJsU0jwBOfFdghc
         FxZXxpykm2Co9C5DvbptCV0YIdNoRWQ7tELG5DP901Qchbb7ZmwRH6FP5LiF2Hu5F/Ho
         3wIg==
X-Gm-Message-State: AOAM5339XMSkdyyGjNiiF78URiYKw2+rruAzoMK4ig+Ar+BPGjWFa39T
        7X+cg4DfQPnpVns5PYZymS1M+UK+qg4cfA==
X-Google-Smtp-Source: ABdhPJyzpTgLpm6it4q23D/bS2EHqQd+zz8+Yw933XJkrv3hK5+qWrkHRZ1/sutaG7ZeyDvUv3iNaw==
X-Received: by 2002:a17:90a:e454:: with SMTP id jp20mr2286118pjb.129.1617175886799;
        Wed, 31 Mar 2021 00:31:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x2sm1089198pfx.41.2021.03.31.00.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 00:31:26 -0700 (PDT)
Message-ID: <6064254e.1c69fb81.35b28.3030@mx.google.com>
Date:   Wed, 31 Mar 2021 00:31:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.109-29-g0914ff5af18e7
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 153 runs,
 1 regressions (v5.4.109-29-g0914ff5af18e7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 153 runs, 1 regressions (v5.4.109-29-g0914ff5=
af18e7)

Regressions Summary
-------------------

platform     | arch  | lab             | compiler | defconfig | regressions
-------------+-------+-----------------+----------+-----------+------------
qcom-qdf2400 | arm64 | lab-linaro-lkft | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.109-29-g0914ff5af18e7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.109-29-g0914ff5af18e7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0914ff5af18e722d6c63f322e899881bec1b2bc4 =



Test Regressions
---------------- =



platform     | arch  | lab             | compiler | defconfig | regressions
-------------+-------+-----------------+----------+-----------+------------
qcom-qdf2400 | arm64 | lab-linaro-lkft | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6063f1de21f2438393dac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.109-2=
9-g0914ff5af18e7/arm64/defconfig/gcc-8/lab-linaro-lkft/baseline-qcom-qdf240=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.109-2=
9-g0914ff5af18e7/arm64/defconfig/gcc-8/lab-linaro-lkft/baseline-qcom-qdf240=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6063f1de21f2438393dac=
6b2
        new failure (last pass: v5.4.108-112-gfa41218230fa3) =

 =20
