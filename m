Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A793A3E4F81
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 00:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbhHIWuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 18:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233266AbhHIWuy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 18:50:54 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41048C0613D3
        for <stable@vger.kernel.org>; Mon,  9 Aug 2021 15:50:33 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id t7-20020a17090a5d87b029017807007f23so1363016pji.5
        for <stable@vger.kernel.org>; Mon, 09 Aug 2021 15:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N+zP+jcTZOOeSiBgcyC4YM8PIPpBOhU7JQI6pwim8Do=;
        b=oUnk28r81QhZo7G589jMO5YM9Xs2jbn5I/nnxCofxcQPddaeAnhS2FO5zcFXdF27ZR
         vwWsBae0HiTBkC9SY6rYjgsPLcBeUuZadw48fV7riRnfd6Qm2USgxFLH87UfZ8+S+CiC
         dxKcmMJsZrVaVuTHFTcLVvOKQGVfFDiBDUk/9D2mSDltyEdu6ZFq3cV4aB2F0orhg91S
         yKm/BRfz4ArAVWsM8NnKHx7xH2a4eLwVTU+lLNFAohnH709qXmk0ykW9yz6aaS0XJiUT
         4KnyiOfLlwDBwgmRgLCIDIA7izF0I+qkv46rXKsNhwnIrbBTARYROPJnL60NTtrvMQ+c
         DzhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N+zP+jcTZOOeSiBgcyC4YM8PIPpBOhU7JQI6pwim8Do=;
        b=tVonLda/sY/Qx1/jlZ2rjdRslYY/F9iaOqnyL4wgi5kdoJ1cIIgu4TEaiyZgHfN6QG
         nrbJ3PcpAdPnSLlt/uWpNDlA4DCJ005BtJ2CznrSVATOD2jbB5tVj1bDQY6NRbfsTvR3
         FU5FheYikNkkR3wZ4Ndy9GYYgWFwFxzZgIehQ+a+1VlxpRcK0Llt/N4UvzbAw2Toscxb
         cb1ciesGULbBfihPlSOMT4QJsTAaBzJW+MtAYKIFxtsJd4N44icZT3OJ6mx+qOQzt/0D
         tOxIdryZLLHXotdEWUTNDELzQL4BY1HvgFmaXLWPDYftky1n/qSFVvsnwzak6RYJD503
         3zZg==
X-Gm-Message-State: AOAM533trMJTS03NvvC0GiOFPw57awshFuf98rF6+RN+CId3W2S5N65o
        cJJqaARXFw00gQPbgCZsw0RF6UsK/Z/U/aMN
X-Google-Smtp-Source: ABdhPJy/56e5CmDQnzFT0HS2gwExBvVQXUV9QxB6I1EUDC+8So2K4l3ZpIoq5om/0JwcTJCjzAmmCg==
X-Received: by 2002:a65:434c:: with SMTP id k12mr1131774pgq.17.1628549432641;
        Mon, 09 Aug 2021 15:50:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m1sm17923726pfk.84.2021.08.09.15.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 15:50:32 -0700 (PDT)
Message-ID: <6111b138.1c69fb81.86b9e.610e@mx.google.com>
Date:   Mon, 09 Aug 2021 15:50:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.13.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.13.9-164-ga82f71b58c75
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.13.y baseline: 162 runs,
 1 regressions (v5.13.9-164-ga82f71b58c75)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 162 runs, 1 regressions (v5.13.9-164-ga82f=
71b58c75)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.9-164-ga82f71b58c75/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.9-164-ga82f71b58c75
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a82f71b58c759966d6f05296a08847335d2a5b81 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61117d84391fa15d5fb13663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.9=
-164-ga82f71b58c75/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.9=
-164-ga82f71b58c75/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61117d84391fa15d5fb13=
664
        failing since 1 day (last pass: v5.13.8-36-g1eb1590ab470, first fai=
l: v5.13.9) =

 =20
