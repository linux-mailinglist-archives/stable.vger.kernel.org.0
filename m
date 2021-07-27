Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26A03D7849
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 16:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237010AbhG0ONm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 10:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236760AbhG0ONl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 10:13:41 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8749DC061757
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 07:13:41 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso5029089pjo.1
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 07:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Lg1wnUfGajZKGGjwVzsdK4ORrb0QhNAGa2SSweD6f7I=;
        b=0WxFxG2Fid/T3uuxJRn/zh83nWalTQuQeaiCx+8Rmnh5TbfHwQ8KBOQxrhTcQTGdeN
         BWgrW5+vI4Ijky+IOMkf+M6WV0TBnN6JG/HDQFj+7jb62Hn3lBNABEa4+RQv7agQLpya
         2uI+2nDpbptysszWR08wn/ZzqYAwowX5Bz/tIRBv5sfPSb0tlC5hU+ttto8CCbRb5q4w
         /XQ7Tmi3BCCW/MzUZ0sPuXLqiH6N09UoAA0JzaZWuhG6FHhr8I7vLcSluvXrDxDh8Biq
         1mu4kLLwqXk+VbvZhDogdSLksR6SKFnmC5kawyUZXRbvwuVOHqvn9otkV5gvs2c58aVo
         D/iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Lg1wnUfGajZKGGjwVzsdK4ORrb0QhNAGa2SSweD6f7I=;
        b=VR0sl8dHjoxG2LZyvZ514CyS1UIn9vPeks4WThWObf1+IBlaguSvuRqQMSNm1t/3lb
         ZLlqdjgt/djrRl9aOJHfCS2MolDpL1a8D4OASQ6h7+fjsAkVEMlIZxIxcp43LCzTloe1
         zRDC+CcEzBZ4udf5YHioCubK9sxaww0REAoSus29W55i7B41X0ejKNOjcjsIrBaC4mYY
         Faj14RhToLrFkJGE30Z4T45BOdD0RFLUbQHpymnbmMYC9Bnb9+VpXgMLBY3kSr/csyIu
         EsiF07HqdftCSiwcN3fbIIDcUuMng9NtAKKIzHpbxKU0/bVBNcqOCZSPBAPyfQmgf7xD
         JQyQ==
X-Gm-Message-State: AOAM530wecTubH2h8QYPdJIv578E7GSFsyc52ftO3kiZzi1MdrgN/GH6
        xqLA+p6fTmO8U7/n9NlHD9lrMJG6w7pVtQh7
X-Google-Smtp-Source: ABdhPJz+VX8A5x9mJOdW0xBNfLA3eUkWeJXAqr+8YaPdzzHx7HfsetIp9OyDTVOJ+zicbjXvf/S0dg==
X-Received: by 2002:a63:770c:: with SMTP id s12mr23678416pgc.339.1627395220941;
        Tue, 27 Jul 2021 07:13:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p5sm3891603pfn.46.2021.07.27.07.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 07:13:40 -0700 (PDT)
Message-ID: <61001494.1c69fb81.5a0f0.bb7b@mx.google.com>
Date:   Tue, 27 Jul 2021 07:13:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.240-81-g502f0bb32687
Subject: stable-rc/queue/4.14 baseline: 159 runs,
 1 regressions (v4.14.240-81-g502f0bb32687)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 159 runs, 1 regressions (v4.14.240-81-g502f0=
bb32687)

Regressions Summary
-------------------

platform         | arch   | lab         | compiler | defconfig             =
       | regressions
-----------------+--------+-------------+----------+-----------------------=
-------+------------
qemu_x86_64-uefi | x86_64 | lab-broonie | gcc-8    | x86_64_defcon...6-chro=
mebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.240-81-g502f0bb32687/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.240-81-g502f0bb32687
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      502f0bb32687c84fa6e14fe62eae7cd581835659 =



Test Regressions
---------------- =



platform         | arch   | lab         | compiler | defconfig             =
       | regressions
-----------------+--------+-------------+----------+-----------------------=
-------+------------
qemu_x86_64-uefi | x86_64 | lab-broonie | gcc-8    | x86_64_defcon...6-chro=
mebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60ffe3765cf061382f5018fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.240=
-81-g502f0bb32687/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/=
baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.240=
-81-g502f0bb32687/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/=
baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ffe3765cf061382f501=
8ff
        new failure (last pass: v4.14.240-82-g416f0340c5b8) =

 =20
