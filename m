Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6823747A22B
	for <lists+stable@lfdr.de>; Sun, 19 Dec 2021 22:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhLSVF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Dec 2021 16:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhLSVF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Dec 2021 16:05:58 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044E2C061574
        for <stable@vger.kernel.org>; Sun, 19 Dec 2021 13:05:57 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id d11so7616877pgl.1
        for <stable@vger.kernel.org>; Sun, 19 Dec 2021 13:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=K1swBHppFTgtC7Rm9JQ6AUT3c8nQE+vkCblmkFTZfWE=;
        b=KGNH/OVmLP7PDuPMIlgJoCs4XeC6WJdKKjcY1BKTEHZirPWfoiapsYsBPc8XJLJba7
         XoPVZZIi3CuC7ruFvrJw4m9q+K0hhbNQ8qZ1OkavJk+ZleNDnZj0dvePGiJv6FSsfpOw
         Fqjqb2zJfyNjZrVDOXBG+DQ1uG2YLSuRdqYDxH7BVa5Iq0ojqdrcYH30moFlcngSRDdn
         RhFC2QSeUY0f8ITa586I4WRbQ0nY+FHL4zdPMBzSI7VoN7su1sdHVPZVljU/XG1Nbf7k
         AS0/9dLf1EnIjGckymOR2g+uv4VVHKawC2Az42vUVBX6S44ExsTPwhSCtL6F/QX+dF/q
         bG/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=K1swBHppFTgtC7Rm9JQ6AUT3c8nQE+vkCblmkFTZfWE=;
        b=CMT6Esdx1QazwUVjFASOWXlMaZ2Owe6hS84gLR5sk7vBlypZXJnCqPYvLm+vw+M1zK
         4J7WYfPojJLOWxPz5Uo6/i5xlZYwURqifVo+vDGVep1GFnsEwSRqsl7GFceH0Qprj259
         Le7xGp6PMVT5R+1hfRBSRURibCkaeqyGINXQjPaanAaEs0sr/zESKaaYw5r4dKsCXJ4V
         ocnfjT6JZd/sdHNozKmLOSkPSC9MR8JCRaky1B+PKC/k9fLFGA1SQkiJHWypxo/msHDe
         ilMUDwqMVG0SskKu0ug14diOdO0bqPVsiIu35sN5e03pdfFiRIw8UHPsUMizREhza4Kz
         A8UQ==
X-Gm-Message-State: AOAM532KtlB6DXI0RaQLi7KZ5F4ngVArfFLe3k9H3tjIJMnRSVNTAmYF
        gEz08qpzuudI2e0F6IXST+atn12Rg8VVVB+E
X-Google-Smtp-Source: ABdhPJxFaf6O+qbK0tRzlJSEVLcUMsZ/l+UUizLbIez19x6z8zCQdQOh087DeOjLeH3Fn6B4kSfTTw==
X-Received: by 2002:a05:6a00:124a:b0:4a0:b9d7:66bb with SMTP id u10-20020a056a00124a00b004a0b9d766bbmr13010504pfi.15.1639947957309;
        Sun, 19 Dec 2021 13:05:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c2sm17165029pfv.112.2021.12.19.13.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Dec 2021 13:05:56 -0800 (PST)
Message-ID: <61bf9eb4.1c69fb81.612f.ec26@mx.google.com>
Date:   Sun, 19 Dec 2021 13:05:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.258-24-g6a08d661000f
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 151 runs,
 1 regressions (v4.14.258-24-g6a08d661000f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 151 runs, 1 regressions (v4.14.258-24-g6a08d=
661000f)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.258-24-g6a08d661000f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.258-24-g6a08d661000f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6a08d661000fe72b18b4de59e449f617d453626d =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61bf67679d07c276b7397132

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-24-g6a08d661000f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-24-g6a08d661000f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bf67679d07c276b7397=
133
        new failure (last pass: v4.14.258-24-g5205a2d8fc35) =

 =20
