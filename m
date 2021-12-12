Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B4D471E35
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 23:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhLLWX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 17:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbhLLWX3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 17:23:29 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F35C4C06173F
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 14:23:28 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id p13so13367130pfw.2
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 14:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j25j3QVaiOUhbgRmGDC/eBx7xnvvvYL45XwHS6qzIWM=;
        b=WFA8/0XoR7jodIGA5pM8npvtEkFHdIak2F/l46MnGTzyfOvv1w10QnmXZgiBxXQ0rO
         DywHqsEX0RV89KYPXl5BL0a4dsZktO9XPbSMdB+WGZvgNN/L3v+O/QyJjO2wOF/pgh41
         M6hj+jUOce3EuVYj+QnVoXcA2H4vilp55HBZXWv7eX5WocFwcRfeEh2bucKSMgrXWQwz
         +UeMAzvfpQMCrzharjHWzC3oMEIuKT18k0eZoW7ZllOUZN9mGiZJIRzHlpc5uKpljMcH
         UZhDBztdWQwJRHZ65fMGsVUqa8p8qbo2CFjhY0SClnm2ldFLq6npxxOkPfahV86FmNwS
         bYrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j25j3QVaiOUhbgRmGDC/eBx7xnvvvYL45XwHS6qzIWM=;
        b=AShIj6OPsaxKwjdXbTlJXKTWnfFuEuED/yojd0ct/MwUdWfvr8zZA/2QWrFnmCLEge
         dQ8WrI0cIxNu6+0RWuNv9m40gZJdiEoYtByK3/ioanGvRGOO4Gc3fX/xRg3a/lnSqP2q
         yKdp25gckZrNTc3iSE1/bjr1dFy06WfA522tejbMKLW9KpJ0o7/Kr8kOM9qtUfMhhP44
         vyiSyvYtJTFOMByJM+BvKwBTbd1Ov1TO33joRG86jI4aiX/42F/Ur2iScSKEtAw8/iHb
         w7miX3c6V07r+5fxKiyvXPjf0lkZ0Nc9TkgK7HC+5MeX0JuouroSxstN6EVc/97sPS3W
         IhFA==
X-Gm-Message-State: AOAM530qEB0hekSTGhs85dUwzc7Pva1NeIZQTf21ke34N0XCm9TPJYr2
        i257nVtb+talwBGWMIMGcgKvIP3Jv0Y31OaU
X-Google-Smtp-Source: ABdhPJyMa4AujFD2i8KRG5KUalLtmFAFpe4eqhWZCW9G7Bbc1qk72qgfAcASRCt9fuOuIYtsiFeb0g==
X-Received: by 2002:a63:565d:: with SMTP id g29mr50308448pgm.245.1639347808360;
        Sun, 12 Dec 2021 14:23:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d13sm9629604pfu.213.2021.12.12.14.23.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 14:23:28 -0800 (PST)
Message-ID: <61b67660.1c69fb81.8198f.9a10@mx.google.com>
Date:   Sun, 12 Dec 2021 14:23:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.164-63-gff495d982559
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 218 runs,
 1 regressions (v5.4.164-63-gff495d982559)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 218 runs, 1 regressions (v5.4.164-63-gff495d9=
82559)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig               =
   | regressions
---------------+-------+--------------+----------+-------------------------=
---+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-10   | defconfig+arm64-chromebo=
ok | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.164-63-gff495d982559/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.164-63-gff495d982559
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ff495d9825590ca1753479f9388688a23ab4448e =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig               =
   | regressions
---------------+-------+--------------+----------+-------------------------=
---+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-10   | defconfig+arm64-chromebo=
ok | 1          =


  Details:     https://kernelci.org/test/plan/id/61b65159780398485d397137

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.164-6=
3-gff495d982559/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.164-6=
3-gff495d982559/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b65159780398485d397=
138
        new failure (last pass: v5.4.164-34-g53b05f61e0c6) =

 =20
