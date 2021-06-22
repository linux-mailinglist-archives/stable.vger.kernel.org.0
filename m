Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27C43B0FF5
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 00:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhFVWTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 18:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhFVWTe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 18:19:34 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61235C061574
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 15:17:17 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id t9so18235498pgn.4
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 15:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ck4mNcWzh3UraBKFjKx16g+hCXq6Mlf9RckF3nUi+JA=;
        b=QPABZ8YM+PO1CZKnLxLqSFZ70eP3l6cnLhDjKgzfF0UA2Ia0RsJtlwqPM2T4R7nsVs
         Y9tHX4aR7k0tCyuxV1CKk6e5GUv4RgqG9nkOTVy94Up0zYvO47AMK0Vbjv1ZF2lUnJLv
         No2ZNL87Qtr8J5TJa4mH5AP6DX+TUICDgycj+WVbhuF/rWNbyfM3NGYAsw33g56e/09h
         tiN2QlHaIpTyT2baRDtG5EYDDRWRaKH0H2m9E+yLYyu9IffUPZqqb6ig8wE36qhZxsYE
         20Lyjo4d3dCa5i9zi+PezJtfrlAZWoWU7svwfbRew0edViCyDjFsYmLFzV3PaTzIulN+
         nfDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ck4mNcWzh3UraBKFjKx16g+hCXq6Mlf9RckF3nUi+JA=;
        b=J0f01xLzRibUePXWp1ruKHB6eBCNpyus4nsBKr98bELu9wluF+5yh8TSQOf6E8pg1K
         qGHJiKaQ9A0kHDOMKf7rf2n/2Lhy6aspfY++AKpRIVYiQjTm51ElT9ZHgkOJvkEJonEp
         9/bSWwCzHn0wloNQDtzCFq+YCOkv/HoxxD4clg5lKmj1F47G7AfskUZqUgpzl5Qbk92w
         TkijJiSW31PKsDv5N2gtibeVPK9SyKAhsDOzz+lsGcp1RDEuXNE7WOnAt4jcRlBfEKEK
         kTzLi4AEAsjIp2HVVlmj5uWmBPRp+bnSreRRl8Du4Nf79i2bN4MzxzdsFKkm9KN4vbIZ
         x33Q==
X-Gm-Message-State: AOAM530WSVlhd1pgsmw7pAwpd763/Qo2ClKZewv8Xpn+73sDM47tJPDA
        odLNOVoQ2PbtvxwGb7af0xP9YUK9WYsHww==
X-Google-Smtp-Source: ABdhPJwvho1jQfX5abmIJWodhdGOerNgQXyOk1xerdNw3RLKOuvecTsEhMAYA8quDt4BRw0BQkRU/w==
X-Received: by 2002:a63:1c0a:: with SMTP id c10mr763550pgc.306.1624400235821;
        Tue, 22 Jun 2021 15:17:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 205sm287613pfy.40.2021.06.22.15.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 15:17:15 -0700 (PDT)
Message-ID: <60d2616b.1c69fb81.8008c.1607@mx.google.com>
Date:   Tue, 22 Jun 2021 15:17:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.12.12-179-g88a915cf22fc
X-Kernelci-Branch: linux-5.12.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.12.y baseline: 167 runs,
 1 regressions (v5.12.12-179-g88a915cf22fc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 167 runs, 1 regressions (v5.12.12-179-g88a=
915cf22fc)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.12-179-g88a915cf22fc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.12-179-g88a915cf22fc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      88a915cf22fcd20d2323dff7a4b0f70909cf4099 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d22fb3bc40766d2f413287

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
2-179-g88a915cf22fc/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
2-179-g88a915cf22fc/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d22fb3bc40766d2f413=
288
        new failure (last pass: v5.12.11-49-g3197a891c08a) =

 =20
