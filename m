Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8DF395329
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 00:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhE3WXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 18:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhE3WXS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 18:23:18 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1AEC061574
        for <stable@vger.kernel.org>; Sun, 30 May 2021 15:21:38 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id pi6-20020a17090b1e46b029015cec51d7cdso5559532pjb.5
        for <stable@vger.kernel.org>; Sun, 30 May 2021 15:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Cw76sKXwr2tsxhnx9jnP7q0pwIIq1lXgBAzBjT+JcpQ=;
        b=NsT6qx9JZox+0fuAk00KMSDammcNT+hQ45hNeGLTlT/fEcitDmYl21VwRSUbF7sZ3y
         +QkyAwabhTBkEMPIY5mN2MwSAvYCXQHMLKT3FlT20YkT7uXCOb09QNvD5fiSthrJKxln
         T602L4Xfrfldh7VDn9AlbTHCXuv/f5c+97rEk2R1Cx9VBG/rxpNZzfUyga2cZvUDE6X/
         6vi6AL1WuOQjDhQ4cDuTFwj8F3Bvb6gJjXSNvMcZRJ2THQo9qnnQjCDwpJfwiXzCxlcf
         w7bLaLjXxFOTsVNiLr5/a4lDDk/pG1MRf/cTJqY/qqZZJlrziFHR6xMvTnyOaiMBI5MA
         xS+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Cw76sKXwr2tsxhnx9jnP7q0pwIIq1lXgBAzBjT+JcpQ=;
        b=KTCcwclKbiXsrhFAgWa5wSgJKESXQU31A5qzHJCE3w36yQJhAwuypyWQHM4u+MGIxc
         QLTqLCSEcCYUG5agi8RF9WGhUf9cgQajETsM2+ujGQl8mxB7AFPOnvPwzs/7OyglxLZr
         r1xLjC3W9ajx5VtXdd4GF/fnFekaLjFewPk9wBddBDpiKbooiHEft95P0fu8yzYwSS/O
         pv4oNCIPoC+NWt1Zl9pq12ux6Tk/uirWkBqTeAGWCSRuvqucRDVNk/95VrWw4D0Sp1ia
         rJX+Y+8mWzE1uwviFyeQGD9vuf+iUQJBhwt7yR812O81WNzODEsNSxr5+I1BzYFOiMf5
         XZrw==
X-Gm-Message-State: AOAM5310zv/d71CkrujYjOT/3EoY0e8HOIozNUTBVQ5DGCffpAbssE4B
        Bnr3Fne0ZIHyqpOcaeingT5Zvo3TUFnK6oq4
X-Google-Smtp-Source: ABdhPJxSVOF27tYKoZtn/5sEXZgZbFGa9t8COmKsjRmOr6YRnjS3J6Drg43KFzJsJEL6ThmpRim92g==
X-Received: by 2002:a17:90a:dac1:: with SMTP id g1mr15953355pjx.199.1622413297751;
        Sun, 30 May 2021 15:21:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s12sm9397977pji.5.2021.05.30.15.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 May 2021 15:21:37 -0700 (PDT)
Message-ID: <60b40ff1.1c69fb81.c870b.e151@mx.google.com>
Date:   Sun, 30 May 2021 15:21:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.40-139-gf93ddb6581f8
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 186 runs,
 1 regressions (v5.10.40-139-gf93ddb6581f8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 186 runs, 1 regressions (v5.10.40-139-gf93dd=
b6581f8)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.40-139-gf93ddb6581f8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.40-139-gf93ddb6581f8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f93ddb6581f8cad4a9a78e98563beb147d491675 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b3d92380adefacfdb3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
139-gf93ddb6581f8/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
139-gf93ddb6581f8/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b3d92380adefacfdb3a=
f98
        failing since 0 day (last pass: v5.10.40-98-gef1477410758, first fa=
il: v5.10.40-139-g2cb2acbbafd8) =

 =20
