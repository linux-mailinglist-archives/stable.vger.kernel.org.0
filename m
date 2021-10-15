Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538BF42FF03
	for <lists+stable@lfdr.de>; Sat, 16 Oct 2021 01:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236015AbhJOXu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 19:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235740AbhJOXu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 19:50:59 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7840C061570
        for <stable@vger.kernel.org>; Fri, 15 Oct 2021 16:48:50 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id m26so9651964pff.3
        for <stable@vger.kernel.org>; Fri, 15 Oct 2021 16:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Suw2Q4W3axlgGPEKFZA0xFdCpd4scAKXEGbvfC2uRxU=;
        b=o17WAEoYQBFZEWMp0GLfXCNfwHWBz8lLGulWx2PtO+eLEw+2ID5hxjuBXu3/Xesq1n
         UYWY8h4Kx0vYlCAeCHfsPH3PkgfFUKTuCp38ywKzSPY1qIXqJkApfMNFITgIbRxtkHUZ
         EUfL20gj7zwg/fHi+pVn9343cG9oSMgdPE8UGJVeFdG9wo/tbPpp2folZBPkh74kZtKO
         F7+Yn3NMqBUIZVppezH2YNlizuYD4bmlfyqnTD8NdT2G2NwnL+PzwPmI9u07Q5FH/sC6
         /aY471flH0MT3H4Dhi69t15BNHcj5ujQ/KjIwulWnKeezyFRQgfivJXu4mHdqNFfG9kV
         qNBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Suw2Q4W3axlgGPEKFZA0xFdCpd4scAKXEGbvfC2uRxU=;
        b=XwSOFMxebCBDSjDrnModrkBa1l9WEUHPCfa0Yrbh7OayWqu5UFa4x+5hSbpejEXHTL
         zMYGc/fdXGeikumFhGTkj2xIlJW3AeNcIDNws9DuzQ349KXK/ya1cSJbkh7xE3DlZMyl
         Tvxx63lsu5blMdvfGKunPQcPYtzGIlFMoFUmcmmwxXTeO8kU6k92teg8Re6125O7KX6Q
         qkqOr4ibXSr7SI5N/pT1rWZQ4OjZLy8oawsDZRTpbN6eVTs+Ug03ivnPCZW1Ufa4OoKv
         eaJLTSlwi5nltPft7POl0rcl2cvMQtQTnZsxTJtP31xtOed8nfhfjJFSddT0aj2AUGT5
         EWBQ==
X-Gm-Message-State: AOAM533xfth2BnX2KGty4xCYWjMZj6aW/SXUJnJVtw5/+eVJN6nozf7x
        Yj/y+XX/cTcWKkHxke677nkj5brJwEsyP3tr
X-Google-Smtp-Source: ABdhPJxshu5QMNZm9ATBlR2nJWhw2lRs+P5hizvWOlZtRL4jesfecB0aw1imRu9k0NGvNzrz1UdNgg==
X-Received: by 2002:a62:6206:0:b0:44c:bc1f:aa5a with SMTP id w6-20020a626206000000b0044cbc1faa5amr14782633pfb.5.1634341729968;
        Fri, 15 Oct 2021 16:48:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t1sm5787908pfe.51.2021.10.15.16.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 16:48:49 -0700 (PDT)
Message-ID: <616a1361.1c69fb81.b87a4.2733@mx.google.com>
Date:   Fri, 15 Oct 2021 16:48:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.73-22-g663be328eb68
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 80 runs,
 1 regressions (v5.10.73-22-g663be328eb68)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 80 runs, 1 regressions (v5.10.73-22-g663be32=
8eb68)

Regressions Summary
-------------------

platform  | arch | lab     | compiler | defconfig          | regressions
----------+------+---------+----------+--------------------+------------
imx7d-sdb | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.73-22-g663be328eb68/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.73-22-g663be328eb68
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      663be328eb68171c4b5de4c1f18f8ff6da5fa696 =



Test Regressions
---------------- =



platform  | arch | lab     | compiler | defconfig          | regressions
----------+------+---------+----------+--------------------+------------
imx7d-sdb | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6169db875073fc9ba53358e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.73-=
22-g663be328eb68/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.73-=
22-g663be328eb68/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6169db875073fc9ba5335=
8e1
        failing since 6 days (last pass: v5.10.71-29-g7067f3d9b27d, first f=
ail: v5.10.72-19-g2ca9b8bdb28b) =

 =20
