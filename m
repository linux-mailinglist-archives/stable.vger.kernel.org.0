Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F95E439E3C
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 20:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbhJYSSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 14:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbhJYSSt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 14:18:49 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F233CC061745
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 11:16:26 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id f5so11727215pgc.12
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 11:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=W9avvp6I57az0S0GfCJ2FU9POqC5+lf48M+pneuTGuA=;
        b=7uLDaDOki8bbGOYBmkqYfWVBZ7M/LyZvWrMYsBfGDn+l9YIlXANhczsJzM+sw5d7ev
         b1dy6O55sYvkj9i/XioGQPFmt7ElMpEmV1uPrL/yC6Wjs5CbMr7ePiRG1QRVhOVg+nfH
         /QcI8MQml1NLrDExfqrzrdkVGCS1+1nZppWW3+piDWdgpvfSDVQnb5kzhFro6apQ5fCp
         6H9bHSjV9OYs4NITcDSPAmDw+CoGYnh15I8mgL2UxruJnb212XXNgSyDzINvCtIo1fAY
         GW73W6Wrr/c8yLuqxtmdc05okDWM4KefXYI0hy2OVa/v/aDy8WG755FqemNOp/8NDzzS
         YwSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=W9avvp6I57az0S0GfCJ2FU9POqC5+lf48M+pneuTGuA=;
        b=4Kg6JTs6VHG+Zo7SLAR6DY4VIWUK96XtRqaYZLcO0OmZzweKi5X/bq9u6VmtBNk0Oy
         4juhrQzQQXziqHCOU+JNpMQu4/Om7eEy9NCcWCo2cxIda8GkXHe7xI8J0ypK3vwDxHco
         X7dzzE4mgM6urY4/U3815PocaGtfSJYepgA4VbzXz/Ln2cxd54wmsNHsqZ0Hlf/D908o
         dg53cJpAT9kJFn93vtu2qvebRvpLPB/BBNoYYyN1XVkJ3WYG2Ans3ke6h31j6uzWwW8p
         eseiXy4Cy4p/lo0OyZj0N45VddSYiYzE1kTrwMZAFgM9IZNnq0Em3boUexiG6gwb4LKY
         mO8Q==
X-Gm-Message-State: AOAM53278yk+tQcRPMcTdEcua+yHSFDuV1g9TazqcO7o2AnKFir7epG6
        0OXN48O4TicVpePb+r3qAr8P+3+nZ42tUoL6
X-Google-Smtp-Source: ABdhPJyfPOLRLmumDWOG37K/Lhm9nfws6mNZW9WElwaX+PZe6QDDBC6z4CakvlhAalZwxgWLRBKodw==
X-Received: by 2002:a63:8c12:: with SMTP id m18mr7184999pgd.187.1635185786337;
        Mon, 25 Oct 2021 11:16:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l14sm22851604pjq.13.2021.10.25.11.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 11:16:26 -0700 (PDT)
Message-ID: <6176f47a.1c69fb81.6ab0e.d6c1@mx.google.com>
Date:   Mon, 25 Oct 2021 11:16:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.75-88-g629133650a80
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 151 runs,
 1 regressions (v5.10.75-88-g629133650a80)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 151 runs, 1 regressions (v5.10.75-88-g6291=
33650a80)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-g12b-odroid-n2 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.75-88-g629133650a80/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.75-88-g629133650a80
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      629133650a80d33f324897d63cf43c457f012d6f =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-g12b-odroid-n2 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6176c182d5127d959f3358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
5-88-g629133650a80/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-=
odroid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
5-88-g629133650a80/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-=
odroid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6176c182d5127d959f335=
8dd
        new failure (last pass: v5.10.75) =

 =20
