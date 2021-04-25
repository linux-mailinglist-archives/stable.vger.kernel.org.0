Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4378F36A520
	for <lists+stable@lfdr.de>; Sun, 25 Apr 2021 08:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhDYGeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Apr 2021 02:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbhDYGeO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Apr 2021 02:34:14 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB27EC061574
        for <stable@vger.kernel.org>; Sat, 24 Apr 2021 23:33:35 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id f11-20020a17090a638bb02901524d3a3d48so3368532pjj.3
        for <stable@vger.kernel.org>; Sat, 24 Apr 2021 23:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+BIMY6cWPP1ZVohXEd4nYeD2zMWoANFzPVbQlHTDyq8=;
        b=DJNcGSWkzVJnymkC0lSDtDr0ierfY5OX1vt5QXpwCtTJnM3fpVDTlzm5/aLReAJE9K
         3WRpAf8gSnP/ondG62IodScU0ePIQ5NAqL9XlGHnKgutd3Hbo7l+M10ELsPfQiaiy9yT
         UixUSrfUz3kNYJiIyYt7OCUiJ6P4lIGo1G7uScjUzGrfkE1Wuw8gefRC6aOoQ8SOmXDH
         +Nf9j7MF73HsfZj3uMH/meCteccfhODz0w2BFKZrjfCZqTBlk4XMMRLI5Ge/RvAdoglp
         0WPw/POvnKGssI11obFiUrqBNrdrrcoQGOpkEfva90lga17YY5zgtveP4f20zDNJ+mIH
         jVgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+BIMY6cWPP1ZVohXEd4nYeD2zMWoANFzPVbQlHTDyq8=;
        b=b7euXLgZNFaGVEiLpaLPk+nxrWkskAaq86n/LzzXAtEpHxtHQJk624Ieu/MTzkj2Z9
         /UUrxibx6yElRFPXrQOAYAqkQdroLvbxv+jZ7NocPMklSO+64WAv7SeoNr22LUw24DXZ
         jeTnfUUWosrppjpg35/0iaA9Kos9/hZUnV4AMGfpJSDNWb5a/7t9zN7uJ7EABEHIumX+
         wow0TKPHCfznjDDLQ1lG8P7uNk4pTekOelCncgiiiiPYaBZrKpbuE+b38q1FZI1MM0EU
         vda1AI3wt7Yzi6R5DCOVrf+0g8cXUBBXUJbcGZH3WJ+4Nj7/NQnU+q1GxOgb5cw9efwn
         ZqBQ==
X-Gm-Message-State: AOAM531J9uVQRxZjO/0WjcWu33r45fqFTTqyyzmb1I5UgAQz1G5BMlk8
        EyWB7Tjz8AAiROChu92s5Nk/vjeJwbFRNjsN
X-Google-Smtp-Source: ABdhPJw3Bi/m7QjCAylTlfkjHImKoOuiHAjp9RSTUIoKiTia/ivM+fwDmfNoanQ02cww4YzornKZ6A==
X-Received: by 2002:a17:90b:238d:: with SMTP id mr13mr13801521pjb.23.1619332414941;
        Sat, 24 Apr 2021 23:33:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i10sm11176844pjj.16.2021.04.24.23.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Apr 2021 23:33:34 -0700 (PDT)
Message-ID: <60850d3e.1c69fb81.6c210.1acb@mx.google.com>
Date:   Sat, 24 Apr 2021 23:33:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.32-8-g1d9574aacc92d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 166 runs,
 1 regressions (v5.10.32-8-g1d9574aacc92d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 166 runs, 1 regressions (v5.10.32-8-g1d9574a=
acc92d)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.32-8-g1d9574aacc92d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.32-8-g1d9574aacc92d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1d9574aacc92dd0ec52f09be91a040ec930af8fe =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6084e01b7a3a65ebf19b779a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.32-=
8-g1d9574aacc92d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.32-=
8-g1d9574aacc92d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6084e01b7a3a65ebf19b7=
79b
        failing since 1 day (last pass: v5.10.31-102-gaa052671687af, first =
fail: v5.10.31-102-ge394e227268f) =

 =20
