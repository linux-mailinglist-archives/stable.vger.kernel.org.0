Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA952950B7
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 18:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390710AbgJUQ2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 12:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730602AbgJUQ2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Oct 2020 12:28:19 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF6EC0613CE
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 09:28:19 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id g29so1784642pgl.2
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 09:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2i9iYCGv+uQE726jIsld7pzZSHsSPHYEK7YU+Saq8z4=;
        b=aNL23NVoV4Npr2pHSB+Id7D4pVlGHW8vc5ThwQ8vYn8ZIsPseUvuz3iSfq+hZO/u70
         aWqnCE3KlT6nK+ha6aaqUZuGPpfJMlkNDR+9dtaQvlmEP32BqUgy3k9NrP6MEyAx3gMY
         QMBQGgefLfg8YfC2wgOTzc3v0UfevpEMNYB/z7VCKhZcpn+PeWRe2j0e2JhQfntaveXn
         rZczQu+wOpvMdND22TIlHu9mGrHcMa578TERjixMKuLDhRlEkgfOlIbj+v+FKLy7q8il
         eE0HrQhJNAU9DgTDb5cpyo3TuSm2LeVvq9zfXFdJ3JKUj1sUIJ4nwND2Djk8WME+RgR3
         hKWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2i9iYCGv+uQE726jIsld7pzZSHsSPHYEK7YU+Saq8z4=;
        b=cOGM2qx6MSQlTKMEJPOAMC14q7oJCCvtrr9t4odJD2SJdGXDCpqBD5mDnoHpOnBLYR
         6zBHMsSLWaDrgSjMV0Z4CUnqWUREAP5vww8dVleqPuVtd1SooLPv25E8KffqVzT/dwne
         umqomH+oMgl5SOy1SUyMx6Qg1i6G8daaNX0hsprEZyRIhCYZT8BHH2pH94ebc/vYSoG8
         CwpjyAauXKQytJyNb+ZpckFXuJNSWuketzxDSpQzVy/LZ8X6HxnieVCC3cqYPp3S7jxa
         4kyTq7kofaiOrR6RDNZFI7X0jCXltVzWRZFXKKPz3O0rW904h9ZiYPgyAN4l/zjUz+4R
         k5FQ==
X-Gm-Message-State: AOAM531aC00ca/x91c6VdIUc9N7KMqk7Ewf0fnHe3S8MrPzNgNtHaT+E
        lWLcsa2+P6rRRzZgr6jFcqBxGSPAAMGslg==
X-Google-Smtp-Source: ABdhPJyfbuLEgUYuR6xP/p850xHpfjmndLZGfJ4tFs3D1bo0E+3a3MvzNEdWOVrbS8ieKtkirqwIbA==
X-Received: by 2002:a62:80d4:0:b029:155:3225:6fc9 with SMTP id j203-20020a6280d40000b029015532256fc9mr4407209pfd.41.1603297698876;
        Wed, 21 Oct 2020 09:28:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n15sm3155808pgt.75.2020.10.21.09.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 09:28:18 -0700 (PDT)
Message-ID: <5f9061a2.1c69fb81.b81ac.7622@mx.google.com>
Date:   Wed, 21 Oct 2020 09:28:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.240-5-g7222bd699321
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 93 runs,
 1 regressions (v4.4.240-5-g7222bd699321)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 93 runs, 1 regressions (v4.4.240-5-g7222bd699=
321)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.240-5-g7222bd699321/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.240-5-g7222bd699321
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7222bd699321cab18445d6ed7cfcc01dcbd9b958 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f902e6f2e10c42d084ff3ef

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-5=
-g7222bd699321/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-5=
-g7222bd699321/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f902e6f2e10c42=
d084ff3f6
      new failure (last pass: v4.4.240-5-gbfa505ccb587)
      2 lines

    2020-10-21 12:49:47.520000  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
254 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
      =20
