Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A454135D097
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 20:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239578AbhDLSuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 14:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236804AbhDLSuF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 14:50:05 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF814C061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 11:49:47 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id em21-20020a17090b0155b029014e204a81e6so2386874pjb.1
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 11:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BrYIhNNmXXmHzceJdKi8SJbt0Fxf0rDLeAyNSmhLdh0=;
        b=wgPNgTsZnPBQbSIGVdOZUGQ2MGS730U+N+OrEOkTXOO/0RL5aOSLi/4OP8qI05FfSo
         +Koj20GCn8L4Wk8rfl0sRSJ6zlRRr2GgnksQuNU765Q8r7iQSfcU0YMBc8Ty7R1wHUV1
         3gCS11sMvqIoFyhflVdvqUndULd9HwP/WjvZEQmwwV0opGmFf2c3VD0VcWBkc7eQ9EiD
         x5DuXm7pjmhrhniwODClKCOYxdrnUi2HPlSFeLvaVA9SfnSFvKky1ThZOCuS/bY8p1Iw
         wBhm6id3wT8pka8UEtNJkiKKugSmXJHUqasIn/fFKhxFTzbs9v0PvFt9CYlXf8dER8Dp
         u7Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BrYIhNNmXXmHzceJdKi8SJbt0Fxf0rDLeAyNSmhLdh0=;
        b=oHtINNDjPYjlpQZgBkGdMiw4SFUb2nWwR0TkwNWA/VoUZSyYUTRHq4huYIlPI00lCn
         6IGmDkAFYdpyT1cSo2T1zdtnsj+Q9b7Sl92Z9BWXWGMcpH+x7BgwYZuG3QdC1PULSZzL
         1u9v4hg4DE3zmLiHOj8KIMJUK+JRCVAmBgnNOa+0LmWusTh89p5EBiSNNlr61RLO7jFF
         TcQgUtRursx4MpBcjj8iN0Bi1sJKJ2ipfCFnLjPlldvXREXiQP8o2i5UMrmYqE7w9HT6
         IDp9NU7YI5wEh6NTDl+X9rc3NmDcG15u4Nu70nxe7tl8EcK/dGn+qlM+Ep1nZkTyMIdj
         Tt2Q==
X-Gm-Message-State: AOAM5322RqlJeuhNYYf1cEvG3iazU7VlHpabG7uIW3Rp0lsct4rhTsET
        YwbMn8WFS/Wogq6vNTTdRLmK8iMxrqAhLm65
X-Google-Smtp-Source: ABdhPJyn2oW6jpir82EhgCafe+25/ze0DjymJBa2z32REZAKjrP6jStTYnk+RZldmShm1/3dXPKVlw==
X-Received: by 2002:a17:902:e313:b029:e9:263e:f5f9 with SMTP id q19-20020a170902e313b02900e9263ef5f9mr27653785plc.53.1618253387095;
        Mon, 12 Apr 2021 11:49:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x18sm10470678pfu.32.2021.04.12.11.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 11:49:46 -0700 (PDT)
Message-ID: <6074964a.1c69fb81.8a012.984b@mx.google.com>
Date:   Mon, 12 Apr 2021 11:49:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.29-187-g536959c7536e
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 127 runs,
 1 regressions (v5.10.29-187-g536959c7536e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 127 runs, 1 regressions (v5.10.29-187-g53695=
9c7536e)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.29-187-g536959c7536e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.29-187-g536959c7536e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      536959c7536ec8af340836466c6af23b7a85d8cf =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6074633e6218724451dac6cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.29-=
187-g536959c7536e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.29-=
187-g536959c7536e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6074633e6218724451dac=
6cc
        failing since 0 day (last pass: v5.10.29-90-g9311ebab1b30e, first f=
ail: v5.10.29-93-g05a9d4973d3b9) =

 =20
