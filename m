Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC9049C0CE
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 02:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235905AbiAZBl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 20:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235863AbiAZBl1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 20:41:27 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C003C06161C
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 17:41:27 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d1so21049069plh.10
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 17:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wKzv/FPH+JYjwueSCY5Vd4tr/CIXGQQF1gflTxerkUg=;
        b=wk5LCgsxg1twTEnYNYdDszVlZAG54nBkriUyaMtR1/pU1evrzMwtM1dLYPIYaZQ91s
         cCiO1WqNipmBYOOWWwZqAd1TIukVnRp1QFbzXrajN/xYT31tqlcBivakX0PQkHcNw3zC
         pTiTVd10+WfKDHiImqYIo6nqexYlyWYjbu0ve58nhuHkUehsbkJNs/FY7p6B/4nfT1TD
         TrrOuyDATak7Cdp7jCvd/x2dzLpBfdl0xEME6+89vf+m0wtGtWcKAdH/DtQ/8SFWPyNh
         8zW2k59Qi12Qwc5biRq8oxmY691Qd++sc7Xg7CHgMExCQpWXOWfI8/czr7vlt+6MLgdK
         ZegA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wKzv/FPH+JYjwueSCY5Vd4tr/CIXGQQF1gflTxerkUg=;
        b=5NLjYPFx3N/+B6sbHVuDg+0Te8KXIJUb0l47XdiWmGQOwgUBGAMbvTM2OuwP38l+2j
         Oii91ZviKI4pebyJZsO0NEloNWENqnOHtSP38K4GRlLuqP9xR2J6qVn/sRPxvaD1adMR
         qRcSz0fZYGRP9HGlw1N9EEpRET+pFu6ByAzt33AF7Rq2JdhpyIEG1orwKhaohNZBX2vi
         C5Wy5xdqancQMJdM9iulVSwoqAOHU2U3q1ouc67s+XhXqJVwKBPStuJf+jLUNbM1Ctlp
         ig8Mk7RASbySMF6w9cM7auR5UukbWG2fr6x5nvAJ/4Cpd8Cjo3zSPAUKkimJPaOIFZUa
         /VEA==
X-Gm-Message-State: AOAM531irQ20cacNLVXycfy+mt9j36FyuYay8t1k8h+VVYlyLBbZHhGh
        FCKpJ3h7UY80+ydumsx7O6mhZAR/CFEu10fe
X-Google-Smtp-Source: ABdhPJzshgyAo6vwO17HDCH86jCO7L5p14+fl6LVXyGYbMPuhM/6eDZmn0O/pvtQ5cTLlYUMlZrH6A==
X-Received: by 2002:a17:90a:a393:: with SMTP id x19mr6448798pjp.196.1643161286466;
        Tue, 25 Jan 2022 17:41:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z25sm240447pfg.129.2022.01.25.17.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 17:41:26 -0800 (PST)
Message-ID: <61f0a6c6.1c69fb81.9c36.12c4@mx.google.com>
Date:   Tue, 25 Jan 2022 17:41:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.16.2-1034-g39cb7e05eaf4
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.16.y
Subject: stable-rc/linux-5.16.y baseline: 100 runs,
 1 regressions (v5.16.2-1034-g39cb7e05eaf4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.16.y baseline: 100 runs, 1 regressions (v5.16.2-1034-g39c=
b7e05eaf4)

Regressions Summary
-------------------

platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
imx6ul-14x14-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.16.y/ker=
nel/v5.16.2-1034-g39cb7e05eaf4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.16.y
  Describe: v5.16.2-1034-g39cb7e05eaf4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      39cb7e05eaf4fd55c6445fe8fe9ffa7f8d329205 =



Test Regressions
---------------- =



platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
imx6ul-14x14-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61f06d94a54c27c9f8abbd1b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.2=
-1034-g39cb7e05eaf4/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-=
14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.2=
-1034-g39cb7e05eaf4/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-=
14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f06d94a54c27c9f8abb=
d1c
        failing since 1 day (last pass: v5.16.2, first fail: v5.16.2-1041-g=
bb0f7c24685b) =

 =20
