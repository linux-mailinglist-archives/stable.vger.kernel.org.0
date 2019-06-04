Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B21523466F
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 14:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfFDMWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 08:22:00 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:35953 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbfFDMWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 08:22:00 -0400
Received: by mail-wr1-f46.google.com with SMTP id n4so12553979wrs.3
        for <stable@vger.kernel.org>; Tue, 04 Jun 2019 05:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=80bvjzgs+pZgZPhfg0DbIIZgK7KEYjK+VwjGY5Ar/N8=;
        b=dnIJKySDgMI6JDJLscUd65GKaOH/PFR9hjrnThArG0hni9hQZ0VkVeeO1wKMsE2Pl2
         /sh/Pwq4S59Kj8OrVAxv/tvuk+/75ue4WrS3oTHeFzOMiioNOs2r0kOYzV7U3bl7raBK
         qUj/8NtM5Qw035cCm8m98YhWL5nouneGjfaVmVA/7ISbjkYumtYD8OxTQwUmeDOkTl6x
         LrGgDLcBuu0CKKEc5H0Jz4FwQczs5phnC9QGFPQwmVSS8BWBYGY0QOArDoYiZ9gYFhIK
         R2IcpOqmi7NwFpGY0CU1z/0FrODehqPaYoABDs/9ftC/TKRhfWjrga1MXnT2jxQIKsX5
         t+gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=80bvjzgs+pZgZPhfg0DbIIZgK7KEYjK+VwjGY5Ar/N8=;
        b=M3hmqxyzlVWwb5ycUMZBkaL/rCZZskv+BxiKVF2RHEoi48SUG66k7ae+A690LXX6AS
         XxzH4jv2Tbh1+eXHe4d6PtIJcx+2ESWbUqYg3la+37Eqntq2X6dRqi3T/I4Vqey2uTRO
         MvI4Z+FTsbjd17K5DPbrvMIdk2L6mz+jgVhKeUp7xdLXpGnCmbcVRnWu9DgY+nrsTHeG
         cOxqoh1ZydIfzR/F+dvqAqklQkxLi/Xxeg8tdsw4QiiEMFkIXhV7M6LqrGCeO2EG6/ea
         8chO+/flk3MsileTuoULSyM9tbwI0Gk0Qs4/wO7ORf+fG2E5k/G7yiy0OflYQdL2WfFx
         TK9w==
X-Gm-Message-State: APjAAAVHtmrQLMcLyMJns/16thxyJyFQOfbygbTSlFZt2SvDlUCXoIBw
        /jDFf93xzdGpWo1BWpsuLt1wNpxspNWrLQ==
X-Google-Smtp-Source: APXvYqwpqdEB1hLaN5QycQ4Lu47pbVYzl79Opd3jTs53Uj+EH0J5xOVPDqJW1TMqEnLrnIaR9R6aXw==
X-Received: by 2002:adf:dcc2:: with SMTP id x2mr6401688wrm.55.1559650919165;
        Tue, 04 Jun 2019 05:21:59 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q14sm14895096wrw.60.2019.06.04.05.21.58
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 05:21:58 -0700 (PDT)
Message-ID: <5cf66266.1c69fb81.50c45.0b83@mx.google.com>
Date:   Tue, 04 Jun 2019 05:21:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.48
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 126 boots: 0 failed,
 116 passed with 10 offline (v4.19.48)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 126 boots: 0 failed, 116 passed with 10 offlin=
e (v4.19.48)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.48/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.48/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.48
Git Commit: e109a984cf380b4b80418b7477c970bfeb428325
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 23 SoC families, 14 builds out of 206

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

---
For more info write to <info@kernelci.org>
