Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8651A6B83
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 19:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732940AbgDMRhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 13:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732939AbgDMRhv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 13:37:51 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55578C0A3BDC
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 10:37:51 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id v2so3630033plp.9
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 10:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xz0yL1FNEWTu2klNSYzwas38DJkUSic/CqPOuS1qPRE=;
        b=d0PbkETuL7FxCHndByO+fhbwPOi7k01EnkAoqHSOIMPZFOSUcGiAlCLI4k+YS3WXOD
         mU8jxEAwshD8+0rWBJv1tWFh3ZMsZJnfVektldA2yh/MVRcuVL8RSXG6+j5ZJropJpcU
         1gtTjISfJca1nQaZsyVl24MwkuMnX48wox4YbW+1TobsBn82Jk48qLNRK2R+vJgFMTw8
         Jw0wQS7jCJue5Vb7UEQp3exU4uaK0lNOyI5rdkGymaYboLXpF6q0uZkzB/CcU0C7pUKT
         ekau9T2nqlMQ1imea3qMantb6m8FTBm4xmolyeGS1L4C36kCXFLglreLhrxg4AmuAfpI
         ukrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xz0yL1FNEWTu2klNSYzwas38DJkUSic/CqPOuS1qPRE=;
        b=A7dbe05XHEXU2ZQ1R8txMR9iakzBDgKYVM2eHq8ZsotdcsM0LipRp5DlRM40mbVIiH
         yp4HQXZRwWwAeKmZqHR9Rj3EFNmXNq0xoEWjjGreWXsZEB6ZfJtYdrqfwNrfNHAViQq2
         LpWVhfmB49hPejXb0bRh85Z4emU5HN1FR7tjMTeoSdcmZkinha4uTsGCAwhg3zrAGGR8
         Xlorrn5AV8Dj6ww5fNN5Vpu/o7OWX4RkUrmKIXTlzel2k3wamKCZdfJg5mcmG/4ldIh7
         sca0RlRnOztxNwS3evhY3nzAZCQW6oPRs0ayM6VwgTOyIJO/uuiLldWEgfVA66s0tdS6
         Yawg==
X-Gm-Message-State: AGi0PuZD6upCzIV0Z0E3fgeyYwM1HEYokI5256mMkaCL3+L7YiTK85eQ
        fsPHdJlCifn6yS/BJkOLBxYqGA8FC1E=
X-Google-Smtp-Source: APiQypJdVXbSAJEsZ7Iuv9HJWJgssl385XCUCUJpiAY4bFy0YUbS+PvGxXs9v7hYTkgz8qiGdEf3cw==
X-Received: by 2002:a17:902:123:: with SMTP id 32mr18514637plb.38.1586799470558;
        Mon, 13 Apr 2020 10:37:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u44sm8658584pgn.81.2020.04.13.10.37.49
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 10:37:49 -0700 (PDT)
Message-ID: <5e94a36d.1c69fb81.6b9c1.bf28@mx.google.com>
Date:   Mon, 13 Apr 2020 10:37:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.114-56-g6dd0e32665e5
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 92 boots: 2 failed,
 84 passed with 6 untried/unknown (v4.19.114-56-g6dd0e32665e5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 92 boots: 2 failed, 84 passed with 6 untried/unkn=
own (v4.19.114-56-g6dd0e32665e5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.114-56-g6dd0e32665e5/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.114-56-g6dd0e32665e5/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.114-56-g6dd0e32665e5
Git Commit: 6dd0e32665e591e9debe3edaf73c2f8135bf047e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 54 unique boards, 15 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.19.114)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.114)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v4.19.114)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-p241: 1 failed lab

---
For more info write to <info@kernelci.org>
