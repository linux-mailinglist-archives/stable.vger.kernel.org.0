Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E26DAB038
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 03:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfIFBiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 21:38:18 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:52413 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbfIFBiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 21:38:18 -0400
Received: by mail-wm1-f48.google.com with SMTP id t17so4742205wmi.2
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 18:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jsK3YBhQUOvIRHimiECmos7/LG7wVD6V6rI7JVUihJo=;
        b=rzdpcoqekbkRKzWvziNacgVRN4FiV1lPHmY4TaCo5KDYm52rviOin2BtTo9N7GbRsi
         AxWS+++3o9jYTr4uhZ6Mn3fGms5aYYrDlGxIEmW34tEX2eL2MPhg/cNwPuyssCJystSy
         db4f4A3qZEf6lOBXecbpGFl7Z7jGRWMI38oXtpWTUS/xXYRS8pEHZF8Cm409w7JLRNUO
         PIAghXdGzZMzUEx7Gtqpmvs+ElIhTscYNBGoiALeMLduZRi6thZVQlu3NBQgtxIVc70c
         fm4HtyNYrD7Cj7d3Ovua8cw/7HlrCMKkPJnqF7eWTIO9XIP6tnGfsv5JC1pCiIlE6/ez
         qBhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jsK3YBhQUOvIRHimiECmos7/LG7wVD6V6rI7JVUihJo=;
        b=FIeRkN5/TUo4pA5wVkmdZYF4ozZ5c8rDVFhnI8rjK34wJNf/u9ftdb4dUvuhzRgZzs
         ti/jSYdR7ZSMZwC9BHb7e05cjkWoEzhAdvyL5E835mMvsQD0bppnqFwixSgJu3u55Ibz
         +Yb9o9oWjiZ0TZTO4ay4aaUGjaDn66ee3C6UEaXB/wFF/KtuM40ycHvEPPr8RkAzcNYH
         8+EafnS/q5NWSpo3AC6B5SK3ersqjhZxhbo39w48h4igUjzaw1p7IpWvOZHzTKQbNKTe
         B2U3mQ1HezYGG6nlfkspTw0BmyHHkXqQJGfUC21wYMNZpqyd5+stOd3Ly3yKt3gfitU+
         RZSw==
X-Gm-Message-State: APjAAAVHEk+0zevzIs7WjcBX9/jPCgPJ/5xqTOAqQJipyOpCdJ/8rA8F
        eW4ukMEbKBFghaQ8xMp45b0q9W/XWqNkJg==
X-Google-Smtp-Source: APXvYqwbQlwUXHGW2CcvWwArot2/eDOb0+J+03r/8QsNyaCgAG59/a/+Fv2ElbS3cDu56iZ/MlBIJA==
X-Received: by 2002:a1c:a54a:: with SMTP id o71mr5316561wme.51.1567733895678;
        Thu, 05 Sep 2019 18:38:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v4sm7016482wrg.56.2019.09.05.18.38.15
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Sep 2019 18:38:15 -0700 (PDT)
Message-ID: <5d71b887.1c69fb81.17fdb.253b@mx.google.com>
Date:   Thu, 05 Sep 2019 18:38:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.11-147-gc548feab76ab
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 129 boots: 4 failed,
 117 passed with 8 offline (v5.2.11-147-gc548feab76ab)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 129 boots: 4 failed, 117 passed with 8 offline =
(v5.2.11-147-gc548feab76ab)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.11-147-gc548feab76ab/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.11-147-gc548feab76ab/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.11-147-gc548feab76ab
Git Commit: c548feab76ab4fe96255f342a0cfd66e4e04c830
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 27 SoC families, 18 builds out of 209

Boot Failures Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

    vexpress_defconfig:
        gcc-8:
            qemu_arm-virt-gicv3: 3 failed labs

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
