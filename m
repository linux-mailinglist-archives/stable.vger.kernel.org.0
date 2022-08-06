Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A21C58B862
	for <lists+stable@lfdr.de>; Sat,  6 Aug 2022 23:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbiHFVMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Aug 2022 17:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbiHFVMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Aug 2022 17:12:46 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF314BC01
        for <stable@vger.kernel.org>; Sat,  6 Aug 2022 14:12:45 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id x10so5486794plb.3
        for <stable@vger.kernel.org>; Sat, 06 Aug 2022 14:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=+y/L9evDCsjADiB3oxNaDkEzp/IiCMmK0JYVYGoterg=;
        b=ntHHWl4En6EuH0GGtM3E5Znd9sT1NKiRtkI7z08JtL11ZTcBJM2Mf5beMhPdkkixEl
         nTZi0Kf54Zj32nYq4Lou/pCQvcDpFXZnbyFsGDhSBnRHDJb21smv7jrEC8JEgWpH7x2O
         a9SETE3MPN4XYmVxW154mHUzJZD1su8a+nhWXVNWeFF/5rUbbWrk2kO3vGlHK6sBuPF9
         4OPFuouHABzxxMkEd9g/EDqSSGp8IJNnUlrvPQGJF/7H4rECUPLM4Ljz1EkwvMOGmCtV
         2Lqm887ednT5aTK+p9qwBA4sAAo+lvezlWaYlzvXLk6TVjO3tI9E3+a8ZQGCDlLg/ZB8
         XuIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=+y/L9evDCsjADiB3oxNaDkEzp/IiCMmK0JYVYGoterg=;
        b=pNNW6LdZbd87R34Le7TaqVIQgZbHC8FOPj/mDWQZqmHBYoMnXhV0DgGC/4Zoq+9Ukh
         0QP9oGaNyhUPf9RBiKMakbo5HTDFSF+P1OR0O5P9ayZI7K6/AjoNErkQr/5h+yd1pUw3
         3tYvIdhNEvShHV6AwuPmfYo4wHj9x0w6xbszqEBhaCmD5d0JZ1pKFP+NeOK0jZkZ+VrL
         UeeeL6NYvE0eJpLVer41iJPVBDWNiCjFYf18lzoj8ou0YyD28UTtBCP9L9eP+SrgPz/W
         GWqi8SwCrGPEv0/E2ZmvYCLHY3VCm23bveaxBqwiLy4mzSHcZdVt5H+NqiO24bx/oA71
         abLg==
X-Gm-Message-State: ACgBeo0SOqlGFsIjrh8mmYLSySJAf7mBP9Ow+B1sqP5FIURm1Sh7hvgM
        zM1dIHpVi+tb7AA66Xoqq6kOYZgey2NJLsr/gUQ=
X-Google-Smtp-Source: AA6agR6j1B6K+inpyCn8JhwyOWGNFL0LDv13dDz3Mmp4G4Qff+vLub/4M+LDT+Bq0Oid3GIxJVrSHA==
X-Received: by 2002:a17:902:f792:b0:168:e97b:3c05 with SMTP id q18-20020a170902f79200b00168e97b3c05mr12050549pln.94.1659820365044;
        Sat, 06 Aug 2022 14:12:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e187-20020a621ec4000000b0052d200c8040sm5400043pfe.211.2022.08.06.14.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Aug 2022 14:12:44 -0700 (PDT)
Message-ID: <62eed94c.620a0220.67833.8ff1@mx.google.com>
Date:   Sat, 06 Aug 2022 14:12:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.59-15-g9e86d04b098c
Subject: stable-rc/queue/5.15 baseline: 143 runs,
 1 regressions (v5.15.59-15-g9e86d04b098c)
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

stable-rc/queue/5.15 baseline: 143 runs, 1 regressions (v5.15.59-15-g9e86d0=
4b098c)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.59-15-g9e86d04b098c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.59-15-g9e86d04b098c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9e86d04b098c8538556a8872a9e9e9e19ae35e1d =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62eea81d3e8229a187daf0c6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.59-=
15-g9e86d04b098c/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.59-=
15-g9e86d04b098c/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62eea81d3e8229a187daf=
0c7
        failing since 128 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =20
