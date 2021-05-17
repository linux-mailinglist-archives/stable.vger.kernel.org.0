Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2ED386DFA
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 01:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344623AbhEQX6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 19:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239670AbhEQX6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 19:58:52 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10ACAC06175F
        for <stable@vger.kernel.org>; Mon, 17 May 2021 16:57:33 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id gm21so4530407pjb.5
        for <stable@vger.kernel.org>; Mon, 17 May 2021 16:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+nExnigf1aYaUZofHTx86kXbE/2yN0/nIe+aCkamIME=;
        b=BlUIOgXB2NqxLZ36clU+dzQcub/70gOn3F0yrotj/Aut7ZFLvzwUzuykQjVFT+p4Fg
         LDNwqdHEZziWBM+9cWbImfkRxAC/Ki+ogriFjAKV+DiRiKwoxOao6HCNCRdOmKyJfHQ1
         V/fAfVhVZF00fi89ULyoshSD6KOEpHLi4iIpD048mWVmMZJMdxBPtmoWHdtAo6ntA3b1
         n8K4BELWcusk4uNSTWfKZ6kKkAKymyvmHu3iOo0OdQbbj8xjHGnBXku77QUTXkHWx+V1
         p9uGllG0CYkMTH2OtB5SjVtvDCa/BKOXc3sIWNu4le3jHk5yvDBCoZCCNbL9GOOQdkeV
         OR6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+nExnigf1aYaUZofHTx86kXbE/2yN0/nIe+aCkamIME=;
        b=msJgoMv93Y6hgcXtfyypzvwgUi3EUxTV7cb4Uge2NjArKQulpDSSJB0hZ5p3HcRQiw
         I4v42SpxlAkUvQ2oe9we1Nao93rgCmgta4wRoCsqkSUqwG1L02jTUNoCdjzzehDh/VOn
         OQgfL0YsYdqV8AMK3eXPij3oCoqWeykAkaleDDiJH+KA4TphPMNtPkE7q+YmHNOLT9ej
         l1jEWE0yysZt8WLqKQVvYjk1IHML/fJxYucVoDB3OoTTnDg6f8PDgmIvdmw3io1Ognp3
         xUq9RSvYplYYqhWbvFTAJ4EbRJMtpWNkG9kXoYDkrAUU9hfht+BxcW3CdH/A3/wDl8aI
         WOzg==
X-Gm-Message-State: AOAM533C0mdT8ZaPjPRdikTZw4RDG1zS6esBFyrhdXzIi6ZWwUUk0FSS
        lVFE847NzNWLTVYT/p3uJwjezrirAMjCd0dE
X-Google-Smtp-Source: ABdhPJw9RGXPNVk+3IcKqMppJA1ORSY5wCa5C06ErOAJD5eajLtJrWNnLCJZPhmZbgi8Gtf2zVatrw==
X-Received: by 2002:a17:903:3106:b029:e9:15e8:250e with SMTP id w6-20020a1709033106b02900e915e8250emr1178282plc.33.1621295852461;
        Mon, 17 May 2021 16:57:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q3sm323426pff.142.2021.05.17.16.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 16:57:32 -0700 (PDT)
Message-ID: <60a302ec.1c69fb81.77a4b.1c31@mx.google.com>
Date:   Mon, 17 May 2021 16:57:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.119-141-g7da8d4b28831
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 129 runs,
 1 regressions (v5.4.119-141-g7da8d4b28831)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 129 runs, 1 regressions (v5.4.119-141-g7da8d4=
b28831)

Regressions Summary
-------------------

platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.119-141-g7da8d4b28831/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.119-141-g7da8d4b28831
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7da8d4b28831c396e3dbcc00cdd4b34974e05028 =



Test Regressions
---------------- =



platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/60a2d23ead5a6f2dffb3afd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.119-1=
41-g7da8d4b28831/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg=
2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.119-1=
41-g7da8d4b28831/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg=
2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2d23ead5a6f2dffb3a=
fd1
        new failure (last pass: v5.4.119-141-ge4eb292ea326) =

 =20
