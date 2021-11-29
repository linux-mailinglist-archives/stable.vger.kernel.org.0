Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53067462789
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236098AbhK2XHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:07:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237463AbhK2XG2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:06:28 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E91C0FE6DB
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 13:53:37 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 200so17541285pga.1
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 13:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6QTRv4HV+z7+ovMR6VY5O/FTtlrB3hzff2MN8I4j7vg=;
        b=BxkGyxiq3asayRn2PF3QGJTcpnbJ8RI2PJ40m1Fv1ejUfbZhiB0JJMeZ94FBa54QGr
         1BUHo/cFlKMuAQj3HK96uf0Jmf6iNWnFzMcjlB/CPC9hcChHiXZig1HfldqKj2aRVTxS
         yGZI1THqeJ6sB3DGxT1DtSnsIPLIFpr3okvNrntH/N9lqi6qiZQ06BXiijw+xwuUbg1j
         NXW+/ijB2HY+eHIH5u9XAbGf8JTS0Y49OiWxw+ckxqczn+ApCQBs7RDwHtWYlOMCmOMj
         97RZlTOv/4hj6Wbw3dhnP+65wDQdUuCenaTawSps3CbrK/WrBlI2NH3cZYXbUsZf1STQ
         1XNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6QTRv4HV+z7+ovMR6VY5O/FTtlrB3hzff2MN8I4j7vg=;
        b=qmz1DBFMyttHjXw5AznhoSls+k36iy4An3yzGB2fv0j4jSvntv+ihhLqZPqzS90WfN
         qWhkRJ6yfUyURJzzMvqP1AJbyL6uJqBrtsyq9I81Y2bHOWeisK3nQJsfnkCxhBibn5IB
         q2t4lYT9d3pJW5QfysVgFzMRLanm1lW9JEtMpzJmcJVQFgW1thbYv38hwZGiwLCZMgot
         BUB2mHzoy6PbFWIKK/rFy2+vhAp6RWfuO7oqPqyNLueWqOnrNKeIZfxTs/qZfG6M3W9A
         1XgY73ZzfBcpTc2AWAiupyK7SfmqPQpL6F+B8i1OSVJxFwnR4wuVDMNx/mNNAVWlzoTr
         RzlQ==
X-Gm-Message-State: AOAM531mLJf/904nwrXWzuZYVK1XCmQWqF1iB0yU/7vXg5anlWYRKG4C
        0Qo0MEPWF5ildQP7GZ/UIfJWI6Yqa8A/1A56
X-Google-Smtp-Source: ABdhPJwisxkZLNuI7yQQmXiPe6cX4ShWZ/VpNso3zHrKsIjMTQdh3WhFuH9QtDVS+Z3vOtdg5M2YjA==
X-Received: by 2002:a63:6849:: with SMTP id d70mr36935800pgc.269.1638222816477;
        Mon, 29 Nov 2021 13:53:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h194sm17993280pfe.156.2021.11.29.13.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 13:53:36 -0800 (PST)
Message-ID: <61a54be0.1c69fb81.5baa4.18ae@mx.google.com>
Date:   Mon, 29 Nov 2021 13:53:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.82-120-gbe161646c6c05
Subject: stable-rc/queue/5.10 baseline: 148 runs,
 1 regressions (v5.10.82-120-gbe161646c6c05)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 148 runs, 1 regressions (v5.10.82-120-gbe161=
646c6c05)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.82-120-gbe161646c6c05/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.82-120-gbe161646c6c05
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      be161646c6c05c8a405b449d8e4dac850c291e1c =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61a51347173b21e70b18f7a8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.82-=
120-gbe161646c6c05/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-mi=
nnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.82-=
120-gbe161646c6c05/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-mi=
nnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a51347173b21e70b18f=
7a9
        new failure (last pass: v5.10.82-40-g42dc63546c6b0) =

 =20
