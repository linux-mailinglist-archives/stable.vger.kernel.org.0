Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4904377435
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 23:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhEHV4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 17:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhEHV4G (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 May 2021 17:56:06 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3765C061574
        for <stable@vger.kernel.org>; Sat,  8 May 2021 14:55:03 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id a11so7321243plh.3
        for <stable@vger.kernel.org>; Sat, 08 May 2021 14:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0Q+/eGdF288tpUoI8s2Xv37SdBg05Gp3OIlWK9uxKYw=;
        b=UjvgUnhUhyPQz0NQezMityNimnVhIm0gGbkOlP/PQAWO3zxrteQl4l/8qm5B/RcPdf
         JBgazezlv8E4A4pbKoiwnS1EyjLMuaOaYLZuzyos7NJeMbt1ijswczanXt9EEFw2v7SB
         kTcXpBYIuB2oCxiUz6IDfqts0uHg/KvR0p7Bw8pfHEIJcHKPU14bXvruxCOMUqrkcvhO
         2UM+xUzE+t5g7z7K9D3RynglHiCmVfJA4Xticx87IJjHzyFc0fLcxGZe7mJMkZpNXtwu
         X1Y2UCRq9+p76IBHSm5TLIl0tgrKZVLAbK7K0++08bIUNwQPBPRxS7eeh5Es45jALMhc
         QheQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0Q+/eGdF288tpUoI8s2Xv37SdBg05Gp3OIlWK9uxKYw=;
        b=oaCtUL49buIA4yL8OzWTmMXF3si3L+mBAXzGQPd8PFpyDLrGFpAOZtT5/DwbO7kdCI
         cN8IouyTsVvay2X8kF53pcxG4GVICgGyR2mNr6ntFw1EjIy2TIszWeuv6JdSkPNB44WY
         jtDm3MKgQfnBuKf8fQaGxf0km3PY2ApLd4n5qTbPy8dH5IuQxshChKBfSB5AieQyeYSO
         sTlG2B2O7TT2/GlSsOij0E5tOJzMiQ2536ivcA4ZTq+THjadFE06g5wZ79GiefKNLmJw
         4rUeflTXa3XtR0qBgywVeFvs5Siu41b3K5u5MfsSGFK4GCN9htTzHBLfqcQSYhJGUgH+
         1bUw==
X-Gm-Message-State: AOAM533sYXDGs1LyPhho/bolnCEmRBZZTSXBAJVaWldySgYm4RdpNc9Y
        uXMTeZht9VnLgNm4WQSPLqwL5IwAvNDRVNQB
X-Google-Smtp-Source: ABdhPJwHDrLBNHKmHc+UbeHmFIG7vhsPmXM0NNZ9CTW9J7J99UjMHn8unuBC5Dx60s4xmJPPUs/Utw==
X-Received: by 2002:a17:902:e891:b029:ee:fa93:9546 with SMTP id w17-20020a170902e891b02900eefa939546mr16803949plg.23.1620510903081;
        Sat, 08 May 2021 14:55:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q5sm4906011pjg.2.2021.05.08.14.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 14:55:02 -0700 (PDT)
Message-ID: <609708b6.1c69fb81.ac18b.f50e@mx.google.com>
Date:   Sat, 08 May 2021 14:55:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.11.19-254-gd241c3fb00ee9
X-Kernelci-Branch: queue/5.11
Subject: stable-rc/queue/5.11 baseline: 140 runs,
 1 regressions (v5.11.19-254-gd241c3fb00ee9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.11 baseline: 140 runs, 1 regressions (v5.11.19-254-gd241c=
3fb00ee9)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.11/ker=
nel/v5.11.19-254-gd241c3fb00ee9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.11
  Describe: v5.11.19-254-gd241c3fb00ee9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d241c3fb00ee98732475c4880362c845ec739da1 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6096d6471b6c5cfa8c6f5473

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
254-gd241c3fb00ee9/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
254-gd241c3fb00ee9/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6096d6471b6c5cfa8c6f5=
474
        failing since 1 day (last pass: v5.11.18-29-g6c2ae64a2a728, first f=
ail: v5.11.18-30-g4232ce7a02cc) =

 =20
