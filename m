Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B8448EF98
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 19:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiANSCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 13:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244034AbiANSCw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 13:02:52 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB34C061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 10:02:51 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id n16-20020a17090a091000b001b46196d572so916564pjn.5
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 10:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fwHueT5/yYc+5pvjF/7yXQH/Mz4ZGJAz+tHlpldqN3Y=;
        b=rH+a2pKDaliQSska58ajMHWVz3bErShOrfojAAzcIM1LFQ4B5/tMRKa9WXBPloe8yY
         Dl+AO4cuxcJfvfD0Ufgod1VUKDdMAxZYWDbwYSDSw6SrnTm3wPk1B6+nVHkL14j7dPpd
         uIxUTRIeiREPj78iZsWkdPwdNu/IrmJhu8GMh2qiSren+0q/NH1c5O0ZWaR37pBYaeXz
         okiSvG+b062SXAx/cw3BZOcPZ+UN5KjnSoMVSshLCEif8X80SYP58VFUo3Kb57v7no/a
         uLtEIefGNwntjoK5u8bLzF/0aDv45lOmo7pc0EOwrmk1Cip5U/20mbhdmtyLEBdMncDY
         9lUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fwHueT5/yYc+5pvjF/7yXQH/Mz4ZGJAz+tHlpldqN3Y=;
        b=07pZ0Fn3ZlPXiUo2zr2ZLhzxn5ZyR9JM64f/g+cGFcHFby4Sn1iOH1E54S8Z3MdVd5
         svGJf/DC4QgIkmI3VVoR0qM1qXBiq0t8s6807SBwRzav7p7dLs3tJSDkb6toWfWFKGzf
         69akDgZmEgGqffjktZvOirBvtMGTk3/zeJP+Pqp8Bc41T9kVdVyxZlp2t3EOOGLYs2jj
         wcdbDfBmLBw8H6qG75R+znKbnHJDHJ8UAm68CdzyMHvyqK225Trd7nuJ7cdbZTwdgU++
         3goV42wxDGmqhEShQ1dZmU8p7OGhabzInNv7I0rlPoMPlnCnOUx7kxmoqDqdNuplYHrz
         oVeg==
X-Gm-Message-State: AOAM5337XnVKXwUBj+LTMwsk4oOI2442P5rw1RyNlg+0rq/Ksmx86A4a
        vVKxotBU1lr6JsNfBZwTBvWi1kKte970FCSD
X-Google-Smtp-Source: ABdhPJzUj4ptyN2sCslu09ykLwyzjVLsTFNPZgUMAdINLsxtPaXN1ej/BWCFt0XSje3jPTy1QDgCZw==
X-Received: by 2002:a17:90a:9511:: with SMTP id t17mr11995397pjo.173.1642183371304;
        Fri, 14 Jan 2022 10:02:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id pf6sm12336304pjb.10.2022.01.14.10.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 10:02:51 -0800 (PST)
Message-ID: <61e1bacb.1c69fb81.9f9bb.0115@mx.google.com>
Date:   Fri, 14 Jan 2022 10:02:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.14-42-gf9dc3f25c12a
X-Kernelci-Branch: linux-5.15.y
Subject: stable-rc/linux-5.15.y baseline: 140 runs,
 1 regressions (v5.15.14-42-gf9dc3f25c12a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 140 runs, 1 regressions (v5.15.14-42-gf9dc=
3f25c12a)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.14-42-gf9dc3f25c12a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.14-42-gf9dc3f25c12a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f9dc3f25c12ab4f1f1e691dcb48202fbf8d6226d =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61e181d937e2ceb243ef6750

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
4-42-gf9dc3f25c12a/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sa=
lvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
4-42-gf9dc3f25c12a/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sa=
lvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e181d937e2ceb243ef6=
751
        failing since 0 day (last pass: v5.15.13-73-ge8d40b0a7738, first fa=
il: v5.15.14-39-gc9df4d832e20) =

 =20
