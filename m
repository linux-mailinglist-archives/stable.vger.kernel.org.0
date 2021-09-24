Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3875641765B
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbhIXN6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbhIXN6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 09:58:53 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994FBC061571
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 06:57:20 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id mv7-20020a17090b198700b0019c843e7233so7589774pjb.4
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 06:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LWIi4fjKniCfyplsztd7vUNxscn7SFXdsnvm4mQvJpE=;
        b=xKqVbpGOfwjWUh4rbD3a4xW8+NlKa8XreKgGXda2nX2CJc3DbNrXYrc/wLB3kuBMWK
         H2pRmze+vmvIGJ1C6rem2SA2oKB6ISc+qILsaKHoljgWF03JAu/q2NyC9uZXS6HN+hgW
         YBcR8v/B8rq3mxLe7RDu5Zn3YaEYL/icrp9PYXvb4tDW/UnUs+NsUOINk0j7jtQ7sF5Y
         sKOwyy/s5Q7jRkq8AuhcWc5HWqCKALXw6Fzxn31yP87VgPpn6fheEADS1ltjjg+O8F8P
         nb/y0G4xE71BK5aR8NmjmNVi7mCEQKo0jH6qElS3YYBaZnE18xqRuqtqfceaUoiY5/l1
         AoUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LWIi4fjKniCfyplsztd7vUNxscn7SFXdsnvm4mQvJpE=;
        b=HVfz0WC+NkHTeEWvJyU4w7hlstEuRzIMFgANZek4EcZt2YrKZCeCRMd6yfI5CVWAvG
         ijuhN3duwAIPIoiyRMwwa70nVoxRILnWXHBfPFvvPQ5QVyJGdHFy4v/NpHtq4CGNLCV8
         6fpOq6ErYoyW/d5Uc+XFW/zw2xuANU/tJ3p9qm9TfWiTTyp+BWPCc4h1pBEoxveJZl+8
         nWxZb/sI2JAdrQkhJ0il+Ki0OJR4B4ZtNmHH1AqNaGd1EVKqefAUI3TkBUWHeDjtE+OT
         Snz+rqRBR8RQKA6X7uztaiIQRhf+8s/XZRC+QDoYxeQgRHouKpBOck8ng4J9u8Uixk2W
         QLcA==
X-Gm-Message-State: AOAM533a6oCrivPxEua21sUwHU23R8vqZg06ImGBSCoISckq2QaY+O/Y
        LWKYAkbL+SYJwci0RaWA6LUiTs2pLgTc82WK
X-Google-Smtp-Source: ABdhPJws7gD1Oq0U4lBInnrwIEqHshwQ9FS9G6QprfWjkyYl1CS+a54kpORcNZ43VGwLnZDXXsUh/Q==
X-Received: by 2002:a17:90a:1942:: with SMTP id 2mr2389078pjh.195.1632491839888;
        Fri, 24 Sep 2021 06:57:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q4sm4221622pfl.50.2021.09.24.06.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 06:57:19 -0700 (PDT)
Message-ID: <614dd93f.1c69fb81.ae7d6.e40c@mx.google.com>
Date:   Fri, 24 Sep 2021 06:57:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.68-10-g027039d50beb
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 141 runs,
 2 regressions (v5.10.68-10-g027039d50beb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 141 runs, 2 regressions (v5.10.68-10-g027039=
d50beb)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig | 1 =
         =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.68-10-g027039d50beb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.68-10-g027039d50beb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      027039d50bebaad8a9279dcf19a6f22f5c457413 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/614d9e784611a6fef899a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
10-g027039d50beb/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
10-g027039d50beb/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614d9e784611a6fef899a=
2e7
        failing since 84 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/614d9d21f2f17b384399a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
10-g027039d50beb/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
10-g027039d50beb/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614d9d21f2f17b384399a=
2e7
        failing since 11 days (last pass: v5.10.63-26-gfb6b5e198aab, first =
fail: v5.10.64-214-g93e17c2075d7) =

 =20
