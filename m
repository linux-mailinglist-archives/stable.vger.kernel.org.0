Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 179D8526D85
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 01:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiEMXaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 19:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiEMXaC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 19:30:02 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB93F349137
        for <stable@vger.kernel.org>; Fri, 13 May 2022 16:29:36 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id x18so9328122plg.6
        for <stable@vger.kernel.org>; Fri, 13 May 2022 16:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8E2BXIzByALIAAbWqEoSkg4WPT5HfF46ue0Dw5pW4jg=;
        b=qj/Y6E2j0oCaO16hzt0WQcsz7KYGVYWGM/iV+rTQYYm2PmGdkxZ1JOVghT/OTu8Yze
         5GYZmJRrlR0EZbd8M95wM14vJQIRIgcQGMwSXvYwb2iWm/4tJZRBd6G+fbmQbspJKF+A
         IVfO5w6zDuvniNm9j6f8QYCvpV9zu3x4vSRXoXVFW3x17/YznMvJCtJr9t0r1Hbhwr+l
         cnHUAeyPtb97Z/nVCB2634kjAVinlkiS+bTiRnx3sIjtdA8Xp8oxetfcRNXX5SBlSGaF
         GQEpgGQjQN25Aikky54+7474C2V4p5iKClTkBrcmgnB6iqoCAgtP7AB6MhYicgyHagQB
         dFiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8E2BXIzByALIAAbWqEoSkg4WPT5HfF46ue0Dw5pW4jg=;
        b=WM7JSyV047uTt3SlymZSGLGoDGRPLYMx2+rTkz8mXmJjYquPhgLEdsJl8j0Co5kqFJ
         n6PCOT/MtJ2yDTDWh9NUpuTdWe2pCLkt1I0nkge39FwXnJ/yvGxWY5ZhgSo+9LC1qJZx
         1G2yb1+KRv6QARrnuZwC2oLXMzMensdDUEy0EdfqP2DtHYRrIuZsV8sVrMndxtSZRTD/
         UfI/eQZVah717ARw98Rc+XqqmgnGk2B9f1C3l+RMgP97qfwf9ylI4UCKzpIB0xBO4v1v
         5YNJYs7pw4rXXlqzgdXo0QHUDdi5ghuCBAksWbkT/3pnw6mVkS5FhxmQs9xX6BmX8kL8
         y37w==
X-Gm-Message-State: AOAM531tMBMx7OQ7NxP6y0rgt1wXjxuTOhDqET4HA1ZkengMCQW05vXZ
        xSe/TCCyL5/y6RDtA4DZWc1IjU/D1cmavdMZ3yI=
X-Google-Smtp-Source: ABdhPJxu9a6DjhmqrhEPNg6nQCu3Qyxjd2ZnDDs2x2iaD0hP4wd0PrhiUyacZpj609PF5LfaGX1QbQ==
X-Received: by 2002:a17:90b:38c3:b0:1dc:b8c1:d428 with SMTP id nn3-20020a17090b38c300b001dcb8c1d428mr18309694pjb.55.1652484576235;
        Fri, 13 May 2022 16:29:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s16-20020a63f050000000b003c14af5060fsm2144854pgj.39.2022.05.13.16.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 16:29:35 -0700 (PDT)
Message-ID: <627ee9df.1c69fb81.ebd25.5b49@mx.google.com>
Date:   Fri, 13 May 2022 16:29:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.17
X-Kernelci-Kernel: v5.17.7-12-g470ab13d43837
Subject: stable-rc/queue/5.17 baseline: 160 runs,
 1 regressions (v5.17.7-12-g470ab13d43837)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.17 baseline: 160 runs, 1 regressions (v5.17.7-12-g470ab13=
d43837)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.7-12-g470ab13d43837/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.7-12-g470ab13d43837
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      470ab13d43837f573e74574f1d2512453ad93d79 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/627eb9591073faa61c8f5745

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.7-1=
2-g470ab13d43837/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.7-1=
2-g470ab13d43837/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627eb9591073faa61c8f5=
746
        new failure (last pass: v5.17.7) =

 =20
