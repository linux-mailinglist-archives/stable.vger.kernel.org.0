Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F110054E976
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 20:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiFPSfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 14:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239009AbiFPSfa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 14:35:30 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F8C53E2F
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 11:35:30 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id mh16-20020a17090b4ad000b001e8313301f1so5764252pjb.1
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 11:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=86wwnDLSXJTm6SvWerXbjfLZTav8tCtNR42VEfM3sSg=;
        b=rKHmXVd6fIxtuscsBNWZYZw4j46MaY2AaCiZIKHmmwzC01ofdFRWq0EUgAl/Sht0Uz
         GaJ68q2gnKLF5OJHXyqq/MznRkqYcdwAw3iG6J/iTprIGo2LcvHA10Ea6kVDgiZd/f5+
         k5dYZf1x3++icGmScvoCKucld0uPW/qr4C1LmSCqpxl6+Eb16CDEi6viEDXfE5OH57Ma
         Ayvcayp/Kj/NZLk4tYxEEPaxRTd/HOYTP56d8lcpNfnY8Y8xHG0CqbSxW0mJkEgWBVdy
         JU04qAzQ1cCZVndHl5rd8CUlzy0PKdAF3S5vK3OD3ORkzjUEYnCBbPx25Yc1cvid7rJC
         zJqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=86wwnDLSXJTm6SvWerXbjfLZTav8tCtNR42VEfM3sSg=;
        b=O3oyWeU9zWcenUuQwK9LpRvyPLpmIOrNm7EhsOUun7TbwDgi+Jq/8UCBIDQNN1ZeLi
         qQAqfeIakAx4YNMbU6N19vXn9cqSdKdMncz13sk5rdUM0jLn2WQi7GC2xMEAY6ROOL8c
         CHk5gcQMA3ZTg7tTKQ74wCZGuDsFtuv1jQYtrN5Uq6iXKoKsH1RDGy7ZM39d6VIA4Odz
         AOp0/B22SGUC6wOPcZyeR1LAGQCJNMTyWRTs0ke2P5KrE11eSrmkLf+TvSRplbkvJQ79
         BFFbaQNJ43O67tBYKyFkwR3gBQzur+FOrxG1g+YCq5DOQoJcErfjd9wrwG9Ss7yDCqsD
         Ncqw==
X-Gm-Message-State: AJIora+1H0iOJf6lCaUi3dc9iHEra6IEGUvkPc5nYUo1CGktYZtRqRG7
        urR58YkRBs7YGtff5gijhd/tYMaaTS7YmyikFW4=
X-Google-Smtp-Source: AGRyM1vdQilyT5MCeGsim9CWcx/qeDX2i24wOF+U6Gkm/TA70v6QxcwGowO0LGGZWTRsG+pa5vMgkg==
X-Received: by 2002:a17:902:ebd1:b0:162:224f:abbb with SMTP id p17-20020a170902ebd100b00162224fabbbmr5760326plg.160.1655404529356;
        Thu, 16 Jun 2022 11:35:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g15-20020a63b14f000000b003fd3737f167sm2121429pgp.19.2022.06.16.11.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 11:35:29 -0700 (PDT)
Message-ID: <62ab77f1.1c69fb81.28a78.316d@mx.google.com>
Date:   Thu, 16 Jun 2022 11:35:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.5
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.18.y baseline: 102 runs, 1 regressions (v5.18.5)
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

stable/linux-5.18.y baseline: 102 runs, 1 regressions (v5.18.5)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.18.y/kernel=
/v5.18.5/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.18.y
  Describe: v5.18.5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      71563d69a8ec34d41857aca6040e90d54f566ee4 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62ab406e2581086ca4a39be4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.5/ar=
m/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.5/ar=
m/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ab406e2581086ca4a39=
be5
        failing since 17 days (last pass: v5.18, first fail: v5.18.1) =

 =20
