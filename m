Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC10D6162
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 13:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729363AbfJNLeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 07:34:02 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33956 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbfJNLeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 07:34:02 -0400
Received: by mail-wr1-f67.google.com with SMTP id j11so19324925wrp.1
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 04:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sPq2S99FsAJbhJZalImhpUp/y+ytbJj/z7TFARCwjhM=;
        b=TaYEcy/iDOPRpnJcgQDxRN/BcaiIpBPf/cDUelAUqClLblWAVltLfOwtNS698n0SmY
         oCfjHpgADd+Yqnc/VORvLKEPAYDuVhCrDZRLuTyq0PF17seJOME9odoDtrgsSrRncIHE
         B8A79ZMAiReamzp9ytT147xoMmEjrIaszS7W4daQfPh4up9HM7fdZ3NG4MsV+h6p3FOI
         JcHxtJqDfwRJLVWjE0rE6BKHYOSthHD+LV9w8tdEJv9u7XVyGiAvS41u5DNHAY/p1Hdu
         86bJNWHYx0wVwOAmJXI+7qrFzXgy3qkI/zB2a4Si5HZKAz8hx41HK99nahWHO1FaLkmP
         bjRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sPq2S99FsAJbhJZalImhpUp/y+ytbJj/z7TFARCwjhM=;
        b=oZ0n2jg7Ttq7E15xCH0f9hIQ/OSn5OSQFwV4XEYOv02TOr3MkHjZV8YLBcEl8zOwgI
         X2F6zls1OUMV4FpnRB2dzBoCZc78ipmplTwt033R9lMAOXFqW4TwhR1PR5payq3b4LH7
         gtjjJto+DMISd7MWbipL1yJjCs7/3+bI21015OoSGDK1MKYA3KV+9ZBkOVB4/lZ3VeSS
         LIZF3VUAV8lrB9FuobfO4FiNFVpSwdcmRwTkaJA67QavcaEn9XwHzA9/IK1pECbRVvoN
         Al9ZRR59BDdhe6IBIQfWY0RnANFAOTirhbfoBq2UC3aEcmXmr5/BbCv61mL/5tX8NVjc
         9vEA==
X-Gm-Message-State: APjAAAVaZ+YDzVlwxMnxek+IPRUm+BJfCRs/0jK1HE2li6acgedY6+hA
        tpeh0+cUr15DOlAyJFdvJUUN2n/DMlo=
X-Google-Smtp-Source: APXvYqyHqXGGYcvFxNDCGijURcVUyT0Zwb6301sqrE1xIIFCKTEmA3NV0jDw7DvYldVO2mUe+aX+Ng==
X-Received: by 2002:adf:ee8a:: with SMTP id b10mr25252353wro.40.1571052840502;
        Mon, 14 Oct 2019 04:34:00 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t83sm41952597wmt.18.2019.10.14.04.33.59
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Oct 2019 04:33:59 -0700 (PDT)
Message-ID: <5da45d27.1c69fb81.3a5fa.fb30@mx.google.com>
Date:   Mon, 14 Oct 2019 04:33:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.2.21
Subject: stable-rc/linux-5.2.y boot: 135 boots: 0 failed,
 126 passed with 9 offline (v5.2.21)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 135 boots: 0 failed, 126 passed with 9 offline =
(v5.2.21)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.21/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.21/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.21
Git Commit: e91ef5bcdeda8956eb9f1972ed90198b698dca0f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 84 unique boards, 26 SoC families, 17 builds out of 209

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

---
For more info write to <info@kernelci.org>
