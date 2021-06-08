Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBA239FE90
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbhFHSHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234161AbhFHSHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 14:07:34 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E9AC061574
        for <stable@vger.kernel.org>; Tue,  8 Jun 2021 11:05:41 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id u126so12341344pfu.13
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 11:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3uCcAXy1UPEzUxQYUM29x9g48de7PoKtSa2ZIPK1UgM=;
        b=FJ8HF+XZK+iIxbC0AaqVQG1/TbVTNFj2pV0/VVXVg2c1ENWd9q2onfffd/KAMndczi
         2D3lNrPw7sDNjGuVkkkrCSgyGAbKV14J/oVyttl2Gc4bJa8A/mPvPYxNSZSKlwwFsZ23
         G6Y1LdISmcHgcbOuakOkEDCqw2oB2T32UFAlMzmHShHQsIRfZd+tyk0X/ieu9v8K8cL7
         8hT000+3WwGzXD8vgsKWq7VSnjnogzQzvR0CP8e++3ipHYyiffZdUN4jSZNwAbwUOhqk
         1CHnS8FTjQd+UltevOoEpkfXo4BTfDxj5qnM2cPgVFolLmp4vfsogiBl41r4OqDnFyZs
         ig1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3uCcAXy1UPEzUxQYUM29x9g48de7PoKtSa2ZIPK1UgM=;
        b=Gac3/15bakhR3VeC0YRBKxHsk/f7hWOB1SMfKI9Rbwdkldtf4pieQa9p5sp/8WVYVW
         P7C+qVzByfPLkvPu5MAU2P46vYxtTVQZNRJFr1r3BR++pci91TnXKqkkl+Ofm7958Lis
         IYMOchkBEaQ8gEQXsjbzM/uVZcrPt+ql1c6VgDNoZHxmuWxwuMawA4zb35wwq0KbjYlp
         9vBAbSMnHOxWiomJgPJgjz5rdKZWMv3I6CsbrPO69ExizzI1+RFcDPGyATr335CfIVqa
         dDj97f8YZ8Bcykio9PmzMDlW8W3JqUkZIS2IKbwx2ppmrJo6ShDd3cyNw5bdpBWC4/LT
         4t/Q==
X-Gm-Message-State: AOAM532zMfCVB1eNDqZZmWI4Nm6cEDaguOwm+Pd5x8dIfbKFjoyRBYxD
        I337sanksybyYW62Z0ymljWUuAaw5ktxdJD1
X-Google-Smtp-Source: ABdhPJxsWYUUShbXjHgJT4ipTIGXwICHvx3u01Fc1ZmE72hdXkLKKXPucqFvA5yD33XWpEwdXq3Nqw==
X-Received: by 2002:a62:5285:0:b029:2e9:e0d5:67dc with SMTP id g127-20020a6252850000b02902e9e0d567dcmr1121544pfb.79.1623175540719;
        Tue, 08 Jun 2021 11:05:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s22sm12099528pfd.94.2021.06.08.11.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 11:05:40 -0700 (PDT)
Message-ID: <60bfb174.1c69fb81.21cfb.51f0@mx.google.com>
Date:   Tue, 08 Jun 2021 11:05:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.235-21-g36ad1594e5ec
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 135 runs,
 1 regressions (v4.14.235-21-g36ad1594e5ec)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 135 runs, 1 regressions (v4.14.235-21-g36ad1=
594e5ec)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.235-21-g36ad1594e5ec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.235-21-g36ad1594e5ec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      36ad1594e5ec963b931a1b44ae2289fb772e1777 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60bf8904a899fdd72f0c0e15

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-21-g36ad1594e5ec/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-21-g36ad1594e5ec/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bf8904a899fdd72f0c0=
e16
        failing since 99 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =20
