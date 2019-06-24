Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9205E50FFA
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 17:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730625AbfFXPLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 11:11:16 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:53367 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730548AbfFXPLQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jun 2019 11:11:16 -0400
Received: by mail-wm1-f54.google.com with SMTP id x15so13154766wmj.3
        for <stable@vger.kernel.org>; Mon, 24 Jun 2019 08:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5PTa33ogTni5Gg4Vr/ihQKZAkZXaPg7xdd3sdJLvL2w=;
        b=BCir+cy7v1Tsk1tc4/DeUn4LFIg0N42euH8PUJ2n3j+7d2wTroJkFUm0s3QsTAIoZf
         N7PCQmSVfe5Od2xGA1VEgeY76pDqYpWCro3zRmOYpJ48ZV0SQBaaM/N/e4CDK71oNwzc
         Z85mC/d65YHm31osqEsFiRecCDgFompzRCr/NQC+w5bqJ2bbOO+Q9JYBaaWb+nMrRzb1
         B3jywVJkUm021UnpE+wP/nCig+mhg0k9japf2yEihrHVHYURZEC9haEfjJjzZ0chW+zw
         GP+PXpd8fECU28IfASHKAOXpTeP+ZPC2FCEEhfCW1m4sP7KhY4VPrghrjbXImDSnNJsq
         RHdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5PTa33ogTni5Gg4Vr/ihQKZAkZXaPg7xdd3sdJLvL2w=;
        b=EhI43c5gHuAbUzwfOARztr8VdX/BtbACqGJ3EfDswm60qT1MT1TXjaMupHrT6Wb1FN
         GPSGhkMWR6f7xiQXmAZ5sn0malNJh5Xywv5pvavpdBRagZCTuDuTn9wWA/PxI2f8DGBv
         RsIuz5NA5G7l3ESaW6UjumQrrbv77ed35fwxwm87IaWstEELW23yewb0XoJk8lKIS+jp
         UnMrE3Nswd0PmETHPxuiRhhNa/jntx2JLqdZnRINqKLDhTvCfxh83fpNwM32Ji4nlLKe
         vAGXiW/vPF6wVPr1cVsY2JDvJXFBr9sKOLGL+b/7mfHH8z8yxItliyUrW8csBA4Ags5X
         ktkQ==
X-Gm-Message-State: APjAAAUGf0xdY9Y45HSGW4welufyWhdIz/c9pzveaOWwf9C3P/0MX6pK
        HuZzg/6zb1tYS1r73flB+JhSuGJba3WGrw==
X-Google-Smtp-Source: APXvYqw1FbMm9oTMl5HIIlxTku/2MoFWxNlM4sw1Bx5B8VLBiFSe9eu405mcw/OIuHWpWygbaf6r4Q==
X-Received: by 2002:a05:600c:230b:: with SMTP id 11mr15856725wmo.85.1561389074342;
        Mon, 24 Jun 2019 08:11:14 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a3sm8375733wmb.35.2019.06.24.08.11.12
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 08:11:13 -0700 (PDT)
Message-ID: <5d10e811.1c69fb81.b7415.c85f@mx.google.com>
Date:   Mon, 24 Jun 2019 08:11:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.55-91-gc491b02eb03a
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 120 boots: 0 failed,
 113 passed with 7 offline (v4.19.55-91-gc491b02eb03a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 120 boots: 0 failed, 113 passed with 7 offline=
 (v4.19.55-91-gc491b02eb03a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.55-91-gc491b02eb03a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.55-91-gc491b02eb03a/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.55-91-gc491b02eb03a
Git Commit: c491b02eb03a59e32d78bb8d4ee00c154a694267
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 24 SoC families, 15 builds out of 205

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
