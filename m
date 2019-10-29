Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF91E8C30
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 16:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390038AbfJ2PyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 11:54:01 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42832 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389960AbfJ2PyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 11:54:01 -0400
Received: by mail-wr1-f68.google.com with SMTP id a15so1943704wrf.9
        for <stable@vger.kernel.org>; Tue, 29 Oct 2019 08:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LgCTrdZo20qrhPb5vrvv0Wx8hM2BuJI9iqxR4jr3Khc=;
        b=1SOXtZAju0UuX0sRz3xH9N3Xi0dJy9ANAvX7N9O9UdoxQN2u1K8Md/PKkqXfCaW5fX
         N7XLtu9dFP0ZxBqyAGh37633srycs2FdSu5piQ8S8OtHRphYlaGaIyT81U7VSVRbyecz
         BQGEDaU54RSae0ywXORPFL2UDuVtvE0Fim1PLCW4b/ZJQ/2IGbndQ9bffmYuprI2v67+
         UFlIwNqfVo0ip35A/sAxC2+tU1FKURkpq5/LBK8Ju2S82geE+taklQvy1A4HHg1ZBvYQ
         0xGtht5qZbLiOAOsrPlA+2/7IVvoWdXoNwG8JnoFU6rOKvHdABbmRSbTrNq9acnqVJE8
         NhXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LgCTrdZo20qrhPb5vrvv0Wx8hM2BuJI9iqxR4jr3Khc=;
        b=rn7f4oyAPoqNNtKa9VFVFhsas+w2BFSNpMof1qJ7QeLvKySBBFen8X1NtLPFMavEzp
         5qmrFKfP6tV8K7y7vYJGeLtIUZ4Mr2Hi7cZwOvuHDubf8c/OQOPNitO0KmzucrimvKuj
         qLcQX1XbaNiYuBYJVBM8DLMcge8adzCQKMEqmq4696cKguiI7OvBsRO13oyo77ZNwA31
         UCr3ekS9/jRryol0Ce9g0D11OoGo18/XnWEj8479o69E6DiNDuY+GpWxvxCHtDiO5faI
         CP6b/u3e7tJ5eK9XsJmjVv7iY+QZZanZ9MT0DYDx0Nu32AswmQctuMxoiM2eMv8m2SXW
         LtVA==
X-Gm-Message-State: APjAAAUe649sqTgawSy38oXscCo/It+eQnUWYKEpoSajEdFrl9bJUWSe
        Ju2A+8ko8FVB3Zhs9ZBAmRU7y3BwSQOKAg==
X-Google-Smtp-Source: APXvYqy0cDB93slaY9kBRfcFcXPWwdCIrb9mRHy4K+yDH/6Au9VQy2tJJa6k2FouyOEW2IiurHb0eQ==
X-Received: by 2002:adf:c448:: with SMTP id a8mr21094699wrg.233.1572364438646;
        Tue, 29 Oct 2019 08:53:58 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v6sm16334336wru.72.2019.10.29.08.53.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 08:53:58 -0700 (PDT)
Message-ID: <5db86096.1c69fb81.de3ea.47e4@mx.google.com>
Date:   Tue, 29 Oct 2019 08:53:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.151
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 118 boots: 0 failed,
 110 passed with 7 offline, 1 conflict (v4.14.151)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 118 boots: 0 failed, 110 passed with 7 offline=
, 1 conflict (v4.14.151)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.151/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.151/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.151
Git Commit: ddef1e8e3f6eb26034833b7255e3fa584d54a230
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 22 SoC families, 13 builds out of 201

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: FAIL (gcc-8)
            lab-baylibre: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
