Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBA24502EBE
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 20:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244338AbiDOSfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 14:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243945AbiDOSfG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 14:35:06 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812856351B
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 11:32:37 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id q12so8063197pgj.13
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 11:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fZ2yk6hVA2aikyfhGYez3ueSGhY4PJz/a4y1Fn9fUFI=;
        b=sBXD0tttNKz9hCypXUHhyeRU4EZ/+tZoNq/huNy3SSJcwqhVriVRXJYkeIRZZdBTfx
         l8vj314L2BOW18TxmcPnZmwC/ZnJD9mKPlkfkxZBlwP41f5tEDyFsZ8rirSZ5MJBrwv1
         XTm9DXtG1NOeMaSCMmTIJYcBwuV+bcKYhLQM57EdQHHb9cskY62fWvF1ycYEknPeT4ao
         uim8Ms+8YsXbSY/L/nomsTlZrOxpTOAhNZgESMb32mukOSLgg6I9xKskv3o5I7O1AYbZ
         Ia9250JO3aSq1OgBJmO9gU1PouMt2R+D7dfUgH9ocr5OlJY0zCAFSJ32KruuemDrddx2
         90Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fZ2yk6hVA2aikyfhGYez3ueSGhY4PJz/a4y1Fn9fUFI=;
        b=Gco/Dw0hyUf3RcWkSWw35xwMI1yDd+cpMmqlJC5hzC1LauebAB+8L57bgIEVXTJI9r
         Yexg1xAUiKoBO2B9DLIE4RvDK9q1NyAYYTqVTUcWfG+aDZTvqCRqI7LthfwvdmZPCEUR
         5if1A/HLLTWNsC2iNrSbp+1dDvu5AUCr5MS2qlRddxHOT8xZONHlXxvShxg3xwHJOMgt
         Le6U8QgFQgwr0gvTPPSCtbuF3JX7eF6aTDJXb3AutBulVjeDNppiFu+XDj2PXOdfwZaS
         TdNAaM1ckvawyNSjtm4VtvGhfak0Cn5fJvCGaphAgu9Ko6YZSYU0yabG9iCIzHI/W8Ul
         asKQ==
X-Gm-Message-State: AOAM530yHWrWETtSpHvV93dUHlRV+Ntlnp0T2SCa/noT+co7wTZOyFG1
        miLbQ74WJXUJua9XaGkpM5sryPLFDwAvdODY
X-Google-Smtp-Source: ABdhPJz4syT8UJPOzQ/WqGSeA8cu5Jhp+WewFg53AMjFiQiuQGHOMl+gRuOGvfJdeMKG+ixkx9zs/w==
X-Received: by 2002:a05:6a00:23d2:b0:4fa:f262:719 with SMTP id g18-20020a056a0023d200b004faf2620719mr290932pfc.4.1650047556892;
        Fri, 15 Apr 2022 11:32:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i2-20020a625402000000b004fdf66ab35fsm3497368pfb.21.2022.04.15.11.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 11:32:36 -0700 (PDT)
Message-ID: <6259ba44.1c69fb81.daff9.9a13@mx.google.com>
Date:   Fri, 15 Apr 2022 11:32:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.34-55-g87e83d73d1d00
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 62 runs,
 1 regressions (v5.15.34-55-g87e83d73d1d00)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 62 runs, 1 regressions (v5.15.34-55-g87e83d7=
3d1d00)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.34-55-g87e83d73d1d00/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.34-55-g87e83d73d1d00
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      87e83d73d1d004d933f68658b727d70e3265cefa =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/625988c455fda4abf6ae0689

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.34-=
55-g87e83d73d1d00/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.34-=
55-g87e83d73d1d00/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625988c455fda4abf6ae0=
68a
        failing since 15 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =20
