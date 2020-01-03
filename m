Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6F0312F912
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 15:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbgACONy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 09:13:54 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44223 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727523AbgACONx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 09:13:53 -0500
Received: by mail-wr1-f67.google.com with SMTP id q10so3610698wrm.11
        for <stable@vger.kernel.org>; Fri, 03 Jan 2020 06:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HGPbxMxk5rz7UJJi94QtkcLQ9yjnBLsOKwf94Rx6FkM=;
        b=Gqx7qrX8cAn9Svc4Ixyu44AzPwDwos0dqcdMgz82BmoEoGkJFUPRsgJcsu6aOTN/WT
         hC38iikrcFr39kgDsRRoTnMyhCHaeEYUiAZVht4kmk5KCb/VhEXSTYXw0gjY4TC9Qszd
         yCn6O7EYnhV8AzdIlc0EmPjHhUv4goSOXtFRbZIFfV/R67Acrvtj9LldF4IIPu6FtM1e
         4lO5tZ+p/ZtldGPZQM9Rt8OugziajiXzEs4AtG89hFo2aFFLM6gbsK4i9MoAzHYl9LVk
         QHJSRcWFCYyG2kX3Mb3oYZKywtEwPWuQXDsCoNrsVikkGJ2Bw100PsVku3TFFYB671Xx
         Y/bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HGPbxMxk5rz7UJJi94QtkcLQ9yjnBLsOKwf94Rx6FkM=;
        b=V47PBiMTkfCtqyhdweIRsAAp6SWMgyO2S32ACyj8jRfmQKXQHkDm42NeTi8MIG9ahI
         7+nJ/bG5hNjYAzC3+U9A1lXVPVPgJrjfBVNflya6QCUWYyw2RV2rCnflU8jTzlOtYyqP
         PBH2YNbPrGqrLTpYSzfQiKn2dM4LECJilFKdm6PJwlpd2muUEl93343L5DljewzbAcPZ
         viHc10Bx9+yFk2ON5IPVX8X6KLz5RhTUelyBW7EyzipTj+YE8VPsgmD5YAE2wLa+0FBQ
         mZhWvnaT2Nfc7KgUadHzA6EOOeLPplhbAfukt/Mov09GRS4+ca/vHBvKBtCxjIS1lCMW
         7Iuw==
X-Gm-Message-State: APjAAAVmlGqtk2gKkm/Pxpy20pwnO57gMvg+NQxvhDGEw9jWmwBl6UWb
        2x56bt3OlGBFtEZyqo2O2SyzRhxdAVQCsA==
X-Google-Smtp-Source: APXvYqwTP/7Jfi6hnUiTQpf6c7fuZeKJ22rN4BHe9lDgZUlp9IzHP8qXde6DwXjZb1grH42TjSPV7g==
X-Received: by 2002:adf:8b4f:: with SMTP id v15mr60021519wra.231.1578060831579;
        Fri, 03 Jan 2020 06:13:51 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b15sm12072087wmj.13.2020.01.03.06.13.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 06:13:50 -0800 (PST)
Message-ID: <5e0f4c1e.1c69fb81.eba1e.6c18@mx.google.com>
Date:   Fri, 03 Jan 2020 06:13:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.161-91-g0e6f77cf689c
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 52 boots: 1 failed,
 50 passed with 1 untried/unknown (v4.14.161-91-g0e6f77cf689c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 52 boots: 1 failed, 50 passed with 1 untried/u=
nknown (v4.14.161-91-g0e6f77cf689c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.161-91-g0e6f77cf689c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.161-91-g0e6f77cf689c/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.161-91-g0e6f77cf689c
Git Commit: 0e6f77cf689c028a3c0927237bac986deca2c3fd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 33 unique boards, 13 SoC families, 12 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
