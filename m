Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAE734A5DE
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 11:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhCZKw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Mar 2021 06:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhCZKwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Mar 2021 06:52:32 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A469C0613AA
        for <stable@vger.kernel.org>; Fri, 26 Mar 2021 03:52:32 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id l1so717091plg.12
        for <stable@vger.kernel.org>; Fri, 26 Mar 2021 03:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DwVAkOrcAi/Vfm9enxsXh1bbUotag2obMwmlDHk3ek8=;
        b=0WzAsrhwKx8MR2N9IGrucEhd3vdHT22zK24TeK4FPpUnGF430nZf25AQ5oFexTRIZm
         Jw9At3Mz7YnNbDnAN3+1W0g4C673sv8vev0ZWIizqiVGpdwQMrAc/o2FzLuYzjLZAcF8
         MmlkE2qRw9GTVvrvZ7femSH3hL6yp7MuJuCpyOKuEQFaxP/Bv82dkW3Ox4nhG+Vybi65
         sUWAfxDAwpPW3lgLix6eu5OhhORYu2ab2q2nalkdyuU5nTgiRoXlLW2LvnZmwJrIxEId
         vGeF6s9omRe3UqWx85J+4pRRjP1Mm15lkqJatUd7Sj/BeBIEfpr+nIO+3n78dUxwyeBH
         t1YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DwVAkOrcAi/Vfm9enxsXh1bbUotag2obMwmlDHk3ek8=;
        b=HhT+kejIeHryGF26eAzxtxxeDJPkgZgJxqxpwewkfgZIXiHGjbaBYUowWVH67VddLl
         NKlTrtWFlgcTD+qpwqEF6qY02wmWJNtdLF2ZJLSnW3lXahYIU1sXmiFyczqdCFk+c+8F
         GO8Gp2lfL8nEq+TlZy32EI3YD4x/z+3f+cfjcUp1BXk257rERExiJHzciNKUvfOFUpw5
         HTrFPBIjeCLoXOBBuiyvap9Zmx7oWzYnOg9raTKye8kcbLwUwHe9+11FscqzNfv33v0y
         FwvPWoa8ADjEzv5FFAOQ8LklcXo2Kivftq5EaKPhk9bKrqDhnsGcmmYbrIz/EAE4fKwK
         bQBw==
X-Gm-Message-State: AOAM532nhlh69q+Si6mss1cLRZVk8XOxjcIXmELURlrTCcUSri6rz8Xv
        Tncf/KCViNq55JHMZ0MNfCqTefeaZskKOQ==
X-Google-Smtp-Source: ABdhPJzBeTqaI8k18mNCyPLSWOAJasLyc4p/ItwHylyEYgTWtoRv+cy46fBdFA/8ZF2YHrIfXJt+2w==
X-Received: by 2002:a17:90a:f194:: with SMTP id bv20mr13485890pjb.229.1616755951463;
        Fri, 26 Mar 2021 03:52:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i10sm15901467pjm.1.2021.03.26.03.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 03:52:31 -0700 (PDT)
Message-ID: <605dbcef.1c69fb81.8a0a5.a061@mx.google.com>
Date:   Fri, 26 Mar 2021 03:52:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.26-61-gc7b7b08c4bb5
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 164 runs,
 1 regressions (v5.10.26-61-gc7b7b08c4bb5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 164 runs, 1 regressions (v5.10.26-61-gc7b7b0=
8c4bb5)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.26-61-gc7b7b08c4bb5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.26-61-gc7b7b08c4bb5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c7b7b08c4bb52841547c6666c9fe13215ce92d95 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/605d885791ebfbc236af02ca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.26-=
61-gc7b7b08c4bb5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.26-=
61-gc7b7b08c4bb5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605d885791ebfbc236af0=
2cb
        new failure (last pass: v5.10.26-56-g525a07fb82ba) =

 =20
