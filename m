Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77F340CEAE
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 23:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbhIOVSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 17:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbhIOVSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 17:18:37 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BA9C061574
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 14:17:17 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id me5-20020a17090b17c500b0019af76b7bb4so5253528pjb.2
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 14:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TRrAYZsVKudZDFIZhYSYWDmaXdr2XbkEfLa4gvN4eog=;
        b=RV4Lf7YzkJtU9mzmev2axfV607zXBNK1Y/H4F9CrQQjwtTFzpKDqtmRbVAbABb/Heu
         9TF6PSoVQuB2GQ5b9lBfnjYho1BxZHVkRpkw3iLLe37v1p8T59kM4um1tFTS/RYo0c0e
         +bIqlWjnUhVMM8Xc02U7weiADBzTFcYDL7x26TiITXzYeAhva8eOSXe5j6pB0YUOj10T
         2ioLgWhtDqeAlh6/s9XTK1wAQwOe5VAwjuMTY83C3ejSF5btrqpB9RYd3b3fWjmAdiis
         0Y8+3Z3iksZr5sFJ0vmTLbyi1lMXmP+vJ883kOmJgqYZRMkS9JlTDlg0pAHPGEwBS643
         r8ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TRrAYZsVKudZDFIZhYSYWDmaXdr2XbkEfLa4gvN4eog=;
        b=rIgzxWsrhzRxGu2OEFd96oGYIo5RPci4pnLn/L1UhSio8HZKKPSyyp349LXZkrmXh5
         OqUIkaQ6ENOoQwYD+zC086eqPFGIFP6CpUE+UGjg8MEXO+tGRUWqtRZLzADAAFl27emn
         q3mmMQ6HbzxpniJ61JqK2giMxX1Q5HjZhw1lDFgT2sjxZpkGDx9tQOnpYiKPpP7VH5dP
         OwZiL2KTL1aS5/Y9OIZBQXZWiNnaqwcCAtbe7HbB9vJi/R263fJmC/+WN2Von+pvX7/M
         QJwyd41GPNEbkv+pbzncGmkq0JtbOU+qiQ7ljcHDZOd0vtxRZENZLEjWdOg+DaBstPVO
         ieZg==
X-Gm-Message-State: AOAM531c6RdhsxRRMBBD3EI6Swy71kdCtxcJqvwT8xKZW/gYiZ/zVHud
        wtK0HxtJDz4cynr8WaAYDLNMA1OtGLNj9aVvzFs=
X-Google-Smtp-Source: ABdhPJzHRNt4fw0eZtwUsXpi7n7CMX+RtkEVYddmyQpenB2PlfspOSnMlZ5tpxxHcQ3jWDikmSOt2g==
X-Received: by 2002:a17:90a:5e03:: with SMTP id w3mr1961640pjf.152.1631740636957;
        Wed, 15 Sep 2021 14:17:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j11sm5774805pjd.45.2021.09.15.14.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 14:17:16 -0700 (PDT)
Message-ID: <614262dc.1c69fb81.76e9f.1f42@mx.google.com>
Date:   Wed, 15 Sep 2021 14:17:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.13.17
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.13.y
Subject: stable-rc/linux-5.13.y baseline: 96 runs, 1 regressions (v5.13.17)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 96 runs, 1 regressions (v5.13.17)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.17/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.17
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e228609749a14bb736b6210738042a3c0a2127d1 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61425cfbb5dd70c6ce99a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
7/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
7/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61425cfbb5dd70c6ce99a=
2de
        new failure (last pass: v5.13.16-301-gdaeb634aa75f) =

 =20
