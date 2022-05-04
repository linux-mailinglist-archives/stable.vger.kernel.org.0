Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5D7F51AE1E
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 21:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346016AbiEDTqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 15:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358531AbiEDTqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 15:46:31 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF174D26E
        for <stable@vger.kernel.org>; Wed,  4 May 2022 12:42:55 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id e5so1957817pgc.5
        for <stable@vger.kernel.org>; Wed, 04 May 2022 12:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+lzVF5GjvfzYluwTt3X6bf5qzyKRvLyh3fQq//sqPSE=;
        b=Uld9cM2CkPUzRSK0vjaZ1SVcltbJ5PRmORhgMqpy4ZpNRcbM+/PzQ0lOKjQAUhO+4f
         JZ85ec1vVnG9VGAjcwc5WQ3rjBJLeEet3/fFJ4atjSdhaz7MZeENftjTnEtl6aX4KVzl
         bQTZMCxEIdWWcbJf05L7C6LrKB+ttFXR557vBgYyPOR2qduHXly1a8gNRT8abi4xn3+0
         BvHls4YjJsQl0LQdccKnQb0o/RAsk3at3UvakEkmwip4Vc6vwKOi62EmdFIwU0fJvhHq
         8ped/Uz9YG/l5aL7DJEWRkaPVHO8HRLSeHE9Puzn8tQsjj1T8TsqdW1n/pPHQqgUWnNk
         GT7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+lzVF5GjvfzYluwTt3X6bf5qzyKRvLyh3fQq//sqPSE=;
        b=QSk0KPKWlojll27a/BVGYhbsg5n98koa5ZIKiKqMtlIOwXT9XukZEqgJf42P/TYQ5C
         9cD6SVY8zFGuIqf1YCl6Rt4qOP/vb0lQjbkk32WOztc0Qi781zTvMMVVCKEeO/74KAUK
         21UqV5o4gDSb4UjEGWhKAvVLxikCV28Jf370/If5gLvmHsikeUQQ0myYnPkel7JnTJOU
         xCuMZJXyPOyOJiHDV/nwf2RbhbvEUF/rMgZ4v/3B3kbXfPoaTFFELXKITelj7WQGDxlN
         bVvW2VF3+iHmcfFGpRmXE6HtY3UBxc0ymVt7p7O9Y3A939GjZ5YrucEnHNXsxNW8xH29
         kXjg==
X-Gm-Message-State: AOAM532iqh34tmw4lpLr1jKhGLq8LPTycsp7ys4uazhZQ9t+qHBRjypF
        kNW1UC9zD27itZieFvTa3Yr/aXymObayTlFY/eU=
X-Google-Smtp-Source: ABdhPJxdBneSgqbJxR61y1Mre9yQbB7HLPG2knuOenk9Iuevr0EE0fD+osvvzYG3e/Jlk7/REkwX3Q==
X-Received: by 2002:a05:6a00:349b:b0:50e:570:180e with SMTP id cp27-20020a056a00349b00b0050e0570180emr11387741pfb.13.1651693374629;
        Wed, 04 May 2022 12:42:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x20-20020aa79194000000b0050dc76281fasm8564938pfa.212.2022.05.04.12.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 12:42:54 -0700 (PDT)
Message-ID: <6272d73e.1c69fb81.7a361.53a2@mx.google.com>
Date:   Wed, 04 May 2022 12:42:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.17
X-Kernelci-Kernel: v5.17.5-222-ga37132fdd160
Subject: stable-rc/queue/5.17 baseline: 131 runs,
 1 regressions (v5.17.5-222-ga37132fdd160)
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

stable-rc/queue/5.17 baseline: 131 runs, 1 regressions (v5.17.5-222-ga37132=
fdd160)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.5-222-ga37132fdd160/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.5-222-ga37132fdd160
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a37132fdd16013a9908c7ac342b8c6b02dac42aa =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6272a3774f5fc2c1908f5724

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.5-2=
22-ga37132fdd160/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.5-2=
22-ga37132fdd160/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6272a3774f5fc2c1908f5=
725
        new failure (last pass: v5.17.3-221-g1d72a498d8d2d) =

 =20
