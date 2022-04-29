Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B79D8515589
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 22:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356481AbiD2Ual (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 16:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232546AbiD2Uak (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 16:30:40 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8E03CFC1
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 13:27:20 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id u9so7466343plf.6
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 13:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ttSGgddUe4+Wg7rAj25se3eF13RdHGh+Vq1x8k9c2Gg=;
        b=rReNgSQc6dY1fkXADj4ZzrIscLiHwYEOOQjnmmEabepJVM8UL9x6QBBcJP0d/qPy3f
         r/5FKLGcEW46Uavh8vzXqkc7uz5IsjquhO2SID93nj1u/wWhIufBVuPVO3kTEAEeI9yw
         eQaXalX1pM24KAsCZuZ6WBvdLV5x2E9bk8XsJh3rKuOD2cWJiioy8aYmDiRtulLppd4U
         RQ9uW8CvP6uy/DaQr7zEj7LWP55ky5Yj9KItngk+Qr2NWKAtC30zAaDajdl3iypznOup
         PB9dozOSKFdREBTH6UbnF38OHtY18SidKYXVBmPQ72KHaoTx53izPuyBproFNc0MwHab
         99uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ttSGgddUe4+Wg7rAj25se3eF13RdHGh+Vq1x8k9c2Gg=;
        b=IKnMzVRFEt4K3avFWoj6h3y512iRP6oWbePO1lUJfpRsGG0Kx4bJYa02IaYgwI/fJq
         7Zn+8UlZxdLkrhdPHOs/aSAaKBUMWCIvIvSC/uBR/8bXR1aBczzXuUqlyqFocwzSIEuA
         i9l3Y7blOUgNpXIIVmPXqmnBYFjGwX9c+GHxFamrpQIRnBDSwsQGA6olq2bGOT2t6jfL
         SSrbO4PYx/Gv5fMRG+LXDN7Vwe21koLivoc4eEUZUL0bZeFYSsrrwUvnVogWpLfcl/Qh
         KWp6J3vrq8PkTN9ZMqIEA5hdTn5Q4TvQ+Xw45pI3IwfFRcbvJejej3uPSFy+4O44veeh
         U3AA==
X-Gm-Message-State: AOAM533PfbluiZIwjrO6cuSU+gpti9NIHJ/FqH+NapAimFtYUo6eJ1ik
        gQTReT2QeLiL/atM4DCLbjlJkX/I4Ub18yfLBiY=
X-Google-Smtp-Source: ABdhPJxOTza2Wv2lf8VoVIkVlzuJUUOZ4LGvj1vDH7HCphaou305PDml6iWfgOAoYf0sEGUMghnTDA==
X-Received: by 2002:a17:902:cf0c:b0:15b:63a4:9f47 with SMTP id i12-20020a170902cf0c00b0015b63a49f47mr1044185plg.1.1651264040164;
        Fri, 29 Apr 2022 13:27:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y10-20020a170902864a00b0015e8d4eb254sm15138plt.158.2022.04.29.13.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 13:27:19 -0700 (PDT)
Message-ID: <626c4a27.1c69fb81.b7753.00d0@mx.google.com>
Date:   Fri, 29 Apr 2022 13:27:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.36-34-gff3177a2b8b3
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 78 runs,
 1 regressions (v5.15.36-34-gff3177a2b8b3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 78 runs, 1 regressions (v5.15.36-34-gff317=
7a2b8b3)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.36-34-gff3177a2b8b3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.36-34-gff3177a2b8b3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ff3177a2b8b333ce1007cb22d7e2adafdcda9720 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/626c1269aac7124ec4bf5fee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
6-34-gff3177a2b8b3/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
6-34-gff3177a2b8b3/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220422.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/626c1269aac7124ec4bf5=
fef
        failing since 98 days (last pass: v5.15.14-70-g9cb47c4d3cbf, first =
fail: v5.15.16) =

 =20
