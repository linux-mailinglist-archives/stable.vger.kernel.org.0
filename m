Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950CB498179
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233939AbiAXNxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:53:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiAXNxs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:53:48 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6EDC06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 05:53:48 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 133so15493989pgb.0
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 05:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=71+NBYWeR8Or4DqF1NZuA9IPHbAyIHmemB/8gRSR8yg=;
        b=LCoqn25bJVCn8JNFDoEPI/P6LhvMr2OIOhzy5xnwLBEEH2TfHgcYxhRUpx37vfjKDc
         /cPehmEJt/SwIuT6y3N41crMvTIUAnHn+5+UqYkl+fLcO1SGv79cvJsNJHr9XAlc2DW+
         KhhGvuAxjB+ACbKr2vbxeYihTKesMUGOMRToT0Ajt8hQKMLlcStrs98PnurgSQVEw66N
         eFSyxkruzSY1POgIBMk0KRL1qL9vhdMyr819qqew4HFvHlh6SuANjVLKsGAAogSxG1BZ
         tgml0hCm34NMn3b3jh5KQ2m0FLK0YMoVi6cKo3tXGc05EnQ+k6GinhFmxmwLixT/VWAr
         /c+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=71+NBYWeR8Or4DqF1NZuA9IPHbAyIHmemB/8gRSR8yg=;
        b=UIIAfG7926O0wGoZJ824cGSgCsVRWyjuGS1NtkPLy7sDp4NQQqwW1oPl5xcNPGO3GG
         88V38rfQ8HuLM/wpWVeDlDOlnMFJ7SbfiYtGdtl30He8DlP3xtBjNDvRXx8xZVl/uj+y
         Y+OMy1tmbYr9+MeoySn3Jb0BomnlwUC1HAj+hdwvIWgCLTBOzXNFq9hKL2W1QxeQLWgo
         zSeA1x4XTZJVd3MuQpEzUyCgca81P59Cm/oOpyuprt6jJ8RoJ9HSdoH3gaEC7UjxwPrj
         fCG4IXp/ra9CsQvvL9LEBoDIuynJ7JtIBYvVYtcjIJpLoSF97YC+2VBWVn+VLMvEWgOK
         7Ekw==
X-Gm-Message-State: AOAM532b2xK2oAyhRTEq/Xtl1GR6pegWwbm/6BRBde7HsjhNZyo0UarL
        RAZddiqe+WJo/w73FcTftKXU9PnGLbvFakDU
X-Google-Smtp-Source: ABdhPJwDZDttH/y1jvE/qEnirsgm1rk7jc2xOSEZyFzCJ+ILbCtNduUa88P08thkFio2rC69syrSAQ==
X-Received: by 2002:a05:6a00:13a8:b0:4ca:25ee:d633 with SMTP id t40-20020a056a0013a800b004ca25eed633mr1508200pfg.23.1643032427841;
        Mon, 24 Jan 2022 05:53:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x25sm15217638pfu.205.2022.01.24.05.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 05:53:47 -0800 (PST)
Message-ID: <61eeaf6b.1c69fb81.164cd.9cab@mx.google.com>
Date:   Mon, 24 Jan 2022 05:53:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.16-725-g30e9a00daffc
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 190 runs,
 1 regressions (v5.15.16-725-g30e9a00daffc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 190 runs, 1 regressions (v5.15.16-725-g30e9a=
00daffc)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
asus-C523NA-A20057-coral | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.16-725-g30e9a00daffc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.16-725-g30e9a00daffc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      30e9a00daffcb28e50c83beae6107671213b36f0 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
asus-C523NA-A20057-coral | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61ee7893f7a7120738abbd15

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.16-=
725-g30e9a00daffc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C523NA-A20057-coral.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.16-=
725-g30e9a00daffc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C523NA-A20057-coral.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ee7893f7a7120738abb=
d16
        new failure (last pass: v5.15.16-717-g26d8a22a9267) =

 =20
