Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F64665DA4D
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239863AbjADQmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239577AbjADQmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:42:23 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53221A071
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:42:22 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id c6so3191823pls.4
        for <stable@vger.kernel.org>; Wed, 04 Jan 2023 08:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=G/eFuagx8s2X10GPplSCDwoL0shd6Ixyt+OYcqu+UDU=;
        b=q73HH4RpIryE3oogpK+9FMSAV/SD8ur0EJ3Atn3TzFV4HgwjiSieVLYLtO9dKz0Ajv
         DwuOhIElbj+Ao/QyeCygYmWSoHeTth7kqlEIOxLwHLihb0zeRjxMhBD6GVocqn/vG+Uk
         P1gQQkMWWsJkZSp1tJPZ2Cvv8f+g7CvAO6iZyGCR7JKmD81mnQje9LFm2nntB3to7/IB
         LgSH2fHIYxCHkvHBd1522kP7jKZMpOrY+SZd1iSMhJ9kHZYBtW75JbZ+41u+RCv8GcGj
         0lHqwucMRASpPWsYhOs7GnfofQp7j1cdYxaZyQMSYpWrNoUDmalm/fKONx7g6kzGzIMm
         Nt+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G/eFuagx8s2X10GPplSCDwoL0shd6Ixyt+OYcqu+UDU=;
        b=XrwkNIHKiHoJwVh6a7le4dXliSyC5DH2QKrntoyX5TY7quHWrfbhp9Ugx0Kepv9NHY
         n7SbKmU5QN/8HuxT4pHlESu7Xp8Xr9o3CFUX0iYWy9q4e7IazgCDF55j9LLnzGXcCuNq
         FSmbz3ODIaRpm1jziup0Dm3uEOfWYaksuWDdcNnIl6OO7bSIjNmQiP0atDHdfGS4tZB8
         ldII/M7HZpS58hFebIdLpSj29Cx6DmBfiasy0BDIF4AAJm+FRR2OCAduaK+2sLbyEFck
         XIbZMHSRag1hERSzl7HjvYV1+IiMuA372MWtJ6/XxucOfpsZ/gg3Ih/x3E+KEJxmESik
         QQzA==
X-Gm-Message-State: AFqh2kqbXE2i0YYbEzDWNsEuzWviLLzqtNthRRLKUJ5UoMGS1ijY+oVS
        J/CNG7DR5Y2MdGHotxrLYCd/UF+Mh2Vd5YjgM9bUgg==
X-Google-Smtp-Source: AMrXdXt8h9PCBwWAv4Zq1HDDQ9Z/cYv9OefQW9y8zLLQxyhLciBWRWnPsQARe8gTfe66mQ7hLTqeUQ==
X-Received: by 2002:a17:90b:796:b0:219:5f68:586e with SMTP id l22-20020a17090b079600b002195f68586emr50049332pjz.18.1672850542008;
        Wed, 04 Jan 2023 08:42:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n8-20020a17090a73c800b0021e1c8ef788sm22816146pjk.51.2023.01.04.08.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 08:42:21 -0800 (PST)
Message-ID: <63b5ac6d.170a0220.5629f.43dd@mx.google.com>
Date:   Wed, 04 Jan 2023 08:42:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.162-600-ga40448b88ea7
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 119 runs,
 1 regressions (v5.10.162-600-ga40448b88ea7)
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

stable-rc/queue/5.10 baseline: 119 runs, 1 regressions (v5.10.162-600-ga404=
48b88ea7)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.162-600-ga40448b88ea7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.162-600-ga40448b88ea7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a40448b88ea73570568f2915e1305a4617050adb =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63b5791bcfea6256204eee2f

  Results:     17 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-600-ga40448b88ea7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-11A-G6-EE-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-600-ga40448b88ea7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-11A-G6-EE-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/x86/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63b5791bcfea625=
6204eee42
        new failure (last pass: v5.10.161-600-g944c1710b080c)
        1 lines

    2023-01-04T13:03:17.288264  kern  :emerg : __common_interrupt: 1.55 No =
irq handler for vector
    2023-01-04T13:03:17.298315  <8>[    9.951453] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =20
