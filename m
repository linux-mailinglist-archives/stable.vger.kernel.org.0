Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF0631B2F2
	for <lists+stable@lfdr.de>; Sun, 14 Feb 2021 23:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhBNWHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 17:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhBNWHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Feb 2021 17:07:00 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F153CC061574
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 14:06:19 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id o63so3163412pgo.6
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 14:06:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gduNGYGnjAjK0SeDbeP92b5qbpqHA+EeySrj/r1Y4Fo=;
        b=wij3DnWWk7izBsiec83nFSERCIEriX78K6vbiVxc58FlsM5DzkXaCIAvDz7kgOvDd8
         w8XG35Ssl4SjzcfsgvVb6jk1Ko+Tuyq6KKj4Iv17Ha9oh5pP7KZmwHApEkYo4H/+AVan
         aKkw1CpxZNKRzVkI5W419ZME6dKnArPeagADSXdBD7l4yaq1/e5XJeVePgDubcaNUGMO
         0cPVqFnk4SeGMb1DDRh4MMAlXOUmL6JTPh78eVKNWRVdTDAVtoBJm5f6qa+Cxau/w9iz
         zJF/80lEYMI7NlI4cv4NpY7GS4hC+2Jsjqc7ywtSc+JLm3fPNPscRer6jUyJ/2FQizKo
         +fZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gduNGYGnjAjK0SeDbeP92b5qbpqHA+EeySrj/r1Y4Fo=;
        b=GUZ69e26CdVGSkt+h21ExI5WH9+ctxSfkPfMdSvuiSv7UxhMjUM0R+pxF7zGN3K2TB
         yJSQoxhEn6gEhMjqxJ8WjiG7BTKyuIbiAyngwA267Gfc+w9mQYtcQdo6P0cI822xPc9p
         Y5SpSqTzkiAwD26oIn8eskMq6dsVOj2uPyfq67Yu98UAe2Mk7T8+lq5c8kUgA5M5QMk8
         5mp59PzQFK9VLaKEg6Lv6kmBmtAkD3ACveVUG8y/rMImwEPK3N9Hc4Lng23WkLxD5JUc
         CuH96rNgC0maeoTrle8qoXbQ1UQ1a42KrDNGUT2FE2PsjOBJ/vj5dLrqPkox6IbdRcSi
         FCWg==
X-Gm-Message-State: AOAM531s66mO+dMqIPvSfUi8IrVTJk7r8DeOer7UEbO6UMY7ulpSDcxF
        ggpHoK1gyKwQ8riBnOu8GUNksuIRo1GCMw==
X-Google-Smtp-Source: ABdhPJxuY2YvXXiHEFIS4k12A1aBX4IfDIS4USTKpOWCY6z2DUQRXkW+JOhVkStktXisA0Dm7KiZfA==
X-Received: by 2002:a63:416:: with SMTP id 22mr12406919pge.286.1613340378114;
        Sun, 14 Feb 2021 14:06:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t25sm15763786pgo.87.2021.02.14.14.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 14:06:17 -0800 (PST)
Message-ID: <60299ed9.1c69fb81.bb0cf.15e0@mx.google.com>
Date:   Sun, 14 Feb 2021 14:06:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.98-23-ga860ca302099
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 94 runs,
 1 regressions (v5.4.98-23-ga860ca302099)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 94 runs, 1 regressions (v5.4.98-23-ga860ca302=
099)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.98-23-ga860ca302099/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.98-23-ga860ca302099
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a860ca302099652d849cdaf09d55de50792eea05 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6029661edb90d003853abe85

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.98-23=
-ga860ca302099/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.98-23=
-ga860ca302099/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6029661edb90d003853ab=
e86
        failing since 86 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =20
