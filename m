Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9912ADD56
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 18:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgKJRs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 12:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgKJRs4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 12:48:56 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4D5C0613CF
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 09:48:56 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d3so394115plo.4
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 09:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vhGLRoMZ4JBdM0Nc2FZD3n1cPPOFzxgaU6pM5Recb0c=;
        b=YUJe3KqIVXqkjFlzUo7X3LJqSm/UFnXEG6THPEpCMt3FysPJx4R77T+jyachUdAsek
         maTELv58ex16cedbsRVqkBIXBIwvbCBkJ7rDDuMXor/ktbnyhzrOoLMgwjrKnl5KiU5G
         h9MjiCwFYS56+tBYKlCVcJRuv/Ln4WGfhWpeVqDVzo5tBr5/3FwPTUVgt8DgmZu8RaVY
         qUktnLnkil5439ng7zzyroQ+kazSzbZIACx7+iuXfXLsgr4VwbPOBYTpG3lIwq8O4RjU
         pfK31/QkwrM3B6ykEMTxA9QlhQowO8WkcNdc2TN0fJSb8yqAAqWO5m5IJ2uqtp55GXi9
         GuWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vhGLRoMZ4JBdM0Nc2FZD3n1cPPOFzxgaU6pM5Recb0c=;
        b=mDYh4aML4l72FOThw8ctBMpmynSDVJsChZJVE87iJfMdWLM0KffX0sEWEUEE+y+w5b
         ih7CqV3ktEHsfSrc3sQQx64DhtZuqCvBvnfgS4DYsmQOBGGkeay66h7LMKLzav5oSIhU
         gz5ut0ZxWTsA+N5gvuQFQx1alTGXT4IdqwExEEwgSQpInGIB4KGqvbvVE9DtIhGumT3V
         B4QeMXFiaQLmUd9aSuwlUCUH8k7VJFOqFj+TpnWOf8HqysRZiriJ144iorCfnt67lzUl
         IMMmdFpXMvMIiafGSixX/pWDyMMV0cYANgDIbWNwjF1AIgax/Ealw2OUxKaY7AOsf0UZ
         bYfA==
X-Gm-Message-State: AOAM532g9QjFk8Sce2zl75J2Lo0RhUfNaltcwfWPX/IDAUmzFu7wutdv
        CLS0Cf6BlGJ83n1C6q/5bTTTEQyIN+gnMg==
X-Google-Smtp-Source: ABdhPJyEo5RVkWhCdn+TQ2jOfQLWbeynFo9UwKGpFozMkau+O49rQpHe4Pf/fJXfZdAux3MkSZreYA==
X-Received: by 2002:a17:902:b283:b029:d6:b2a7:3913 with SMTP id u3-20020a170902b283b02900d6b2a73913mr17993696plr.54.1605030535340;
        Tue, 10 Nov 2020 09:48:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g85sm14944957pfb.4.2020.11.10.09.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 09:48:54 -0800 (PST)
Message-ID: <5faad286.1c69fb81.a1ef4.0e29@mx.google.com>
Date:   Tue, 10 Nov 2020 09:48:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.76
Subject: stable/linux-5.4.y baseline: 208 runs, 1 regressions (v5.4.76)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 208 runs, 1 regressions (v5.4.76)

Regressions Summary
-------------------

platform             | arch | lab        | compiler | defconfig          | =
regressions
---------------------+------+------------+----------+--------------------+-=
-----------
sun8i-h3-orangepi-pc | arm  | lab-clabbe | gcc-8    | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.76/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.76
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      ec9c6b417e271ee76d1430d2b197794858238d3b =



Test Regressions
---------------- =



platform             | arch | lab        | compiler | defconfig          | =
regressions
---------------------+------+------------+----------+--------------------+-=
-----------
sun8i-h3-orangepi-pc | arm  | lab-clabbe | gcc-8    | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5faa9fd27484d49a88db8887

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.76/arm=
/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.76/arm=
/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faa9fd27484d49a88db8=
888
        new failure (last pass: v5.4.75) =

 =20
