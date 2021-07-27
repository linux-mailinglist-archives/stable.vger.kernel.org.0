Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C533D7EF9
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 22:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhG0URx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 16:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbhG0URx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 16:17:53 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD0AC061757
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 13:17:52 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id f13so7057866plj.2
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 13:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=35E9oCfZbtR5gDHdri5sza2SToeZ2DoTgLrYgod81Iw=;
        b=vB0x9K9H8WbANclJjIhcA6TT7pvpgLQvfse35sOyCuwO0TlcYFu4BN2CaB+oroJyVp
         TiJ+KbDnThd/6eEK7m7u87dZQWsyiNwLzMIo7+kmoq5svFl1KdyqFQXCnvR639KemJYQ
         aPmIadxOgPki/r+mklbFGa6Hrtjt0qZdqS1H5Zgwy0Bol3a6qvHqwjQXueEI+xUlLjq3
         NcFFd0zyIHf0DBCuoX6nj4KI9zyfpg4aqL9G36UK6dI3B37K4O8xTRiuvVJ+3tRKYqz4
         KNytpX0SOefRcb71Ppu2DzzW3jiGb6L3fjFl3oQDez5KrpJzpQNvmj/zIWpY0s7vo6dt
         LoHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=35E9oCfZbtR5gDHdri5sza2SToeZ2DoTgLrYgod81Iw=;
        b=ITfneZQ/P+YWZJTG9npHAWEZtWjCgXTeyzkCtB/lz6d7btXcto665IC0+8JHmSF1/W
         JvMwEweeuICbn1TsdneOXdlGbM0h24rtoHCNPfB4FRE3hK1xh+QTFcaJmlC2TH93LheW
         aS1aN/BVhiSAmU1x6zVtOzohKtDUSk6hHcMo0z0W86OEeNpNj4sl1O91NoN7UMCwTCbV
         lgAhUsa/EXFdqYftMmhajukwG19I03GY5A4EgGhuE5OlGGFzu4AJ+Pv9CUOx9h/JSsGL
         LNEnDx8S4Or+4oDoh9aVywb2dlyOGy63UqXuhyxPi6iZO+VB4zmS4KjxewyaxC3kR4tB
         3iSA==
X-Gm-Message-State: AOAM532tu6eeGWW7lDDU2cVlqcGhPtVT1yVPZLIK+7gWVBHuJf3PEGAO
        9pA4AkZmdmRE6IuDSgYOzwZUKHFe3SaxPjd0
X-Google-Smtp-Source: ABdhPJzmycYMQ3goJzfY4qtZFlHLBAMgUR21eAoRfp5ri86scnN6kQxJGOnWucdihSoGoI5O+/Vakg==
X-Received: by 2002:a17:90a:2f8a:: with SMTP id t10mr5930157pjd.146.1627417071763;
        Tue, 27 Jul 2021 13:17:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k11sm5368850pgg.25.2021.07.27.13.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 13:17:51 -0700 (PDT)
Message-ID: <610069ef.1c69fb81.41a58.1060@mx.google.com>
Date:   Tue, 27 Jul 2021 13:17:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.135-108-ga603506776c5
Subject: stable-rc/queue/5.4 baseline: 127 runs,
 2 regressions (v5.4.135-108-ga603506776c5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 127 runs, 2 regressions (v5.4.135-108-ga60350=
6776c5)

Regressions Summary
-------------------

platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defconfig             | =
1          =

d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defcon...6-chromebook | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.135-108-ga603506776c5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.135-108-ga603506776c5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a603506776c5a2ad47261d88eb75fb5bf9a37c63 =



Test Regressions
---------------- =



platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defconfig             | =
1          =


  Details:     https://kernelci.org/test/plan/id/61002febf7351e4395501908

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.135-1=
08-ga603506776c5/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.135-1=
08-ga603506776c5/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61002febf7351e4395501=
909
        failing since 15 days (last pass: v5.4.130-4-g2151dbfa7bb2, first f=
ail: v5.4.131-344-g7da707277666) =

 =



platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defcon...6-chromebook | =
1          =


  Details:     https://kernelci.org/test/plan/id/6100315428750c3e565018c5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.135-1=
08-ga603506776c5/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.135-1=
08-ga603506776c5/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6100315428750c3e56501=
8c6
        failing since 16 days (last pass: v5.4.130-4-g2151dbfa7bb2, first f=
ail: v5.4.131-344-g7da707277666) =

 =20
