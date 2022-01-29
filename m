Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2D44A3001
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 15:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238107AbiA2OOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 09:14:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbiA2OOE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 09:14:04 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A78C061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 06:14:04 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id h14so8699481plf.1
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 06:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=M3uSk/peubIx2re4+mVJpoy+N2yW/Rizth6WlU29Nps=;
        b=Tt0STJA0CS+bhDz34Bc7y572mcY0dNCILbGkjLd8g92PFsnl/JrhNm7vkClqgkv/uv
         wZKPXr9Wb8ODEitf2bgPy45jsJG5Tx5leHI0jFwpd02661Pma2S3FEghyRJdd10E9mky
         Q3qpBibeAnnf+yh8b1XrplDIfXSvSsw1niMmywQ+u75bG5LSPQsTc54/DgJDqjRwPv/X
         6MXiJsQQMg1nQs8T3i9lHMeiR/0x22jSlUj7NH9MHnhrHhmQRuINVH6yJ8/1KfBADat5
         F57KkIHB33/n60dBEG440r3fmJJEKpSb1OdeZ97Rbm/l/FB6CdfRktC1fR3HIpkwFSuB
         nJEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=M3uSk/peubIx2re4+mVJpoy+N2yW/Rizth6WlU29Nps=;
        b=D/ORCCX/rhHTTQrNpfULvos5Edi2Rr8RIEr2oV8md2ivoO7wxYUxqLGgZOORBEjMyj
         YqUWuxsvhLDHZ6YviFz/JnplCL86HqetI7xwSud/GTO+71xw5ciKVLHoLIlH2yVQpAHN
         I4XRCOu5VRL0x0J0GlQszrRNwLblgOL0FSzbpY/c349Gwh+9gWcT4pA56ybl5K4nF20i
         tYxRqeaQp84FYEWt/5sV+OWsjOPbRgUY0hCrk0Z1T/MKXT1gcDEZp62Br/CchEGyLOCV
         6JKfrP5458sCY41nVxG+SYPia7VaP00TNzyAW1q7f/566stZ/JglE3rtwqfE1u8yHHy8
         vOPw==
X-Gm-Message-State: AOAM530DicH6HokY+aRqhexxrqY9SmW321gsHEZzEPXYf2nupm2GjfCI
        UK6kWSCFvJz4QD/mO+vTj88B6wHcWjTOLMxG
X-Google-Smtp-Source: ABdhPJzlOySaZ20UJbAStKBvAxu7jbs+oFeJqLOqY9l7wRL1Zzh6IJpMzG/mzlfh0PORCxmDvd6yZQ==
X-Received: by 2002:a17:902:aa84:: with SMTP id d4mr13415636plr.137.1643465643929;
        Sat, 29 Jan 2022 06:14:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q12sm13780149pfk.199.2022.01.29.06.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Jan 2022 06:14:03 -0800 (PST)
Message-ID: <61f54bab.1c69fb81.19e5e.4372@mx.google.com>
Date:   Sat, 29 Jan 2022 06:14:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.298-9-g56a939b7bbe6
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 53 runs,
 1 regressions (v4.9.298-9-g56a939b7bbe6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 53 runs, 1 regressions (v4.9.298-9-g56a939b7b=
be6)

Regressions Summary
-------------------

platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
qemu_x86_64 | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.298-9-g56a939b7bbe6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.298-9-g56a939b7bbe6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      56a939b7bbe68cee0692664338bd0c5f5254dc96 =



Test Regressions
---------------- =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
qemu_x86_64 | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:     https://kernelci.org/test/plan/id/61f51103cfa9c09383abbd26

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.298-9=
-g56a939b7bbe6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.298-9=
-g56a939b7bbe6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f51103cfa9c09383abb=
d27
        new failure (last pass: v4.9.298-9-g33338373a46eb) =

 =20
