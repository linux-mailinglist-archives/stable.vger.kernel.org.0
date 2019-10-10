Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6280BD2C51
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 16:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbfJJOWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 10:22:54 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42111 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfJJOWy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 10:22:54 -0400
Received: by mail-wr1-f65.google.com with SMTP id n14so8116700wrw.9
        for <stable@vger.kernel.org>; Thu, 10 Oct 2019 07:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=veKUUIF6SlD7O2YVOYN6vkJnTt3Q0mZRuOcITuCXqmo=;
        b=K1M55KB3ZRI0k0NHJg5rAWZ5cFnxs+7sq0u8JNN3r4fIsNsNyZwFWDKTCeOrKF9cdE
         LRF7TYbgTQ90sRJjZq703HL9Unbz3QBFKUJlmI/2u+7WLLsB0ddPlwVk4us/pZzHZY1L
         znoNbqW5+hvD7+WhgCKd+jodob+3jvnZp59R5PG1LZ9JRKYEltEWVQKAOxOCfwzHAz5d
         4AaApN8WJ/cTNM5hrrgNeJ5lpTE/568Ti7qHWt0kqWP9xhX4hv0b+qoFFISlAFvjMomr
         XOSF7K5bu2OoEHWoDHNQHwL+jVoHEYm8qLWvtmZ4iC7ypG/mLZKwQyNjBUBB22VxGj5v
         XSaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=veKUUIF6SlD7O2YVOYN6vkJnTt3Q0mZRuOcITuCXqmo=;
        b=Xwq03F/Qli8zaPPhzaNnuu6dEvGchazfcUPSjHAxe8eyck859TDY6Iw/+iesFj+9W6
         zIRPgrVVwUCdvuqi0jRoaJ5u73anu/pOu6SV27VhZ0/RTcwcrEvz3auueSpNPmhDe7hN
         0ecVpePlN4FLqvUcjkJuV2kGPeIojXN4KU6ugyKUw5BxASdY4qFg9tE6KQ/sXyB6m67a
         ZlMICcKP6OU3Bk2UDL5IJnfax2V1RlIzaIdIIYCaLs2QBEicrStWCQMQKfeDsP8rRD+J
         0IScsaEb+UFAET60S6LPiRmvKRNeORTPV0H4zhgA3guFDGF1BzuohKziGNd9QdBg0Fhn
         TEaA==
X-Gm-Message-State: APjAAAXLe1dZtF60DwiNOak9sbrP1EchM1h7cQ7tXihCRGRb0CXWdMfY
        ZbVbQTpsAUHkHze/P0Zl8aIBy91HEMHovQ==
X-Google-Smtp-Source: APXvYqyjKb6M9yK7ELHxDxL+U6mVluHhOr+dJo7equ7EMZkWdL9yzxo/J0Pn1sUj54deioPM9cUkwA==
X-Received: by 2002:adf:f704:: with SMTP id r4mr8760061wrp.30.1570717371961;
        Thu, 10 Oct 2019 07:22:51 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a18sm8556857wrs.27.2019.10.10.07.22.51
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 07:22:51 -0700 (PDT)
Message-ID: <5d9f3ebb.1c69fb81.5072.a1fa@mx.google.com>
Date:   Thu, 10 Oct 2019 07:22:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.5-149-ge863f125e178
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.3.y
Subject: stable-rc/linux-5.3.y boot: 129 boots: 4 failed,
 115 passed with 10 offline (v5.3.5-149-ge863f125e178)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 129 boots: 4 failed, 115 passed with 10 offline=
 (v5.3.5-149-ge863f125e178)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.5-149-ge863f125e178/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.5-149-ge863f125e178/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.5-149-ge863f125e178
Git Commit: e863f125e178f8d2edf7a3a03e7fc144d3af82c2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 80 unique boards, 24 SoC families, 18 builds out of 208

Boot Failures Detected:

arm:
    imx_v6_v7_defconfig:
        gcc-8:
            imx53-qsrb: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            imx53-qsrb: 1 failed lab

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-libretech-ac: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
