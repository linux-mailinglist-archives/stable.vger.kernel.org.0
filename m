Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213F532B0B6
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345104AbhCCAya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:54:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236455AbhCCAKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 19:10:08 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521A1C06178B
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 16:09:21 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id i10so5781101pfk.4
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 16:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uVJwdUXQcQwcm3HTa/4eaGKjRG6flNRjjfKUbGPD+s4=;
        b=XNpNV4J8tel/XDLL3tIWAeJA1Sb9cCzl+NqWn/XXlD+fKmqPajWEawLbA7PUt+KGR+
         ZiTzwaDxLHR4cBXLnX86KpNqNARiu2agVXoLpQtEMPd/Ka/FAGBT56VBSFeZzvNG0zVi
         9YmGaFPFczcSfwF+wJse94Or5DdA7n78dHjwJCBv0mU7zLBU6OtxNol96toKVAciEpsK
         F+jV4yidRv+o3THYIbOVoQhtpfU6k9AbjU2NmKXfaQ/N4qmDmYwX4AaHyoGC91ni6j/p
         mB6YObfYssw/Oj/UjMwzMPLKdgC73J8xUVXMooN96I0zDLqD/xlyblMkJkxyZNInwvUK
         7xHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uVJwdUXQcQwcm3HTa/4eaGKjRG6flNRjjfKUbGPD+s4=;
        b=SN3gM4MUtWMxOXzKnfqbRtQ1T2CujL9dOgOVecYscAMBh3tBACDgP2QNpMFglfXSkz
         id05TEN7nSetI++kK0YxDy+WHzsv4Mk6Mxta4UQ5xkX/liiqyuM3kejeP/uyZww7JY6E
         WJ/CHPFDjhz4LDrAAagrnJelA9RxWvMmXlcFbWuS0VONxUWCh/73mwwIzIDXxic5HbgQ
         8QV0EJHHqwidGr9oaEt9o5cZu8/759DcXce54sfpwkGRHwYUppQCOiwiXDr6MmQcxAXT
         4yqxpv27EVqhaFLUFbuAL+mFzjew6U9L3/c7Xzn9k+OxtjtUNyjZCSGlfmX5UgJD5hRY
         nYYA==
X-Gm-Message-State: AOAM530FZ1FvYFtJUjynSj+AYJEgB/dCjuJLZUbzx+jydmaerXcue5Hf
        oIx+o5ufjDOQ4Hf14jlv1W0ZA7xR9LopZQ==
X-Google-Smtp-Source: ABdhPJxeyDvhrgkwWbfU3DoppbKGet/4I5glx+WCOZmf+KXAYNcRrDA/nyrNuBPyz6KTTWjHXG9YEQ==
X-Received: by 2002:a63:fd0a:: with SMTP id d10mr19828090pgh.405.1614730160688;
        Tue, 02 Mar 2021 16:09:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r13sm23374169pfg.37.2021.03.02.16.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 16:09:20 -0800 (PST)
Message-ID: <603ed3b0.1c69fb81.6b7c9.5b42@mx.google.com>
Date:   Tue, 02 Mar 2021 16:09:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.19-657-g84fa1f13a46b7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 104 runs,
 1 regressions (v5.10.19-657-g84fa1f13a46b7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 104 runs, 1 regressions (v5.10.19-657-g84fa1=
f13a46b7)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.19-657-g84fa1f13a46b7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.19-657-g84fa1f13a46b7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      84fa1f13a46b7d394d799497d32f25af206d535f =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603ea154aca7e96b9daddcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
657-g84fa1f13a46b7/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
657-g84fa1f13a46b7/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603ea154aca7e96b9dadd=
cc7
        new failure (last pass: v5.10.19-658-g156997432be5) =

 =20
