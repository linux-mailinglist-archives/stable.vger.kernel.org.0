Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2028433F63
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 21:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbhJSTpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 15:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbhJSTpv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 15:45:51 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9016C06161C
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 12:43:38 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id qe4-20020a17090b4f8400b0019f663cfcd1so709555pjb.1
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 12:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oFGjzOZrkra1iP87NO6800pf+ChGO+Uk2/ihFGWRDy0=;
        b=PV9iW5wCpmlcITZNLw8WSMjztR+zXDIwjb+yAsDLfJhUJmSGji75qX9kZ5NwjqMBCB
         e239NHSctHDbMR2lulOzylOmwQUWQn2Pe+YeC74jtvpltcBPupQw12tXF3w33l+f3+37
         Vd5kCB3lAi5621eevqPggG/jPZMz8NIWeqihTfeW9108wdf6oF2vCUq+GkclALZUG5Ri
         SV/MYGUGI1qHkBkBuIWP5RMUAxdKyedVpfB/y1sGyNpkNrAqDCabNW8lgCZiO3QPRF41
         NPTn6OwluX0/fiCRpfoq0pbPlHn4GMo2zfIto8CvYTSiHdE9/RbeyQfHegneLPtjOYmO
         cv+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oFGjzOZrkra1iP87NO6800pf+ChGO+Uk2/ihFGWRDy0=;
        b=CxCKzUKt/bCskAksg+FlJ4fmt+Yw+PtOEGNCO/OD4PUHRQjxTGOKNTLhXd5AC7sp5V
         3HBHSHR8bIz82Jb/e/XjiwgNJYxIGKhHnmqzWz3lp3iYbR9Qv5mNPH6Muc3QXzzuc/B4
         GHjZ2laxscyLP93nbZOeQRzSOGvoYfzzalFls5+SliuBXFUsTkLzaKGOGHodXPlSfxEc
         WWD4MZLQakCr+tquxytSfkdQOlL4H17ni9C8q2jZ76/T7LpgCfCI1I6cpZX7S3Yq5zkW
         wy/3hAxpaaUgQvrByQ/QQMB5qnzyNXsfQtWhfFU2+r7Z3qCE7nb9s//6KBNe6kNkN641
         kyiQ==
X-Gm-Message-State: AOAM5329nuxQpw0hT9qjzzDLjtb/bTr6MV3DQHt+1f4+b28CjuUT2eY+
        5/0pTmI1klSBmKIl5lg2EGbbl2Q5y27tixG6
X-Google-Smtp-Source: ABdhPJyWxTRbhpqkNVwqXytNBSQJBCCUaFIb5aSoutzBdRT7KYTuJ8k2KRMFnSmi7GeF5+EL/ItCIw==
X-Received: by 2002:a17:902:9303:b029:12c:29c:43f9 with SMTP id bc3-20020a1709029303b029012c029c43f9mr35428087plb.5.1634672618079;
        Tue, 19 Oct 2021 12:43:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b134sm46718pga.3.2021.10.19.12.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 12:43:37 -0700 (PDT)
Message-ID: <616f1fe9.1c69fb81.75210.034d@mx.google.com>
Date:   Tue, 19 Oct 2021 12:43:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.73-124-gcadcf306c4d5
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 187 runs,
 1 regressions (v5.10.73-124-gcadcf306c4d5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 187 runs, 1 regressions (v5.10.73-124-gcadcf=
306c4d5)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.73-124-gcadcf306c4d5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.73-124-gcadcf306c4d5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cadcf306c4d538d9a42e9f389ee1eb9f3bb04351 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/616eed4fe9886cf048335908

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.73-=
124-gcadcf306c4d5/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.73-=
124-gcadcf306c4d5/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616eed4fe9886cf048335=
909
        new failure (last pass: v5.10.73-126-ga7ef479e79a6) =

 =20
