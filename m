Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE465552FF
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 20:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376856AbiFVSJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 14:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376474AbiFVSJJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 14:09:09 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FEA0393E5
        for <stable@vger.kernel.org>; Wed, 22 Jun 2022 11:09:08 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id i15so16051257plr.1
        for <stable@vger.kernel.org>; Wed, 22 Jun 2022 11:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WWG5d4KveUfL0l47AxY/VdI2yS+7LB8nTTKrdAQ+U/o=;
        b=yLl9ntIKujJBlHnZ/w+55IFdOE6th2jt8eUFTj8dD0B0Z7ZpObkKYGcsHYMn4K9sII
         3lEW17qF7lt0xdemBJxRFeRQfDf9QpLHUcnrkQH1bwvGunlq0MJEmr3wu6jjQZX8ZrKZ
         3HvuKg9rOOpY87inRmGQLRCkaiLXpgM53gPMqlv6aeMrp4z2H6go4oV9DJ9ONZyx+I0r
         zR6niK0+vq2yLsGphtqB9uOHOuEq78IEC36TeLfYs8I9v5w/9Y0UcWp7HCsZvNIOOBGa
         Tn+5j5clSj67mqosgfWtjbgV/Yvhcnj/CQXMY0EQ2iaFTUTMAd8yjJ4YWnot5+69QRdr
         k4LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WWG5d4KveUfL0l47AxY/VdI2yS+7LB8nTTKrdAQ+U/o=;
        b=bffxrgSXYtJPornmXL8lz8Ms7HjTNfsChvU+F2bpF8kWr5XP+wN/8j7dL7i+08csNL
         SSZsFRNi6rNvpfbV8ZNnFLGKgVTBRtnE3jJJhMV0ffeeh+J8rgTkVhcBls+YwgTgBqxd
         i+fdyIUFUOFBVwxL9dXdMMpyJOO3LPfOs/BfNXYZFuBjAzTNvabqw7XdlNOYQYh7TqgU
         /i+gHZQPspGqXyFatwDn9nEjQzJPF4+GpSQn3upw4if5dJHYec3kjCexwkLZD7Zne/4/
         Uzgljs2a/ETlEHEXidyier2mHK8lgeO2zf57cfJyoH67vzEoQpnorAMQ43bF6QBZ8Iy+
         Ndug==
X-Gm-Message-State: AJIora+dDgQwzE9ZhqZPZUZpdWkAD611/pP08R2DLthEHpv7XNNs7Ez4
        Xk8fjt+Jajegx/E7FMVzL+iq1LpNTu58am46J9U=
X-Google-Smtp-Source: AGRyM1u05OXgpvPPdxHxa3YbKerfNLejuS5IIH7TSimXTNCGVDiJmqwo8iBrydyD7jvbCY7IQv7dwQ==
X-Received: by 2002:a17:90a:13c7:b0:1ec:c72a:9668 with SMTP id s7-20020a17090a13c700b001ecc72a9668mr11704612pjf.141.1655921347578;
        Wed, 22 Jun 2022 11:09:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f1-20020a170902684100b0016a3f9e4865sm3120325pln.148.2022.06.22.11.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 11:09:07 -0700 (PDT)
Message-ID: <62b35ac3.1c69fb81.8978e.4edf@mx.google.com>
Date:   Wed, 22 Jun 2022 11:09:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.49
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.15.y baseline: 194 runs, 1 regressions (v5.15.49)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.15.y baseline: 194 runs, 1 regressions (v5.15.49)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.49/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.49
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      ee039006371a0b1d64d825a59f0eed8627bb3c91 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62b32521fa3dd57f1fa39bff

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.49/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.49/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62b32521fa3dd57f1fa39c21
        failing since 105 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-06-22T14:20:02.063366  /lava-6668690/1/../bin/lava-test-case   =

 =20
