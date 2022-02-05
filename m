Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D144AAC71
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 21:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381190AbiBEUUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 15:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241319AbiBEUUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 15:20:01 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F93C061348
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 12:20:00 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id my12-20020a17090b4c8c00b001b528ba1cd7so9456438pjb.1
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 12:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EAUgNK7ekjec7CceJroZ42Wjgr9hY68GEIZh+UReRu4=;
        b=c86KtZ2mYDlIvnkQUqLyvrUdhQkb5ZeJDNB/VtLRIcOWLb8C8J0mvPh7fnfXxVzAHS
         E4srizhrGRbbU4iJTI5AlHvZh7TMmwPD/ZQBpgnAHX5bICbdRzuqs5DUjTcGaYfVPJhD
         9vKG0ThchK7YEUzisaIfYzmUgEyv9+UD/hYK+Oxr1E+8HkxEZ2VDc2l6bi9z8kFgvFBC
         EOb5wBxUKhZ7jkx9KbfHH9tumtfFPsARWZClKceLT3r9kO+Jc3l5AVCg0/DWPmT09t4m
         oVNR5YIhB+Wa63C9OINI6XeQDKDKHyuLp9HGaS+Ug6kTgvSIfr+tgID4YA1C7KJckp6X
         OXlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EAUgNK7ekjec7CceJroZ42Wjgr9hY68GEIZh+UReRu4=;
        b=yFuExIJiWBORtDBCaPjQeQ7S/gza5Bxon4Cj5QUHGgzK3LfQD3YF6sucewA2UBpYKF
         G9C58uMGRDc9NMLtLpzTAF9nAFkvATg3UW461ShQ3h98nXrE9fJ8bgnLQBHh3Lq/eGLm
         49h4E64P5b7ci4OVKCCvPbsyafv+8q+znkgBuxM9pRQnYqjEq5zk/3eSdTzMb4fx3DQO
         J4Wt6AOQ75QoMkmRI9w9iwKywbrcEWGU4tzpkT2J4njLmqO/uFQMHFR18eUeIl23uSE0
         Z5AOwlko9GwR4Br5UIGYUssr0WlBwRd70CoEV4Q8eon/Ogm8kvE1WkNJ/v7qTwgb+HXK
         53pw==
X-Gm-Message-State: AOAM532DWtfS+/wjDEaqZGTzWABk1upU66xU0yx1anFmEGuQzbfjXmZg
        E8IOBHB5KJXppOu7jWOCvgO4ujp6hIEermug
X-Google-Smtp-Source: ABdhPJw7nRv0ESVyuB09XLN3x+0pejumI2y5N46oBcEDFx9tqTuA/Otuhe7hw73Djl6METjxdLQTqA==
X-Received: by 2002:a17:90a:8592:: with SMTP id m18mr5925226pjn.142.1644092399750;
        Sat, 05 Feb 2022 12:19:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f64sm6601539pfa.165.2022.02.05.12.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 12:19:59 -0800 (PST)
Message-ID: <61fedbef.1c69fb81.a7d43.14eb@mx.google.com>
Date:   Sat, 05 Feb 2022 12:19:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.19-69-g4b868638972f
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 157 runs,
 1 regressions (v5.15.19-69-g4b868638972f)
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

stable-rc/queue/5.15 baseline: 157 runs, 1 regressions (v5.15.19-69-g4b8686=
38972f)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.19-69-g4b868638972f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.19-69-g4b868638972f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4b868638972f6547710e6391986685b97be92dc6 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61fea0f86183c6d3f45d6f19

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.19-=
69-g4b868638972f/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.19-=
69-g4b868638972f/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fea0f86183c6d3f45d6=
f1a
        new failure (last pass: v5.15.19-33-g3c0633f6c3f0) =

 =20
