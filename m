Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F65645B054
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 00:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhKWXji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 18:39:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhKWXji (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 18:39:38 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF02C061574
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 15:36:29 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id t4so441722pgn.9
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 15:36:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RF4/pZT0dpgZRs7LhKbe39sax+0o+6wfiuS2XS1AdaY=;
        b=Bpnl+xv9aSn4gDnTM3IMRvGr8FjJMOEAtYcVT/f8mdbEG5YWftj+XxQhv/r7GOfFC+
         E001q6ZLHhIfnucwa85qAdOcKW0Psiz+TWpTcxbxQQf0peVvuR5A/gn4VPJ8gLBh7pHq
         Red54rUtuZHQwag+U+s0M5+rtIyw/D3E5lT94LS625dzk+6FQB9iFyzGyUihAiluFFPv
         7mYHyzGXZHrrYwm6NPczNHqiH3K1hMKA7G1ghV4KsaxmEOeDDTA6prOajq1l2pBPT7Iw
         /jbN5v3Lv4K3nqk2GG+PQh90sQWfwJc8tDVCtaA2jMpGN/+YPVqRoWmGnwdRFD9LujaZ
         BJ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RF4/pZT0dpgZRs7LhKbe39sax+0o+6wfiuS2XS1AdaY=;
        b=c6gHTmUnX0aL447VYf5h/CmURX8ycRoXS1gPg9dbwMm94tfQUwlpcxDxhLhBs5O1/j
         d4jbc7vCg8ypxj2HpKfLfDAn+NgKfQRC+WaNC4CD/i7w6eoTHAdtz6H//uuvhY8oR3X1
         ASVFJlp92SqFIIBN9iEtD45BJzvkxyh9ThMgbhXGd8FJPsnxquzsri2djK8Gu1kqlszt
         EjhARZV7y7Wv7Nr6bK8uyKHku9lkmcUxfvU8NCGitzD56QxqncVi/H7VcSfIR3uJWUgZ
         YH4A11BgcTmVVGfMGovubBvgq1vtu5phnFbi2DZ01WA/pSI+R2nr1eUbxyy0nso2sHji
         C3sQ==
X-Gm-Message-State: AOAM532FFixhsmqsn5yQ3/1/NMxYuPeBKMzj8AtTfbtYNT8pGTB6fkLh
        SIVeERGNyV1e49hpyhCVoVqFiNcm0fsEtTEP
X-Google-Smtp-Source: ABdhPJxieizPq2tUzmS5eVnJLyCu1cSamg1u5dYAH8rxcLyB83W3vYIQiNDqjOw2UBgLVaPbMn/vvw==
X-Received: by 2002:a63:be4e:: with SMTP id g14mr6898036pgo.194.1637710589335;
        Tue, 23 Nov 2021 15:36:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p188sm13520559pfg.102.2021.11.23.15.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 15:36:28 -0800 (PST)
Message-ID: <619d7afc.1c69fb81.0627.673a@mx.google.com>
Date:   Tue, 23 Nov 2021 15:36:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.4-266-g7d1b0014a364d
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 174 runs,
 1 regressions (v5.15.4-266-g7d1b0014a364d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 174 runs, 1 regressions (v5.15.4-266-g7d1b00=
14a364d)

Regressions Summary
-------------------

platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.4-266-g7d1b0014a364d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.4-266-g7d1b0014a364d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7d1b0014a364d3fe65105c7990b3105452d74061 =



Test Regressions
---------------- =



platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/619d468fd7fc34de5df2efab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.4-2=
66-g7d1b0014a364d/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.4-2=
66-g7d1b0014a364d/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619d468fd7fc34de5df2e=
fac
        new failure (last pass: v5.15.4-255-gc7c7b3e49300f) =

 =20
