Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B760B4C7D7B
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 23:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiB1WiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 17:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiB1WiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 17:38:15 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B50120F5F
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 14:37:36 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id c9so11984445pll.0
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 14:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7iabZe0eqqL3aivVSdCDWW8V5e+SIx36XXedd1I/gYE=;
        b=7dLWbVqTdm/Q5co5HrUX28fQPA7RAcnqGkZV9nfo3StdV71BYY6fpvMVLnbAFOwBxz
         PHt9EptmeNbuB8Vtuy4n+fpaTOQSxcbP1CqPz+6YXWMAmJ8ycdrJO4G6Xb8lqUQsTQTG
         xObHElwG4xXdK6vPtyOVbDTgWPaCliPkW6JCADcANUg3U4ywlwG3aJOwWHducAbqrGMY
         IZS79heaDVZyNT2Roqrr3eNe0jx5BxmFT41xuJCMk2KH/KUZS8YYAX3ojAHisbFbz7lm
         Fx9GOB3GJ14xwpyFT5/yyLUSEho7sBLCjh1ezswaYKY73q91ihLClItaO8PGJLxA6b6+
         oqQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7iabZe0eqqL3aivVSdCDWW8V5e+SIx36XXedd1I/gYE=;
        b=2ILn3qg6gcuxiahmHFl5RV+W0WM3FdlXTClMOnNK29HkwkrWqVNV94TJfxjgeUeJqE
         /HF2OjR5cES/r+K/uYNnRnluZEjjWcXUP8Zf38STCSpGYEj6kSo68x0vuK/qrYhwRgz5
         UjPxZyNMkgqWsgiuI+NRDl6DYhgpOUWQN+jrH02sNJqR+769jl+q/xu4MYv2kkSFNVhx
         8VSCE7NBEO0pGOVposSkP9Ojfn6+YnsF6QPMf3f+ffgbqAcUw+QBIzMqa501HTGybOgg
         8VrXbkoKuN9whAxr1dtTWysN56FjkzSvHmtL64ZwNfQTiQumihf45fq87NBxb33rmxW3
         sYSw==
X-Gm-Message-State: AOAM530WK3leMfOXPctlpTlbRZwqcPd/abf1NNOtwJ2tP9j7B7hf/Jkz
        HrD8eFkwcO+6gFykg7KO24iC+jRnCDUN0Lu+b5w=
X-Google-Smtp-Source: ABdhPJw5Iw1tm96LMlNvnj4XLPK7Dm8uHNBGY5hwbPO7XLuovwRUUR0okHiNXXEm1qaK5A7YJFM94g==
X-Received: by 2002:a17:90b:110a:b0:1b9:eb62:7c00 with SMTP id gi10-20020a17090b110a00b001b9eb627c00mr18947928pjb.67.1646087855348;
        Mon, 28 Feb 2022 14:37:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f18-20020a056a00229200b004f3cb984582sm14710943pfe.136.2022.02.28.14.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 14:37:35 -0800 (PST)
Message-ID: <621d4eaf.1c69fb81.d3d13.532e@mx.google.com>
Date:   Mon, 28 Feb 2022 14:37:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.25-140-g798174743716
Subject: stable-rc/linux-5.15.y baseline: 74 runs,
 1 regressions (v5.15.25-140-g798174743716)
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

stable-rc/linux-5.15.y baseline: 74 runs, 1 regressions (v5.15.25-140-g7981=
74743716)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.25-140-g798174743716/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.25-140-g798174743716
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      798174743716117a3388365925d6d20985bf920d =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/621d140e51c011cf66c62989

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
5-140-g798174743716/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
5-140-g798174743716/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621d140e51c011cf66c62=
98a
        new failure (last pass: v5.15.25) =

 =20
