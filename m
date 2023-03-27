Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D5E6C9BD2
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 09:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbjC0HSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 03:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbjC0HR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 03:17:59 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A494695
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 00:17:58 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id l7so6803785pjg.5
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 00:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679901478;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=H3UBW9lKs83weNx3nMhXXo/cnpI0K10x94J6rn49oWg=;
        b=OvOkTIGpH7HqY2umYHbEKbEl/uj83x1nYmWw4rDBU3yZkbK8gxMKm2Vt1aPG8eiPxS
         /K9VHYY1LEkhtDb+4aoDxzv/XSg+54M2t5Kvo8Ncspl9my05R/gF+lDOirGzfHU3QiK0
         qUIqMrscXSfT0PR6tjOsJqHZvSkT8vQtXd9nem7eQi614S+Wl7dJVHOvS1sOsmb6EFJL
         /4B7/b7WL1ftmsF/LNbCr6qjt6ESHUNKSsnSI7enzego62D15oO3QPttlBft13NkWIry
         7Jlv0JdAgxSc8sbJvdGLGOrPXzHFAzPza1gCHIH8ByCE8dOIAhApVVIMEAwPHQjMoRdA
         V3BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679901478;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H3UBW9lKs83weNx3nMhXXo/cnpI0K10x94J6rn49oWg=;
        b=58aSFB2AcAWZjS5k6s8wbVWBRCL87RWwZTH1m5qXlFqYMV7piX9IwPPrspKxKnrA8j
         SZJ2JpYVpAtD7SZhMEmgB/6MLNfotbUpb4Q3vApraKbt1ic3UDgsbVnd9KrXweAwg2Lu
         TRQTlggQxt0sAgtyA27+0M+wZ62f1jeqP7MEAIS6+SavRh3TYWLtpxj1RmREeIU25YY0
         fY93p048lDcqhyR1ckpFPTeHbK7sY/Vgfyolw+L9YFtt5AuNmLON+6ANE/M3IGXVa515
         OnOAqtJK2x6rfoYcW8TzjvVt4bixNn0HWmrIPF70vMdFq4heFcKQU5hdNbasFr3ae++0
         lgIg==
X-Gm-Message-State: AAQBX9f5DrRJYUmwcwdSHyKDWd67qtPEpE4LYpXoakRYz6uA2pFrdd+r
        6uOrgnB1dsbiaBIyoOsfNNOQiYfBH1fpvn6QLh4=
X-Google-Smtp-Source: AKy350ZNxdvnAuQDGaWchuMUrPPzfpZ2KRpV13EZrNeBRjprFwoyiPzJU0SFBghGPbImdtXCIX5/oA==
X-Received: by 2002:a17:902:d48b:b0:1a0:4046:23f2 with SMTP id c11-20020a170902d48b00b001a0404623f2mr13117817plg.56.1679901477632;
        Mon, 27 Mar 2023 00:17:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bj4-20020a170902850400b001a076568da9sm1363595plb.216.2023.03.27.00.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 00:17:57 -0700 (PDT)
Message-ID: <64214325.170a0220.59a83.2305@mx.google.com>
Date:   Mon, 27 Mar 2023 00:17:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.21-102-g4da819332d9b
Subject: stable-rc/queue/6.1 baseline: 79 runs,
 1 regressions (v6.1.21-102-g4da819332d9b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,TVD_SPACE_RATIO
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/6.1 baseline: 79 runs, 1 regressions (v6.1.21-102-g4da81933=
2d9b)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.21-102-g4da819332d9b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.21-102-g4da819332d9b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4da819332d9b990562b483db017217a78c1ff495 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64210df004f35a9bbb9c954c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-10=
2-g4da819332d9b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-dell-latitude-5400-4305U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-10=
2-g4da819332d9b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-dell-latitude-5400-4305U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64210df004f35a9bbb9c9=
54d
        new failure (last pass: v6.1.21-97-gc318abd556672) =

 =20
