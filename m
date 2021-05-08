Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440B337735A
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 19:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbhEHRVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 13:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhEHRVp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 May 2021 13:21:45 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47267C061574
        for <stable@vger.kernel.org>; Sat,  8 May 2021 10:20:44 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id n16so6870731plf.7
        for <stable@vger.kernel.org>; Sat, 08 May 2021 10:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cDVdb6h4+m80HStlzow3aRw8mQOO9ueR16jCRYqnUXQ=;
        b=LJECyGsZCu21Hv/GSdsAtUdSA5N1Rrb/LO9eG9NCDfJzSWbvR7o0iq8gw7Dnf6OxwO
         WcoNcrFLaoPpo+vWBcsoqrUHL2NGYzlJK/OHO9UL82PBImy3Tg06mW/ON8ddzvWEFhqH
         wuhp7k+dnrxchlkvKps1H/lYiFjIFiwttI96P+ElXhBghMZEoVYqEYmFgUqnjux4TJzQ
         lHPnsEon3KspqvKcLO+34krUqR8N3dM7NSUzasO+iVC+8rzs8oKPweRaaquGeg5Csv0v
         qeBhGMgjY89ny5HdPE1jWg3IuEBCwJalOQ6cYiqX1TPaTPpD+7Ja+T5hYPoYc80b+wED
         4kcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cDVdb6h4+m80HStlzow3aRw8mQOO9ueR16jCRYqnUXQ=;
        b=DLtDm4QOtFbsiPeV9GzSrIQ8zHizZ2k+a75WfmQvw29gXE/F1twfTGBJDnsZXbNRKj
         43r3yfjd8mXHY/qvrWwP91RwudkAQ9+aCxMSEhcaX3EksgE0Lir/hZLr6lz/pHNUq/nW
         EfRxqPENl6cItVt3HzvkEKNcIVNLpVE3Ze4AOrC+2XaktaUfPkK5BekZzWYFFxXzYELh
         RwBR0bJghAOGSbGjmxt/vP3O9WInJfFsA91pWdN1csvH/OfEyW5XwwmMbMH+hMOLC4qE
         FklnEcqjTkbGu2xqiF++XMcGd3Kod8/h2GRtak3ZF8SSDxn6AQxkjDE/hTClYfgoPM+6
         N7GQ==
X-Gm-Message-State: AOAM533YOfPFqUpNm7AzcOPZU7TCNChSbkya/Rp9We1vJShHDIGuwRPD
        TlPJP1zPKwUSVKGLzNvlGRm8EQfeYmtVYM2g
X-Google-Smtp-Source: ABdhPJxuzyHNJsNRRz/9UH9ubPX37j4Oc56gZeZRbm1K/qXqjgZippPaWo/r9Z/NFTj2IPuILffC5Q==
X-Received: by 2002:a17:90a:fed:: with SMTP id 100mr17430700pjz.89.1620494443605;
        Sat, 08 May 2021 10:20:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i197sm6940353pgc.13.2021.05.08.10.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 10:20:43 -0700 (PDT)
Message-ID: <6096c86b.1c69fb81.9c1fa.4c56@mx.google.com>
Date:   Sat, 08 May 2021 10:20:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.11.19-252-g746df32fec55e
X-Kernelci-Branch: queue/5.11
Subject: stable-rc/queue/5.11 baseline: 138 runs,
 1 regressions (v5.11.19-252-g746df32fec55e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.11 baseline: 138 runs, 1 regressions (v5.11.19-252-g746df=
32fec55e)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.11/ker=
nel/v5.11.19-252-g746df32fec55e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.11
  Describe: v5.11.19-252-g746df32fec55e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      746df32fec55e8dd42407e288da4bf834423b2f9 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60969779ca4a57ba996f548f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
252-g746df32fec55e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
252-g746df32fec55e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60969779ca4a57ba996f5=
490
        failing since 1 day (last pass: v5.11.18-29-g6c2ae64a2a728, first f=
ail: v5.11.18-30-g4232ce7a02cc) =

 =20
