Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A94B3813CC
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 00:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbhENWiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 18:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhENWiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 18:38:22 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4F8C06174A
        for <stable@vger.kernel.org>; Fri, 14 May 2021 15:37:10 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id c13so766405pfv.4
        for <stable@vger.kernel.org>; Fri, 14 May 2021 15:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CBAyhNwc0RTph2Y7OIcgYK2uVrqj/qJa9IjE8Qor2HA=;
        b=h6rn2Fu3IIVMrPhgU7nt7sG+/0D1VATgmFsmqAj9UhTGmRsNUc1Qfvx9eW81xpvnAj
         9fi61sYSwBE1biznP5FCMBvoV3S0jxdrpwQM/hSC+p0JgRaRrjPVM2WokaMZxiGXjfTD
         ttaTQuy01XGz21f6CBwXckJWXs0DXa2oyQQoZAwqRuCn+XLMwINwXROidZpwg/JAD5GI
         MO93A6iNpXzHoce4B7nvSd28GZYApAaO9VXqCAk1hgpq/FSgGfYYe9a+LQKLFjxPKN9y
         h7tml53Za7R4kRAa80Ns7XBrNxdiQ8mtYktCzRUU1EuJ64WqRGSezfUUM6xu9sU161MK
         WvxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CBAyhNwc0RTph2Y7OIcgYK2uVrqj/qJa9IjE8Qor2HA=;
        b=EVypbrlsyuKqeMkqsJpOOKzdjiENA2PwJGbht7UEn4fzjCdpo8a910lHC+w4PELk5I
         kCPJCqQZSzIzV/ioTWCy3R74koT2vLsvSclqKThj9cQTgvZY5tjRXYi1IE++A61d1ltN
         3MSDV4A5hwIAe/aCEyitajt+5Vb6ar6U18Au2ViY0g95G4Q18FoMqVVguO4z2nWlV65Q
         KWQStSN13aahB1b0K32tJKX40nWTHgURZFzToH9zQrV+CzYTYGcpWsn4dA2KbHZXlMo7
         WzVAYJHp64FyM0eaoZUbvSE51Xn2bXnhY0Btp0FwlXMy8xFGpNZGOAzcng5bbez/6Q+v
         sP/w==
X-Gm-Message-State: AOAM532gea+1ACTtdRSbRt8B++rNq4INMv+IymvLRMBncuS24ZDl3W4E
        B93GjtJaf/Sq1lBm8rNVO9pvEwKRg6J7TEv8
X-Google-Smtp-Source: ABdhPJyv1+Rxwhm81SmOo4dAdHScidA8eJ48u5NAdES07UnBLWLD9z1ypxbbYRCRpDc/jytLhI7pqA==
X-Received: by 2002:a63:b102:: with SMTP id r2mr27759738pgf.254.1621031829749;
        Fri, 14 May 2021 15:37:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x9sm4810279pfd.66.2021.05.14.15.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 15:37:09 -0700 (PDT)
Message-ID: <609efb95.1c69fb81.4323e.1022@mx.google.com>
Date:   Fri, 14 May 2021 15:37:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.37-10-g331de0de6bd1
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 134 runs,
 1 regressions (v5.10.37-10-g331de0de6bd1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 134 runs, 1 regressions (v5.10.37-10-g331de0=
de6bd1)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.37-10-g331de0de6bd1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.37-10-g331de0de6bd1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      331de0de6bd1f7af45775e715ebaca78b9e1859e =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609eca7c43a8af0249b3afbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
10-g331de0de6bd1/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
10-g331de0de6bd1/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609eca7c43a8af0249b3a=
fbe
        failing since 2 days (last pass: v5.10.35-410-g9dbd9e48e4099, first=
 fail: v5.10.35-830-g80be48bc51024) =

 =20
