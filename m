Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C774CCCB7
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 05:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbiCDE7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 23:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiCDE7N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 23:59:13 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEFF4551F
        for <stable@vger.kernel.org>; Thu,  3 Mar 2022 20:58:26 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id ge19-20020a17090b0e1300b001bcca16e2e7so9705009pjb.3
        for <stable@vger.kernel.org>; Thu, 03 Mar 2022 20:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=M1k3gSuB3si3kA9NnusEe2tnlJbXbB82C9oO75bxFBc=;
        b=MXi7MmXmiX2u6Z3yoEemN0GRtMsy7rK9p08y5GeuOFZfJgSmyOpqHjCa/Lx0Ua+aWw
         IYtv4LOUykPJFy0r1Cn2h4nGyvfORbjo/9eIoFJ10+Sbh2SiAH7F6BPp5RJ8KqWy8e7M
         mTXGgPNSuFzFZ5sioT6pur0h9+udNplTcO8MIyfPZDuPQE/CpInlDi8L97W+os71NZwf
         Wyj4kJuj0TSbtpezluJuO2L/qGTUHVQczP1lUgIRKbqfKMOuaEnt4ZvWHmyvXtw6Og+X
         hhGfa1cZtmlASb7g+A4ns+TRdrAkO/8fWLvskQ5xVzjMhaWnGOU1MEYec9OnE0TNkZvl
         QhEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=M1k3gSuB3si3kA9NnusEe2tnlJbXbB82C9oO75bxFBc=;
        b=LiUmwVSSWuZSYv4CJwSByp6iEfNNQqzLBZaVJra5PYoXod0QRSZNiqubESDa67tAT/
         2vTto8aVa8giDERSPX1fTfr63a7amDqMxOUtzavFkP88ZTow3qBEFLt9LFi87VscQwQU
         1RqFknR8Xob2g2IqSbADnyYghrqYb+kgnx2l7a2RSOpybxgrFv8gE8GOXHYLvjBUc4nz
         y4MDBwvUf8vJH+9ICVb2dgSJ8yiq39FU24LQJs/JHh2tysAvrbiHshT9E790h21WUPjq
         aPA6dmswE8CFLLsZonY91mxZ8w1AwxxJoLoXs40NYrDYpRx8sfHLCek4xdV60H1GQYzh
         YWQg==
X-Gm-Message-State: AOAM532o5w9skFzLIIMBrKn2EqRqIff2uAt24aeEIbnTbrRTKVVCaTRH
        QOZwX1m+2hlVRk7PRKrUxiWKqwdaJ5kD/AgXheY=
X-Google-Smtp-Source: ABdhPJxSmCobStvYQSVadYcLkPdlA459/TgoL5VxT/M58iqK607o4j4GSM0lPMLAsVbxMspnjgyCxw==
X-Received: by 2002:a17:90b:180b:b0:1bf:27c5:2c51 with SMTP id lw11-20020a17090b180b00b001bf27c52c51mr1409617pjb.142.1646369905791;
        Thu, 03 Mar 2022 20:58:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f6-20020a654006000000b00346193b405fsm3325474pgp.44.2022.03.03.20.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 20:58:25 -0800 (PST)
Message-ID: <62219c71.1c69fb81.4a3c8.9e4f@mx.google.com>
Date:   Thu, 03 Mar 2022 20:58:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.103-24-g6e6a2edbd4e6
Subject: stable-rc/queue/5.10 baseline: 106 runs,
 1 regressions (v5.10.103-24-g6e6a2edbd4e6)
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

stable-rc/queue/5.10 baseline: 106 runs, 1 regressions (v5.10.103-24-g6e6a2=
edbd4e6)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.103-24-g6e6a2edbd4e6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.103-24-g6e6a2edbd4e6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6e6a2edbd4e623d2c3551f8d0457403f556cab17 =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6221663d52dae84a19c62994

  Results:     17 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.103=
-24-g6e6a2edbd4e6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-11A-G6-EE-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.103=
-24-g6e6a2edbd4e6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-11A-G6-EE-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/x86/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6221663d52dae84=
a19c62997
        new failure (last pass: v5.10.103-17-gda6937c6cb24)
        1 lines

    2022-03-04T01:06:55.713643  kern  :emerg : __common_interrupt: 1.55 No =
irq handler for vector
    2022-03-04T01:06:55.723900  <8>[   11.221720] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =20
