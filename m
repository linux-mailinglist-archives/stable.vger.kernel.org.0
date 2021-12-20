Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E09A47B5DB
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 23:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbhLTWV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 17:21:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbhLTWV4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 17:21:56 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBDBC061574
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 14:21:56 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so581805pjj.2
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 14:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kSpcLAiTz4xWFQxZ7aH1owdVn23af6hCZKr8waf4OzM=;
        b=QHvq3UJFrvR+rHouRZGa+tVPG1uVduzlqstf8ynxIcHOtvbYLdVJNzJAk6byvhA7Lm
         EdDVp+YVhTMqSNg8zNFSeDPzFf47uCpSgbEee/KOXB4Aw6W1oDzBR5JCWoSy8y9Mmhud
         nUTLkgiY76nQcHixWR+3ra2fm3s1kFOjUey28sPDXDRkA4QQp7o0aAAN5a4i+vKAgMA9
         d5QFBs6LFIXvSCUp4zUyuh8BGpj+7R3vzGGnJaXEYeccPmptxzK/APa5HZMg7XSJLbJl
         xRVsfYbJeROqZDCTtXXs1JDurwMtkysLWEP6/iv/1D1t+HyKlpBDdEsyk9aHCCDnxhvI
         8Pbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kSpcLAiTz4xWFQxZ7aH1owdVn23af6hCZKr8waf4OzM=;
        b=t0mDLRFVKs/zXOZYvTdaaezkjuOS9wN8djLtkyQHY6hdr2PsATHo43oYh7IAkuCRTJ
         BDswHWWcEvb+xkoK5LCqksXR3aTQTuwXl4/cTwxmNANvmJRSE0CQ1SsFnliRl9oBnMfb
         Fs/Nd6QKrQI/QgfB1CH52nio+NMrPyxUbAutR211CtvgLJPY/48AQYgiYsQ8V/VUABCE
         DiIjmIZoYK4vVgRBYFLNuj+Jen7PK3zSIhAwLLD2Ubd0+zT8EHsRr3ww2nQ777RB/TLY
         C9SQEtreYxm7tW/oWXVKg3YGvvu5VF2bXOzmHSTCWx3/47X9DqeQChhNXN0w3t8MKKPf
         xLdQ==
X-Gm-Message-State: AOAM533WykQ6rDVSlgw/m8eCZr1O4txLBXcFKhtfA4MWUxKbbov/jFtc
        wQxo4DjH1erj5YS3JLiTqrZOUKdR5eDipBTo
X-Google-Smtp-Source: ABdhPJx/tBnZcBrpodpanEIJ8lLAE8bm8rVoEYgwOUNY9JpMzU4V+dhIC6QXAy7pI5HUUSr2jGQLWA==
X-Received: by 2002:a17:903:2404:b0:148:ca7f:931c with SMTP id e4-20020a170903240400b00148ca7f931cmr53968plo.34.1640038916212;
        Mon, 20 Dec 2021 14:21:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id rj8sm391395pjb.0.2021.12.20.14.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 14:21:56 -0800 (PST)
Message-ID: <61c10204.1c69fb81.97be5.1954@mx.google.com>
Date:   Mon, 20 Dec 2021 14:21:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.295-24-gf46f7fed4810
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 118 runs,
 1 regressions (v4.4.295-24-gf46f7fed4810)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 118 runs, 1 regressions (v4.4.295-24-gf46f7=
fed4810)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.295-24-gf46f7fed4810/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.295-24-gf46f7fed4810
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f46f7fed481068d1389efbf0122c45cb9f36480d =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c0cb80c7eba3f361397136

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.295=
-24-gf46f7fed4810/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.295=
-24-gf46f7fed4810/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c0cb80c7eba3f361397=
137
        new failure (last pass: v4.4.295) =

 =20
