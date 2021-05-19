Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53EC388672
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 07:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhESFUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 01:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhESFUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 01:20:21 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725A3C06175F
        for <stable@vger.kernel.org>; Tue, 18 May 2021 22:19:01 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id 22so8700637pfv.11
        for <stable@vger.kernel.org>; Tue, 18 May 2021 22:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aewOccm58pxtH61HRnnSs1Meod/3frr6a3w4fIgA0Zk=;
        b=SXjbFZsasXM3oORjhNJusYedCU7nOaczJqwCEL1gF/+hTRwpIaONvvFx9g0Ro11tJE
         foNPYHGY27rywhwHisZkax1Xjj1fqpIx1q7GMWVigIXIRYXkuCU0SBFexPu0YgXelPBK
         IYlOFDOF/LeLnLTHfAO4QFVVj+PNwULS6TUk1dwWyBnoa7QEWHNV6I36YlKYqx1u/yQR
         H7594EUnwKzdnnx2zr8KlbVRL2DGS82UpyINGB4kjQxSQlhE3enP7g/mMDF4p0G6EqaK
         wNlOnhySq26fnJlsu3mBneh5a+HHAq11H81WU5lFbu8MhwWXaKZ++Yft+3cm2Sjcm+yn
         DwRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aewOccm58pxtH61HRnnSs1Meod/3frr6a3w4fIgA0Zk=;
        b=eHgkHigItVA+2jkwDALcKmKuCupcuw1NefNM1ifo2PFkb/qVDK9+85g7BrX84vq4Dn
         MxgqPSFOy0PKGSPirKVWB7k/Mw4l/ginr+b6ERkposuYEZdcnmzu5hWetNpP1O9VpDYT
         uhbOXkY2eN440d87uarvqd3LHPWJdZQ4fqva0izjynqjVzMg3E66NlqDyQCg3K+6xnNn
         DRqpbi3gu7lizKNl5O9ifTAjk49UkuPcOuPY0Fhz4djCCCUUUugk+9dx7aOSjkMP25kN
         WkD0jKkQ3YBtyUAGCJWsxfbDuClWk/8MRZ1cH7Nj5fNj8tnGvxJvE8WnAjf7tCDUDzLj
         FBrA==
X-Gm-Message-State: AOAM531b3TeAfdOyQpgb7A5uDpjXYPnzEHzpeYTxMTy0wuRhRsGHajRb
        Nok+ZDxWJjhjNn9WGEuVNwJOZqNqSb4NT61r
X-Google-Smtp-Source: ABdhPJzr48TZHYWb9dzs8ElWyRYAw0KWYYn9Un8/kU7vhP7oVwa2UJJkYRuVrEjteQu7gGp7MT6DBg==
X-Received: by 2002:aa7:8715:0:b029:2df:8e06:5d96 with SMTP id b21-20020aa787150000b02902df8e065d96mr2097358pfo.25.1621401540663;
        Tue, 18 May 2021 22:19:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c13sm12517301pfl.212.2021.05.18.22.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 22:19:00 -0700 (PDT)
Message-ID: <60a49fc4.1c69fb81.1be7a.bf13@mx.google.com>
Date:   Tue, 18 May 2021 22:19:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.119-141-g3b18c174ac3f
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 165 runs,
 1 regressions (v5.4.119-141-g3b18c174ac3f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 165 runs, 1 regressions (v5.4.119-141-g3b18c1=
74ac3f)

Regressions Summary
-------------------

platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.119-141-g3b18c174ac3f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.119-141-g3b18c174ac3f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3b18c174ac3f96802d717435fc5c8e325d709975 =



Test Regressions
---------------- =



platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/60a46e8a0db1a38cf1b3afac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.119-1=
41-g3b18c174ac3f/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg=
2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.119-1=
41-g3b18c174ac3f/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg=
2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a46e8a0db1a38cf1b3a=
fad
        failing since 1 day (last pass: v5.4.119-141-ge4eb292ea326, first f=
ail: v5.4.119-141-g7da8d4b28831) =

 =20
