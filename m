Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F35D148C53
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 17:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387732AbgAXQhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 11:37:50 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33143 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387687AbgAXQhu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 11:37:50 -0500
Received: by mail-wm1-f67.google.com with SMTP id m10so3873528wmc.0
        for <stable@vger.kernel.org>; Fri, 24 Jan 2020 08:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Hth6E4SYdwXsmP8dOgE3o55Lla49prwt2EeIiUXK61k=;
        b=E9YgWirkDxZP4NMKubzyXZNsrYttXLWjJKvUyBdH+2WCqk9icVwY6LwHuKyxVYuvN0
         3mn9gTYTV8mD2YrXeuvwroekaUXsJTHFq3tBWnsPEvyJjt1jPxSiNYMIWiZ8ame/Vln4
         nyUtPBgafdQLniXQ0tnUJhZ6y2tmIYHcHNUeviCPLZg9kq16/eKfG3Y0UmF9fd7Mu1P5
         f+wHhB1ff14GltPul9J/c2Omc8Gf2YI+rmiDUnIMiyfbK+cB1yOE9urNXAaE3tLIxl1Z
         fdygu7rTo311nEoJ8s8k77KjTq3q4BD8PH5LjBTj1jw7nZjf5JlRybxvp4SX7COXOkEL
         YVnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Hth6E4SYdwXsmP8dOgE3o55Lla49prwt2EeIiUXK61k=;
        b=ghTPaQENNT4hsBZwrsSYNRKpzzqjM8r85hRNVAyqm6ZkUH28HBvThXwOpMaf7bBEJt
         QqIvdtTweUy1Xojobw1my6QdYd3wO7IF0FH43A7lVcEyWmzgWg4A8Itdh4CyvHEo12mm
         JL+obCK7+Lwo+gwBeB6U2b+P19WUi+M/mJjAgkS9iYe3FNUTmie+LQyCe4nBf1V1hoYZ
         Cj29CosL5iv7ychfONHBEjZ9R+tqfByABKPcToNF7a9pi7zklfiiD0LfOBaHZyLym8GE
         vb7JI5f5wVV+ZnOZYrKM3cTipgLEqcXk/POZjP8IXD28n3aTR0UPH7stq57WAA3jiGO9
         2yxA==
X-Gm-Message-State: APjAAAVCs1KJkX3xXZe2Uz3UgvXpfhTM6cEB3AgmYTqgAkvVY6ZSMSLo
        tYWJqQ1DuDd8vnDQC9PVoayJvmKUc/wMqA==
X-Google-Smtp-Source: APXvYqxdt9TIMFBDv8ewfErgM/tbqlNJB5AeikEN60K+kj1am+9ajyuvQgxVwS8BM9VUKvsvknj2UQ==
X-Received: by 2002:a1c:6755:: with SMTP id b82mr52869wmc.127.1579883867909;
        Fri, 24 Jan 2020 08:37:47 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f12sm7462599wmf.28.2020.01.24.08.37.47
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 08:37:47 -0800 (PST)
Message-ID: <5e2b1d5b.1c69fb81.92d31.fa5a@mx.google.com>
Date:   Fri, 24 Jan 2020 08:37:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.211-161-g0aa587edffe5
Subject: stable-rc/linux-4.4.y boot: 56 boots: 2 failed,
 49 passed with 4 offline, 1 untried/unknown (v4.4.211-161-g0aa587edffe5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 56 boots: 2 failed, 49 passed with 4 offline, 1=
 untried/unknown (v4.4.211-161-g0aa587edffe5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.211-161-g0aa587edffe5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.211-161-g0aa587edffe5/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.211-161-g0aa587edffe5
Git Commit: 0aa587edffe552a8298ecca3ed5eac0e06efd514
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 37 unique boards, 15 SoC families, 11 builds out of 165

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

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
