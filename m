Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256F33524AB
	for <lists+stable@lfdr.de>; Fri,  2 Apr 2021 02:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbhDBAsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 20:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234029AbhDBAsM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Apr 2021 20:48:12 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2965C0613E6
        for <stable@vger.kernel.org>; Thu,  1 Apr 2021 17:48:10 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id f10so2628174pgl.9
        for <stable@vger.kernel.org>; Thu, 01 Apr 2021 17:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dw7Qleq5NAt3YhAVxdkBkDlFalRSltOcZzR+9zse5rg=;
        b=vRq+zy0UH/npo5zJT0zKKMSGVYM6QlQXrETNmkK/Sk/UeHBIt2rUsDpNRY35IQ5RHq
         oVoHH9jLQntUNaajTSq0eKLgBCgynRydEjc7z3WKxo+XLCmj+nIMxRmcwqmSxkEbgcDD
         u/qV0RXLjlFyWb8+wrQj6D3/LSQHbplOt3lzJiYIaBusMgm+d/I8tspmSF406j53L2tV
         GFzjzO01elYT/OMuD+UrBkHnst69yYRsAJv0EzUDM708w9ID3I/iYxjsJPureKNZ9zYd
         tClahll/BYgmaUNhwbJn2RDJoktAH5lI1Y/xAIMEjvqK+jAWsy1ag2al+JOIKuHgMgXg
         yyVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dw7Qleq5NAt3YhAVxdkBkDlFalRSltOcZzR+9zse5rg=;
        b=pcnsIVZgbzQfoqduwzwdHKkRhB1Poj+7ACTHA3c51qGwF/4Ga7tedr8rCVxeG581d/
         k1iqSSGcsDmR2W2gWIUnwyk2jo5Si5czUg3dZZ+YDDd3Ozo2pLOFcqDHQLtMwZQQjN6A
         xBL8ahUMdDCxkJO9CG+Vds+ZNkaQMSPlzayGXyjxZJxjoY8lZr+NfThPY014ko+rHOKH
         tFmg9FCk5sHSaAcem8bifyvgTlihBRy23owyhUjR371AdTCj5vTrHQLrTHUvmmpLCTLB
         IpCVydZKzWBaSpkbr3H1gSB4cXLvKF1N79d8sHMw8RfgAfWHzVA2Dc25Y1MJM6NrfkQK
         BxyQ==
X-Gm-Message-State: AOAM533JZlrlZpY9iKhWqQdCmq2K7dTZeXOrU6gmLI4x1QCStVCFSMYB
        EsQmuRtoICSgUPMSxDArVDXxpcqnZE26O4fP
X-Google-Smtp-Source: ABdhPJwxe4CFhgzd7yfbhEgbXUM8VEDWP7pYFx+6TKGo7NYQzNrQcpAPAMVgXPPyqGdenO+ULuOZ/g==
X-Received: by 2002:a63:81:: with SMTP id 123mr9601577pga.307.1617324490229;
        Thu, 01 Apr 2021 17:48:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w22sm6290855pfi.133.2021.04.01.17.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 17:48:09 -0700 (PDT)
Message-ID: <606669c9.1c69fb81.47ec2.071c@mx.google.com>
Date:   Thu, 01 Apr 2021 17:48:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.27-53-gcd7f2c515425
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 176 runs,
 1 regressions (v5.10.27-53-gcd7f2c515425)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 176 runs, 1 regressions (v5.10.27-53-gcd7f2c=
515425)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.27-53-gcd7f2c515425/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.27-53-gcd7f2c515425
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cd7f2c515425d877ff4303e81ece2a9b409bbd93 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6066369ae0a2a41508dac6cd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.27-=
53-gcd7f2c515425/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.27-=
53-gcd7f2c515425/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6066369ae0a2a41508dac=
6ce
        new failure (last pass: v5.10.27-36-g06b1e2d598020) =

 =20
