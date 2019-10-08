Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD7BCF778
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 12:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729876AbfJHKwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 06:52:11 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46500 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730016AbfJHKwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 06:52:10 -0400
Received: by mail-wr1-f67.google.com with SMTP id o18so18792831wrv.13
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 03:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WaP2+hcJNBSQ3xFL6cO6Y7dHjWwG1bXlx6zobz1rYFE=;
        b=dbtZPGkWl94sKUzqV7U5Q+oWjYCuN3lchaw9aA5ja6hvE2WWhSYKmEeplTuATuefQJ
         oNSD1kUHzclasgq03enKGa0/Elndk9EcGMrkRIXcxaBjV/x4GEWhrNIrlSIZyCY2ZohB
         AH14lextaLGGVVZY0lOQo9hc4eepI/RWuObRkaECiMn5U2SoKw8SAtO/ALehIGp6/0GD
         ZPlf1Gx25Y+dEeBhIUKeDLPNrnkCodMP7Pge+8rWHd304EJPxmM4yqG6IC3nPFrIUXvj
         N1w5zfiz7txYYz5dIgnLkSVFpp06/hSifgybtdonhSxvi34e0aZZ2dR4RQ00lXQ7fQlA
         w3JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WaP2+hcJNBSQ3xFL6cO6Y7dHjWwG1bXlx6zobz1rYFE=;
        b=GXhtvVTdyM5Y6CuADj8cD8MNd9knw21hvmCs/KWoF1Csl1xcojEFjl+OrizFHDhVEU
         1H8Z/viOVz4dKbUKtLT+sK+h4Mbg/nsPr1tgzQQa5O7wpdvytMy2WxqiCmKl6priKtWY
         tCb8TsKVeuGw/EQn00sF39vUfaQrjw0tvn/gfqnOn6Mgr43vBEKinhybPRAjyN+24X6S
         Zc3jqWyI+uR+3uSrMwVinrXnXg/lsAl00Td5a4sahRir6GVAFavowyc0u6Fs2lNbNXf1
         e5elB0+MZyYIP49F4MN6sUo8ELKCZDxRBrZWB5Q1Jb8Cb/rQFZoFwCr58CtihNBfWb6a
         G2Vg==
X-Gm-Message-State: APjAAAVMErwuuaQaKM7VpGfgHKrAL13F7pnXRjjgaeIPG0z/lrqmeb4y
        y2uE8NysYwrzLOw/LnJ8d7BXOoNakmkh9A==
X-Google-Smtp-Source: APXvYqwDop2GGNbENnle8culK3wSC+mgwwJzzMRJyATojoNCPeJsMMnrQgYtT0drBR4oe6uEMHbfig==
X-Received: by 2002:a5d:4689:: with SMTP id u9mr26587387wrq.78.1570531928638;
        Tue, 08 Oct 2019 03:52:08 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m62sm2328972wmm.35.2019.10.08.03.52.08
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 03:52:08 -0700 (PDT)
Message-ID: <5d9c6a58.1c69fb81.755a7.aee2@mx.google.com>
Date:   Tue, 08 Oct 2019 03:52:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.196
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y boot: 43 boots: 3 failed,
 39 passed with 1 conflict (v4.4.196)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 43 boots: 3 failed, 39 passed with 1 conflict (v4.=
4.196)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.196/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.196/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.196
Git Commit: c61ebb668f2ce3c22d1cfe6df28bd3198eabbdd7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 23 unique boards, 10 SoC families, 11 builds out of 190

Boot Failures Detected:

arm:
    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
