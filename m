Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 883E326D180
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 05:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgIQDSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 23:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgIQDSA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 23:18:00 -0400
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 23:18:00 EDT
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A396EC06174A
        for <stable@vger.kernel.org>; Wed, 16 Sep 2020 20:08:32 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id bd2so349970plb.7
        for <stable@vger.kernel.org>; Wed, 16 Sep 2020 20:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OfojrTsM8t+ieXZkK8ZaxAelPTtGFUrjjU+EBcHGWYE=;
        b=LAf8SE/t3kWf3xrVDmDcmTL6A4urIAq82dzIpOczY6y82fMzk7la3Weuz/xA3OpJ0+
         poBAYVtKeNaFF8nq/ozsVJ78P4E6CrNiMkwNrQsko9WqMMPsPWisDGr2njDUS3JcxAxf
         TRdNuGcy+Dcy7TFMo0L5m4ZkqSBjJ0k12lj0ry2PhXXQNCu8IcPzxMgWt9OOHoObHv10
         lIdApQid/6EcVGuj2wxRKmbQYTqOrsMOiUijpAeSh8FT63UEyIv6M0AcvbepX6FhgQD/
         0DUtZWjOruwCRadUC9Ef9mUOF4xft+bnPRY/y02OWsHgGJztyph7chgX1gcGr3Y7Hpdw
         UJCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OfojrTsM8t+ieXZkK8ZaxAelPTtGFUrjjU+EBcHGWYE=;
        b=mvh/cDUDc5AEqeM/FeM9aVo141wDB2Il2N3RTMEk25wIAfvBFAan1dAPfP6EqnUao3
         jFtRXKPEp+TsqKPF+ikB8MMOzGzVQLUNJ3R9h6HTG84SzvPzeD9xDLHgMIl71LApJwwe
         rbiIl3yvKOS8S5juZoGuSfwcGmS33mHP5OJSlFBuB4PfeGRgDdQF7qev3kGzvarcmzhe
         LspesY1ugYAcriYOufBKlhtiS42DGJYOQft720OudAASY6cIbpSGvj50ZUsLLFc+RWXn
         0nqV3rxpe0/hRQ49EM6jgU2WkeFYoLEhU9T4s5jrSODMGGCUTIM87xvCL6m4dYkmBGTa
         u3yA==
X-Gm-Message-State: AOAM530XDQ1AH1ZoxJKhGf1MawN+Zte4AwfLW9edYnNHd/mDSW8mHli9
        DkwfAwtNPlI10homevnmd9uAUoMF8RnUEg==
X-Google-Smtp-Source: ABdhPJwMnTiedduyUM2JpIoeGNcsZRcxDlv8Wb7g5vIfHYeN5OSmnq7bkQ1vyF+dF2SLYxJarxvAfg==
X-Received: by 2002:a17:90a:8588:: with SMTP id m8mr6238139pjn.91.1600312111175;
        Wed, 16 Sep 2020 20:08:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v5sm9499726pfu.151.2020.09.16.20.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 20:08:30 -0700 (PDT)
Message-ID: <5f62d32e.1c69fb81.fd5d4.710c@mx.google.com>
Date:   Wed, 16 Sep 2020 20:08:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.8
X-Kernelci-Kernel: v5.8.9-176-g65d077c9953f
Subject: stable-rc/queue/5.8 baseline: 197 runs,
 1 regressions (v5.8.9-176-g65d077c9953f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 197 runs, 1 regressions (v5.8.9-176-g65d077c9=
953f)

Regressions Summary
-------------------

platform   | arch | lab           | compiler | defconfig          | results
-----------+------+---------------+----------+--------------------+--------
odroid-xu3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.9-176-g65d077c9953f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.9-176-g65d077c9953f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      65d077c9953fcbf4a35b3dbd3adbb1bd2f4cdd4d =



Test Regressions
---------------- =



platform   | arch | lab           | compiler | defconfig          | results
-----------+------+---------------+----------+--------------------+--------
odroid-xu3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f62b0a0dcd79da3b8bf9de1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.9-176=
-g65d077c9953f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-odroid-x=
u3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.9-176=
-g65d077c9953f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-odroid-x=
u3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f62b0a0dcd79da3b8bf9=
de2
      new failure (last pass: v5.8.9-177-ge7db568011a7)  =20
