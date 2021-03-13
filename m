Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F18339D77
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 10:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbhCMJxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 04:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbhCMJxy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 04:53:54 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AEBC061574
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 01:53:52 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id s21so6349903pjq.1
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 01:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hHAPehmM4GGdJUgNpL3+ZwzxsqM4W6SYddCIeI9p+P0=;
        b=FJzwJG81hRLHCJcwWEWUC+Ddf87qWcX/bTbTu30QixrkD0SzynQbZjSGRD/AmjF8Bs
         /yG8CvbJy9On0u7hrmH8yfPPUCQ24vC3Whq+w//MDn5+FL30hWcqMc8X1B3eqL6S8Bix
         RVuqT5Jkhk7DvKjTJxjCkYaK+JsQ0aC3/B4UbEDzKDZDFtVD31y7C9lumfGYzUvYv5F8
         CgQ7av+cZv0hN+86YTmNmY2zWAyTaf2RLxGg5vKvjNlDQkjnMYsy4FIKY2V2wHoeItpI
         wqW2pLKhuhu4YAYS37mATxKX852OsSYlRokLbP5lPik5nIzV9QgoUwiomgY+iDCB4VaB
         BMRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hHAPehmM4GGdJUgNpL3+ZwzxsqM4W6SYddCIeI9p+P0=;
        b=UeLmi8ATsJZD9NDNDmnH76WYXKplLyAipSKZj2yJm8MXq/m94k4Uw6kzpbmT1Swblt
         L342xykVCxnvftI3/w2YFdVecjlFNbyt21n7OB+7vKTSeJHLhyZ2mZhlPpisE/WXEgHv
         xdGv/CuOS2S2rcwTa8AbBrKZ+LLgDWETiXmnhTJ4RBANlifSQ6zPkzvUcvNFMlL/no5G
         rYT01Cc95bcpYwkM/FfCLHIFvmseFFl9T1QaK5ZBHBU8052JDnqK8cjJD4fsPqgeDYKr
         EuapZZBm+sciU0i+mxRC4KByol36E+7O24unD7UCzBrx68VgGIE2ciRAWxDA3jExBvFx
         pZtg==
X-Gm-Message-State: AOAM532iqc1r1PcpkAQ9aNhVYaTvD6abfc8PMr4nicdshQL/WuUz9UkG
        DfY/DKm0j3xvpZ+v6GZEuwcNoKhePw0iFA==
X-Google-Smtp-Source: ABdhPJw2HL+rvY4fU3K00JvBqnwV9Z2Q8a740CsYeH6ukZjPK6fUGpRnBxQjk43eJAzafSxO+mYyvQ==
X-Received: by 2002:a17:902:bd87:b029:e6:4c27:e037 with SMTP id q7-20020a170902bd87b02900e64c27e037mr2655482pls.29.1615629231464;
        Sat, 13 Mar 2021 01:53:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s62sm8169925pfb.148.2021.03.13.01.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 01:53:51 -0800 (PST)
Message-ID: <604c8baf.1c69fb81.29262.52b4@mx.google.com>
Date:   Sat, 13 Mar 2021 01:53:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.23-172-ge7d3c04ddf7db
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 122 runs,
 1 regressions (v5.10.23-172-ge7d3c04ddf7db)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 122 runs, 1 regressions (v5.10.23-172-ge7d3c=
04ddf7db)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.23-172-ge7d3c04ddf7db/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.23-172-ge7d3c04ddf7db
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e7d3c04ddf7db7d8260de55048a21d7b634ed831 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c5ad458ff07302daddcc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.23-=
172-ge7d3c04ddf7db/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.23-=
172-ge7d3c04ddf7db/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604c5ad458ff07302dadd=
cc1
        failing since 0 day (last pass: v5.10.23-31-g559d8defe7bb8, first f=
ail: v5.10.23-37-ge21780881c24f) =

 =20
