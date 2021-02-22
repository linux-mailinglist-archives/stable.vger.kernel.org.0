Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B89432192C
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 14:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhBVNlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 08:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbhBVNjA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 08:39:00 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A217C061786
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 05:38:20 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id gm18so3736448pjb.1
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 05:38:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7ArMdis3c/5pGshaPJHK0gfkstT+LguTRVePEz3DLGs=;
        b=eggY9wZFdgRefLIC66BeAQKQ4TFSwPeyXDT3d80joS1S9o5jiIkMDaj7TlMNJKXWLv
         yNvI6xlYvmao8HvLrublLn8CxHTB1NIMthSPO3Jm3DWUvZkx2QqewT7ZKmSqDpNc0YfW
         W3916motW1uQpHny24IPVu05V5D8ivyAT7pbXJYJaVLBGPWR0sLXtTgJC58j8epConoa
         H3vLFyPQ+jIVHvbsBEiqd9gdfC0D26hWAXhIRJgZGRCiPd2yxvqfzxW4GKWQsV2PvP/H
         SSuda944klTHaSqxVIufcKZodZhWhd3p08UsSDG14hA68dlMgI9LePV8lQyubqudWBG6
         UjFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7ArMdis3c/5pGshaPJHK0gfkstT+LguTRVePEz3DLGs=;
        b=SLB2K3QpvMHOaQ3dx7dh+ZOROwlm8KoB/NavuQNcxf0h0orRq2OsrDZLtXcqZa3DVW
         FMtmAkWF3cTU97FFDALzkrIUcwcXlA0m/g9NvNb/0qpHZ8zBNwd7gLC8dI95HSAmpnge
         /MRXbEPtX82zPaYtNdIiWvTXTVVEOfgFbYiR8ecAsDO3zG9nAJCaad/2W4M40/foRBM1
         DF4cpFOiwhmEVkUpKL03edg5UN+T/BbXeQ6dp/uT8u/IS7OlY0YBriRkrOeizNxBvXCU
         fjVAUxo/ZGcBFTmG75oQeXXNpE35tze0Bom1fui9LWeLZHFAvhwyDh5zmLZkSf8Jdwww
         /xrw==
X-Gm-Message-State: AOAM531/i5h167Fv/+UvLxP8UBrmc/aruF3p9JC7Ts8ruRcfZImryFmv
        ZEkCJRgO7gVwsjJOdkNLXmP0djkhuYupBA==
X-Google-Smtp-Source: ABdhPJxUTweo3OiTr6G34ODC3x6ey2kMflEMSsckGsu0efblEe29GPLKs5smfCXewIq5sEKPOnhO+w==
X-Received: by 2002:a17:90b:34c:: with SMTP id fh12mr3938747pjb.61.1614001099741;
        Mon, 22 Feb 2021 05:38:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p24sm11527314pff.185.2021.02.22.05.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 05:38:19 -0800 (PST)
Message-ID: <6033b3cb.1c69fb81.f64f5.6fbc@mx.google.com>
Date:   Mon, 22 Feb 2021 05:38:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.17-15-g77de003de366
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 120 runs,
 1 regressions (v5.10.17-15-g77de003de366)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 120 runs, 1 regressions (v5.10.17-15-g77de00=
3de366)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.17-15-g77de003de366/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.17-15-g77de003de366
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      77de003de3662bb013c6e1204570117d5c41f03c =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60337d95e9c4147559addcc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.17-=
15-g77de003de366/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.17-=
15-g77de003de366/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60337d95e9c4147559add=
cc6
        failing since 3 days (last pass: v5.10.17-5-gdb4f9910056b7, first f=
ail: v5.10.17-6-g4794fa0c53317) =

 =20
