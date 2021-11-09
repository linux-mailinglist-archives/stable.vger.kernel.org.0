Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE7F44B903
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242236AbhKIWyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:54:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345695AbhKIWyI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 17:54:08 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CBD9C0432D2
        for <stable@vger.kernel.org>; Tue,  9 Nov 2021 14:25:20 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id u11so1239103plf.3
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 14:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s5LCZ8fJIVkHdkaIIHi3cIJeKjxOIi968Q/qqiw01DM=;
        b=OkTfpOL2FCTZiE/d1txHTlbozqvNFnlvJvVWxRmHBzVxd+tRSFYy9wUqrQ6hgWTJGe
         N3JPK17Ak1gMrMwvtEzwgNgXTPm+hpUP73+sYGnadDbsLiqM36lnLHaKELJ9FtiDB7Pj
         8C3DSTyxBNIsKdCkCotNgDVtOo1RetDhAtPvMRvoGXrUu+X/rB64HC7XfdlHsi9oshq/
         q/DtmfWunOKlXia7InuK0vaBiyP7VJFiNwCemp2XJ6g7c/Q9DnE/OhIp3ml3fsk0isGj
         m2n0QCaDDzqDkQYguK/f5oSZfgKt5VkuKrsuw2A+Jiwu+5x4f0iAl7b1yVep6bnHo1p4
         IAEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s5LCZ8fJIVkHdkaIIHi3cIJeKjxOIi968Q/qqiw01DM=;
        b=R2XGJiOKGdN3MJiViVzi1YlqzDmbcPl3QecBpUFf86vnmUAUE2krYZDsQNyl6fUFvo
         zDD4x2f78kzpF+mgyQsCBt8a2uX2snBQ1hQFEBTEMhYTRM+w1jyU47OToofpQGUgeCrH
         uF7d9wpE9yKZ69KSByBut+xrsmmNd6hOzhqG24DAD1MaOBx5zIz6SmRWsruuCSZeD82C
         Oxboadsb3y5cZRPyA8IzcBlhzSqjVHh4pyVf36DESfTxD1NvkExaziKZ/q+sVMmyFZ9U
         S2UkgAHl83PSOS39YoHDxCTsf+IIRZ72WE3A7PfS44Qj8kzDquKDR+GJM7+L0ULSJ3NY
         ziiA==
X-Gm-Message-State: AOAM5306V61o5mhnxmIggheap+dg+mLekYI8hjOeQl9OhR3Ea4/lfqLz
        aeZrbQeLXwxvognbheshmN0ewHydo3llSd2e
X-Google-Smtp-Source: ABdhPJwYTSgTXT0bOKdD6tJMrnTWL8cCngatwYVVE8lhtcYbi2p+J4+Mcf2hLmo/LpK3qPm2jSQW8A==
X-Received: by 2002:a17:902:6acb:b0:142:76c3:d35f with SMTP id i11-20020a1709026acb00b0014276c3d35fmr10746035plt.89.1636496719377;
        Tue, 09 Nov 2021 14:25:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d17sm19673723pfo.40.2021.11.09.14.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 14:25:19 -0800 (PST)
Message-ID: <618af54f.1c69fb81.11afa.cd9b@mx.google.com>
Date:   Tue, 09 Nov 2021 14:25:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.78-10-gbb7301181e71
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 218 runs,
 1 regressions (v5.10.78-10-gbb7301181e71)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 218 runs, 1 regressions (v5.10.78-10-gbb7301=
181e71)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.78-10-gbb7301181e71/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.78-10-gbb7301181e71
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bb7301181e7118f6c6769385bd37248b50dee4f0 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/618abab07ed78d153f3358e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.78-=
10-gbb7301181e71/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.78-=
10-gbb7301181e71/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618abab07ed78d153f335=
8e7
        new failure (last pass: v5.10.78-9-ge3bb388aea14) =

 =20
