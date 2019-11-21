Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1F2105893
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 18:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfKUR2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 12:28:45 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34154 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbfKUR2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 12:28:45 -0500
Received: by mail-wr1-f66.google.com with SMTP id t2so5483764wrr.1
        for <stable@vger.kernel.org>; Thu, 21 Nov 2019 09:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=py+bXe7YONFQOM7MAq75iAq+Pb8clhJ4Ewar4JdQPek=;
        b=yw+F52JlCKW+m8xEmhai818eFgrwZNjRPb7rVPMopqhs5pRP0KVmqDgb+CwW4fOK3k
         L3wynRkr1EHjFkxwq0ZJ51LcCa9hHQq1Kd82qhPRT234waz1NzCS2f8wCIcuWbSkTIoE
         9XVd1L90SQ58nuFzRwtQdblVa3i7qS36H8vzJ+4CUXPYmnMgrho/2L9YgF0CfEBAfkuc
         iapA5vYJfdcxpmEF7WZx2VmXAkl6aG1C7m+So6nbH1/SlmjgaP7UHdjoaDk71UZPSpk4
         SiGtbuTQrHCARUqhSWqyboeWAgxCcN2zciBdWmLj9Nl9dp/LmOfGnyfc1Yt4UQ5KoEvB
         JoFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=py+bXe7YONFQOM7MAq75iAq+Pb8clhJ4Ewar4JdQPek=;
        b=AGnSgAgv35SeQv4cxZmR8ktTC2zAvbGjr8xq+pgVLROZsFkKg4LQolGCQIMAKxQDWa
         MfjHGf6Rxq2nnpQthUuwnuR3xEzfHyclo9oAV0bDzpsFXEFp9y9ae7YjSNjV74RGDc2Y
         /UHThSAhBOWWGgHNfh26cSglRDIgSxLFJh/Mnt/ktaBWfPIaDd3F00VwtHpNAA3/+EPM
         OQDMC6nB56mekqTqYoK2gIrhmyNen08FLw2MIgDrEdyJ0SnnBVFulp4VaA3FpxmH9PCX
         LYmjtzF49URkRltfpsA/Ll9bFIbOObNd8kgIhqTVWpKqhuI9M8edzHrGwedOFyN3PcYk
         kyIQ==
X-Gm-Message-State: APjAAAU9KW1T5qKXN8r/SyRSqL8ZnXfqnWEGCsQL+T964zqxkH2XdSDq
        gKN3kAWiqQZ8mPO+4w5OhZXKUssfTxPX9A==
X-Google-Smtp-Source: APXvYqyuh9CyVOK6OQts8oUuWWzFEZo8/RoQl4LgGXzrEXRLOWFx6/pDsLpX8dz45breT/c3pt0zag==
X-Received: by 2002:adf:fd45:: with SMTP id h5mr7935608wrs.388.1574357321574;
        Thu, 21 Nov 2019 09:28:41 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a2sm4148110wrt.79.2019.11.21.09.28.39
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 09:28:39 -0800 (PST)
Message-ID: <5dd6c947.1c69fb81.cbfab.4c46@mx.google.com>
Date:   Thu, 21 Nov 2019 09:28:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.12
Subject: stable-rc/linux-5.3.y boot: 147 boots: 0 failed,
 141 passed with 5 offline, 1 conflict (v5.3.12)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 147 boots: 0 failed, 141 passed with 5 offline,=
 1 conflict (v5.3.12)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.12/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.12/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.12
Git Commit: 807d174bcb26ffc9eeb944d39591a15059aa7cbc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 87 unique boards, 26 SoC families, 17 builds out of 208

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
