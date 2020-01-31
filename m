Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F81914F16E
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 18:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgAaRlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 12:41:05 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34634 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbgAaRlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 12:41:04 -0500
Received: by mail-wm1-f68.google.com with SMTP id s144so9307707wme.1
        for <stable@vger.kernel.org>; Fri, 31 Jan 2020 09:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RSDTctZU58PdJSo1NZ+qAsfsgOu8PwLbc0KE+NJTnwY=;
        b=uNFCy7RIieSFPf4B5P/wSy2EESiwPb8/mNkL+evTz7zf7IEoly8dYoLNRmg8QNdgxN
         zWlx5a+010EiffEM0JmbTKHHgtKCB5foCpjEnwzIgOKlpv9jEt0k1/kbrV3byCMUl3IL
         9Yrcno+BZpxAxBXaefO08ORUw1mAgGN51YwP03Nu3ToqScGQL7+OOhaYEcP+IvkdXquW
         gFpgXI2JeoMqyr+AiohComfgScm5iEmGt1oXfNZfdvas5V9mYG1XMWDg6FQGw6P0wm3a
         ffintcXHJ2GbG4gpypzGBitftCP6k8ZK6gQPOIH93lIjV7gBM7SYsksr36kVtyr5UFb9
         m+PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RSDTctZU58PdJSo1NZ+qAsfsgOu8PwLbc0KE+NJTnwY=;
        b=tD7z6MobznvnYjk4F3jq/UsYc/EqTx2j2TF58Z5iSNxXp4s6CU1I2YS5HOi+PyrDcu
         WgoitgTMvXVcWi54+mDfw1wgsjA31GwOXmlMvZBa0G9Nac2lx9sOs9lMZfaEQyiYk23a
         ddZo9pk4q0VmPK5Z40eqVjJSDtmbjFyP4iiIKYFsnAmrUPUr3i5+HDqd6LDPcgGC5boY
         6CmS12kUpe2Vmw8E+rqoTfE7mcXjpV6kn0nBkG+vUVBMo5sl+LoA004JNDahlmuA3jaq
         /s9hBzGrCeG4PCSZimWUm/1TYy02xQS67P2aCOYjKUaWlyf/6TRvr/Iq37Bh2ll4UEpV
         SjfA==
X-Gm-Message-State: APjAAAV5XWdJkOi1orl0s0b6YCKBUW7n/xU6bjoYhpkQIycDlpVtp1Xj
        Ub+WSu30pT2iJnfsKKbTPfShR5st/1/HWA==
X-Google-Smtp-Source: APXvYqz1zB7bAtbJ9lg7Cglx6X9g1I0t/Pe6D3b0K37e00uWqMFzZQ1v2D44vVoQvVb8YchCkA3l9g==
X-Received: by 2002:a1c:6389:: with SMTP id x131mr12867587wmb.174.1580492462243;
        Fri, 31 Jan 2020 09:41:02 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z10sm11086455wmk.31.2020.01.31.09.41.01
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 09:41:01 -0800 (PST)
Message-ID: <5e3466ad.1c69fb81.ceec4.2dfa@mx.google.com>
Date:   Fri, 31 Jan 2020 09:41:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.212-26-gc8f671aa81fa
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 48 boots: 1 failed,
 42 passed with 5 offline (v4.9.212-26-gc8f671aa81fa)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 48 boots: 1 failed, 42 passed with 5 offline (v=
4.9.212-26-gc8f671aa81fa)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.212-26-gc8f671aa81fa/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.212-26-gc8f671aa81fa/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.212-26-gc8f671aa81fa
Git Commit: c8f671aa81faf69b2573521f6b97adde12b72925
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 29 unique boards, 15 SoC families, 14 builds out of 156

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.9.212)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

---
For more info write to <info@kernelci.org>
