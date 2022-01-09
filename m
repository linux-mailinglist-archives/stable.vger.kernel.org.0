Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8228488C0C
	for <lists+stable@lfdr.de>; Sun,  9 Jan 2022 20:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbiAITeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jan 2022 14:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234640AbiAITeE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jan 2022 14:34:04 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879F0C06173F
        for <stable@vger.kernel.org>; Sun,  9 Jan 2022 11:34:03 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id s1so9407316pga.5
        for <stable@vger.kernel.org>; Sun, 09 Jan 2022 11:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+spl5iBekb/SNiZ7bqPFapKpYFF6KnuWZ+tgnoc7BrM=;
        b=r1oO+E4UJqKe5scd9bHodQXAWetFIwg+oQ/CGEPcM4C7yspJdW3E2R+nrFC+zQrtO7
         jV6yZ9EJdVi2SbmnRCTVALJJSRzBjmoTwu+y1yu7URNMtPcZQBRnp3AZhXZINi7qmuC/
         l11pFFEG7VLIEZ177Lp64k91UH8+2gcv3XYbXLvR8B0vUsAUndZAeKn1NPJn6QAdooCP
         nYM0Fk2qbksLiIT1VShYxo61UF3ADKC9DrfP/wXXGspNonsdBUA1xmrk6Qmhu+XY1G9C
         K7Bml74chHbvNGByz9P6YT2EGJjy4+ep3hIzZBMJHs2/z2p7SXutDD0BhJdxroBg2VWu
         xS5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+spl5iBekb/SNiZ7bqPFapKpYFF6KnuWZ+tgnoc7BrM=;
        b=Nyka1WaAMRE1nksw9UqSPA3DXtlTogmBZ3+CMPSCTH339ZmU11aJAMaAvk8pOSGYlv
         867EUSw7fAoXpxth+N/PnInoZ2PP85FM5+SPexMoUQwRkJvK/bku/faAgcaM6FGClkVM
         vWYDGAzdWSvQxTzg4Z4xLGWn+lLROQwWbRPVfB0pmPhKND0IT+QSWGKKDW3AJwYKgnQI
         JptQhJmx3qGbI6k5w2KNEsXMp4XVVWLet+fFA93xL/qFDckHRR7bSxT6KaA4MQAA/nWD
         DsMogVDU+BhKFKpri4CZubuJL73EA530hoXHtqqPV2JLr0I6YYYilDa1lGSKAgi6xmJg
         InGQ==
X-Gm-Message-State: AOAM530HJoMcYVThEVDqj3I4m2YBPWx3NI3BjPRbMQkymsEZg5OisWV8
        JOi6afZ4YoMMRQWY3lWNOoi0WK7LofPPLhKW
X-Google-Smtp-Source: ABdhPJyUeZPizpxk6WvgwDsdS5MmqIYwiNvCREuIOShfIuYaHxXARO8hq92R8S9AqVXLJZfmYl6OVg==
X-Received: by 2002:a05:6a00:1a52:b0:4bb:3ab:88a6 with SMTP id h18-20020a056a001a5200b004bb03ab88a6mr73240731pfv.29.1641756842830;
        Sun, 09 Jan 2022 11:34:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p12sm4652629pfo.95.2022.01.09.11.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 11:34:02 -0800 (PST)
Message-ID: <61db38aa.1c69fb81.1eab5.b066@mx.google.com>
Date:   Sun, 09 Jan 2022 11:34:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.296-16-ga93775aa394c
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 131 runs,
 1 regressions (v4.9.296-16-ga93775aa394c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 131 runs, 1 regressions (v4.9.296-16-ga93775a=
a394c)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig          | regressio=
ns
---------+------+---------------+----------+--------------------+----------=
--
panda    | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.296-16-ga93775aa394c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.296-16-ga93775aa394c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a93775aa394c2062a82da3e3b6edcfca86895c02 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig          | regressio=
ns
---------+------+---------------+----------+--------------------+----------=
--
panda    | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/61db064e9bf32c779bef675b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.296-1=
6-ga93775aa394c/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.296-1=
6-ga93775aa394c/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61db064e9bf32c779bef6=
75c
        new failure (last pass: v4.9.296-8-g5df6427bc3d8) =

 =20
