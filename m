Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730B84358EE
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 05:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhJUDXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 23:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhJUDXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Oct 2021 23:23:13 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA89C06161C
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 20:20:57 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id e5-20020a17090a804500b001a116ad95caso3902091pjw.2
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 20:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SwyeShTej0SJtJFoUsnCh/AOqi2r4z5pWWMJ9G7Wnl0=;
        b=jNaujRRyq44ofBS8aDz2wpFfFE36qc/ADPedgG1daJO46ZsMXlFmcotQ9OkIqnKLBy
         eySTDQUYRffLp/HeEkJYLDc3Z//lEeZUX5zwWiybHbvgpRqBGtJbNWv2BAKsMNuk6L14
         j5jGxADqW/x/PTXmqQURJ12bw3pQwQVlM7Pczr8NaWYLVefD2e5NAj7IEWWU2lZj9WWR
         p+MBgTS8L2UwX8nsNwGWoBGZ9v2FT/REjsJcZd6mCm6S9+pDwZRWx4Y5eUkdIKIFrY3x
         BXy2KEeleCCNklMUifmnLPyVhc3YdIe3BaDveKsttjqpftoYgfsYlDu3HLUBzCXBOkh9
         s4vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SwyeShTej0SJtJFoUsnCh/AOqi2r4z5pWWMJ9G7Wnl0=;
        b=AHX4EdDqAHQk6IUcfj8nvxKbbu0/EIGhfomQ2aWx5l3nfJlckxu9zXLMhEQGB6W97F
         wkxi+TeXGMrHsTRSVLbLODYhDQDgta/Un0FYI9UnFZXS27cn5KEQO1KY+WaXCAeBzUoy
         abNh7o1654UNlx/USWmn+rg3wkVhPMq12ZEZQgtN3meLkEHLHF6IhTe6/rq51Aak5NjS
         S810j47qAZTXFEl1U/SgzQ1CYxmXXXnweZDa1voBRWQsezZyFa6p/zFajyQq4PassX7c
         2YD27wHFjzUQlhGgREVkiwS/VxK2piauqjdxWifNKdEmTCSEOXMMNc46uplr4/yFqltR
         enoQ==
X-Gm-Message-State: AOAM531j4y2EbvsJb/SMNT+QapA1CJuRh0iB932EcWKn5/+Kp1+TXKrb
        LGb2zSTcMERXIJcO3vbBD45BU21yU3A8AguiyEc=
X-Google-Smtp-Source: ABdhPJzyr3XKNVJELkw6N1R7302S74tIXcDhFf/Wmneo5+/opehlIBu4zNQD9GSEJx5hD5mDslvySA==
X-Received: by 2002:a17:90a:1950:: with SMTP id 16mr3316603pjh.126.1634786457204;
        Wed, 20 Oct 2021 20:20:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c8sm3704739pjr.38.2021.10.20.20.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 20:20:56 -0700 (PDT)
Message-ID: <6170dc98.1c69fb81.b4518.bb49@mx.google.com>
Date:   Wed, 20 Oct 2021 20:20:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.75-12-gd4f688e84543
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 149 runs,
 1 regressions (v5.10.75-12-gd4f688e84543)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 149 runs, 1 regressions (v5.10.75-12-gd4f688=
e84543)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.75-12-gd4f688e84543/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.75-12-gd4f688e84543
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d4f688e845431cad204545be34b75a60f9440f7a =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6170ab71cd2eb9f3ac3358e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.75-=
12-gd4f688e84543/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.75-=
12-gd4f688e84543/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6170ab71cd2eb9f3ac335=
8e1
        new failure (last pass: v5.10.73-124-gcadcf306c4d5) =

 =20
