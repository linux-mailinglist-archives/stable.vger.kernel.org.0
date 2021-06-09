Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2191E3A0A38
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 04:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235869AbhFICtg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 22:49:36 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:46704 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbhFICtg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 22:49:36 -0400
Received: by mail-pl1-f169.google.com with SMTP id e1so11751867pld.13
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 19:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YpKf6hd3Gc6BPCG1oKqJOU/nRztDqOF8mhegAC5KjX4=;
        b=PAy4OF7RH4Z8pgbjYyuK6Y/GWUu7U4uTofoDAFVXsDIcgN96RFeiuPei0gOsX9eCuv
         5JnskOmi4NA145VfzEi7bsclzCKgGAL9zO5bfCJMgg4B7335Rv3tKj6AjAk/MiQLNLZ7
         AcpvZ/xgiFfrYht7HrWwwHq1y/EVuluOUgZROu6hwEtbuTmblYnKVpvC/Wx/kKXDow3H
         W2ZZjR6ieGNrkM/yGrWdd4PFKO3rJyvLy+eaWSL3g4hRmHSOG6hQtrHdkodqnUJOW9Go
         Njdk9VRQWMnR10luvWTb9+LJixVrm60zOqqECvBbcoinTutrdsWWqBP4l5arl9YgRhjK
         8YyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YpKf6hd3Gc6BPCG1oKqJOU/nRztDqOF8mhegAC5KjX4=;
        b=ack+0A5yeZ9mAS5G6PcKS7TrM2XF1uwrJ1N74LAFNlqbeAZt8a0Mi7V6Lx/Oezrkut
         QWudkKomVRI8xD7JCXgUx1MNFmwJy9Hf3EegSO1ajkNFP0qnZIIaI///sCXSi8tv7Zpk
         tCRuXTA1VfPrGx1VS7mHH0CPTicXLLyL6YsYv8FdlvO/tGgWBirL4zjjPlFAAWc6/AxX
         819XRSlNwoHXm0DJS7uQPbz1Y3xYaJu39178hmBbqTE/PdRg9fIYRxq8Z8OFIrWeXyiY
         g7a0b4pWu8jqHsE/idr54U/WHUcXxA98tfpn/D+aglQq/BUhByZKkn4SnUTVpI2YIw2A
         YxFw==
X-Gm-Message-State: AOAM530gSvI+HFgDX7PtcpffQPl1b3jF6W+sdHvdViabFApSR43ILVFp
        rDCxZkflT2pYjGf3aOoQv2uIZ8SPx3jWDpNf
X-Google-Smtp-Source: ABdhPJzo/+i7jI0/Mq7U3wNMnaIt7erDw0ERAFGOFVNCVFPK6OdhBJOMWL84vDO41qQos5Fka8zF8g==
X-Received: by 2002:a17:90a:4282:: with SMTP id p2mr29264171pjg.21.1623206789105;
        Tue, 08 Jun 2021 19:46:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w2sm12061222pfc.126.2021.06.08.19.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 19:46:28 -0700 (PDT)
Message-ID: <60c02b84.1c69fb81.23ccd.6622@mx.google.com>
Date:   Tue, 08 Jun 2021 19:46:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.235-47-g4491bf20d46a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 127 runs,
 1 regressions (v4.14.235-47-g4491bf20d46a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 127 runs, 1 regressions (v4.14.235-47-g4491b=
f20d46a)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.235-47-g4491bf20d46a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.235-47-g4491bf20d46a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4491bf20d46a163b40067b33b9a1c1a30115bc50 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfff65ee80a51b7d0c0dff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-47-g4491bf20d46a/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-47-g4491bf20d46a/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfff65ee80a51b7d0c0=
e00
        failing since 99 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =20
