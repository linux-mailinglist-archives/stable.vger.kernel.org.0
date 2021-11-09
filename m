Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3F544AFC0
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 15:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbhKIOzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 09:55:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbhKIOzS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 09:55:18 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370EDC061764
        for <stable@vger.kernel.org>; Tue,  9 Nov 2021 06:52:32 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id u17so21306952plg.9
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 06:52:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EgSyIQ6H0XpjW8yfehFyN/sFgj48DrqUTnkWOrbN6g8=;
        b=2rqQArKyVswVNaMgoEqcsMBS5Rss6vNhMJlpbQzmQm+sL1Fb3XTVsQNm5G3AEB4aLE
         E9Rc+mcMRi2Dha+4RHZ/fmIp7fb7Wwjtgzvhv5szUrcznjMhyj69n1gvL3Fushy82Xlo
         jxpJVpxVXaVP5c3dYysPhc4KvG9+SJ7ZWSMp8Rawbyn95zRts0YZ/CqLnc9CH89OuDBk
         OXwVrwvuVvZIn7mwAm9/Yz9EO5ZgVZehpLC/CHVIMNPZT6NwQoEOPioyNVYhBl8a45xZ
         rA4jHASho5EtS93shIPcCRWTCcRJdFVtAZ4UyXyXcwQVRePzS8ks61ar8Y/oTt7Wh3OJ
         jjKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EgSyIQ6H0XpjW8yfehFyN/sFgj48DrqUTnkWOrbN6g8=;
        b=Cyj1wJbrCUIKlacc42est9uxJSfTpal+DGWSAGsJ40YYEzBbsOmbolDKXQy/iGZlJ2
         tYSqg18DzhUwUOfkB1z7HS/mPMsIROvf73cA2Ft3pLH9aGHKMorRHqn3HtGDEl+OJQ1w
         qVRcHE2WWBu9DgvVfOauH/M+Eg/mhinbdzZNM7/CyqyZ+hBgWDi82PK+6KTBBfFaVwpu
         jUMVmQynAnkYxI+xzJsw/T7W1isnjpaxNtFl7smalzWDifZmKd3XgjAgorF2R2ITtskn
         mEwXzDYYI+VBHUBkJtUOKmghv8Wec5UtTOTm1AyIUOqDSR/LBZmUeIoVe4WozZNl475q
         JkEQ==
X-Gm-Message-State: AOAM530YEhaLIs7FsIKielDje0Q5zMXMtzoL4TA5xqSh9XkgxnJZbBCk
        1RTLqKRlmG57E0VLMcBRAXUZmYshx8IWd0Ri
X-Google-Smtp-Source: ABdhPJx9sgcVJpBEA1YHrl/VVXiJ9G+KrSN0J7EB5sSB3wwvgNFtbXYJMUZiCKyt/E/os8JXPoPxJA==
X-Received: by 2002:a17:90a:1b4d:: with SMTP id q71mr7526732pjq.29.1636469551522;
        Tue, 09 Nov 2021 06:52:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e14sm15542866pga.76.2021.11.09.06.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 06:52:31 -0800 (PST)
Message-ID: <618a8b2f.1c69fb81.a6c95.f348@mx.google.com>
Date:   Tue, 09 Nov 2021 06:52:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.17-13-g605d327d663b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 146 runs,
 1 regressions (v5.14.17-13-g605d327d663b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 146 runs, 1 regressions (v5.14.17-13-g605d32=
7d663b)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.17-13-g605d327d663b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.17-13-g605d327d663b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      605d327d663b7d493ebf6fa6a8f7c74c6c9b5262 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618a53df80880e82d43358ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.17-=
13-g605d327d663b/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.17-=
13-g605d327d663b/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618a53df80880e82d4335=
8eb
        failing since 15 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =20
