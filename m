Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 203B3142F37
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 17:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbgATQFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 11:05:33 -0500
Received: from mail-wm1-f51.google.com ([209.85.128.51]:38239 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgATQFd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 11:05:33 -0500
Received: by mail-wm1-f51.google.com with SMTP id u2so122804wmc.3
        for <stable@vger.kernel.org>; Mon, 20 Jan 2020 08:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fMDuo9Y9NeCog0iRsPyOle7AGSm0BadbumEWdEHrMJE=;
        b=TIz1I7ShNTloVj2LyMg/WgUi/ZTfPAnnOzjTjS1wUJ3Q/6MvK7aHeKVGmKo8/8gLZ0
         SiHW4bolFuCmuisWI4LRObDsviJthPAw0pYQs/85+6zg7ZEV4OnpPTmnJS3QQE5kIlCe
         X2u40zX0a1h+TROIV0LfNLUsCub3d2MKSW1WQOYK2UsNc9wvfyfc2MmiLtl4vf5GAM8w
         Wsk8kXOtmY/d4LC+YOLHOwZrLFBClIjdR9IfbTLEG8W+H5sa/Jf68W4GpgioaHnYQWeF
         E7Td9ulTQOE+utOxZhzjCtkQQbHw4Y8Ukb+QZmY2KaJrWf3Xu+rHfFMozsGNC0tIwDmn
         2Qsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fMDuo9Y9NeCog0iRsPyOle7AGSm0BadbumEWdEHrMJE=;
        b=Cfj/JAfbHJ4CPCLfjujJKvN0OuE+92BdYnYHBMufJEPoIa+wcvKqEqkLIlM+NrZ15+
         zs9le8AfWRNnAjUlSC3syCrAcbGPm+7JC85CfEHBuCmKprlO1YeA+ansDcl+YZxIwS0O
         pNVDISkA4F3++1LivCTbOZA4YssDbslEOZW0nISAXSKhkKJ206hsXEkqCT8uoD5LblT7
         BFsY7asX9aSHAOsZSZ9pExCH05uG6SYXaz8OeecooEYYbdqrLp5ZqWWwINAJ8FPlFWVa
         vKeeD4jbJP0qkUwCLPfSKWATjtJnydKhS3uFXF9yJSBXM/EBEJAmBxI6nT9G3jCUT1bV
         gGoA==
X-Gm-Message-State: APjAAAXsC04rOA7zgvRNPSFziUqafs6CELo6ctA0zecp4KoNnNhpbDfK
        urOKVrb191DVdlxfdDzd+q/dJ0HK4M03GA==
X-Google-Smtp-Source: APXvYqw//DM74qaf9grq4hVi0kWk47t3MjYqUInbRk+jDOydNlz5RLMM7EZb2R4vWFqGRrY9co4A8w==
X-Received: by 2002:a7b:c956:: with SMTP id i22mr62159wml.67.1579536331514;
        Mon, 20 Jan 2020 08:05:31 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g21sm5452419wmh.17.2020.01.20.08.05.30
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 08:05:31 -0800 (PST)
Message-ID: <5e25cfcb.1c69fb81.5b94a.5c29@mx.google.com>
Date:   Mon, 20 Jan 2020 08:05:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.97-54-gb0ef8c14676a
Subject: stable-rc/linux-4.19.y boot: 68 boots: 0 failed,
 59 passed with 7 offline, 2 untried/unknown (v4.19.97-54-gb0ef8c14676a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 68 boots: 0 failed, 59 passed with 7 offline, =
2 untried/unknown (v4.19.97-54-gb0ef8c14676a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.97-54-gb0ef8c14676a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.97-54-gb0ef8c14676a/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.97-54-gb0ef8c14676a
Git Commit: b0ef8c14676a3f3a7fc8bd1c19fefd91ed6f94d2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 55 unique boards, 18 SoC families, 15 builds out of 203

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            juno-r2: 1 offline lab
            meson-axg-s400: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

---
For more info write to <info@kernelci.org>
