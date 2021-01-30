Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A9130980D
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 20:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhA3TgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 14:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhA3TgG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jan 2021 14:36:06 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070F9C061573
        for <stable@vger.kernel.org>; Sat, 30 Jan 2021 11:35:25 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id q131so8793510pfq.10
        for <stable@vger.kernel.org>; Sat, 30 Jan 2021 11:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4He27AJct3PoBMj6ALPPh5YKXmzAH5tt3pEyqR5JYLs=;
        b=NbrrPQVVTEuov9Q57FTnmdcQI1hgWTWW+yj3PFtvOQcRm6TtN/qyZ/YQyTlsJeE3jf
         sJH67Dcgfu0CU2Anjc20+TyxWxwEQH0kQMLfnDD4VDVYPi31or99yZ2B9F6jKc+Hqzhm
         ulg/y7HAaO70Rg772vkN200yUwHdbRuSXm0PSQzY24U7wgqNfgKHbu/s3TLgLILdBS9D
         ChthJpQDe8jRdbpOh+JHTW9AIBmMBV6mN0sUWM1posmWHxjI3G3OzCht+QGAxlZC6ZvD
         fQsblTldAdEtk8GJ3yCCQ44gzlcjgQzUTfNwNamqCjaAqoYvPO66TbJt0Lsji1Tbui+J
         lj/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4He27AJct3PoBMj6ALPPh5YKXmzAH5tt3pEyqR5JYLs=;
        b=UKQtzo+C0ZOzmVGTcTGepMSPc3goiNotKZ57azQaibrMhw84p/TeJC+VK8S7lKt28T
         KFMS0WR2DX87G3yD272U0mtwkQy3KqkqJNXDr8tm8iJTNw+Rvpu1QLMa9umkaZJQm1ir
         WlSCHKYmicXSZpkyk7SC10dfQAdVP9wMppvKY+2m/1HT+zLbeLmb5KT3jWeL2ba5lljY
         RE3uU8+5GZjVc1PobGUsHwm8tCpKsI8c0SPKkNDjd8sMZthDJoKwvHh4q8dJT2HzhL/R
         9nMfhG0fuNi4HOE3+SfW0TZR+zYgrjaLWY+qgm2oTqZBLyBJkg4siGCB4peFsJFhQ71G
         G4ag==
X-Gm-Message-State: AOAM530kCYr8HDBEb0v4mNo8wSsXl81tJUVSmGLUYwP+qPPUKcDxrWZf
        Hapv1aT9PHDMSFcksBbQ99p6+6ChHVR3sQ==
X-Google-Smtp-Source: ABdhPJyQIqaqr3fHfT2jipposda2Smmr2qv6hMT9ZN20OjlLq0q3lQtF/BM079ht02rIRBVpIp6GQA==
X-Received: by 2002:aa7:957b:0:b029:1c3:196d:aa81 with SMTP id x27-20020aa7957b0000b02901c3196daa81mr9458824pfq.44.1612035324937;
        Sat, 30 Jan 2021 11:35:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q141sm12538034pfc.24.2021.01.30.11.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jan 2021 11:35:24 -0800 (PST)
Message-ID: <6015b4fc.1c69fb81.fb8d7.e832@mx.google.com>
Date:   Sat, 30 Jan 2021 11:35:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.12
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 170 runs, 1 regressions (v5.10.12)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 170 runs, 1 regressions (v5.10.12)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.12/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.12
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      05f6d2aa7e2f2cdd137ee600785704139e6dd3b7 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6015856a5c2357b074d3dfc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.12/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.12/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6015856a5c2357b074d3d=
fca
        new failure (last pass: v5.10.11) =

 =20
