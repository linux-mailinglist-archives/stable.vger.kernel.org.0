Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB4F4336B5
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 15:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235790AbhJSNN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 09:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235780AbhJSNN0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 09:13:26 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9061BC06161C
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 06:11:13 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id n11so13636929plf.4
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 06:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eN6o42od0MdiLsoguz51BvuSTp9Fxr8iSkdhBXAlUUI=;
        b=PK44ydg4cTbpim+09ApAt9JwvuN1yPXeZ2sSl9hIDPwfTWcKscqD155h39FfCwd0wN
         QgQ/NUvdKFM/ZQcq/CmCoT+mc07Nv0sei3x7x44xqH7nKb5F5NJHI1uhQoT0M7qhBMta
         YMy/zUChcHpWKn5gbL/XdAvVhlByRovGSlFdpXOH8VvyP16gCIH/pcnqK21JJBRcQnWS
         wVy0aFoJ6cA70g5rTW94EuJL5+CWTr7vlyDyFDNwm8AZ/HpnfiYqyaplwK/WUd5aVvnN
         d3wtlMBaLJrexF3nPD6fib9F92OUl7sACepDxkwrGuexoLtcfHmwnNV6pqxMqz7Czo9D
         pO+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eN6o42od0MdiLsoguz51BvuSTp9Fxr8iSkdhBXAlUUI=;
        b=j5wVxOT+7uJWbz26nh0rfGD7HhyodbEXFrLJPkRAI7eTRe+/6IqsJvxO6Kwlp1xqSz
         zxaDdq1d4K3sRsH+0C9+ZAkjLZLdn0z42pPAndeFR3936VPj+QtUxdWH0kckA3HrNfBR
         wfnWioADWWo9y38KWasTP0szobv8+yQ51EQRCHOnU+sokADMrXaW8h/WqEZPnSZQnz+/
         dNXEtcgwfrDgbCos6aIIn+lZpI3OGcNfJsqx8WWcXzHmnlhdgypDRZsYs2wJKNBLuvfw
         F84yTINLfbW7DmxITWmb40g//83xViX7x8Va36NWZhbIqwMvk+8jkT92cbLjrrgE3Vc3
         mZQg==
X-Gm-Message-State: AOAM533PblurNMYAK97+3gwvcYFWd3eaSvo7kuD8vlzCEHGcD8fqO0EH
        0HVf/X743h8IAjikElRkSAgdDxTcewVFQKup
X-Google-Smtp-Source: ABdhPJwMwCWeWUWA4lZgykNl5/weOPsF1sk8LT668/D61QpsCKbRKnYo3Tlpz0RKU5ydW9fYjD/i0w==
X-Received: by 2002:a17:90a:6542:: with SMTP id f2mr6331199pjs.159.1634649072909;
        Tue, 19 Oct 2021 06:11:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q10sm16203546pgn.31.2021.10.19.06.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 06:11:12 -0700 (PDT)
Message-ID: <616ec3f0.1c69fb81.3198c.c86a@mx.google.com>
Date:   Tue, 19 Oct 2021 06:11:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.250-73-gcf46928023bb
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 104 runs,
 1 regressions (v4.14.250-73-gcf46928023bb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 104 runs, 1 regressions (v4.14.250-73-gcf469=
28023bb)

Regressions Summary
-------------------

platform    | arch   | lab         | compiler | defconfig                  =
  | regressions
------------+--------+-------------+----------+----------------------------=
--+------------
qemu_x86_64 | x86_64 | lab-broonie | gcc-10   | x86_64_defcon...6-chromeboo=
k | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.250-73-gcf46928023bb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.250-73-gcf46928023bb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cf46928023bb894e5b4a460828cd9b9aa6328bbb =



Test Regressions
---------------- =



platform    | arch   | lab         | compiler | defconfig                  =
  | regressions
------------+--------+-------------+----------+----------------------------=
--+------------
qemu_x86_64 | x86_64 | lab-broonie | gcc-10   | x86_64_defcon...6-chromeboo=
k | 1          =


  Details:     https://kernelci.org/test/plan/id/616eb405ce0bc7dca03358ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.250=
-73-gcf46928023bb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.250=
-73-gcf46928023bb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616eb405ce0bc7dca0335=
8ed
        new failure (last pass: v4.14.250-73-g4fc2a4026e03) =

 =20
