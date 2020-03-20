Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3A7C18D0B4
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 15:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbgCTO05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 10:26:57 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:35685 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbgCTO05 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Mar 2020 10:26:57 -0400
Received: by mail-pj1-f66.google.com with SMTP id j20so2531016pjz.0
        for <stable@vger.kernel.org>; Fri, 20 Mar 2020 07:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=95nhAbQZI8l0qy98Vs1MC8QCAWkVi2D1whnLFCuJkE8=;
        b=L1wAwGYC7cTFLPvgvgchTmA+JOtoSc8/A23uw5dc6WRz4nlkVZTInV6rJEeDTOnk4q
         bynfWuHGi+Hh0uRpgcjK8jIgEQabFDW1JuhOvY5qarp+RyHgOUvkYxxAQdBb1YOpw8uQ
         I9SnK+widdvZY7o7kE4ml/pRJyphHB+4Fmv9bz53oR8Tuf37mEm7zTxxmv4BHMMvecfK
         4sKo48iiiVdfM/0UdAlQRoEutr876FfB5jlq++aZpdwhieKnUpKtfnm9FVRJmNIpqVso
         Z4yJ3nFYIHgDlx7JuGZUwIGmZTDi83bXFJTc8ZyrRddcESit3ORMI9IzV/bof4/Ptdqu
         tUSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=95nhAbQZI8l0qy98Vs1MC8QCAWkVi2D1whnLFCuJkE8=;
        b=PSHFyzC9iV2j11kPiwW2eex2YnAVETGrqG4K6GGSumP0lmLpN8mJ6nlzlMEWYd1PuR
         ScLBX/m+eyaixB/lz83bOm2X9a6T9jXZRIZgjHg3uFz3Vzclu9KnA8cUBt8edZD2nFFP
         Up6OCpRaiq3QxvdApZ3VaWRR6pM7H7CMrw1jk1hF7f3ZmJYHqxTAOm/q/gMCaA+LTSih
         BUca060fWDVVWtfTBMW+NtzyzJHYIBSDhpRKjvbXnUIGRVIm5cWTYK4tNs80fQXiO+qE
         wu1ux1BBeM0xiGr55tLA8wtW0M/Euysc06mneF0J0s6tLoUv3UvpnYx+PfZws0pkUm96
         G/TA==
X-Gm-Message-State: ANhLgQ0iT+OHU7vRX0Xxb9/yQhEqRIZkfPZp9Rrq9sRifhq7ToKJ/VD2
        yXwd+HFTUnBSeO4N0JPPBGNBobWmcBg=
X-Google-Smtp-Source: ADFU+vuRLHfT0Uu+almrNtg07rBLeLeFytANzUO/NGuEVVujYnkhlJmLj4z04v2nYdq4y/Hf6hzQZQ==
X-Received: by 2002:a17:90b:3851:: with SMTP id nl17mr9644004pjb.59.1584714414403;
        Fri, 20 Mar 2020 07:26:54 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mq18sm5618530pjb.6.2020.03.20.07.26.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 07:26:52 -0700 (PDT)
Message-ID: <5e74d2ac.1c69fb81.891d7.26d0@mx.google.com>
Date:   Fri, 20 Mar 2020 07:26:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.4.217
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.4.y boot: 57 boots: 3 failed,
 50 passed with 4 untried/unknown (v4.4.217)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 57 boots: 3 failed, 50 passed with 4 untried/unkno=
wn (v4.4.217)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.217/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.217/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.217
Git Commit: 3b41c631678a15390920ffc1e72470e83db73ac8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 29 unique boards, 11 SoC families, 13 builds out of 190

Boot Regressions Detected:

arm:

    vexpress_defconfig:
        gcc-8:
          vexpress-v2p-ca15-tc1:
              lab-collabora: new failure (last pass: v4.4.216)
              lab-baylibre: new failure (last pass: v4.4.216)
          vexpress-v2p-ca9:
              lab-collabora: new failure (last pass: v4.4.216)
              lab-baylibre: new failure (last pass: v4.4.216)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

---
For more info write to <info@kernelci.org>
