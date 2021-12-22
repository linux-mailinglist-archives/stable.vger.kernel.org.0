Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C152D47D3D4
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 15:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343510AbhLVOmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 09:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238818AbhLVOmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 09:42:04 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCBFC061574
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 06:42:03 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id w7so1501950plp.13
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 06:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Fxj4ZlprQRGFTUehUTrHSOdDJpjodyCJQ4ah6sGmUFk=;
        b=jzds3Gc0+/DTPVt2vOt7FVJRFGZyfZhTRDl4l9M35tC/R97lGs88Ej/ieozQKqF4lm
         RWdc9a/INQwWAVbJIS5PXI0oRw8qPcigIxrPi4sAD2+7Pt04yDdmapFzfgSd7tKae4Yq
         e7/AogToWjV4JMCsY2fxCyGBumv8czx/uNQ3tmhozU4mLKA1lEW79RGDBvwqpMiSSRnV
         JjflbpuWTBuIPktI+apYNKkf8qx1js/HMtWYYDk9HsCvo3EOfyGYDULoYdVIqwz+MhmM
         Z1Qj7X9TITCBBCcWV/JHBJuP09tJbFWu6DkmcjbTQZ8b14naqA1d189dWbpnhs62L3xQ
         uUfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Fxj4ZlprQRGFTUehUTrHSOdDJpjodyCJQ4ah6sGmUFk=;
        b=65cQ3V3O1Cb9yZ3DtCJvTA30ISfl+j5uwn8BAj37fqkqk9ssdLMRBoccFm7hIDkGku
         RSGd0kSc3j3VAb+pTCZTZa/lmTclFem4B5YEd4rzTDyi5+WgmzRNvJjvTxI/RdXlJqq8
         A6aKo4dPjm2tLwoClQnzqmiMowoYsRq1HCQiEfUHGyIwynRshWpZpIODUPfXNsK9+a3/
         XQ7nicRrduKk3SFn6/SbnSnrJi4LM+jwStNC/GMg2lya31SyqkY87QWNrF3TqcCZAUxp
         9BzuBAh7BiTeV1pFLxgE2D+F28oe4/h//wnhaN4oVGhagAx6pi7brOgmn88/MWTVrGtz
         6AZg==
X-Gm-Message-State: AOAM532dbAFxpfGNPCqJyk1eMMrPBzF8bFJ4Op9EPf6fUTsnGsc1WLk/
        wMfY4nHC3GTGCz7tfCmsZ9SzEK06Ve5acKix
X-Google-Smtp-Source: ABdhPJxbqOzNC8uu663BpcqLAaA/K4xUth4EblHiiT1jAfgUFVk3zUBs3TcfmjCDn2Sllz/9RH1gLA==
X-Received: by 2002:a17:90b:1bd2:: with SMTP id oa18mr1727073pjb.4.1640184123315;
        Wed, 22 Dec 2021 06:42:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q9sm2251918pjg.1.2021.12.22.06.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 06:42:03 -0800 (PST)
Message-ID: <61c3393b.1c69fb81.f7311.5942@mx.google.com>
Date:   Wed, 22 Dec 2021 06:42:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.11
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.15.y baseline: 236 runs, 1 regressions (v5.15.11)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.15.y baseline: 236 runs, 1 regressions (v5.15.11)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.11/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      fb6ad5cb3b6745e7bffc5fe19b130f3594375634 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61c305b0f7c4faedfd397149

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.11/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-minnowb=
oard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.11/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-minnowb=
oard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c305b0f7c4faedfd397=
14a
        new failure (last pass: v5.15.10) =

 =20
