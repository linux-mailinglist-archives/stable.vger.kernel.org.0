Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D2C48FE6E
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 19:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236012AbiAPSYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jan 2022 13:24:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233559AbiAPSYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jan 2022 13:24:06 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0A3C061574
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 10:24:06 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id c6so9557108plh.6
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 10:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ziu/Og9xnTSVFBxlw8FouJfavH5DxZynz0qHYwAtOnY=;
        b=XJGXojOsvtC0hUCrLtM86tIl88IrkA0KPT3pGfR0ZgXc3FTkTfGPsRVv0JnZ81Hq13
         k8KOZpeEzIv82FM5SKD/wNgBGk+i/Hp2l2oX9ti638ib6djsuNRPirb1oGAqXmIhQkrD
         JnUn94gjsHnW5v53Y/H5GKFN9jz7Zf20waW3HtjMSipnf1tmaWaexp82KD9w5Q0Dj6QF
         az7Tv/a8L0cP7Cj1vYjK+wOrjt29XNlkHIY/ZP0LfXc81kklXQWamD3SJy+ttZLRyvRo
         HSG17ZL/GLicvYZZaPveuYx4t+JJTw/XCT5lv63t+ynOAOUSYDztAC7Y6KFAkOt56aY/
         qZBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ziu/Og9xnTSVFBxlw8FouJfavH5DxZynz0qHYwAtOnY=;
        b=X0C9tTg8lUrTCnAvu4E2OhEbCzfoAvTPfuwXKo2sjPi6hQ+RRkzaSdqRRmEZ7u8IPg
         Atz0nC6cOz5HaHDmNyzJYYx75rUAzJ2BkJMXZ7RuLiVyYzN1GwgK20z1x80TnZNBM4MZ
         QS5DRdqK2t3mNDdMDKKZ9l/bOhgG5+DPiMf5kuRCn+QxHvsk/f5tABFqZIyofJYdhvBf
         bMed1ol3SV8mJD9uiBjV0JMzweqbrcobQx7TQv//F7FWM3mvU+AlL/sbbV/zKJz6pUCg
         j4Uy7gtPAzKWQczpSbCtrUfehYWI5ikjweO7Wf73EYTJuqVVREfIZd5huAEG+KSxeft1
         KO+A==
X-Gm-Message-State: AOAM533r2P5i1bwnXi94jarxHkMb574vHrgsabncinKgPfkdkFlZe4t6
        wh/zymrNM+WKVaOlszLkusiaz7fcLhCdHkHx
X-Google-Smtp-Source: ABdhPJwJvuJUQmQwY1wxK9LsqkWTqDDGPMGoMS3gWStaUNht+fH2vwzfF7FuJ+pSmBjl7KGTQAlDUw==
X-Received: by 2002:a17:90a:fe10:: with SMTP id ck16mr30822868pjb.163.1642357446083;
        Sun, 16 Jan 2022 10:24:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k9sm9657769pgr.47.2022.01.16.10.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 10:24:05 -0800 (PST)
Message-ID: <61e462c5.1c69fb81.138b0.a4a9@mx.google.com>
Date:   Sun, 16 Jan 2022 10:24:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.16-38-g677615cd2689
X-Kernelci-Branch: linux-5.16.y
Subject: stable-rc/linux-5.16.y baseline: 180 runs,
 1 regressions (v5.16-38-g677615cd2689)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.16.y baseline: 180 runs, 1 regressions (v5.16-38-g677615c=
d2689)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.16.y/ker=
nel/v5.16-38-g677615cd2689/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.16.y
  Describe: v5.16-38-g677615cd2689
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      677615cd2689a0898dd58e51d12abe6663567b24 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61e42c57aff2a9c0eaef674e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16-3=
8-g677615cd2689/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a31=
1d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16-3=
8-g677615cd2689/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a31=
1d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e42c57aff2a9c0eaef6=
74f
        new failure (last pass: v5.16) =

 =20
