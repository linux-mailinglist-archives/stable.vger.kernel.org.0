Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA49B4336D7
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 15:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235853AbhJSNVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 09:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbhJSNVU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 09:21:20 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C6DC06161C
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 06:19:08 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id pf6-20020a17090b1d8600b0019fa884ab85so2048187pjb.5
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 06:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=67J9yxeazi/cIBwJQhvoDaz8NHBKUVnLVpC3Kc15Nb8=;
        b=OKUtKxaXUFi+kyCO2ZR0U2qIembx3uxWgkJUgL/TztVL49EbqAo0/QP/HrU6WtIzla
         HDIvp0QWCXklGbYAJ3LXcNk8o6uGJrWnyAGyndiW7YYE0rOe8GoCKqLqHVeblzFvZ1ik
         51rSAHtE44OLDo7gwNYIamaEHwnjNggdGa+JOko5rXmTjEmsGE9EJP+nIHoMst77zOT4
         C5RLKwdBcITTw0yRABMt5Ye5yMECWmiOxS5SEicR5WIrxhs7DgNZYptHHSPGyWs0zOgt
         J2b39fLUtUhBHTCQMUI9hcblroLiDkk6NV4MG6UHwaePxeffKHLGpIziHNoc6yx40Hep
         2gBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=67J9yxeazi/cIBwJQhvoDaz8NHBKUVnLVpC3Kc15Nb8=;
        b=G5g44Nu02DsH695UGMMi0P85zfbAGLfbyUJfBPz9f4LArsBrfvCsRdP3Hsqd5U/mA/
         9mqqyAB1ClUYx55sdiRh5Wcl4X/mkD6w4n5xS3oDPI+O24bTt3rLn6K1EfyXCBYDVLtu
         lVzoxnZf5tPBjrCxr5TRLgNsfxPS8tQjaSefO3HaIkoxOO+7KLsEMtuPbzzF+f3tCJND
         eh7TR74R1yxRAfwnOcQEi8KhHUE0OIkcLcfyK8nyfUCb079Cd3xzXyljPiftVHPRd9LA
         /OfM/uNTT6v1hbCyZVGnA/+/lt8jwWXoiZdGxNz4BBFtNOA/GFyvZ1s9ZjG9PJ9JHm2U
         V4pA==
X-Gm-Message-State: AOAM532Y0rC9Wm9XIM66QbFBBCUU5XTpP3M+QybhblgAPjeK0Rhlo39y
        wUtxHgoYb+cQgUjI2PYd9SK1ieFWya9loqQ6
X-Google-Smtp-Source: ABdhPJzbIHxY91WlwsjTsTNJ+OWEAST0Y4JUqMMpkq5/dB/9HQp2GX0SsvzY1RkC9Wjce72vktB+7A==
X-Received: by 2002:a17:90b:3687:: with SMTP id mj7mr6693031pjb.196.1634649547762;
        Tue, 19 Oct 2021 06:19:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e12sm16009532pfl.67.2021.10.19.06.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 06:19:07 -0700 (PDT)
Message-ID: <616ec5cb.1c69fb81.ef4cd.cb96@mx.google.com>
Date:   Tue, 19 Oct 2021 06:19:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.286-51-gd156b23118b6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 117 runs,
 1 regressions (v4.9.286-51-gd156b23118b6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 117 runs, 1 regressions (v4.9.286-51-gd156b23=
118b6)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig        | r=
egressions
-----------------+--------+---------------+----------+------------------+--=
----------
qemu_x86_64-uefi | x86_64 | lab-collabora | gcc-10   | x86_64_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.286-51-gd156b23118b6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.286-51-gd156b23118b6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d156b23118b641b679e3e252f508326fd587883d =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig        | r=
egressions
-----------------+--------+---------------+----------+------------------+--=
----------
qemu_x86_64-uefi | x86_64 | lab-collabora | gcc-10   | x86_64_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/616eb84e86fb81d0743358f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-5=
1-gd156b23118b6/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-5=
1-gd156b23118b6/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616eb84e86fb81d074335=
8f7
        new failure (last pass: v4.9.286-51-gfb7706df2334) =

 =20
