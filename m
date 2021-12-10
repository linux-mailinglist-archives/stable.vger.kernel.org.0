Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E86C470BE4
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 21:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbhLJUiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 15:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhLJUiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 15:38:52 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B725C061746
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 12:35:17 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id l18so4307045pgj.9
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 12:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+nSYPiBhjgdlyPZxwbjRYt/GX83miPgAoJdfVb3FOJs=;
        b=isYu+DsBnAflcUJF2nhxFrxGjFLdEAfX1geKuwvs0oROl+rPxRd7i5ZFawIY3LrJ5c
         rRgZlJeVbVjJiYF8HP5shZodpAlnalCT150AY3nnII+Wyg5MLl5iW5YU1SYULxW74bqR
         WtWGOJpsBIjXGFwo999JS2nb3Lv3WKwPgdOS+5gmFpOz5keRMinELoezMOjHTl/h7Hwa
         0XOUc8xRQgjVMb1w+yATtRDJ1xzplZ76ehijtj5pBIVqkas+WK8p9BRe7K4Yh7F60zik
         4EHQ6GMQfmkBdh5HEceI6c3Ta0eQqi9HGBzCpSngoTnaCp9twGuL5xjTgdhZ//q0o39t
         aJng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+nSYPiBhjgdlyPZxwbjRYt/GX83miPgAoJdfVb3FOJs=;
        b=BLLhPfncWu5zLaqMBlbFEhnIHv3TjJEkrfHwM/HYeLoaNVzUsCfdsyvokFVw+oFoeT
         2jPmuJuLbo8nhq0m0GkbfCT/ilUS0OCIhJQEs4UT5Ol/ToZf4lurB1lTaYJMyfZ8fYUn
         aPfj90GqL+PSmb6CMtk4v1xq7+Aa6WUVdIE9JWOaCsxQThalXrLAOTJF4z5zN60tJ4ak
         YDgr9JFCZQaSOCkMM20rr5Ttj7LO9v6nUPmMWBYMfvtc6bDLw2dHekFBUFRT4uMtarFy
         awGZop6KeTPYPcQNJnlSzvT1xUiJQpskv3PQUiTp0DhbmKyntPyP3SjWX/s4iEX0lNaQ
         vISw==
X-Gm-Message-State: AOAM532t8uXiLeYJDVrDOmnih/EUCoso5EviX1/bWU13msEDkVC0V+Xm
        K1/BY8xqPEZje0IIyV8Vx7xvEDiNnihx+A0M
X-Google-Smtp-Source: ABdhPJxKY8hr1LrbZpPPWEaEftLO0VHSbQXr3XkAmopAQl0Ilzh1uBqEblDUaLJJk8OtiXwCdgxhRA==
X-Received: by 2002:a63:8ac4:: with SMTP id y187mr40363260pgd.462.1639168516355;
        Fri, 10 Dec 2021 12:35:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e15sm4121742pfv.131.2021.12.10.12.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 12:35:15 -0800 (PST)
Message-ID: <61b3ba03.1c69fb81.3189.c918@mx.google.com>
Date:   Fri, 10 Dec 2021 12:35:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.164-14-g24c6106b1b09
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 198 runs,
 1 regressions (v5.4.164-14-g24c6106b1b09)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 198 runs, 1 regressions (v5.4.164-14-g24c6106=
b1b09)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.164-14-g24c6106b1b09/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.164-14-g24c6106b1b09
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      24c6106b1b09f0c4fbcab17317222624d556bf42 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b37fd0a41f52179b397132

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.164-1=
4-g24c6106b1b09/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.164-1=
4-g24c6106b1b09/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b37fd0a41f52179b397=
133
        failing since 0 day (last pass: v5.4.163-72-gfda44f5f463a, first fa=
il: v5.4.163-73-gf01a13d9c502) =

 =20
