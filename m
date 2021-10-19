Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1FBE433EAA
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 20:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbhJSSof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 14:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhJSSof (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 14:44:35 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A838C06161C
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 11:42:22 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id om14so627918pjb.5
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 11:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=O3otar1SLaBRtWFqToYN4cheAyMVmv2/E7349aGoPFQ=;
        b=X1GVQ0QfKX/HP33zy72cL8ggFdXkZG4LFD679aZHV057SoclVC8CeiPjZpI8sLVhVz
         2H6xpogZCdsZbLmV9FXwJku04KdBdlt7tY1RVZ2q5fR8DjWhj4iEPhsowjQUFKsEY/Yn
         CqrMrKPy48GkKY0fKRANC8aFcaJhhcxQqpXOtktq8/bWqHXd7y3KWL+nCKyRMSw978Ds
         NXGUGoNliDi3t8HruAXcUYi5XHcBJDmM9ZFvFyl/+cIaq+Jf0/o9itg7j89BHmgoDhwH
         w9SZFSE/m6ImjvK5jLMAPHGQ61mkT7SAlHRlAm+bGW8BIMq7akTxc7nUZjHnHztpT228
         Z5eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=O3otar1SLaBRtWFqToYN4cheAyMVmv2/E7349aGoPFQ=;
        b=fzX1XW0k5Wqw6Rml5G87dUdUBEXuMa2uN5sDSaSrik+WHFq5+gWR+d4KCr3tHaRR+y
         uR3kEsykDOSEVVKx4gHXN+/z9ABpXINzBTCUr3X8SSz0f8kNBE5Lu+tfuiEAonE6shtO
         U/FWNUps+pvWvW9zp1lc1S6lZ7YoaxVWtyoGAhK7yqacXQ0OWDRqU9NPet4vboUJ5zm5
         f1pSLFuhiIkR32+CVd2iSLm2WOKMZWmaFwFxOuKwrTmpFD+2CULYnTPu+GM8JuK1qSXD
         TxV7Q1txGFiMBlkk51yreKSPkGGlTbn5MjurQ2Ak7MZfhqiScHCqnJPdZyuDINvIGUb/
         79nA==
X-Gm-Message-State: AOAM530fe9y1hVIBfV+7Nua9jCF6ZbxQB6RbxadQnjJBzKlJVLCKYUNk
        8cDktS0qOKM/iI5qiuT4ZhWWbq2IQS9FCMvF
X-Google-Smtp-Source: ABdhPJwQuE6VCKUCjNJ3qxBEf6xV42GDH9kN7JMkJMVnsQk9mYoLgvTCsmnk8Qv28u6Mf7q8txvpTQ==
X-Received: by 2002:a17:903:22c6:b0:13f:3e6:8dd4 with SMTP id y6-20020a17090322c600b0013f03e68dd4mr34863710plg.23.1634668941625;
        Tue, 19 Oct 2021 11:42:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c8sm3450012pjr.38.2021.10.19.11.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 11:42:21 -0700 (PDT)
Message-ID: <616f118d.1c69fb81.be65e.9f70@mx.google.com>
Date:   Tue, 19 Oct 2021 11:42:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.250-73-ge93304c5bd7b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 150 runs,
 1 regressions (v4.14.250-73-ge93304c5bd7b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 150 runs, 1 regressions (v4.14.250-73-ge9330=
4c5bd7b)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.250-73-ge93304c5bd7b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.250-73-ge93304c5bd7b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e93304c5bd7b671291fe2b34d64f46d6151677d1 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/616ed6ef79d564a8d23358dc

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.250=
-73-ge93304c5bd7b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.250=
-73-ge93304c5bd7b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/616ed6ef79d564a=
8d23358df
        new failure (last pass: v4.14.250-73-gcf46928023bb)
        2 lines

    2021-10-19T14:31:58.735798  [   19.798706] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-19T14:31:58.780450  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, mmcqd/0/60
    2021-10-19T14:31:58.789960  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-10-19T14:31:58.808851  [   19.870330] smsc95xx 3-1.1:1.0 eth0: reg=
ister 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet, 16:cc=
:7b:07:f5:e7
    2021-10-19T14:31:58.815573  [   19.882659] usbcore: registered new inte=
rface driver smsc95xx   =

 =20
