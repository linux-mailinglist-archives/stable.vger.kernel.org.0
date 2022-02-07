Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16FA84AC887
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 19:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbiBGS2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 13:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235801AbiBGSWS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 13:22:18 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312BAC0401DA
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 10:22:17 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id e28so14426650pfj.5
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 10:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gh80uHYFDz0y2snLPTWdpopfP6CgwtGVgMgyXa/bjpw=;
        b=7CNVYkxT3fdNetgDp7g1CZNYKcvDtlF1w1c6kSo9CysEMU4PsmWQ1jMsIQ9ry8m4qf
         g46Nev5RmnFXvNmmjS/AnaZUzPgEgETw277NtsSpdVRfOOEkZTy4dUWQG7f55ztlR0om
         UUwrxtYFihXZI35Bjseo3GxyCP9p7/bBZJ7m1jJgTX3Wv8mTGzJJi/KRzm28EstRQrRw
         0epbvjg4WQZkk4XCyLXUaoi8UQJmbxDlLGlPua8z3GDJECg56rDz6FueZnmbekmHgcYl
         77npdF8jWr3fbniCdiIej8BILMQK6OlB4Np03y4RO/LymaxnG1fbIXqsbl8jKH65hwkd
         iJgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gh80uHYFDz0y2snLPTWdpopfP6CgwtGVgMgyXa/bjpw=;
        b=s1bkqNzvEeN9Xoj/76By/DTtU5nRpq1sTpvmQB4ywUibmJXzm4Cy6mq1+45l9NVT9Q
         Sv8yty3rAH8XfPzuPij63awcg+67GB5HCz8RWAP26vn0bFryPCRAdkbnSR4hQ05QgRZV
         86FN6p+6NXXjCVkHbHhah9iGDz0MkUMO8AuSNH3KEm7c1nO/UronUqyM45YuwToJBdWh
         iI9wY8iDiAJPymJKlg/z4qBD19NwJczRTpyeE/6Nv//dv6tdbODnHWKcLocy6rUWzkvE
         74nNbjpSCLZHYB+wQ9xGw3BmPqlpPB2LtCXto+siTYr5+Qc5BDp9JFnvXO5Zz9Rj4anB
         aoIQ==
X-Gm-Message-State: AOAM532rxJeonw7Kvupjy2JrKtvgCktOhhoO/tWr6V5NH0/TAF9AFNXT
        Jo5PvZlWJZkUAvEhO3Wa0rgwx+TUFCfI5+7w
X-Google-Smtp-Source: ABdhPJx6c6+ChpIiEF3G6f0nRLoediycYICXxIQ/0MS0lH8y1EYgXoKDscnS6AJ9DAZ48VV+C8xikw==
X-Received: by 2002:a63:d00f:: with SMTP id z15mr515966pgf.153.1644258136470;
        Mon, 07 Feb 2022 10:22:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a71sm8817016pge.12.2022.02.07.10.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 10:22:16 -0800 (PST)
Message-ID: <62016358.1c69fb81.d2e49.5e3a@mx.google.com>
Date:   Mon, 07 Feb 2022 10:22:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.299-49-gfa39f098578a
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 89 runs,
 1 regressions (v4.9.299-49-gfa39f098578a)
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

stable-rc/linux-4.9.y baseline: 89 runs, 1 regressions (v4.9.299-49-gfa39f0=
98578a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.299-49-gfa39f098578a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.299-49-gfa39f098578a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fa39f098578af99470f3762bca8001c0db1c3335 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62012b3d38633d41455d6f0e

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.299=
-49-gfa39f098578a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.299=
-49-gfa39f098578a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/62012b3d38633d4=
1455d6f14
        failing since 35 days (last pass: v4.9.295, first fail: v4.9.295-14=
-g584e15b1cb05)
        2 lines

    2022-02-07T14:22:28.899756  [   20.037414] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-07T14:22:28.946427  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/126
    2022-02-07T14:22:28.956011  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
