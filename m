Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBC3148CDB
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 18:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731934AbgAXRTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 12:19:50 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33292 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731616AbgAXRTu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 12:19:50 -0500
Received: by mail-wm1-f66.google.com with SMTP id m10so3947484wmc.0
        for <stable@vger.kernel.org>; Fri, 24 Jan 2020 09:19:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yN06qSv+Rp54XMaEzGLLeg1c8qESgisTmP8v6pDf2qs=;
        b=h8TTU7tSqYMa24nO+5fyqhQmLGqR6WT0LmXEn9ze9uQrAEVISU13gGsgVGPozjpJGD
         ksmfhnTASBK0yE2a2x4HeAHHU6cCgCM1pEqUkyjcLEXbeG8snCqOsvq2inaSMktb+QRg
         Guz9fiMRLdhJjff6iiIJm3JhwqT3loV/jDEgv7Z6hMUYwsA68o56c3Y0PzabfDG8a5fH
         xQmWb4a+G6mf//nJMkFU/WGpCStFXtaIwglGQCFL1JtNBN2phYfDI54GBZE4cjRpb2dD
         yvM2Davg7rFYPhqCOsUuj9QFciDsm7U84svD7st7PwlsB3lXhGoQwF9sTHuArLZNWz2Y
         VEAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yN06qSv+Rp54XMaEzGLLeg1c8qESgisTmP8v6pDf2qs=;
        b=HYGH47UXFtgs5ufqHMyJ+SfcymoqLOIihC6DLf2HRfrjA02sRGhvDuniCOJm7AuuN9
         HjjGPle1ie/vuZdDEP1NlHRtscCh1xZw/ZK//tmPual2eRZVqpsAXdToieCchMWFsMGn
         CkqUhaEO4VO4INYf+22AvKovB4ddPKylfDLewhCMhIJvyBDIKuSnocNcDWkv56azrdzM
         GaC3FL1SsWZGy1KZ3sB0kxbbUE0DrLmZEXpzcwcxbwfpYdZMrV//VMh+nFHr5UMLSWwY
         9pnQSS98FgYPsZFMONVIxqSJ4AD6c2DIQmpoJZxI0gc6N+b364nul+tFUqHS5BplRwR/
         Yvyw==
X-Gm-Message-State: APjAAAXPzG5wIEqpOmAXQ/kaDVkUAp5Zq4AADQDEeH15z2fOQS8mPCqZ
        yoGHtLgqoiTOZF0XNvgiX3grg3JPpF1aIg==
X-Google-Smtp-Source: APXvYqwCtApwdpHLOf/WN9xAnW/j+4BetggkFZGRUqtvqd3xzT19+Bub3FDSmA4Ro0+kzInH9m2eqg==
X-Received: by 2002:a05:600c:230d:: with SMTP id 13mr228548wmo.13.1579886388224;
        Fri, 24 Jan 2020 09:19:48 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c17sm8005080wrr.87.2020.01.24.09.19.47
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 09:19:47 -0800 (PST)
Message-ID: <5e2b2733.1c69fb81.6c79a.1f7b@mx.google.com>
Date:   Fri, 24 Jan 2020 09:19:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.167-344-g44ca37a00ad6
Subject: stable-rc/linux-4.14.y boot: 95 boots: 1 failed,
 89 passed with 5 offline (v4.14.167-344-g44ca37a00ad6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 95 boots: 1 failed, 89 passed with 5 offline (=
v4.14.167-344-g44ca37a00ad6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.167-344-g44ca37a00ad6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.167-344-g44ca37a00ad6/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.167-344-g44ca37a00ad6
Git Commit: 44ca37a00ad6e970111780ebce3b3b2b127ba3d6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 19 SoC families, 13 builds out of 189

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

---
For more info write to <info@kernelci.org>
