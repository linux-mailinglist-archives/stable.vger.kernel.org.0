Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C88029FA69
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 02:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725771AbgJ3BQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 21:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgJ3BQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 21:16:30 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A02C0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 18:16:27 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id i7so1869973pgh.6
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 18:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NnnqMjbWWrtenvWLzpSzFfZNdtvP2pBXR1M1qxwlppw=;
        b=OCspByrWewz8iVyIEjUbma99B+5S6KOcjg7mNg05wxWVqYrluYb/xTr6aJMzWkUp6c
         BJTmsLpmFC3Zsv1sCAyDggmU14BT3cP1cy0D7aQfDnpNh0l22VT8zn6FKjyB7wkVPvhJ
         X4UnUxqloOacyGPCl82yV86A0eoQ+mgXutO0NSh0OXH9NIINcVSrb2n1TcK4f8C9bY1J
         9W586KPpehCf527LN3aLkv8wV3cK9lcppgKEZlL1UO9U2eI/rScl6yqQjphfsrXdZ5rV
         6VLrXQF2dOLmsMLfQcFgrUM3q+S0C+jXZSLgaSK3gBkSRfhUVCgdW5JH189eKYJNlEsR
         7qJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NnnqMjbWWrtenvWLzpSzFfZNdtvP2pBXR1M1qxwlppw=;
        b=WQfjHHIr1l/n7/hUqFpq7I9zLL8lNBUdmbBTcztrbzfI5bTctnj3jCZCE7733euSsH
         JoLFUVYkOGIPc+9Tx08MwJ8PW704yH2qj5TJkdlH4ipmOzl/vq0iVvbJFGGPtun7Nel5
         Zv6nmBkZKuPIX69joJN25OQNRWZLPG5xpbBXMlMV9pXJsEHutO4U8xg7WsLDO7mJw5Vw
         J6rfX+XDt2+MgiirICtRa6lGJSpWdtFvC0WyjYiD3vn/d524Wm6UXuI2BxIx+4hyhyR8
         NSQieaiREbyKVL42HLDwLGSPtXFtOmvrsxKefMLF2V31AQz9QAawASrwrbObOMTqDO5Y
         RMBw==
X-Gm-Message-State: AOAM532JD8ePyj3fMcWMWmKP4uoBV3QaBSPBQTY2dTz+stsZr9fwGwi5
        o3dji62PWNPa1YPtfgln8QCh2VC8wBL1zw==
X-Google-Smtp-Source: ABdhPJw+PuBUkL5Dno1PbweLS2/1QlzKb4iv+QNzuhxCHvSa3v5g8Pb+X+X7QH18Xw/WBLIfxGePbA==
X-Received: by 2002:aa7:8bcd:0:b029:160:cb7:b639 with SMTP id s13-20020aa78bcd0000b02901600cb7b639mr6967841pfd.78.1604020586666;
        Thu, 29 Oct 2020 18:16:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t15sm230628pji.0.2020.10.29.18.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 18:16:26 -0700 (PDT)
Message-ID: <5f9b696a.1c69fb81.1b574.0f9d@mx.google.com>
Date:   Thu, 29 Oct 2020 18:16:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.73-9-ga9c55e5daa9c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 200 runs,
 2 regressions (v5.4.73-9-ga9c55e5daa9c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 200 runs, 2 regressions (v5.4.73-9-ga9c55e5da=
a9c)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
 | 1          =

stm32mp157c-dk2       | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.73-9-ga9c55e5daa9c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.73-9-ga9c55e5daa9c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a9c55e5daa9c8c24a2529aea9f067d03063e3492 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9b35dbd5f0158c2e38102d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-9-=
ga9c55e5daa9c/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_=
xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-9-=
ga9c55e5daa9c/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_=
xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b35dbd5f0158c2e381=
02e
        failing since 0 day (last pass: v5.4.72-409-gbbe9df5e07cf, first fa=
il: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
stm32mp157c-dk2       | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9b389fe82e81eab5381025

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-9-=
ga9c55e5daa9c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp157=
c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-9-=
ga9c55e5daa9c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp157=
c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b389fe82e81eab5381=
026
        failing since 3 days (last pass: v5.4.72-54-gc97bc0eb3ef2, first fa=
il: v5.4.72-402-g22eb6f319bc6) =

 =20
