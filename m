Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DADA4AB72D
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 10:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234148AbiBGI5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 03:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239409AbiBGIwo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 03:52:44 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7566C043186
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 00:52:43 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id i30so11789445pfk.8
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 00:52:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pjLixAlIzVtilWA6JXoN2ZQCy2yd9yzr11jpR9LEGH4=;
        b=EC5IAlUxs0uyy+pw9bbkYdfrJyamAg5t0ml1PY59EVfoD3EF43bxOF5tUAJ/4TWTzo
         Q0crfL2kO2Q4YO1JUEvqW3RNTX4jx9ActNCx24E97AEp/lNW+9LC41kAEXzGnrQDzPJh
         VeiePNP9WknNWctgvl1XOF0lPlSLnMSsRuqrK1ccyrDR07xuA16QufIeXW8SOugemJxL
         JpheXghqYayQpZ8r2lM7wjrs7qG7Oss50e5OiRyKMI37/Hg+h7/sDGd8ko51az/0NcQE
         8W4rKwiZRQGgxHkHOG4f/LZonynAZHZR9eFpR98iIZMI9q9Q7J/IqZQZC3xUSwQSLlRS
         CERg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pjLixAlIzVtilWA6JXoN2ZQCy2yd9yzr11jpR9LEGH4=;
        b=I6Hvnf2eeJ34lmkxf2SyX4lYsFsQOGCcm4mH+1IsyVGXrXcWcWA5rfu3W49Q/UJCev
         37Q4y+Snq1VrH9gKWiYYgTMxe/8iOy6FxBCOKhJeX+zmZAjPrAN8IoSKRuOBYGuqNezB
         ZVkVKoqJM5DPBdcEkogjdHBVs/grONi77cEMGmh2KpiPWrVxsDh2sLKqcsCOKfkLAOeL
         RcJZ2hSV5/OnDVo2HX5BQppxcUUtjN2s1Is2AuULvFLsF7El1riz4jcN0wRyHFQkbkpX
         KUIZLPM2qHX+cP3pooMjf+weuXIOlYPFHqKjEjUDh/GSGrhqMVafzgTA1vwJrYDsG8vn
         7LFQ==
X-Gm-Message-State: AOAM530pXlRViRKn6qV62K7NFpKl8JyyCrbA0hNjwJCHYjfRAs4v5Rbm
        /wXzV1k+wzqUpdmpf8heKFFvYIjn6Nt7015/
X-Google-Smtp-Source: ABdhPJyk49LNQThDKrYBhNFDdechaFrfQscTztov68B4jyqay8msu57WGt6E8KKMQ455usp2NjRqbQ==
X-Received: by 2002:a63:710c:: with SMTP id m12mr8455944pgc.591.1644223963071;
        Mon, 07 Feb 2022 00:52:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x1sm11863752pfh.167.2022.02.07.00.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 00:52:42 -0800 (PST)
Message-ID: <6200ddda.1c69fb81.9d800.db3e@mx.google.com>
Date:   Mon, 07 Feb 2022 00:52:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.299-45-g4d186adcc4bf
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 112 runs,
 1 regressions (v4.9.299-45-g4d186adcc4bf)
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

stable-rc/queue/4.9 baseline: 112 runs, 1 regressions (v4.9.299-45-g4d186ad=
cc4bf)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.299-45-g4d186adcc4bf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.299-45-g4d186adcc4bf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4d186adcc4bf2620d945b9e5f20417b2b8f32822 =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6200ac6fe82cfa5a615d6f21

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.299-4=
5-g4d186adcc4bf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.299-4=
5-g4d186adcc4bf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6200ac6fe82cfa5a615d6=
f22
        new failure (last pass: v4.9.299-45-gf8835b05f3e7) =

 =20
