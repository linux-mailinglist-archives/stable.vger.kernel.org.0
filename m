Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A72F1F86E6
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 03:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfKLC3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 21:29:38 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44785 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbfKLC3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 21:29:38 -0500
Received: by mail-wr1-f67.google.com with SMTP id f2so16733278wrs.11
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 18:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=M2QNAZUKvk/bpuHO5GyjiLW4tlIFxdnoShZaxMoPrZc=;
        b=DSdmCDvZ6ndqhWq1mNLW7Lqh2mLUkEtrDTcy6Af75HHjtTvok4ykZJcsPalKQHRsNH
         YV/us2yTTrcWTg4KBJFqxQknIXJ5XfZjAY41jC+6JwePXrr9Xty3s7cFnZxqx80Zpde0
         4dSmu+MA/FtJDTuguL20SKLHw7xnDxW9RaV7UhNbgqL1aBBe+oRHPclj9wyZYgYZ59/q
         lXKDWmJ5THcO3R6QaynMVxuiuqWN1Ki1muZp23Gks2971G5JNT/NNGRM7+ja4IKC/VM/
         Cup6yZA85tpwSEqZNPZ9lEXcbv1yQqY1WkN9E0CDe8WWJajHLPfv4s0EgkUqtxlRhSDc
         nX3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=M2QNAZUKvk/bpuHO5GyjiLW4tlIFxdnoShZaxMoPrZc=;
        b=AjLKdjEcPOjrCdHTEQJcfroX7IU0PCGzpq2I1UtjFbG+e58YBSuPIEMVq6Yr5GPnuI
         2BinHOqh5tydhIE3PyF5xUJbkMtaf23dAbyIFd4pw2qzqpc2D+0TmR3wO/8BdFdQ530w
         YKN8T5Ib2GPHqvFyjilFYFuBy88Mp77F+4/YDbDHnoNViOLD0KG3/11bqCtL1Th5lTqO
         DPY35+fbNOC75d2XXUMWmoEMoKmcWdzrwe6moIpSSyRX5wpNonOTalYX5w42EQp/KLZ0
         qn8wyML2bxlChAqVgNq8tV1CbmseNkxACZBuN4grrwnKUzAryt8rO9o3ol0Oa87B+nOV
         NaBw==
X-Gm-Message-State: APjAAAWBquTT3Duy/CAQRaVUQBtFPNkmXcS0NpUxYK4HG+LT5lqULEJb
        GqgskqcgIxMdzjllG3epLgLQd7tfSIQ+kA==
X-Google-Smtp-Source: APXvYqxOEQeiXSy5s9gS4q/1tLzKo1arFYWZRY4fxNXlA1ECTB8NQvCaG0yqIY9dIIXuKKt2O+n93w==
X-Received: by 2002:adf:edd2:: with SMTP id v18mr9131128wro.253.1573525776719;
        Mon, 11 Nov 2019 18:29:36 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x8sm1181319wmi.10.2019.11.11.18.29.35
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 18:29:35 -0800 (PST)
Message-ID: <5dca190f.1c69fb81.92a17.500b@mx.google.com>
Date:   Mon, 11 Nov 2019 18:29:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.10-194-gfeeefcbdbfc1
Subject: stable-rc/linux-5.3.y boot: 75 boots: 0 failed,
 74 passed with 1 conflict (v5.3.10-194-gfeeefcbdbfc1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 75 boots: 0 failed, 74 passed with 1 conflict (=
v5.3.10-194-gfeeefcbdbfc1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.10-194-gfeeefcbdbfc1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.10-194-gfeeefcbdbfc1/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.10-194-gfeeefcbdbfc1
Git Commit: feeefcbdbfc1362972ef26970aed0aafe90cc1ae
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 14 SoC families, 10 builds out of 207

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
