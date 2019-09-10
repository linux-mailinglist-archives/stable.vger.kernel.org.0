Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC351AF2DF
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 00:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbfIJWSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 18:18:08 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50633 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbfIJWSI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 18:18:08 -0400
Received: by mail-wm1-f65.google.com with SMTP id c10so1201740wmc.0
        for <stable@vger.kernel.org>; Tue, 10 Sep 2019 15:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JbtSZFoCuIeiko4MybP1Q59It/1hAbfBNDO/amNIffI=;
        b=WG9PijbR+qXyXeIF5VJ8mvPoB9ahmx8jsPliaFGJaNMACJI1ihOUylYUalifc8t6d+
         mvARWEIxKtpxsVdQSVlOAXz031nTnyhEzDIN+yz8wiXDGwD9UFa1uo8LQ2KxL4TJcoaN
         A6ar8E9alcUZxbOT+De7KEE74P/VI3d1gMlXN4sUFM8R+5HN5gOqLYyyzIjAkn14q7ON
         suS0EmXytFshLFRTe6+Qkmmsy7nhleWe95Qk5hWep8dZR11iFs0wVlsESNzxUBlOvOPA
         y05YR1bwHw73nwxyAsRLQMe1PYuDZRhTV0zj5p7LLLZ9iUmhFGJVwSJs9B2lFkRqHZQn
         3yZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JbtSZFoCuIeiko4MybP1Q59It/1hAbfBNDO/amNIffI=;
        b=UUTfeMZxIjd45BY0sEEmg90L3UBjoSp+Sb/pgGx9fYGbxPQ3rUr9AvgNccFnWAv0Rn
         s0n9ltgFlbHJB3auzRdGX9iqJRhlHyiCs8MZATciQMey0vVDG3tggqYNbo93Acpjpp7Q
         PhO+56G3aOp+ijkZOUZP2t+RYSVMFLGaQcDzW+lez+VeUETFaog3cHLGVMULRJu/l2PA
         SzJtbh/Zyr8uvg5IXITgCZGedYYtEQAPEN4YBJzqIW9RbG7QWZTud9xxPffqm0BEqhk6
         YbcEJ9SRYEcQ8Jp/YzDBy/5KnDkQW7qFYlt4M4DN8yT9hDXNe5+C/P+DYHXRfeDZd1fl
         MXMg==
X-Gm-Message-State: APjAAAXV1Dyi8iPkMA+wXgoCtoUFG+60JfWEZOo9E8Q5dUWIDtu/F7Gu
        fhQLYYW2e/jzn1HhXu3spYI7MSDpaeLnZg==
X-Google-Smtp-Source: APXvYqxMLPQu5bVSgrXju3d/hvEDsI+rx6THs9PvBdhT3lk31hXZQqIYkMDlFeA/ZAidGwxmawGbKw==
X-Received: by 2002:a1c:9dc1:: with SMTP id g184mr1238928wme.77.1568153886370;
        Tue, 10 Sep 2019 15:18:06 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q9sm539754wmq.15.2019.09.10.15.18.05
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 15:18:05 -0700 (PDT)
Message-ID: <5d78211d.1c69fb81.68c8f.2f79@mx.google.com>
Date:   Tue, 10 Sep 2019 15:18:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.14-16-gd24ce912b21e
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 140 boots: 1 failed,
 131 passed with 8 offline (v5.2.14-16-gd24ce912b21e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 140 boots: 1 failed, 131 passed with 8 offline =
(v5.2.14-16-gd24ce912b21e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.14-16-gd24ce912b21e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.14-16-gd24ce912b21e/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.14-16-gd24ce912b21e
Git Commit: d24ce912b21e825b08eeba218bbac826a581b68a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 84 unique boards, 28 SoC families, 17 builds out of 209

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

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

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
