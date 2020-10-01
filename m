Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D2A2804BC
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 19:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732808AbgJARLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 13:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732213AbgJARLi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Oct 2020 13:11:38 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E73FC0613D0
        for <stable@vger.kernel.org>; Thu,  1 Oct 2020 10:11:38 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id u24so4536860pgi.1
        for <stable@vger.kernel.org>; Thu, 01 Oct 2020 10:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+WsNuhGGIvz6KO8npqxTeyAijfIsjC0xbZWMKmcPUYw=;
        b=eyCw/QpUSoxaX0TBCG9GYQQ+ewMZSRCPEyaobsqSmXimj3lr0Di3QMfB0o8JJWCHDa
         wL4uVQHiVDc7yi57y6SVWlxbWTZwzy2gT0gnpDhDK1WIUOv4uElamp4k0lh6tM1ktece
         x3/AS1GCXj0gOxsgfBavEMvB+urXA/yeUAlNShbQgZC/XJu04SEC1EsoJRMowyBAwwl9
         pDt9/BzbL9fR0n8gqMcX7iJwtm9YPS/lmtvXiQKURm1mrejeRQdmFychUAVSAwUtUxKj
         0Uz5PfP82otgIz/T75kQV5JO7TOebhdR9yj/7s9VXpynT+ZC4iE9Q/qwGxMIY3uyvZQj
         860w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+WsNuhGGIvz6KO8npqxTeyAijfIsjC0xbZWMKmcPUYw=;
        b=Lf8UkjFWhbDxY4NNcG9iiD4H/T3YAwptG8dbb51iTie3xQJnGxXoKlgR8I9ybHCJ8r
         vYruynDJspm2+6MmI/58kb5KVDnCgcCuH1yXYHN2vbe2FLD581KORBQRunZ3ouK5u4Pc
         N53RQnOO2Q05KJyVZzR6J9UuTaTslhAF+0h5QKuZ7hhaN05FYqN34bofqKJ+KaUHB1qj
         TUxH/DKAiUrWXDUyNWFjia+2brkY1CtOHPDM8KL5UQj+PyZKC2h0ryukxXYz52QbbHDo
         LFUPoioTp3mDCcszH9h7AFwT9hWzKSvGcu8pjCHH6ghjrJj4kV9OEfQkaVqLFu/64eZP
         tRXg==
X-Gm-Message-State: AOAM533RxfO9OUxG77CxNMkiOib3TF0q5uUgNnzWuCcINX/xfH3eqxq9
        K4EYrpd/vInaR01abY+qeRKQZNg22d2EgA==
X-Google-Smtp-Source: ABdhPJz63S89Pdb4kziwbUSkwoDAH1lDbgBjHmLmAoG6RJA1r+dwmJZdT2SozV+f6uRDVkdVoa71hg==
X-Received: by 2002:a17:902:9e95:b029:d2:4276:1ddc with SMTP id e21-20020a1709029e95b02900d242761ddcmr8689308plq.81.1601572297588;
        Thu, 01 Oct 2020 10:11:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k128sm8346924pfd.99.2020.10.01.10.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 10:11:36 -0700 (PDT)
Message-ID: <5f760dc8.1c69fb81.dd7fa.0b74@mx.google.com>
Date:   Thu, 01 Oct 2020 10:11:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.200
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y baseline: 129 runs, 1 regressions (v4.14.200)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 129 runs, 1 regressions (v4.14.200)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.200/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.200
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      bae31eef2a167ef160ab2703b6a2f5bbecd98d92 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f75e37ef9833c09cf877191

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.200/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.200/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f75e37ef9833c09cf877=
192
      failing since 181 days (last pass: v4.14.172, first fail: v4.14.175) =
 =20
