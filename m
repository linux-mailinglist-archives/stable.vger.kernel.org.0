Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FC944C31A
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 15:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhKJOmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 09:42:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbhKJOmk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 09:42:40 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2494FC061764
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 06:39:52 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id h24so1749185pjq.2
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 06:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s4Q41qDGp6dXnIk+vAVeJTkMkPIh0y9t1Zi598U2yYs=;
        b=cNyrXVhBhx9uh/gQRZ3NGT6Y1Kc4VXjnuwkDy3uv+kv0eFm1nPmHi+fyH3rmCfq4IL
         Ax0rFsqzucHeSneL5cuhKe+8omfDvZshwpRHio746D5X24vaNe+KID3WoY+TD8y2Fv7w
         CRg6aaUgIboFKlwPsLwDGUth1QZKRs6gaFr+fuldF5wkAT3QyDiH0kkyeAVN4geYclbS
         zpyQ1BwSN6yoPubV9Jmh2kROLnBOwvQ0mjSmsoDpHXDcwwE9dWA7cSp3WS0NjFpbem0Z
         8mqJYlQGoHxqPbEnL7GJuJmfDUZsg2aPGoNhPLj+xwRUIFhWWBO9owiMS9i4t9irtT0c
         tFdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s4Q41qDGp6dXnIk+vAVeJTkMkPIh0y9t1Zi598U2yYs=;
        b=sZh5g7KBDvuEvg2mqmvR2x9/oF/ILHu4I/1xoAbcYsCbnj3WJzkvZIDkmK0lUyCf+e
         h1glZxYx6QS5rKGNhvg+oPpV064SRDwC9SvHYQ3hUb9XKbpaK8kVm2Bgr4oiqfS9D8Rs
         i4x+yFql+ASQv9j73qAfwnOxcGY2FAUYQ1IqGKPsKm3uhZmQ3cFzasL6NYh6o5yn+c6I
         bKIO8N8Ms2vWi4us9ZSt7le4scL1kuSD5VGKSQ3Oi+q8Wg2FnxLsB44BOCdf6KW9/EmK
         Bp07Nto8jDAhu15eNkH2icoG7Gs5RKDlnu/y0+Se/yBN5xYEAmPLaYy+ZeTBHmmGpJze
         Xzuw==
X-Gm-Message-State: AOAM530iyPeIBefi8i2t/BLDncZivIuwwPfYGCsJFAYt+i7LFJWlgKS5
        Ern3c/NA3oI/RGeD1uOwNSmXl38TAxa2P9Nc
X-Google-Smtp-Source: ABdhPJy4ie5UU/PzpPwXkDB/dB1PVIczZV0vKYMCKLx6kKU4SIwveq3VPDvlFXo4kDZc+BowcAbIFw==
X-Received: by 2002:a17:902:a60b:b0:142:7621:be0b with SMTP id u11-20020a170902a60b00b001427621be0bmr16174849plq.58.1636555191477;
        Wed, 10 Nov 2021 06:39:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i15sm13479305pfu.151.2021.11.10.06.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 06:39:51 -0800 (PST)
Message-ID: <618bd9b7.1c69fb81.38f7c.59a4@mx.google.com>
Date:   Wed, 10 Nov 2021 06:39:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.158-7-g478246ff3db2
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 190 runs,
 1 regressions (v5.4.158-7-g478246ff3db2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 190 runs, 1 regressions (v5.4.158-7-g478246ff=
3db2)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.158-7-g478246ff3db2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.158-7-g478246ff3db2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      478246ff3db2e9570b3077eaa0f957a009920762 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/618ba4f5857e941bc2335913

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.158-7=
-g478246ff3db2/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.158-7=
-g478246ff3db2/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618ba4f5857e941bc2335=
914
        new failure (last pass: v5.4.158-7-g3d2f6a19f136) =

 =20
