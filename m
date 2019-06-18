Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCB6249941
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 08:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbfFRGr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 02:47:56 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50903 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbfFRGr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 02:47:56 -0400
Received: by mail-wm1-f65.google.com with SMTP id c66so1880951wmf.0
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 23:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vRFNIr9G6Fzz5c1sBOt27MrpC76GvaAC2OqrJIKUh/o=;
        b=eahmUQER9CDOoGxeFqLhMj7nBKoDjgiHmBsx8joSdXCelgmLze6YxqRTiCn4hdOVmX
         Yev7EdhYAnpmO2GyKn4xjnxRGRKAPguxlQ+iHx4Ghjsl0GKk59vA1HqCa+rgo/Cb9yz0
         Z9OeHD5wH0fvAL46y9U7KxJGgLnzucbel08foOeKG0hMEY+t/xHVIuUnqe0gojOPKzH0
         JQkFjS+U4OKfHbpkZ/2iUhhtADaSOeU9FklJkOL/XZCkYRy47lSfZK3XJRex6yqKXIRf
         y0PU8JT3px6iXP2SrMtQ9LAkSoCfqvaJTQrwv7+oIIP1+RqcdeEfYxNVcIGxO1j+oYl/
         xiyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vRFNIr9G6Fzz5c1sBOt27MrpC76GvaAC2OqrJIKUh/o=;
        b=k1C8BIqYhDbHWeuKM2oi9r6eOzyp2iRpz9S0I/gsaI/3XxFnYFf7io6objtaK8+H3t
         mBggH1Tym/8GnhifpLfQQrKShmxQaYBf1iyvcdLCxewK92QUAAJ0uwk09zTXAxlci8ry
         x4FWXYSYxxRqx2EJDo9tcpLaqcg4a8Rcj0sMeTB1xIPd8HbeGrfuhAOzYIuhZADdjabf
         jlmaTKKwa9LMptwftUwlezH+QCZ7He0DG5pD1UeIGepgCyexFTmp9IdHshQQaQJiG/Pu
         +3Cj16fgRKbmOmFzIeKA+PFhIeVTLc4vgVtQn6ppHIdwNiI7sc2y6eeZXhODn4Ag/rI7
         mVdg==
X-Gm-Message-State: APjAAAXWcXDJyIdLcw2fZsWEVOz53YWm/YUtee2qec/GystvK+TaLNx/
        aTyFqms1u/Lkw0F++xzbwyOY4gmXMzBT5w==
X-Google-Smtp-Source: APXvYqy/ubKmTCQuVybXXyHgbxSZ4mMeL8/f0kHPSz0SgO5r/UN33fjbuw8TKVedVsGhqLxYL0LVxw==
X-Received: by 2002:a7b:c057:: with SMTP id u23mr1584502wmc.29.1560836123871;
        Mon, 17 Jun 2019 22:35:23 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p26sm6307876wrp.58.2019.06.17.22.35.23
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 22:35:23 -0700 (PDT)
Message-ID: <5d08781b.1c69fb81.75c22.1434@mx.google.com>
Date:   Mon, 17 Jun 2019 22:35:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.182-63-g36c456baf9b1
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 79 boots: 1 failed,
 77 passed with 1 conflict (v4.4.182-63-g36c456baf9b1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 79 boots: 1 failed, 77 passed with 1 conflict (=
v4.4.182-63-g36c456baf9b1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.182-63-g36c456baf9b1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.182-63-g36c456baf9b1/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.182-63-g36c456baf9b1
Git Commit: 36c456baf9b18b0b852e6dc52d20d678aefff775
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 39 unique boards, 20 SoC families, 14 builds out of 190

Boot Regressions Detected:

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu:
              lab-baylibre: failing since 1 day (last pass: v4.4.181-51-g3c=
b069b52684 - first fail: v4.4.182-63-g4d1195c2c43c)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-drue: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
