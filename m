Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944F43A32CA
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 20:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhFJSOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 14:14:38 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:44917 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhFJSOh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 14:14:37 -0400
Received: by mail-pg1-f181.google.com with SMTP id y11so389254pgp.11
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 11:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8GbXMoyZhwHBsSihKlYi17MWlrqdb/Mu57tmE25+lZc=;
        b=B4bog32usueve1W9Z3BHwSy2rwCZzDhEdDsC1azKk0I8hSy9McHOjz4HT7btx09Toj
         O0Q3xxzOdfhQUSYp6DAOtsx0ygrWfixZ7zNkyZCCdTEDlM1nmQQmK9BmP8hQdfDvzHWN
         FyEOqgyVhIQZbjxmpUNBxAS5fdcZocctK+UBezDeQkM+GPMyDIsbtiM9ezxpzTli+owW
         5eQ4RIAaFsawq906J2Ki502u7lm2IDSkhzSwIowMjhqSLOv1gTZcS4bg1m+WsVaplrIZ
         EdElwQLg7N2DBCkfLq0NyNx9rD61SOjXm5jIWYYNizHv4RYMgP3IjiF+hV1oeftKRYAR
         treQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8GbXMoyZhwHBsSihKlYi17MWlrqdb/Mu57tmE25+lZc=;
        b=ovkABHqQkVxhuff9xFLBe75gGjiB8Q0T6HzDKvEndBddnSrNrM9MKmSSLfhDWKEOW4
         O9w4VMWdnhzBimvRRlKqgSH//Em6fdqX1q2we/7oLw92GVgIdXt2criRR9cLPq7rt+WM
         1mmFcyxUZv6ow6XZ79wAVxaV2rYR8iFKjVP/JsogwW+hJULsF3FJmDXYpiuVdFfpkbwL
         6blUpih1BXpHuFWRWeMH/Wt04+dgLFVGGZC4bgx09IcrXvsHZHelJe+KAcWCT7wu5FNT
         FzAJ4iVf6dlc9yCgYyo0DE8b6CQOqpI8PqrdN3zmFjUre7JSiWP8sKL9awPodcNizlKW
         Im7A==
X-Gm-Message-State: AOAM53097MdchrJJ2EovbwxCAY3tTbIkKGii9AObS9Tx8txDPxK6YsxF
        hPQHwpVs7ga5GFU0RiUfZh2RqkHQobMSfsq1
X-Google-Smtp-Source: ABdhPJzwVG9dZl/bfQ2y1Ib/96wVJXVBSGgrh3+3lADhHbSJtVdNQjSCQbd85RgxvRUCcrBPp6BnOw==
X-Received: by 2002:a62:4e86:0:b029:2ea:25ce:b946 with SMTP id c128-20020a624e860000b02902ea25ceb946mr4300110pfb.30.1623348687971;
        Thu, 10 Jun 2021 11:11:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b133sm3125277pfb.36.2021.06.10.11.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 11:11:27 -0700 (PDT)
Message-ID: <60c255cf.1c69fb81.6c004.9cdd@mx.google.com>
Date:   Thu, 10 Jun 2021 11:11:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.42-137-g42a95aa58d3b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 172 runs,
 2 regressions (v5.10.42-137-g42a95aa58d3b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 172 runs, 2 regressions (v5.10.42-137-g42a95=
aa58d3b)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
imx8mp-evk           | arm64 | lab-nxp      | gcc-8    | defconfig | 1     =
     =

meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.42-137-g42a95aa58d3b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.42-137-g42a95aa58d3b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      42a95aa58d3b1ffd8012db8aeb41274635397395 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
imx8mp-evk           | arm64 | lab-nxp      | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/60c226fbfced7502750c0e0f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.42-=
137-g42a95aa58d3b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.42-=
137-g42a95aa58d3b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c226fbfced7502750c0=
e10
        new failure (last pass: v5.10.42-137-gf24aff0aeb21) =

 =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/60c226f8fced7502750c0e03

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.42-=
137-g42a95aa58d3b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.42-=
137-g42a95aa58d3b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c226f8fced7502750c0=
e04
        new failure (last pass: v5.10.42-137-gf24aff0aeb21) =

 =20
