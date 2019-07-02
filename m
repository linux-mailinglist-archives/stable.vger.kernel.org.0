Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB2B5D191
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 16:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfGBOWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 10:22:00 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41203 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfGBOWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 10:22:00 -0400
Received: by mail-wr1-f68.google.com with SMTP id c2so18059722wrm.8
        for <stable@vger.kernel.org>; Tue, 02 Jul 2019 07:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=u0dqpH+7b46fUf+XdnSm+keFU3bsm4WnEgdYQQ6Lo7Q=;
        b=UovMaAGbIhLViO1vKAvkEQjRNFuy9Zvz7YRoPaNWSUQGriTEdDObT/3v1gZKi1UhI+
         4bWoAB9PEJ87e4v7lzioZe1efWyfaqhvHLImc9Vl8J8WiN6jJJfPJXRZMYQ+pSL1XOze
         ynAifULKIApk1toycn6W3VC2oEJUGEzp4txyghALIAZHlqTlTtOG8/eTWsKLM1iuhVrG
         egn25/xOufoevWFN3//4mFMTs1KjKaihYKdBZSp+kdVRYoqVvjTsGtZebkavQd0Pg6jF
         k3Qru0Qo8gUWLXohQbyQIFJtJzqhFB297C0C+NliHCTBe6U3DzhCxqAo8ak63wtzpO7z
         IT2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=u0dqpH+7b46fUf+XdnSm+keFU3bsm4WnEgdYQQ6Lo7Q=;
        b=kyuU8rtEKN7B5fusvj8pZTs3by0yb3nk4Gelm5ZFOyZV7potKHXw53p3EAKZtBJP8i
         fmauWyVIBDVigbnb19QCR1qagL4sbPjTN3U7TTlkYgXW7cWvHcrR/lVXsW6rvXFDpMXs
         CX4DJzsHCZrSo2SZv/c5FHwJvTV/IjkFzhde6stpqHdrNsVIGe1XvepyRTK7n3oCNN1F
         /FvcBdszvOr2LSBINpUuvAicY4E030LJ7DdKtQ+R5pofzD86BwegTNFh/oUDr5wSI3aj
         WMjkL/hPY9e/nWM9RbUT/s36efKL16sqnFTf1HuGs3cTkw7K7gqxZOVSVkYQaHB2mGq5
         6Czw==
X-Gm-Message-State: APjAAAVXip5Or+MMsLMhxOxND77/kLEx9vqQr2ljmbxuOYai9dRJEZ1k
        DGChES1GU3iM82HiDmJHVvPJMcpdUCTwgg==
X-Google-Smtp-Source: APXvYqwzxINBXfDD+iDKOoV66j14uoYuj+KToCUbBNyOum2s7h7LkDlXVUwKZkW/QyZc1YKqcNYdoQ==
X-Received: by 2002:a05:6000:106:: with SMTP id o6mr24977900wrx.4.1562077318120;
        Tue, 02 Jul 2019 07:21:58 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y44sm15433383wrd.13.2019.07.02.07.21.56
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 07:21:57 -0700 (PDT)
Message-ID: <5d1b6885.1c69fb81.705fd.c5ce@mx.google.com>
Date:   Tue, 02 Jul 2019 07:21:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.56-73-g4d057dfd72c6
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 129 boots: 3 failed,
 125 passed with 1 offline (v4.19.56-73-g4d057dfd72c6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 129 boots: 3 failed, 125 passed with 1 offline=
 (v4.19.56-73-g4d057dfd72c6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.56-73-g4d057dfd72c6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.56-73-g4d057dfd72c6/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.56-73-g4d057dfd72c6
Git Commit: 4d057dfd72c6b6b27f11e499fa7c9fc079fc62ef
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 72 unique boards, 26 SoC families, 16 builds out of 206

Boot Regressions Detected:

arm:

    exynos_defconfig:
        gcc-8:
          exynos5250-snow:
              lab-collabora: new failure (last pass: v4.19.56-72-g828a73287=
676)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    exynos_defconfig:
        gcc-8:
            exynos5250-snow: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
