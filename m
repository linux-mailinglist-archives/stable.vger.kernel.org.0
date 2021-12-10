Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8B1470A7A
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 20:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242231AbhLJTjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 14:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242286AbhLJTjc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 14:39:32 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D0BC061746
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 11:35:57 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id iq11so7531611pjb.3
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 11:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mnGLZxITXKtNKYjRejF0B4yBdM8VHn7KyD5EqDciz7Q=;
        b=7jE5msFnVbzOFcDBScj3XpTVtiMipWCC5CHKDlYOyCJKgdyPUpjiMB4j23CAOCB4vM
         qpWBiTIXVH6nfHvf7XqHYwG94KO3U97Pd6xdyLoHtBwoCagl9MnH6OygrDU5Sb+QAL/4
         bLfWX9C5oYqWvUpA6yb5/LRNuf7QUKLVmePZVoLcAwRb3JJnfYCuZLjAF4PtkwfnzQyR
         al5uuZ6vUJkRn3N7GCfqQzg5j1LY6w6DsJzpLyb12xWWuLMx5JWka1LlxLpOaY25xdbv
         I1EdqP8Dn+A7mIdXehFCodCFsgDzGbVCJQMxlLg4F7ebZgtpIEU95nw1YbYbd0f+tJHL
         0bxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mnGLZxITXKtNKYjRejF0B4yBdM8VHn7KyD5EqDciz7Q=;
        b=RVGag/m+wqcgyy0CqnSQ8CQr84g2pRMYfIS7Bx8J+3HWVqavSap+VX7fE0L9YsMktP
         05t/szUfCCneloK1h3uYZHiIad0UD8tSyLMWMlz8/H+LGT1P+Mz6twODSsbUgDgsrhYh
         J35UQavvKAwBuvd/r+1vD7J+lGs0Donm7tAv8VMbGiBA7euS+1sAILTRhUwj0Sgw+WzJ
         AVcTcJ+PbWuiJ047LcVIRsegwHT6/osBD+SVCbVXExUq+l6ZCKMcdjXOXCaL8l3L0M9/
         9xDcT7thzmms+hGv/411uuc+ddpWcdpDufiTFPOzvOsSV31swUKGs5Fnxqw71GvLnAFZ
         MY2A==
X-Gm-Message-State: AOAM531ndJ20FvrpUbQgvcDPq9eDL+PUglzfRCAESwK6KKj/gWMBJH8f
        FprrykIjQqxDRkIt+dCjPbkmOAWQvp9tv+KE
X-Google-Smtp-Source: ABdhPJwCQ9HABypwQw47XdnHXvxA9w8FPjD2Dh5GG/gT1OGpmaEdQl98LozFfuDw3uO6kGEK4CDUiA==
X-Received: by 2002:a17:90b:19c8:: with SMTP id nm8mr26216359pjb.163.1639164956687;
        Fri, 10 Dec 2021 11:35:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g21sm4254725pfc.95.2021.12.10.11.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 11:35:56 -0800 (PST)
Message-ID: <61b3ac1c.1c69fb81.12842.d04f@mx.google.com>
Date:   Fri, 10 Dec 2021 11:35:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.292-8-g267327cffca6
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 115 runs,
 1 regressions (v4.9.292-8-g267327cffca6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 115 runs, 1 regressions (v4.9.292-8-g267327cf=
fca6)

Regressions Summary
-------------------

platform    | arch   | lab         | compiler | defconfig        | regressi=
ons
------------+--------+-------------+----------+------------------+---------=
---
qemu_x86_64 | x86_64 | lab-broonie | gcc-10   | x86_64_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.292-8-g267327cffca6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.292-8-g267327cffca6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      267327cffca617b78804eb276b51cdde7d4d21c3 =



Test Regressions
---------------- =



platform    | arch   | lab         | compiler | defconfig        | regressi=
ons
------------+--------+-------------+----------+------------------+---------=
---
qemu_x86_64 | x86_64 | lab-broonie | gcc-10   | x86_64_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61b3750b616f616a5a397143

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.292-8=
-g267327cffca6/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86=
_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.292-8=
-g267327cffca6/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86=
_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b3750b616f616a5a397=
144
        new failure (last pass: v4.9.291-70-gd8115b0fbf8b) =

 =20
