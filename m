Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA85430DAD
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 03:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238649AbhJRBqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Oct 2021 21:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235368AbhJRBqm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Oct 2021 21:46:42 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389A1C06161C
        for <stable@vger.kernel.org>; Sun, 17 Oct 2021 18:44:32 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id g5so10152174plg.1
        for <stable@vger.kernel.org>; Sun, 17 Oct 2021 18:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xhpwkmFlHaxu2UZ4fbTNF2bWBxxnXVLEII/Mi/kB1tc=;
        b=k0G2HmV0fzYnxBT1XYWcnt7zJgKdIywP6Wv1yi/pLx44ofJhur5c5cVEgArOCwBwdC
         TssJPlu7aJSp10Ds/kHGpMQ//Z2W3CCz+lVARyVEGWdQkcXJ8AlPR2+IMjuNjQJfTfjh
         rXKyQYmhFAKwSDSrRwvQyCvydDPriA+cvKHgNX41rRhyqx+RsOO+XdnInTyEn1PjCArx
         7gsjXUNrm5DKC0iRs4t0L4jPeQOq5Xi/UGV65lejIGSArUb58LNlaOKoyzzWnOj9tTl0
         R9XU/QpTO7Tg8XMa6SVQ4/m1u/529HdXdPjUYBBePF5idZEnghVpVjp7AtIMZlG7Guer
         iI4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xhpwkmFlHaxu2UZ4fbTNF2bWBxxnXVLEII/Mi/kB1tc=;
        b=IchRkaEWpeO1mT0aK/FSLAo8FhdkmJryEhBs3wYzxKZ6n4I/gYyqwmGiq8iRJ62Lsv
         WRKOtuN8SlubWhJgVdxuJhGZDPWmkgke3EgcNDtJ6+fHMbuD/QtRBaqGYf7fw0BckbOE
         Xy8Ax1Y93eC9x3CtQ/fB+DlrdiJ9N3iWU1jzGRAiXM0cfuvOftb0x/KLikkIkp6D6xqW
         lyON4A0Os3FCM0RzxGC3STYQrTUUQ+x3DtsC2nWWKVziGpvkTCJoHlKIvpYWU6Eofri8
         z3jXoS858oeKDJA6NoX1DhwwDk1YQFPUzhbwr7O5eAAX8B45VuDqEovlEtq6XWDLnVLe
         ZtdQ==
X-Gm-Message-State: AOAM531+ZRdVkS4+onoc7DUufW2dab2BslwGDqb49xGycs+Fn3fiLhMl
        gN8MzJE0mR8/vKC8r2+WxTDlHOiYd75/QNaK
X-Google-Smtp-Source: ABdhPJwp/XnGydy7KMvk4qZdK7EA1qH4QJlfO/S5bNQ/EABgKVLregjsizBh/Ow2h0+B9QmV2+2N/Q==
X-Received: by 2002:a17:902:ecd0:b0:13f:1469:c0f2 with SMTP id a16-20020a170902ecd000b0013f1469c0f2mr24192784plh.10.1634521471549;
        Sun, 17 Oct 2021 18:44:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d15sm12109533pfu.12.2021.10.17.18.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 18:44:31 -0700 (PDT)
Message-ID: <616cd17f.1c69fb81.afb15.29e7@mx.google.com>
Date:   Sun, 17 Oct 2021 18:44:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.73-48-g2947530aabf5
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 102 runs,
 1 regressions (v5.10.73-48-g2947530aabf5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 102 runs, 1 regressions (v5.10.73-48-g294753=
0aabf5)

Regressions Summary
-------------------

platform  | arch | lab     | compiler | defconfig          | regressions
----------+------+---------+----------+--------------------+------------
imx7d-sdb | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.73-48-g2947530aabf5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.73-48-g2947530aabf5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2947530aabf5faec106229b1a967fbcb13a7a2e8 =



Test Regressions
---------------- =



platform  | arch | lab     | compiler | defconfig          | regressions
----------+------+---------+----------+--------------------+------------
imx7d-sdb | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/616c99603a3fbf8f983358f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.73-=
48-g2947530aabf5/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.73-=
48-g2947530aabf5/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c99603a3fbf8f98335=
8f8
        failing since 8 days (last pass: v5.10.71-29-g7067f3d9b27d, first f=
ail: v5.10.72-19-g2ca9b8bdb28b) =

 =20
