Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0C1321EAD
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 19:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhBVR7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 12:59:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbhBVR7i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 12:59:38 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68130C061574
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 09:58:58 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id o6so51712pjf.5
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 09:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eaqhY0pTWnfWlSoiTP3mCYZKO8MH080jdTO4f1KvL5c=;
        b=li6He1EvKdvRH73ahqVC0XNL9o+8P7JsJcTiIc/SUY+qZoA+pzCVOfthR848comWFT
         0p5ot1+5YliRHZEFJqXCA6cY+vplziAcyJF71Rxl1n0PeoaxduN3fK1i52xegOUNQ/4+
         MbFcgeCu+odwZhll1GLu/pESeHVqodlag+sEk4/1inurALGPmbQY/An2YeHfa9pK72GJ
         6uRa6ctcl2O8HvC1orWnFFpAzfiC729FA9C7Y5Ct+9Sj6d1TB57Y4yb1ukNPJDfUie8M
         OScXNuRFbINN64NOvuswSQHc/wGYq8jq4BiY2A58aCJCeg2a36GlhXYMYYk4s7aSfws7
         fDew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eaqhY0pTWnfWlSoiTP3mCYZKO8MH080jdTO4f1KvL5c=;
        b=aU8bmqzipeDkwi8yludeZjsvRgsAsK8nLEiZUMt1fHPr+rdfvN0/A2Flg66goCH1sW
         T/aAkFl0TByL272scgJ9H20wEEYVLvRPpM3KMknbD7oq87CksxkFTRbLxaVeSxCNatXn
         eRtbgIlcdROP+8oM8zNKKP+ON9sCaQEP/gSxhNAgZ9R2Crl8SHF1jMRgEZdipxZaYY04
         MmXP43HkabGZhWIAe0aMaoMH/xYPKNHBXBNnkMU3CKSreHXClaHoMMRuzc8Zm7k49qxu
         I0p/xhv+za1pE6GpHtvcSP/5XOKTd7dosBr07z4pMyFWZ+F/YlHvgKpt9PMP1BbohOdI
         DNdg==
X-Gm-Message-State: AOAM5308oin9rH0OM9T7ABfsmpqs6ruW1vgAjBnuctSmPiBWMYPoK0on
        UDTEcGBpg+Zkw7GMLfNRzUDreU2SGUoVtQ==
X-Google-Smtp-Source: ABdhPJxzTfXjMQKPtqp2Je7sx/7H52HTgA7wlu6fjvP/VxqipMADdDI+QHf+RdQlL++5h+Qj0A+mRQ==
X-Received: by 2002:a17:902:ee84:b029:e3:afe5:dd1b with SMTP id a4-20020a170902ee84b02900e3afe5dd1bmr20420234pld.35.1614016736198;
        Mon, 22 Feb 2021 09:58:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w25sm2876947pfn.106.2021.02.22.09.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 09:58:55 -0800 (PST)
Message-ID: <6033f0df.1c69fb81.709d2.4a23@mx.google.com>
Date:   Mon, 22 Feb 2021 09:58:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.99-14-gca97cc5c886f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 108 runs,
 1 regressions (v5.4.99-14-gca97cc5c886f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 108 runs, 1 regressions (v5.4.99-14-gca97cc5c=
886f)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.99-14-gca97cc5c886f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.99-14-gca97cc5c886f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ca97cc5c886f88ec3d2a1c4183e8f7e68d7b3dab =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6033bcb2c8600e31dfaddce6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.99-14=
-gca97cc5c886f/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.99-14=
-gca97cc5c886f/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6033bcb2c8600e31dfadd=
ce7
        failing since 94 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =20
