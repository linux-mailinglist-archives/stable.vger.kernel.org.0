Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA295ACFBC
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 18:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729400AbfIHQaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 12:30:02 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:38014 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbfIHQaC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 12:30:02 -0400
Received: by mail-wr1-f49.google.com with SMTP id l11so11260279wrx.5
        for <stable@vger.kernel.org>; Sun, 08 Sep 2019 09:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xgoJ6KIl9oObahyFLTn9w3P2px6DYCxMWHv1maMbGpI=;
        b=JziK0ZSCa8QugbbUNXazOtJPs9RRnyvkmiqXtcuI+A4f/pIfERaCu2osJ1UBz1jj3O
         0VYq/Qbhq+ZJiYcEiDXS8A/W6uhUS9P3i1+frn5cjrxaD87lxQYuqZpcs6FruoeW4BxT
         mh/ZkUdzlMLecmyunl7ropBi9X9ktjqdp4TDBjiWF2hq9GoVfBmZyvUqmR0M5BE3UWYM
         bIcJYu2lvaU/DJOaT1gzTz3wdmABmz2T7glf47hcqy3W+KJraBkjUjHzeBmq1sIJhgpG
         i2jrtU2dVWwDa1kBGnPK2wPW4hWy7tAazcmzZVtZRhzJz3/jmC2pCWPrrk1YYmsDaBn6
         lBQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xgoJ6KIl9oObahyFLTn9w3P2px6DYCxMWHv1maMbGpI=;
        b=EFTUOYfyY3g/a2ypdjJDVLjBzm3MM76G43QgXognsU82630s9Ho0Jvtd8NZ3vhUnEa
         HBtjsW9lVFeEJp7ls3RE9G20LHkycT97QEI0IokqO369BhfVGeKQ3k/dQPu35JWqm5l6
         Xf6meY2DeietRZO/QI7vEGB2fY/KgXAz5xxYvvT8XQI6bc2nQfjT/qvcEoQ3I4I63y9W
         v5me0swxlaJPLZ9W0+IfiLUx68sp9yvZgiUIGrsEgj1a08AqQYKJlPepZyWtaScIqORN
         JkLXJ8sXvKVity1n49NOvlvTXgD3dmsrtndPooOB/PoggE0sp2dcZYue8/5yaBromvEN
         H2iQ==
X-Gm-Message-State: APjAAAUKcmQz/cu4GZ0TIUVxalm3thlX1L8rpJ3YNPaRcpi14AWbaCQZ
        6HDeSSWiftl4Hqu1E2e9v6kxCsmenkI=
X-Google-Smtp-Source: APXvYqy4+/J9tpUGYJ/0t5/81eh4rxeeh+6KSrP93L74yIlEI0hEcDjnsmwhU7lIm5MWVmojNqJu1A==
X-Received: by 2002:a5d:53ce:: with SMTP id a14mr6910738wrw.169.1567960198229;
        Sun, 08 Sep 2019 09:29:58 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e20sm22856331wrc.34.2019.09.08.09.29.56
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 09:29:57 -0700 (PDT)
Message-ID: <5d752c85.1c69fb81.0f33.958b@mx.google.com>
Date:   Sun, 08 Sep 2019 09:29:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.191-27-g77779f048861
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 117 boots: 0 failed,
 108 passed with 9 offline (v4.9.191-27-g77779f048861)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 117 boots: 0 failed, 108 passed with 9 offline =
(v4.9.191-27-g77779f048861)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.191-27-g77779f048861/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.191-27-g77779f048861/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.191-27-g77779f048861
Git Commit: 77779f048861f050cbe941d81d4674c7de3008f3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 56 unique boards, 22 SoC families, 14 builds out of 197

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
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
