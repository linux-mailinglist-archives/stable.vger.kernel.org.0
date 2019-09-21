Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B96BBB9D9F
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 13:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407575AbfIULf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 07:35:29 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53614 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407573AbfIULf3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Sep 2019 07:35:29 -0400
Received: by mail-wm1-f67.google.com with SMTP id i16so5055506wmd.3
        for <stable@vger.kernel.org>; Sat, 21 Sep 2019 04:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N/Ae+8SX2YdQ+owzz/dxBTEFtBj5wNRDyfhjyctCvQQ=;
        b=yp6ZnAEqeoo/fj382roXaDxkXh2uh9MCTT+tH6CRaJ9qIorC27AmztYtyyizUS2cMv
         IhFcn3HKHPlR3xGu9NElwpSOKbPuLW9gZKjwlTllnO7FfGU7cDYXGD/EPhsHYsOa0r2J
         2C2SIR8peNE5zos1IaHTo/QQfc9XoERDsILspmbcONtUFX654fMw2rVchF6s4rgPXIsB
         ZnE/V5MPcQ0zmWJ64Xay5ppUGIfxr7p0ObGScy7oelDZiAxAQk8LSs60fcgvbgXfZekw
         Fprnya4N9ANsF0Fw+qC9f/BcmUjGa80FJrBgLIvAsUQQYT82BRae6xopf2Jwc7fNF2P8
         rTWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N/Ae+8SX2YdQ+owzz/dxBTEFtBj5wNRDyfhjyctCvQQ=;
        b=eG7De8DN/GMVcsNYZScWPfyNNig+qLEfUu3gej026FIkhvovwsGw3m4+pQgnRt5yS1
         vV4rrWwqVKs4zi+5o3n6gvdwXbxwJYASJeFjQyFyoL9nDCNnZ/2bWX0ct18pnWGsNQyR
         BQvm7NtLCka64hh5kfMn2D3xiwOdyRHLcGrXTG5eecDb6Hyd+bXaPcaPu5LP15ENVY4B
         T/R/9fsgN/IhWD7bHGQxNEcRKWGYp0AoXjRBQ1pGeN/WdHwwjiMeBktfecihd8Q2olEH
         lFS4AN62OZeQwUjPsnYMxxxU8LZntXggLpHUwN74q62Byzv7w+X7EezNvxwJIT7DGK41
         1AKw==
X-Gm-Message-State: APjAAAXjPsJMFh/iogttCZeaXBdoyZfIugEz9HYmO4I9F1R8NyP0q0yS
        l6MLZhIXaqiln3aYjgZ6Me4j2dDiwofkhg==
X-Google-Smtp-Source: APXvYqxjH7pZWjAtliIpS4o3L3CIKaIubqDO8C5tddQTIL2HyjMvGO4S4XQFbaFMJ800Or4OjbXGyQ==
X-Received: by 2002:a1c:4108:: with SMTP id o8mr7208153wma.129.1569065725311;
        Sat, 21 Sep 2019 04:35:25 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t13sm9247143wra.70.2019.09.21.04.35.24
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 Sep 2019 04:35:24 -0700 (PDT)
Message-ID: <5d860afc.1c69fb81.10624.ea22@mx.google.com>
Date:   Sat, 21 Sep 2019 04:35:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.17
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable/linux-5.2.y boot: 85 boots: 1 failed, 84 passed (v5.2.17)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.2.y boot: 85 boots: 1 failed, 84 passed (v5.2.17)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
2.y/kernel/v5.2.17/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.2.y/ke=
rnel/v5.2.17/

Tree: stable
Branch: linux-5.2.y
Git Describe: v5.2.17
Git Commit: 5e408889e4af03a27b77cf4635934fefb9f4afab
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 50 unique boards, 17 SoC families, 15 builds out of 209

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-g12a-sei510:
              lab-baylibre: new failure (last pass: v5.2.16)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-g12a-sei510: 1 failed lab

---
For more info write to <info@kernelci.org>
