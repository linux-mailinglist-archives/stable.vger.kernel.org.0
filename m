Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028A4608E56
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 18:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiJVQEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 12:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiJVQEp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 12:04:45 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22AE15A1A
        for <stable@vger.kernel.org>; Sat, 22 Oct 2022 09:04:40 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id m2so883662pjr.3
        for <stable@vger.kernel.org>; Sat, 22 Oct 2022 09:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=yqhupNfqv6LEoU+BjiKBg0Hjxc7Az4zvDfwFAnMHe80=;
        b=6JLyLJGCf4aSlJ0QWYRxlCq2Z7RGWYOsa9sST0FsmB98X1BvXyT/0Y/N9oGTlWqLQc
         8bKsInqofAGaWqNZaap+fbs79Te83ZFVl0OcMHjNd8CYIhdt8pIPDrSGSXB7ljAcAQ5S
         accYce95IwlrHYwsfT33qZIWrIzOWjzuWID6XRvYrYTm65I94fVb47NkVzL/tiDOkGeI
         ekdRTBZRYqhz+/AHp3xO7rUw7Fo+G4JNrrwIIo5xPbAHrV73eVlZMZ/m8QmRHAa/ebEa
         wF9hG4ewdYklbLDMiIOZY+gHifwFQzHAeqjInm89XNqRYAsL6iFBfCeUVmW2OPF+rbzA
         GqAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yqhupNfqv6LEoU+BjiKBg0Hjxc7Az4zvDfwFAnMHe80=;
        b=QKkw+r7fCB2s/BbOpn+fcAtoVlURjPsvLEQ+gkb/fqy0p5pKHQDdnM+lajlK5HA8xI
         LcgiaLNODFCQV5F8uY2AmK53jSPjPAZ+6/jKlr+rWQzfzwE3c1LHcsWm2Qc5k0G7YmHD
         QMecgx0ojk6DGub60Vm9ieE2ti6JHc8BMn3pBzj3ilvs+YcASKbRMPFr87zhi2zLYoB8
         TsZ/pANVUSvPqSOBafNmrBe6Kxy+wlqGG4za3CssU1GDDgZg+g2gTDHWqhPH9tD4Zn8C
         hhL9XymfUg27t7EGj7bLedsY3UHOgzinLOD79cn1jfs0Z6tz++p/KtDR+FemczFzmxfn
         gigA==
X-Gm-Message-State: ACrzQf1LJaZtSq2Xu1V39oqZcMkYRiyoZdqfJ1C8FT5to/p/3x9h81ch
        mpEnjnQQl0jZ+OOGW6BJLpdBMgRvRaMeg8pr
X-Google-Smtp-Source: AMsMyM4fmO2AimP2nF84UUQyqWvDJYC3+IViph/HSa9sBMKWqIfabBZmfgq9UA9k33pyAd8ZLBGcbg==
X-Received: by 2002:a17:902:f706:b0:184:7a4c:fdd0 with SMTP id h6-20020a170902f70600b001847a4cfdd0mr24608763plo.98.1666454680131;
        Sat, 22 Oct 2022 09:04:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f6-20020a170902684600b00177f82f0789sm5675924pln.198.2022.10.22.09.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Oct 2022 09:04:39 -0700 (PDT)
Message-ID: <63541497.170a0220.7a92c.aed5@mx.google.com>
Date:   Sat, 22 Oct 2022 09:04:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.16-718-gb0c2a34d484b
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.19.y baseline: 146 runs,
 1 regressions (v5.19.16-718-gb0c2a34d484b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,TVD_SPACE_RATIO
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.19.y baseline: 146 runs, 1 regressions (v5.19.16-718-gb0c=
2a34d484b)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.19.y/ker=
nel/v5.19.16-718-gb0c2a34d484b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.19.y
  Describe: v5.19.16-718-gb0c2a34d484b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b0c2a34d484bc2819f59332935fd31bc30ebfbba =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6353e2cb0dbb3dbfa75e5b42

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
6-718-gb0c2a34d484b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-sc7180-trogdor-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
6-718-gb0c2a34d484b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-sc7180-trogdor-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6353e2cb0dbb3dbfa75e5=
b43
        failing since 4 days (last pass: v5.19.15, first fail: v5.19.16-2-g=
6f2c61ac925e) =

 =20
