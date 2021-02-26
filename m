Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F303264B7
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 16:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbhBZP23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 10:28:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbhBZP22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 10:28:28 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2C6C061574
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 07:27:46 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id h4so6376194pgf.13
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 07:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BnSmR0TSGF4mBxRFjITcnvyAS2wUff8n2xAsLkY+SYw=;
        b=En4expZ+vzhxkYJLEoRFywqTo7+E0ALLWck2P0b7Y7fRcxwxByAyRuSSehVd/Tp038
         f8/Pbetpj592gtrGuaj49M/RoeQWhF3IGwyaXot8UAXnlqeVdTUiyNOWIUo9YyhpIMHP
         171Zqfessh02wtGILx/pP9DuiSCDFfsDdSt/lk1Oyug43ACCQLOsDtZindXT2yTZTAPg
         P+pBnLnxX6N6IYY5aRqnLd28iHgiosDHCbZRkrsr5JUHy3xqoh89tjzQiXxYb6TxT79p
         SjUm3gZ9dPbr3VhhK0t2/rYc2K9f2QrXMDx2FiTDmvDYkPV1UYLgTQ5rUN0tY6peWhIc
         a6Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BnSmR0TSGF4mBxRFjITcnvyAS2wUff8n2xAsLkY+SYw=;
        b=eAlnME14YxINhUn70Ic27XdIC87HYvLH28X807wImuLYO+W8g5FaaB+SSONWsFre0d
         Iug2ZzCkUSUkU1S8lov0uJ1UTdcJ+da1gszDslrEuH9NR06qRgACBk1Dd8KscQRmXmWY
         SdcFzqzYLMIFdn3Ev+ez8C1fYGePZSUJLBm/ci9QjmfV0Rc4xYpS5WmvYjzG66/8oJNG
         WZAJdWgq8/SRmYrKjYrlZtfsN284yWB3GVIgz59eVyBHwhn6AXd+OTNx3PFoNCT2iatL
         Mcvwr+62SWTt4OtnKIDxmPXwiL3Wyt4hTQPA3ogpawkKWSvvHBmdtdV+ZB6m24GZMytA
         uY+A==
X-Gm-Message-State: AOAM532LhvRmhjnN46dwwxAFEI6GwGZnFfqvfRTo3IdtCZQrEB2+HCef
        nx/euXB+kBvDY0c+BJovKg4Np/yBL2WNTw==
X-Google-Smtp-Source: ABdhPJxELBra6FDvQqTARflShIdJFWkLPlayfDh822AKyNqpN4RVfDmKiqHoXTEsNIeAValaVLPSSw==
X-Received: by 2002:a62:e413:0:b029:1ee:2b3:488a with SMTP id r19-20020a62e4130000b02901ee02b3488amr3664579pfh.58.1614353266016;
        Fri, 26 Feb 2021 07:27:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a9sm8923496pjq.17.2021.02.26.07.27.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 07:27:45 -0800 (PST)
Message-ID: <60391371.1c69fb81.e355.3f3c@mx.google.com>
Date:   Fri, 26 Feb 2021 07:27:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.18-23-g15327fb9b0f2b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 111 runs,
 1 regressions (v5.10.18-23-g15327fb9b0f2b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 111 runs, 1 regressions (v5.10.18-23-g15327f=
b9b0f2b)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.18-23-g15327fb9b0f2b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.18-23-g15327fb9b0f2b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      15327fb9b0f2baa5634275068092e7e619412e3d =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6038e04e47e6bc3ffaaddcb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.18-=
23-g15327fb9b0f2b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.18-=
23-g15327fb9b0f2b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6038e04e47e6bc3ffaadd=
cb6
        new failure (last pass: v5.10.18-23-g8f04ffed62c35) =

 =20
