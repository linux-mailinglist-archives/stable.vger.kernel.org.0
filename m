Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6300B24FDE1
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 14:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbgHXMcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 08:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbgHXMcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 08:32:21 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9323C061573
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 05:32:20 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id t9so574685pfq.8
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 05:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X9FsGlPlNcYbNAaZgVvh7m6vlfDlElx4WjEr/UX/q6A=;
        b=tQpP52mVTLlCuvg+v2zu3NvtfkKBVNqHc3jnzTj77ogs8pc6JjfBQKTu6XSE0Gs314
         U1xIgKeY1RYCVrZDgmHRcRUoC0vtx2+B4rIAW1vB3sRD9BBD7BTfeQNxmCHF7K8QOlcb
         S0ryOwqZfm/FTVn6qPvEb2/Dneg/g1kSxkrW5OmbDp4iLQP/6hY3owgdeA2/HfqvcL9s
         rZxy+pDbHckgEVu5XjBUGKMoeN7HiPCnuhgbyCi2dVPCVJRLrmQMvhJbGDz7RjUiJG0k
         aLnsJ1UI8msFPUDFBCNcFfETxfYyI9wCIC/7WRthEBZNMOGwawYTlLs1SMTeN8FVCzKL
         dupA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X9FsGlPlNcYbNAaZgVvh7m6vlfDlElx4WjEr/UX/q6A=;
        b=AhNbC7WZq5UJ7ct1o7QwxqE1EMIwhEHwoNT196rmNt95xo4D5NcidRqpkY2wG0dArj
         8cEtTW9h3AB2vqJdcH5grNxxqeeJ15NBnrJ2Pw5IFHPCESulbHVy7gEWVD29W58imoJI
         8RC++cF98yAwGdBCiNOYG2QkKDMmKNqELsD+i+45XOaneIWSBUpDgAFXqK2lx1OMIh5U
         +nhig7z41x0xi6Tg0vxXduqYA3D2jcbsc6JmA+S5UrV6DUa/fPyNp1nOOA9AE9u/yFTl
         MSfEcnuNFVgi0LbaTB8whNJcSIz69E4bCIxI89gJO2mpZ6L4j3lK/KsaR139JO6bP9Eq
         NSYA==
X-Gm-Message-State: AOAM533bCc9eTfKmrN1oPte02hwn0734XIGxU0GsFo0kCNckSsCrVEeM
        nRf9ZOGwooXlwbzFL9BTB7buRSHi36IEqA==
X-Google-Smtp-Source: ABdhPJwOLlApk/dKtcf/CNLTAoxv7TXvocbzMI8sc0VbZu2ZoL9mpmANunyiy717p75eCYHDh9pN4Q==
X-Received: by 2002:a62:38cb:: with SMTP id f194mr3999938pfa.243.1598272340013;
        Mon, 24 Aug 2020 05:32:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g7sm10319813pjj.2.2020.08.24.05.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 05:32:19 -0700 (PDT)
Message-ID: <5f43b353.1c69fb81.e5cd.ed9f@mx.google.com>
Date:   Mon, 24 Aug 2020 05:32:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.141-72-g62187e309cc4
Subject: stable-rc/linux-4.19.y baseline: 129 runs,
 1 regressions (v4.19.141-72-g62187e309cc4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 129 runs, 1 regressions (v4.19.141-72-g621=
87e309cc4)

Regressions Summary
-------------------

platform | arch | lab          | compiler | defconfig      | results
---------+------+--------------+----------+----------------+--------
hsdk     | arc  | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.141-72-g62187e309cc4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.141-72-g62187e309cc4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      62187e309cc4a54d45a0122d2a1ec9c9f9597f8e =



Test Regressions
---------------- =



platform | arch | lab          | compiler | defconfig      | results
---------+------+--------------+----------+----------------+--------
hsdk     | arc  | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f437ff2be803637619fb42b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
41-72-g62187e309cc4/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
41-72-g62187e309cc4/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f437ff2be803637619fb=
42c
      failing since 34 days (last pass: v4.19.125-93-g80718197a8a3, first f=
ail: v4.19.133-134-g9d319b54cc24)  =20
