Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5614F4184D2
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 00:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbhIYWEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 18:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhIYWEO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Sep 2021 18:04:14 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828A0C061570
        for <stable@vger.kernel.org>; Sat, 25 Sep 2021 15:02:39 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id g14so12117225pfm.1
        for <stable@vger.kernel.org>; Sat, 25 Sep 2021 15:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CfutFF/fkVlPv1foZ+j6tL5+ABjI7uuyhNauZ4Eh6Pc=;
        b=pXHXt3Ul1L+1xNTQ9S7ApxPPCS2kaZk9tgS7WGS+v6JLM5xLycBFspd24pWMeIGN1f
         86+nzi71A91JQGRVO+eaNg2/LnzambDs6JTU5SrQEX4qssqOb/HpGvyewXXU+MnK38Dm
         CWKyCWsCPWcWs9iJp/iMnTVCai+Fn9c/PX5HfolG6kXoCVDleYDV9lj9jKcyv41QOB0Z
         z94TDHgQ46HOrX0StOG0aVVa88+zluufhyaWuY3KZ7+jlzKJv8b/DTaNrnfY++C/LsfJ
         7XHVTGxjWQ4ltibrkWJrIlKEALvwNOC974PFHBw0hiTXDeQw+aBLdBPwwFkBUwOKBW4g
         lhcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CfutFF/fkVlPv1foZ+j6tL5+ABjI7uuyhNauZ4Eh6Pc=;
        b=8QkdzjGIi1mFeIJAPqIPdzQvYxIK9IisEMoD2psJyRavcOZjYtt3y/riSefkPrTEDS
         onHhAHDZWgWcHap2OgK1e/8YGXWQ64QyvH58zv09ZzytaLL24Bpj5KqfU2E0S0ZSxcKx
         OlobJ1pLboh9KbpkUlDYQVrbsDROa/tDPV9FqyJgJwjZa5dXfVxmmlh46Pb17GW+sb8L
         VfgFnhjfXz2GR2fzME8ROOnNdAafKsPJ1RKQ9Y7IkQMfs5jZ511u/M1aMgodM+shYxgd
         c709g5DROCDnnbDYFlcIpfQb4Dz5OxJMkLOyj4JklUTU85CbLE9U+ZIHqzG4LVUYO2QQ
         j3bg==
X-Gm-Message-State: AOAM533kx8yT4mxCMkMVtN+JePkQVDd1AL+7nJOFlIqgXmEPrnByaYS2
        VC4LmZ0PlwvjIHj2lUPZ0wLR5OSpg9lD452T
X-Google-Smtp-Source: ABdhPJxQofsM0O1ZmryRZkB8gH0prTAYpiCViZXJikDe4oWUUuewNVIPKobKc7+en52Bl26XHiwcEQ==
X-Received: by 2002:a05:6a00:148d:b0:440:4e92:798f with SMTP id v13-20020a056a00148d00b004404e92798fmr16347858pfu.17.1632607358855;
        Sat, 25 Sep 2021 15:02:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v2sm11422901pje.15.2021.09.25.15.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 15:02:38 -0700 (PDT)
Message-ID: <614f9c7e.1c69fb81.28c0c.2b02@mx.google.com>
Date:   Sat, 25 Sep 2021 15:02:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.148-50-ge9755952d240
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 49 runs,
 1 regressions (v5.4.148-50-ge9755952d240)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 49 runs, 1 regressions (v5.4.148-50-ge97559=
52d240)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.148-50-ge9755952d240/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.148-50-ge9755952d240
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e9755952d24071ff6f516d4c381e911abec76d27 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/614f66d6e738f8010d99a309

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.148=
-50-ge9755952d240/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.148=
-50-ge9755952d240/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614f66d6e738f8010d99a=
30a
        failing since 309 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =20
