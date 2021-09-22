Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3ED414D4D
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 17:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236440AbhIVPrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 11:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232571AbhIVPrK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 11:47:10 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAB1C061756
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 08:45:40 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id v19so2375015pjh.2
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 08:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wflREp5nA7Tbp9asUCnKDRv/dhl2EukCa7SITdjD3+U=;
        b=g+C/HK5od0sUulk6L4D39OtAq00zg+BGQSesdnQZPcnqBikqVlgI8x9TW+SuCQd5fI
         TderjFN9jQyqtfbVdkiNC0BkaLWfkLYnJYeOtdZg/0PVIPCmrztpIFmEW2liP9VYBvwf
         FExzavCP25Y5UO7CJy5g13Tsnx1Yr8DlYuyqH+Eu3kqV52Cqz/WU7iKSlTmJ2FgmGBhz
         HJahP6K4QhMwqAlkrH8kbHbgLBiWWJ3gu43q5sdHqR4k53H0gHl2uEOBfq/87d6cgUe5
         m1vbapspjG1C/yiIPYOXnT7lbdC3lerOIStI56cANEEzUOPLUdodcjImYzwRt+PgGsrR
         z1KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wflREp5nA7Tbp9asUCnKDRv/dhl2EukCa7SITdjD3+U=;
        b=YjByEVq7I8EFr27UR9UZxxYabr9fN5+oAmCfxl5w6PoDL5U9U9uEXUKCAhl2sgqUAh
         89TYA4Ykve75zwXmhPQXyxm6zj1B+qzUtdG6P/MmwD7A2BoqPHE3Z3wiGtT2QK57Rs4f
         tRPjk8EIYK/0bleSJe8DgkbeRNVlZHYjC4S19PI8sjwyrW0O6UsNgqf5hTJcb5f60zaf
         wB2+UfBcE93K2nZASoR3MH7co8HtaX0ASaBhrUxuedonE6bPDp99DvnJ6JdBwjA2ohtx
         0AqoKWQ8y1zYGF7ife3F9psZKygV/Z75nEIYlGbu0V4H8LncqpR1BEUAZDukiMj0qdj3
         tu9A==
X-Gm-Message-State: AOAM533uP2GkFW67rC+pt5IVHeHOLgiVPOw6O4fhwJdqDLCmU0vy7afq
        ROztnw726jeRS47MnGestiAPL9gDLBP4PpnF
X-Google-Smtp-Source: ABdhPJwJw0RdtLEo26bSR1oyJcZ+yeXgndnTDVr3xte10Bloc2UBJ6OZHF8CsKgBftpcu0r7ugaWPA==
X-Received: by 2002:a17:90b:f02:: with SMTP id br2mr11899765pjb.125.1632325539810;
        Wed, 22 Sep 2021 08:45:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v25sm2735247pfm.202.2021.09.22.08.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 08:45:39 -0700 (PDT)
Message-ID: <614b4fa3.1c69fb81.37945.74ac@mx.google.com>
Date:   Wed, 22 Sep 2021 08:45:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.6-174-g89f346fb2d60
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 131 runs,
 2 regressions (v5.14.6-174-g89f346fb2d60)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 131 runs, 2 regressions (v5.14.6-174-g89f346=
fb2d60)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =

beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.6-174-g89f346fb2d60/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.6-174-g89f346fb2d60
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      89f346fb2d60977a64df7e4b2c4ce88835fc7588 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/614b1aabcfbf67b09399a312

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.6-1=
74-g89f346fb2d60/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.6-1=
74-g89f346fb2d60/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b1aabcfbf67b09399a=
313
        failing since 0 day (last pass: v5.14.4-395-ga49a6c3da2c6, first fa=
il: v5.14.6-170-gb1e5cb6b8905) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/614b195942fd10316799a2ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.6-1=
74-g89f346fb2d60/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.6-1=
74-g89f346fb2d60/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b195942fd10316799a=
2eb
        failing since 6 days (last pass: v5.14.4-24-g6da4ee8977f4, first fa=
il: v5.14.4-73-gc291807495af) =

 =20
