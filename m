Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0AB4A6816
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 23:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241993AbiBAWhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 17:37:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241703AbiBAWhi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 17:37:38 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D61C061714
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 14:37:38 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id h14so16636173plf.1
        for <stable@vger.kernel.org>; Tue, 01 Feb 2022 14:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jHHT1/ync6kO9lCWo3gVevzy4eaf2yKZO+pOvwVHNRY=;
        b=7rw9M41/clLS6jGmPnWa0OQ5LWMEgZrhuDf2It/gKQcx2EJRN7nziu9bn/QmXI6cca
         CW54kmAstXDx2QvlNMIT+ebEC8lKXlfkWJu/s7FM8p9spuce/oQTszbNN5sXQDem3uQu
         mT5GG5/EAbNZNNKOON3O7kbS/2EqLvBtR8u3X5jdWhDM9JxgGu3CyHjsJrvOJfKtG4xk
         mP2m/6iW4XR8nWvTPelvJVUaD3UCOWEy8O4PYChb0tYvL7Bzg9fAPBrqZ74ttx3v4giL
         R4Iw3qWKe241LuTPXzF+O45nRRKGebkeZ8oMV4qA4gkR1FhN2xx49zISZd8g69JDtp/q
         BwXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jHHT1/ync6kO9lCWo3gVevzy4eaf2yKZO+pOvwVHNRY=;
        b=3aCb+gUUad5mK+x2mi97oeplJZ6OkRoQV4K7aD8heMe0B2AZe1NE+Dr1EfqFfuRN8h
         4mbV7trEz9hfF8c3U+cf3QaxSf6/ErPUESDWKjkXYE9PkHjAyVNYfiA11EvMVVAkFX7b
         hKBMArx1+SdVFHzBz4ZZ9nTjmjc4el+YLDMMeMIvlGx8sY/lsG1NsHTBDJR55L3JtKq+
         E3QbB8S4kDVPazdlvAyWE2LL+3BaHt9s9MvqhpGzKVD8owZPq1d2DWW2TmHKEmjGzuNE
         vAogEE1Ny20U2W/ESiaIS90/Pm5vqprSXAYQfGdOEu0TVIgq7mPVIEiRmczQ2CDU7wiT
         0P6w==
X-Gm-Message-State: AOAM532RWVDiAeJ5t3CqaORkz9UyCMdsQUjz5TcWktqbIQTX24l8ARGW
        mmDVXQV2nma/Z0bgrRH5vVzPxqHGhy2jPNtg
X-Google-Smtp-Source: ABdhPJyPa3nue1zeENA3u6hQOd3IrsFBY3HVNgC6O3AgxNELUuAjW4ZJ6mAEWuVL8heizSwjfq1gow==
X-Received: by 2002:a17:902:e88b:: with SMTP id w11mr26986108plg.153.1643755057652;
        Tue, 01 Feb 2022 14:37:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k12sm23688213pfc.107.2022.02.01.14.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 14:37:37 -0800 (PST)
Message-ID: <61f9b631.1c69fb81.876ca.e3af@mx.google.com>
Date:   Tue, 01 Feb 2022 14:37:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.95-100-g8287ac0335ea
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 139 runs,
 1 regressions (v5.10.95-100-g8287ac0335ea)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 139 runs, 1 regressions (v5.10.95-100-g8287a=
c0335ea)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.95-100-g8287ac0335ea/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.95-100-g8287ac0335ea
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8287ac0335ea45acfd79802e3afc0ce53ce14cea =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61f9856996c0c3effb5d6f55

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.95-=
100-g8287ac0335ea/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.95-=
100-g8287ac0335ea/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f9856996c0c3effb5d6=
f56
        new failure (last pass: v5.10.95-99-ge487fd8c7e1a) =

 =20
