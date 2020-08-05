Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7859A23D1C7
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 22:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgHEUGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 16:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbgHEQfG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 12:35:06 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087CCC008689
        for <stable@vger.kernel.org>; Wed,  5 Aug 2020 07:28:27 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id r11so14896518pfl.11
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 07:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pMxDybBI4Rnhv0ZPNmt9Xmslr5k1gZeXdz72YmHUsHU=;
        b=Vpgpmqrh69a6FL4xrpBoPfOZq7vy3FgNjeV+GuCMSCuU8PU1PpRJigOyhGfvDXc+E+
         LOBf4kja21Z04+M/EtvG4mpiZNoZgHtFRgMFIJ1maEZeSgcwatQ6QOMRqBzy+1QW+m6S
         fFZK1kDfOjGhJcSUzqlEwK8ogQw2AJSLTKesCSaLhv5yTKYIdg2EEUNzawFSOqHyvDI4
         Xhhxw6rbl+lRxHOO73eeQjYED2XICtTueQGT/B1YHAoY1KTCDbuXL+LKg1E3QnY465jL
         G8Kl/mPYoosvZ7kUczTpHqr5pVRkLOYqe/1J7LWWAHnvXHjAn6Qpm99AgupnA2GjFf1Z
         X5cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pMxDybBI4Rnhv0ZPNmt9Xmslr5k1gZeXdz72YmHUsHU=;
        b=XMBr8uV6zV7AEj/ATYllN3M7L8FMz3+4hpWd/asfPetM4TkIYQnIOmz3DI5mwR8QBQ
         aJL5w7SR1XEMfhFl8z8W5iWizGp6Ll+UxhOs10tA0g/NYSHvy4LpRWcAjBI22l3oAAuq
         WYfxsh4ZQwHtVa1Elmmaey2hzh4ti72mi1lA6CEuQCnecicknHDfOeCUaa5xEuwf1vxB
         g1jlT6kR5mAxUGIn6QNNlXHVYq9dmVnn1ZTOQSmpRN1asQcj5zHnG+L1PL/fnMfIgjqL
         CiAVhQAPzZt2f+nfCRgn15BPHwacNOOfpmqmhPPgAv7j4SMUnfvVe6/X+wbGgKAyrE5H
         YrIQ==
X-Gm-Message-State: AOAM533xowFveXvn3O49snYURjGT0bT6iCChG+8FXwn7J1aqQGp+PpbE
        /c34gooJsvjbT5kPgotLiN1nhUJwqjQ=
X-Google-Smtp-Source: ABdhPJw2qKu1xto18UnEkuagToUjVrXs9lfXkT274h6tkSDn01SYf2EXtwUW1nfuQWfxI8mJFHdB3Q==
X-Received: by 2002:a63:ff03:: with SMTP id k3mr3119656pgi.116.1596637706231;
        Wed, 05 Aug 2020 07:28:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a19sm3939203pfn.10.2020.08.05.07.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 07:28:25 -0700 (PDT)
Message-ID: <5f2ac209.1c69fb81.83684.9612@mx.google.com>
Date:   Wed, 05 Aug 2020 07:28:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.192
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y baseline: 153 runs, 1 regressions (v4.14.192)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 153 runs, 1 regressions (v4.14.192)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.192/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.192
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      ca4f2c56d4162a4a5236f2099b55453fb98296f9 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2a8df3b659055b9852c1c6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.192/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.192/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2a8df3b659055b9852c=
1c7
      failing since 124 days (last pass: v4.14.172, first fail: v4.14.175) =
=20
