Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6252A37F045
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 02:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbhEMAOf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 20:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347365AbhEMAKX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 20:10:23 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E1DC061351
        for <stable@vger.kernel.org>; Wed, 12 May 2021 16:54:14 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id k15so6819917pgb.10
        for <stable@vger.kernel.org>; Wed, 12 May 2021 16:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=imEs5hGZqDu3SD91/rjBKA8TsKswd2d+SWxxV0U8c6k=;
        b=YOp2g/bzmAGFXOeW2nWEnoWJSblU7Njxe0e54WMbw+DPp2+hKaFlZPWSxRycVh4z9O
         lrjtPbh1piBi5SNA0ZTjK3dta4HY9i5gyJ6JQHj+TXO5gxtOA/r7+XEd21a0JpXqNAe3
         k7nBxJyMY7IronDjtnK+j26NAhLMvHjAjw+AicKq/TSY5STIoaFt0tRgT/rrdH9NZfem
         QPRtc+xZQ11K31sKnXAX+vpv0w6amBkxk5FhbB1CYJDyHRVU3NR9JvakE1XSNFqytVx7
         CuaoWHRKvqP74sDt5Zh4UUt6LNDbR/0HLrd/SUcpU3hTWZmf617HuBXFFtxfE0RO9QS2
         mfSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=imEs5hGZqDu3SD91/rjBKA8TsKswd2d+SWxxV0U8c6k=;
        b=MypCmvwVgzkTfLm4BRx2+I62UxsldU30MASFY6I5S3iV5V/2v+kUB+DCzDc3zto520
         vrgP5q30fDramvuHMx0kK36hp72WlE8YiZUCcB55V7PRuBaBMPbi9gRSf/hVP1wxIoNn
         Ydw+BQrEGewUh7sRi1IRwhxtXozG9AyrBqIhOwRG5oo+BH0Oq7YENB4mhypeSs+ueAVb
         74g52+Boq9Z06+n51KD2WZQND36uwqpycKjXilmN0Nlr33ou6MmP+Mj4Jc/1nHw51T/A
         jjftxWRJtCtrxkJPH/bNtXkptbnD5aToPKiU+p1PhaHjJY1mY4qwr52IQde0fK3YEt4C
         eSzg==
X-Gm-Message-State: AOAM5332g9IOTNm3UY3XzCgym6e2mFCcG/nLBnyLxa1Wan6gS/fJQ6SS
        DFCSuJlM+Kq5uI+2bgY6UDKKFDxH2pDNbhHV
X-Google-Smtp-Source: ABdhPJxsFQNRVUz0N8TcLz+4KSxZF1h9Ior5FARIEP9NZy89DA8c99HAEiXUM0JV+X7UUxKk4nWiWw==
X-Received: by 2002:a63:6f81:: with SMTP id k123mr38257459pgc.230.1620863654085;
        Wed, 12 May 2021 16:54:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 23sm715592pgo.53.2021.05.12.16.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 16:54:13 -0700 (PDT)
Message-ID: <609c6aa5.1c69fb81.71b9e.359a@mx.google.com>
Date:   Wed, 12 May 2021 16:54:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.117-427-g6fb37a144648a
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 150 runs,
 1 regressions (v5.4.117-427-g6fb37a144648a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 150 runs, 1 regressions (v5.4.117-427-g6fb37a=
144648a)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.117-427-g6fb37a144648a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.117-427-g6fb37a144648a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6fb37a144648af7d96098a8158c5815f255dd885 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/609c3740a6936978d1199289

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.117-4=
27-g6fb37a144648a/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.117-4=
27-g6fb37a144648a/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c3740a6936978d1199=
28a
        new failure (last pass: v5.4.117-429-g047bfedc58ad0) =

 =20
