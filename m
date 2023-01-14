Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD5E66ABDF
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 15:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjANONW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 09:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbjANONW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 09:13:22 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8747EC4
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 06:13:21 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id v23so21264444plo.1
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 06:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=lDrNBI68xSz1cwNCjNdmIsNxDx9PHJVKj5nxjcmoF0o=;
        b=suuL71pgitLiRNIohgoIdIWlEb4GDMHAruZuZQzlSMUlFtbLyOHxe1KrTdPvT39GKP
         UbkVRndOsfuSIn7EzD/YYsHXnaPVnF4XVof2A8Mbu8qoWB049iQ8Maf2CY1iJTb92lTB
         TFVwVNW6OcZTS/84PT7/V/Bi0qoWXaWpJ0K19yO/EkQcNICgsa52w33T8sP7qB61zJD7
         OcbIxPSNgWI2H/wc+nY7uzC9nw7XXi9h9Hjm2ZrrL/i6YfhkEd+1ux5fKEjzd2jBuwPw
         mFh939y5NjpeoxP+5EF0SMXzGZNlsIrC7W2eyh5n+Vh/f423WqO0a/AWTNEOAx+fHcU7
         Iv4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lDrNBI68xSz1cwNCjNdmIsNxDx9PHJVKj5nxjcmoF0o=;
        b=RIT3VxIk2DS9NrcXVJhEu7xFxGi04MzcHLNdnuIN5Q28b540KGKfVU/QduP/8N4Lpf
         pjnSG2flqmZ2FD0MSSCkR15J/Ko6uEmuV9xBdcjL5v97OPDmeg8STcMSY8l8li5pthOO
         dyXAskSur08q30f1ZhjLJxSncsJf2qsB6IcugaZfTwycnqWCEklKrQtsGA2dfBskrBQE
         giDAb8/fNltS2v6aT+umnBxEzCq7vtjEuU+VrfKqIogZEVSEEiB+ceXwGhsGr9DED5so
         dJhTzYvWQNDtqHwoAtOknsleA1LFKLezR/v2X5ir3EBymruJit1RuPzwCtI6MhrqPX6v
         /eug==
X-Gm-Message-State: AFqh2kqnCemuY7bjgPPAby8bfKdzVaKqPoeez52FpdhZXO83hCeJuwOR
        Ttp8Q5HOd6mxQTctjQBKYyGzLBZsT0xuMeWnq+Ny1Q==
X-Google-Smtp-Source: AMrXdXu5HMqGlV7y2VVFcGgm6tmlAmfvtt0RyLiT5VF4tL+sPH3XUvYIuz6ssCVO++3HNElPB2tzvw==
X-Received: by 2002:a17:90a:f10a:b0:226:8efb:2ce2 with SMTP id cc10-20020a17090af10a00b002268efb2ce2mr14076888pjb.22.1673705600843;
        Sat, 14 Jan 2023 06:13:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r60-20020a17090a43c200b002271b43e528sm10098860pjg.33.2023.01.14.06.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 06:13:20 -0800 (PST)
Message-ID: <63c2b880.170a0220.a58f9.05a5@mx.google.com>
Date:   Sat, 14 Jan 2023 06:13:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.88
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Report-Type: test
Subject: stable/linux-5.15.y baseline: 133 runs, 1 regressions (v5.15.88)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.15.y baseline: 133 runs, 1 regressions (v5.15.88)

Regressions Summary
-------------------

platform                  | arch   | lab           | compiler | defconfig  =
                  | regressions
--------------------------+--------+---------------+----------+------------=
------------------+------------
asus-C433TA-AJ0005-rammus | x86_64 | lab-collabora | gcc-10   | x86_64_defc=
on...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.88/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.88
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      90bb4f8f399f63c479c188f3771a38e9a42791d9 =



Test Regressions
---------------- =



platform                  | arch   | lab           | compiler | defconfig  =
                  | regressions
--------------------------+--------+---------------+----------+------------=
------------------+------------
asus-C433TA-AJ0005-rammus | x86_64 | lab-collabora | gcc-10   | x86_64_defc=
on...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63c284cbe38efa8d1c1d3a02

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.88/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C4=
33TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.88/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C4=
33TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c284cbe38efa8d1c1d3=
a03
        new failure (last pass: v5.15.87) =

 =20
