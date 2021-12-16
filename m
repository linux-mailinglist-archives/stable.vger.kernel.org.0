Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20EB4780D5
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 00:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhLPXu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 18:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhLPXux (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 18:50:53 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0F2C061574
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 15:50:53 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so941375pjb.1
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 15:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fNCXWKE7DA2pu1uxyFgBwDRJjgEnwIGIuLvv0Rua0pQ=;
        b=djOpWv7yPSHgmlDWYvZwhybmzHtARLV389/8so711KMh2ECUy4dwqkH6pH8AdjG+yf
         1lXrjQcdUY1ruyAk0l1MOkBnss0LKWOhQYHPJFYzq7SjcXQV0qkCTorZT9TFPHCdgIir
         +rvInHe3KkX+lp7xkJ8R7xB52IXo6cGUqPSZzxi/SYYsHaTMPgowxcsrZ4sjCvow7JQn
         9nnwDThB6RvHsOx1BLEgJAOPt45Az4kqS+/Na3Ua9yaYcK0J2eqQOrrL3xeK51he2Oga
         K3+G4Ea9uZhPUvekBqW31pH830rZ0L4Sc8zBZjkQnznUFGZBYiLhG1hlvwyx4yutPNQA
         vo4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fNCXWKE7DA2pu1uxyFgBwDRJjgEnwIGIuLvv0Rua0pQ=;
        b=ulDwuvMC8dPsgclbQ4/s4vPfT7AlNqf6KC3wml3ZSfPMWXP4dKdlOZ5BB7oObrfVMj
         0v0PKnVeFpW/AyEBb38Mja9an9et2+6zurOhfpNptapUrjgk5x+w3C7qwQlMKRcpF9ZT
         usM05CqIGaeIhrP+y6isgQLQ5gJOV1PWLfB883UXAvaeZ2vmFMskLhX1JKRyn/KC1yFe
         +9rYEdyXKy8Q+5WyU0EPKlWQTGoIs7GEeFD6UBWiiEB5t3aM2SuJ1RtdUpTNSmUDcBKX
         3TW8lRkUN7xQ9P9SSEqOFiNnF1hS4J5XnWf96Rp6W6OfcICbfMlxBwu/zVeCX3A5xsG9
         BKrQ==
X-Gm-Message-State: AOAM531oM0jkQSxF47YplgULr7sU4B2ZwUTBFJMsddwIPi+6XGrASqt9
        TSdl6itjcJn/I48mPhgWlqav5jJnICGUNJcw
X-Google-Smtp-Source: ABdhPJyDMNpnDLMA+uRPKeogYIjHEksmQg+bTyDQImqMU6O3JIx7JNhVeBUKLhqfuHUcR7hRlimU1g==
X-Received: by 2002:a17:902:7089:b0:148:b897:daef with SMTP id z9-20020a170902708900b00148b897daefmr202397plk.61.1639698652826;
        Thu, 16 Dec 2021 15:50:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j8sm7648547pfc.8.2021.12.16.15.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 15:50:52 -0800 (PST)
Message-ID: <61bbd0dc.1c69fb81.153ce.513f@mx.google.com>
Date:   Thu, 16 Dec 2021 15:50:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.293-7-gd89b8545a1fa
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 117 runs,
 2 regressions (v4.9.293-7-gd89b8545a1fa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 117 runs, 2 regressions (v4.9.293-7-gd89b8545=
a1fa)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.293-7-gd89b8545a1fa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.293-7-gd89b8545a1fa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d89b8545a1fa22ac28c4b0ac754110a88702239f =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/61bb9b0b1f394c7cbd397157

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-7=
-gd89b8545a1fa/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-7=
-gd89b8545a1fa/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bb9b0b1f394c7cbd397=
158
        new failure (last pass: v4.9.293-7-g3a18355545cb) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61bb9d775697c5d170397133

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-7=
-gd89b8545a1fa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-7=
-gd89b8545a1fa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bb9d775697c5d170397=
134
        new failure (last pass: v4.9.293-7-g3a18355545cb) =

 =20
