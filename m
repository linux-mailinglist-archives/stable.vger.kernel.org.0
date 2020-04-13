Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9956F1A69FE
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 18:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731614AbgDMQdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 12:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731558AbgDMQdE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 12:33:04 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650ADC0A3BDC
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 09:33:04 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id w3so3564259plz.5
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 09:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sQ3o9KFRko6B1WBcbS6XKriAyPEdQJcZDQT5/+s3gwY=;
        b=YCAcCOOi2WcQFnl0cBKp7lJGBpCu6PaFj9eSAtiVMwTCd/ylkpUClME7myUQeFuXHr
         NlYmIGyZrHkr9YcrJHUEe469BuVFnhPaHfiiKFhJJh89WBjEF7CzL/PJVledK3i50/CW
         noeICEyOUhpU3vgr5jWDD0c0vtb3pPj0MT/froE60zDoyoHV38o5a5zwG1P0hvChOCW/
         WsDJHYPwuoL8Rubi8TJv3OeqYL1zO5d1NBCcR08JyAXjrkroPvhFgZRjitiwAxY9MYjA
         /ScMY+AjmBuZOmIy8SoOD5+a58cCGZDatXA+DEVLYw3Q9niznnVQYOgY+9SiFDYna+Be
         w65w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sQ3o9KFRko6B1WBcbS6XKriAyPEdQJcZDQT5/+s3gwY=;
        b=Tx67IbWDiBnIn2xrWiUJgdf0Vsyve3R66sZuV5EveBoN/wQRJeApYcUKYNMoP+embS
         Tstcjlb5JQwONafXyDEh+E2w6Ceh17EuCoCPkUW4JjrOAwiSml2gOAnRcBsyaIlUF/7R
         Z8DMYObr7jusyNLKrKaiSu6IlMcYlqf86UDVP3hN0ZYRJK9s5H7/laSdDVtIHB+stZ3B
         nzKeJGrHzwo3B69b0bHkLK9+dqG67VVlJRFhQb26TK8hFQjK7q/veQruWWLiIqbfu1i8
         r6liOtYyrCFAwqHwq70z7+5QuHYwMb48Uo+YgVR6NXhNK2J5HAPMCiPAbTRdAVMh8jBI
         D/pQ==
X-Gm-Message-State: AGi0PuZ9bZfLzrM6gZb7jmAbgW3ka3d4qbziRtbKopLaasedszYubkKk
        nxclTGq2VVSy190m8DIe7zp1jYpijeQ=
X-Google-Smtp-Source: APiQypKSXMbbUJUerCDJzkQZ+o5Wlt6AIF7kPQC2CehOwLVZm++qh1hDu1rk2N+eaLeF2GT8b1Yq2g==
X-Received: by 2002:a17:90a:df8b:: with SMTP id p11mr9013811pjv.67.1586795583631;
        Mon, 13 Apr 2020 09:33:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t186sm8197916pgd.43.2020.04.13.09.33.02
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 09:33:02 -0700 (PDT)
Message-ID: <5e94943e.1c69fb81.8d505.9d6a@mx.google.com>
Date:   Mon, 13 Apr 2020 09:33:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.176
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y boot: 80 boots: 3 failed,
 72 passed with 5 untried/unknown (v4.14.176)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 80 boots: 3 failed, 72 passed with 5 untried/unkn=
own (v4.14.176)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.176/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.176/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.176
Git Commit: c10b57a567e4333b9fdf60b5ec36de9859263ca2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 46 unique boards, 14 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 80 days (last pass: v4.14.166 - f=
irst fail: v4.14.167)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.175)

    vexpress_defconfig:
        gcc-8:
          vexpress-v2p-ca15-tc1:
              lab-collabora: failing since 23 days (last pass: v4.14.173 - =
first fail: v4.14.174)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
