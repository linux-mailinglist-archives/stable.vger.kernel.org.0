Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 445A1536498
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 17:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238730AbiE0PUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 11:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352407AbiE0PUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 11:20:07 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD97934656
        for <stable@vger.kernel.org>; Fri, 27 May 2022 08:20:06 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id m1so4418544plx.3
        for <stable@vger.kernel.org>; Fri, 27 May 2022 08:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NlBqOayUuPbtKu++rJLyPai0QUZs7e12fQ+/8q4YEqY=;
        b=7F3CVoT/FJcHQedHeRHiWvpHjAkKRgWG6cI9opi4f6Fpb2gsAyRHjIRb3yI/EzM1Ct
         bwXK7sazb6FY91Srtb6dmxFyGnccx+WV8j2EruOwkcFbBocXKVw/Xzo9D1qUjUv3+NRK
         mTRxl6YkZl99r//I4GrpnNBuDLm37R6X5yg9SsM4TmtALfTsRx1lBARhL/Jkk5Sw53wp
         uD6MHob9a47hH2nhke/gC+WPrsFy7WUFOnU8A/vFtiHD9xlnxpB4/Q0FGOXjjBxpr9yb
         AZQGQgRLiw5GLXrXBnnLhcvYwz7FaWUZaPms+kMYWmIALunse2nd8dzufb5GvnGcpro5
         4dGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NlBqOayUuPbtKu++rJLyPai0QUZs7e12fQ+/8q4YEqY=;
        b=AiN+lLuh+F0NadoSQAaHNAc8j539l6mlliHZOL41fNI4WLVLmlyZjhhXLWVfvecFMG
         wMHjvT1/GFFksxovUKFl3PhqQGwwI6DXLQJXyhQsF6Pfcqr0FrRpOqOPtIULNTbM/1kI
         5jgz+oev8tAEzfZ/qJUilwhBPHdfyZoTCvF1F4+kJKW5fBNCy9qeli6QsAhCj7h4KRms
         2ScbZCLrvotktWQWndxZpSot43L3BadEdL+0YWXOkb6cwTrqeVc8xtXr8Tup3DB0PTal
         PERXKLgx27I2Bi5G3ShYgoOa+n7W2FbXuX9UKRhX+Z2VGlIIH2OTNrIAAOJNtcymu7cS
         DXWw==
X-Gm-Message-State: AOAM530h+uHQqFT/PUgDcKVfO0S24lEtuAsoJeEdZ9oPx16U94E0T8Do
        yS9kvzGTF9dZtHAzoHvsC+u58uVrirhk7b9ceFQ=
X-Google-Smtp-Source: ABdhPJzVwaJ+Yx/2uTBtRLuK37qhgFWEeX8fYfmDEv/BZ6uAlVxHc8Tpro8nga4S+GHqOGcvgd9Dlw==
X-Received: by 2002:a17:90b:17c5:b0:1dc:e0a6:340b with SMTP id me5-20020a17090b17c500b001dce0a6340bmr9019557pjb.34.1653664806133;
        Fri, 27 May 2022 08:20:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u185-20020a6279c2000000b00518b4cfbbe0sm3643962pfc.203.2022.05.27.08.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 08:20:05 -0700 (PDT)
Message-ID: <6290ec25.1c69fb81.57b1.845f@mx.google.com>
Date:   Fri, 27 May 2022 08:20:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.43-145-g2d6e3434d25f
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 106 runs,
 1 regressions (v5.15.43-145-g2d6e3434d25f)
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

stable-rc/queue/5.15 baseline: 106 runs, 1 regressions (v5.15.43-145-g2d6e3=
434d25f)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.43-145-g2d6e3434d25f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.43-145-g2d6e3434d25f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2d6e3434d25f7cb7f7a805f1adcfae48225a5203 =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6290b4f3cd2dc0710ba39bdf

  Results:     18 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
145-g2d6e3434d25f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-11A-G6-EE-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
145-g2d6e3434d25f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-11A-G6-EE-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.tpm-chip-is-online: https://kernelci.org/test/case/id/6=
290b4f4cd2dc0710ba39bf2
        new failure (last pass: v5.15.43-144-g375b1504fe930)

    2022-05-27T11:24:03.160093  /usr/bin/tpm2_getcap
    2022-05-27T11:24:03.187484  ERROR:tcti:src/tss2-tcti/tcti-device.c:286:=
tcti_device_receive() Failed to read response from fd 3, got errno 14: Bad =
address =

    2022-05-27T11:24:03.193656  ERROR:esys:src/tss2-esys/api/Esys_GetCapabi=
lity.c:307:Esys_GetCapability_Finish() Received a non-TPM Error =

    2022-05-27T11:24:03.203515  ERROR:esys:src/tss2-esys/api/Esys_GetCapabi=
lity.c:107:Esys_GetCapability() Esys Finish ErrorCode (0x000a000a) =

    2022-05-27T11:24:03.209463  ERROR: Esys_GetCapability(0xA000A) - tcti:I=
O failure
    2022-05-27T11:24:03.210261  ERROR: Unable to run tpm2_getcap
    2022-05-27T11:24:04.205200  ERROR:tcti:src/tss2-tcti/tcti-device.c:286:=
tcti_device_receive() Failed to read response from fd 3, got errno 14: Bad =
address =

    2022-05-27T11:24:04.215182  ERROR:esys:src/tss2-esys/api/Esys_GetCapabi=
lity.c:307:Esys_GetCapability_Finish() Received a non-TPM Error =

    2022-05-27T11:24:04.225492  ERROR:esys:src/tss2-esys/api/Esys_GetCapabi=
lity.c:107:Esys_GetCapability() Esys Finish ErrorCode (0x000a000a) =

    2022-05-27T11:24:04.228360  ERROR: Esys_GetCapability(0xA000A) - tcti:I=
O failure =

    ... (43 line(s) more)  =

 =20
