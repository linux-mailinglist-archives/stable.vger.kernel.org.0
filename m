Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6362117D6D
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 03:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfLJCAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 21:00:24 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37101 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfLJCAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 21:00:24 -0500
Received: by mail-wr1-f67.google.com with SMTP id w15so18317204wru.4
        for <stable@vger.kernel.org>; Mon, 09 Dec 2019 18:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7IIGfOZL2Bn5xzx1nguWhrlqvGrNeb19e7cmlmQphjk=;
        b=VA9nIU5dEMczuwTgW3hk0BC7IM1E066kqMZNbDgAjctPBFpUiS5oB9eTHsFcSMU4+/
         1FXPSAqbdcnicHVM4bnFwbCWpLeLf+XR7J029QpR6L0WsEf8WyzjrXiui8U79zFZgHFv
         +115egABFMGuADwYJa5gsqhZZj38dxo1lgMWWiz1v4eJh/5mKu8UZUE3Ex3/PErpnEvs
         YTRKYHCmqtDjVfbFlmyR1HWk5ATwQja1clE01avTS6y2gY4brIYxKF/Gg0NUN1o9n2jF
         ZWx5ZFxdkQv3Eh0aGYxGHoQV+gn1fLfJZI8YaFsYT4szL6x/vUYjIC3OLVr2QTfXj+Ai
         QXAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7IIGfOZL2Bn5xzx1nguWhrlqvGrNeb19e7cmlmQphjk=;
        b=rSlOGuRAF4FQvePD26qadVEkWTZkwcnuh+u2mxJy1/vfbt7bP2bkP9IyzKViFNc6oq
         E1MATYpKlZn4xfpDTCWMYmol9EibWnAuqpwRm0KOe7GnCEfRMpFtCFtDPN0Pv/tYnboX
         E4aOz+6kETL9cWx3IWxLfx6SUsj01BTsl2Q4qKw4Vm78dsi6ytMOU4cqpCSVXo4SUoTj
         J9JUq7M08t8Xli2+N+cHeNEl9F5OUKNAusszu+PeliwZD5tTItiKTmdW9jx4qx4abXnk
         I2igrbbrBDYa4lNbfB/rKuWVDun2l3SxqpzQv4oc7ykjlyM9PXblRIz8ZcxY++dWlxDO
         OaVg==
X-Gm-Message-State: APjAAAV8BhSLuGkuBmXYbmm4dlzeWKh7KrcM6mc7YfUx+OwKye4nvW8k
        1+/hoRQTOJJ5+gVBS2YRIKJMX5LunfTpGg==
X-Google-Smtp-Source: APXvYqwkX2P0zkxNQ8e8WlMs5eVDsWTpHBqq00XV1GjteNl4ud5cQSTSDfKWEhwIpf9R/XduDoUzfw==
X-Received: by 2002:a5d:5491:: with SMTP id h17mr5320181wrv.374.1575943222394;
        Mon, 09 Dec 2019 18:00:22 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a20sm1451242wmd.19.2019.12.09.18.00.21
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 18:00:21 -0800 (PST)
Message-ID: <5deefc35.1c69fb81.dab9a.77f1@mx.google.com>
Date:   Mon, 09 Dec 2019 18:00:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.206-83-g0c2588d74b73
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 110 boots: 1 failed,
 103 passed with 5 offline, 1 untried/unknown (v4.9.206-83-g0c2588d74b73)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 110 boots: 1 failed, 103 passed with 5 offline,=
 1 untried/unknown (v4.9.206-83-g0c2588d74b73)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.206-83-g0c2588d74b73/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.206-83-g0c2588d74b73/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.206-83-g0c2588d74b73
Git Commit: 0c2588d74b73efea648551507ba3744f94186e50
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 57 unique boards, 19 SoC families, 16 builds out of 197

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
