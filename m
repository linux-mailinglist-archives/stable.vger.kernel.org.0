Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE40043BDB0
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 01:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240219AbhJZXS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 19:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240216AbhJZXSZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 19:18:25 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78411C061570
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 16:16:01 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id m26so924304pff.3
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 16:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kkrvIjNzohCrJ7uboWF2hCicyi5h/vtE+q4iPecryAA=;
        b=gA1Q8zB07xISWx7fQgz/ihuOWafuxSAe+8pn7vhaWd5x1yRzCheZ5q1ZJfFlRnev3q
         rlMKvru7kDIzOyGSICqnBf/Xw9h4uAplj5Aa6SP+X6U6+Fa8uVwekKsYIn8JozaPbF/s
         Yv+cO7aHqmBzpTme3HixrV4SOj/cvqc2IhWCGnLwr6wBr7ZBPlAu8EDTJfGC6QJUwMri
         HRlTg7oI6r0+pgyMmLadhAfC+5YlX6snqv1TQPyvqmtq/VtHhkG887kEp4YdtXPlUhy8
         4ByHRCBhz3vZ8Krkd+l6Frr6FgTsSJy9ZPo4s624SHwwWgGud+2A7h1rJ9PemZs3REV9
         2kJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kkrvIjNzohCrJ7uboWF2hCicyi5h/vtE+q4iPecryAA=;
        b=V7Bl6sfGSGS/+v2FNQWdcvauLiBgbJoNEvASJqrTunOfwPV7sE2O+cOKheT11wLB8Y
         j+39RPn5d8qmRA+O++G9vFzxadCHjrmbd3Hu+JuzbCBKk+wgoPIbjU2GcSmOw9rC0aPI
         H1n4OqVtpwPB4+3Tf7rixj+fzKONxZBimCTRFW1aErMwzY3FKPVNY0lO+2zVgrFss3e/
         2A4ql2zSzSVWCoMeiBAs/AdSrIiUHQ8G2qkCNdOlBnaPMHII0P8MrB1kx7Gni7ShqKzk
         tOSGcqdfz13FhptkmP5Osov0H+L5PVxE6qEQ+m9gr3nbzq2E5Z1MTlkWnAENUtbSy7tk
         RlXA==
X-Gm-Message-State: AOAM531xt42SO+2csTLzdW/Mje94j4RybWQ/+JGpHj1b6tNJOezB757W
        19dzd01puvE2OMcT8Jsn5bdhQvlsEtTt87yq
X-Google-Smtp-Source: ABdhPJzD35Eg4yWGKkQYIY0DEVIUTGmuPKRa6Ki4Uv/mGEKrkIMMcIfD8Q+y4Zey3P4AMvmO/yLMmw==
X-Received: by 2002:a63:8f5a:: with SMTP id r26mr14677591pgn.50.1635290160873;
        Tue, 26 Oct 2021 16:16:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y19sm5124851pfn.23.2021.10.26.16.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 16:16:00 -0700 (PDT)
Message-ID: <61788c30.1c69fb81.d5bc5.e2e1@mx.google.com>
Date:   Tue, 26 Oct 2021 16:16:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.155-57-g682a02fc84db
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 131 runs,
 1 regressions (v5.4.155-57-g682a02fc84db)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 131 runs, 1 regressions (v5.4.155-57-g682a02f=
c84db)

Regressions Summary
-------------------

platform  | arch  | lab           | compiler | defconfig | regressions
----------+-------+---------------+----------+-----------+------------
hip07-d05 | arm64 | lab-collabora | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.155-57-g682a02fc84db/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.155-57-g682a02fc84db
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      682a02fc84db08216631e08c934c73c00a78bba2 =



Test Regressions
---------------- =



platform  | arch  | lab           | compiler | defconfig | regressions
----------+-------+---------------+----------+-----------+------------
hip07-d05 | arm64 | lab-collabora | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6178670bb50a0b85f533590f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.155-5=
7-g682a02fc84db/arm64/defconfig/gcc-10/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.155-5=
7-g682a02fc84db/arm64/defconfig/gcc-10/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6178670bb50a0b85f5335=
910
        new failure (last pass: v5.4.155-56-g13177975f7b1) =

 =20
