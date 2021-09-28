Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0A041B7AF
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 21:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242415AbhI1Tk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 15:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242394AbhI1TkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 15:40:25 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222FCC06161C
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 12:38:46 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id x191so168292pgd.9
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 12:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aCt0wRAhhhF29okwjGKWLU7z1zeU1z+PDsgVblEp4n8=;
        b=iWvzhu8V5CgEjPtaD4b866kWV0u+5+dK+lIBAR2GSWLLbc4AIIgDWr81LmqTg/2FB8
         KjO+b4MufkAvmQVfwm/VzprZaYWb3B1FwgV8/ikrlZ2qmvdCZRr/R4ebw6R2T2PzCeii
         ihMRnA4N1AFEwur/Qkg41NlA6aTTyLswHxGegoNwVJR/P9Vmcb17BSNKpKzAIAq/Wo44
         iPh1419TOvSVz1747C5wBYQHgzjqnHxLmrP+/AmSZhl91FzldIfEUMZ8j9wcUVPYBsWw
         hHRkxBycJtaHkNCd965JVS5WcfA/3Lr5iXyQcJIixdfcWyk0qEHGFd4Y/tGwo5iMvjQi
         raxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aCt0wRAhhhF29okwjGKWLU7z1zeU1z+PDsgVblEp4n8=;
        b=aIiH8YQzQk1cJOE7ob8T19UWCdm07bZvj9MkdVVV7fcXcclGVUnVaYW00LmqkeY7kT
         HbY4U2vxYv/4XUtFd8nZBS7ODXO0kB9GrN078Y93XL5grozCzbvDVm3M1AMIAUPqf6Xr
         3otSaTYhGVBHpexdhWXzS5eT5466YzwWphSK61TkWrFtl4oDyx+7YwYfNfpcaub3FIgC
         g0qCX996+Lgwr4ARo+JaLNliuk97YS+4b7DClLQ3ekHmCRgJDLNzzJkDdA7jK6vXG6uv
         k2lZ14t9B7JJmrz/mMK58vGe9jSEWQEzowqIn7rD6/nga9g0dSODRC5y5rRbpyiUrqlq
         DlMQ==
X-Gm-Message-State: AOAM5319CI3IbOmy791v4J6eFm1w/pS2PdTpnjqjvL4LC1+nyADT4RmO
        8vhIxp7FAcIP/BOUSJ3hcGi5FMcAvE+uqhgo
X-Google-Smtp-Source: ABdhPJwYtmod2Tcy7JKwlEwfpGi6SKSuCem7qQTeuWK0UweJ1cM+v0aVB7XQE61aTt2rwNX7Le2Q9g==
X-Received: by 2002:a05:6a00:1142:b0:43f:75ae:5084 with SMTP id b2-20020a056a00114200b0043f75ae5084mr7268423pfm.6.1632857925549;
        Tue, 28 Sep 2021 12:38:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id qe17sm3690905pjb.39.2021.09.28.12.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 12:38:45 -0700 (PDT)
Message-ID: <61536f45.1c69fb81.fa27b.b5d2@mx.google.com>
Date:   Tue, 28 Sep 2021 12:38:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.8-160-gc91145f28005
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 98 runs,
 1 regressions (v5.14.8-160-gc91145f28005)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 98 runs, 1 regressions (v5.14.8-160-gc91145f=
28005)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.8-160-gc91145f28005/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.8-160-gc91145f28005
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c91145f2800552fa057a7a1e36d49ce5870c69cb =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/61533abbbbd72661bb99a31c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.8-1=
60-gc91145f28005/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.8-1=
60-gc91145f28005/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61533abbbbd72661bb99a=
31d
        new failure (last pass: v5.14.7-248-gf2e859a1e522) =

 =20
