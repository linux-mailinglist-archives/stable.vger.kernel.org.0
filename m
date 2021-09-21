Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82115413511
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 16:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbhIUOMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 10:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbhIUOMz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 10:12:55 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C278C061574
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 07:11:27 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id v19so14466035pjh.2
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 07:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eO9HR0KI3yv33wwlkhQyPgSibHyDhEhpf+GJAqtERoI=;
        b=GnbxTDSoKN3XE/k1juOYtKh4cSTnLzde3AZAU32+AqmT9lPXS4khDHEPiPZ6LWrpzl
         9y95Y/+Od0fECLtoGnO91d9phbBmghnnZAO6GTTddtU2h/kOhKX+g6nKqneYAp6TUCfC
         AKXrBoQahyVlRBTIvlZEBZntNIz5BGojTu+w7IciooDsZh7D91/JidK0yKRxZRI8XdjZ
         QdXlVTp6QhjPXBNeUSHeQSeOuX+BcVt5Qs26Txu0iPpRlnqodpbtZKCpUhgnnqpBAzqu
         4fe4ODsBSnN3uIrmBSqj0foMItC2FPrxpwR1gck0Z/d+67SbS1KqZEZZp37EgWTjTx9N
         1agw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eO9HR0KI3yv33wwlkhQyPgSibHyDhEhpf+GJAqtERoI=;
        b=carWMuxn7iss7/huyW6PLCr00hhYCK4lHfp5aZ1N3iHQCZyT88QntSCkj7rywIn+jh
         GN83TXJOliiZSkM+KTpO2uoFqhZ6/3rwb8rRJXmjusNWTCX12CsQ1u51Lq3Knr/cknFq
         1yNxPkvI6t70uxXB8FD7Ysu2c+SgoctgHDGJye62yOCHnAuKgBB2nkgIMOTMHK66KfDg
         wNdLUVcHsNTAEiZDuvHxFLlGc1hbsI4z6kxtaVgWWx/SRR9Qm3O8uUwy51hqyCok+sOj
         VfKQN5XZhV1BKF0QuvTd7Am/75vyhnGSoqExgJGI/Ite27G3wdK7h/B+JCRQh6gOO8V8
         nTsA==
X-Gm-Message-State: AOAM530bgdMGqbUxLuU1pLYevSH9ojeCsqJFEHd4SS8MwiH9EksQEb5d
        JuNlaKqpkdTbKQNnIWIELgzqbPCYwlWIvih6
X-Google-Smtp-Source: ABdhPJxQhOK1ZYyvXoEGmClvJmaSzMTGggIGuU2DIPXVOcBzZY0XIgIxNp7jixiCVt6lEjblmUQaeQ==
X-Received: by 2002:a17:902:bf42:b0:13d:b79f:a893 with SMTP id u2-20020a170902bf4200b0013db79fa893mr6927190pls.1.1632233486398;
        Tue, 21 Sep 2021 07:11:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h13sm19463046pgf.14.2021.09.21.07.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 07:11:26 -0700 (PDT)
Message-ID: <6149e80e.1c69fb81.df39a.850d@mx.google.com>
Date:   Tue, 21 Sep 2021 07:11:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.13.19
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.13.y
Subject: stable-rc/linux-5.13.y baseline: 169 runs, 2 regressions (v5.13.19)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 169 runs, 2 regressions (v5.13.19)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =

beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.19/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.19
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f7eb8f60cadbedd31a2f39d8866b991b67434f2c =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6149b20d456e8565ec99a2dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6149b20d456e8565ec99a=
2dd
        failing since 5 days (last pass: v5.13.17, first fail: v5.13.17-69-=
g9af0951786ff) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6149b0b9cfacbbcdf399a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
9/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
9/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6149b0b9cfacbbcdf399a=
2f3
        failing since 5 days (last pass: v5.13.16-301-gdaeb634aa75f, first =
fail: v5.13.17) =

 =20
