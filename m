Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6F114156D
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 02:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbgARBX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 20:23:59 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36202 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729797AbgARBX7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 20:23:59 -0500
Received: by mail-wr1-f68.google.com with SMTP id z3so24395978wru.3
        for <stable@vger.kernel.org>; Fri, 17 Jan 2020 17:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p/ahwKDvf87lnxsusoWC2yG7pCCMNYflFhWW7v0sgQE=;
        b=jmQrioCkupyiwx8jRWjq3Oqw9GeRxGtEKuI3lwdqzGxHqTahoBmESBybrcJ2VJyfmN
         l2IhMLq/6OmlteOr6GCUO9YeBpvdA0HgOFFSFeBlxxlk7WQmObFcdOzmP3NEFIqt77Ni
         MsffQ6sqsmV70O+6hhfvI+putiYRztTpakofTUpO0XSc/6pK4Y7bF2fUvNHj1PDkwIL4
         IkkO/Dc90id9jn+ByW0g+ybCihTNAvPuwO51Yy0XBW+SBqu6IJm42DfxTuh1D+BZF9qN
         AJcni+v0ylb/XShFoef6zQmCpd8O5feKlOM0LjMMO6QulaZK+1K76FKskfeY4KJFlRee
         HTwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p/ahwKDvf87lnxsusoWC2yG7pCCMNYflFhWW7v0sgQE=;
        b=e/wd+EW+rdtOO8TLwBFgpZDGxu+sR/XjkVYSK6HNG9ZMxc/wlyPC+DOLBVsxCOFwWE
         meaYMiuubggYNL8LrT3t1iNNjnBxM6Z6P0wIFiEkvcMaoIjDu414ZQ9nf74r63iDaOHS
         wKvOZPvjS8nac8nfveqWGgDVTd3k2AtGUmcnHQFbO6TrkBSpmOWaLDBo5C2B6ZQXiRxh
         Mahroo1D5EkcWTrSaR+N92QSJ/zAAcWMPfuSvWVdPd/YYEkyMhSkyHR2b7mQWthMyJmd
         P7qDYzgKfvU9tABe4V6hcZyHm+7V5JDNKz1O6kj2ZHyeEa0ZynZue8W6bj6d1UE0nbn0
         4Ynw==
X-Gm-Message-State: APjAAAXAXNozkFRSaAxB72VDZqeDTtMaMhC3ZviWOC/JxjpyE3IE/Usf
        bVYzS6d9jQbXGEninMxWr21mdwdlL2PRmA==
X-Google-Smtp-Source: APXvYqzU4RVYwb8qUy2s89wWNN0mtLeKWvGIo5mgmyEBpjdiouQurIbwXeBLxksk+/M76OcG1gnU6Q==
X-Received: by 2002:adf:eb8e:: with SMTP id t14mr5874800wrn.384.1579310636832;
        Fri, 17 Jan 2020 17:23:56 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p18sm11767403wmg.4.2020.01.17.17.23.56
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 17:23:56 -0800 (PST)
Message-ID: <5e225e2c.1c69fb81.88cbb.f732@mx.google.com>
Date:   Fri, 17 Jan 2020 17:23:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.97
Subject: stable/linux-4.19.y boot: 85 boots: 1 failed,
 82 passed with 2 untried/unknown (v4.19.97)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 85 boots: 1 failed, 82 passed with 2 untried/unkn=
own (v4.19.97)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.97/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.97/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.97
Git Commit: dc4ba5be1babd3b3ec905751a30df89a5899a7a9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 53 unique boards, 18 SoC families, 16 builds out of 205

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v4.19.96)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
