Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0457B147C1D
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732963AbgAXJtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:49:18 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45279 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729567AbgAXJtS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 04:49:18 -0500
Received: by mail-wr1-f67.google.com with SMTP id j42so1160610wrj.12
        for <stable@vger.kernel.org>; Fri, 24 Jan 2020 01:49:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4rCLosyoD5qI/HoituMcdlpGcd4WH+FCeOWsNlpwyII=;
        b=Q4//lGi/n1WZ+3fbbm4cv2gZwmbk2WQjqWaJjX4ZFMVJiqChbTvvXcTVTrs4QTNPRm
         oXv6zkOghb0sxrH7aZ2uK4nEMh122RkEFlGRL16xG9uOIkst8oUcRZUTCIDEQY2vwWGd
         fdqD36PrrEpPvwMAqeps/kpjgrU4LN0piJrcDjAewZCACFP89MP7TUgwubyLkGTSVy27
         j5EYTfUhHJhhM+ISmD0PPmvZgDJoOslgxBDQDsrMAfR1l37DJvIuChyiIR5T2NbdNIQ1
         bipmvNnA140bBfazaRNzl3iwa5sTrkUE7Dtn1wo6lLMb16wwuOQEFikvaqFhNbhuhoOs
         ETnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4rCLosyoD5qI/HoituMcdlpGcd4WH+FCeOWsNlpwyII=;
        b=FGc9C4Sy16srpv2OWF1RT7AUF3oPHOkKUuUFXawZ1tv27pt3XffUgZAu3Io70Wou6P
         +McTVcEpU1OlkKujG6x5EvCe3qlMHglSiS8LeD/4JwgkxxjUgf60CP23gNji3YKYIsdV
         iYslaY4V3mYDeN1gZyNMfj2v2XmWlqWIZpqbuFyVL8qn+3eRkEa0NDw3sYwRBJMPNuWv
         8oAoXDDg3mDdXo08UtRG6tPbmuYNvQJPb+BmalaQUGiARh6nBhe66GY8IOPrXZMvhET1
         Xy21R9aPpVjXl2JCjCpF/aSZts+wFQGrKR1axX2mBvhGSw24Mp9pV1Aof0xqGdkNCsH3
         5Qgg==
X-Gm-Message-State: APjAAAXp0JeKgSU44PSn7GMoDmVL4BjTgB31YxCuEJIytdQeVfXdbfkj
        pEzkABgDiouX5ZuVrAwF8oN+oPdoUuLsSA==
X-Google-Smtp-Source: APXvYqxjKnnmt1V2ePVA4XUsV9Ci61etebfAFybHWYLXxyPfOJG2dMFdB9N+pXEnoho/QApLyFYT6A==
X-Received: by 2002:adf:e683:: with SMTP id r3mr3504335wrm.38.1579859355661;
        Fri, 24 Jan 2020 01:49:15 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n10sm6569699wrt.14.2020.01.24.01.49.14
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 01:49:15 -0800 (PST)
Message-ID: <5e2abd9b.1c69fb81.72cdb.b762@mx.google.com>
Date:   Fri, 24 Jan 2020 01:49:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.98-640-gbe6fe2fc68d0
Subject: stable-rc/linux-4.19.y boot: 135 boots: 6 failed,
 120 passed with 6 offline, 3 untried/unknown (v4.19.98-640-gbe6fe2fc68d0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 135 boots: 6 failed, 120 passed with 6 offline=
, 3 untried/unknown (v4.19.98-640-gbe6fe2fc68d0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.98-640-gbe6fe2fc68d0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.98-640-gbe6fe2fc68d0/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.98-640-gbe6fe2fc68d0
Git Commit: be6fe2fc68d0d7571c06b5fc11d2282a6544ec0f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 80 unique boards, 24 SoC families, 18 builds out of 193

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            sun50i-h5-libretech-all-h3-cc: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun8i-h2-plus-libretech-all-h3-cc: 1 failed lab
            sun8i-h3-libretech-all-h3-cc: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun8i-h2-plus-libretech-all-h3-cc: 1 failed lab
            sun8i-h3-libretech-all-h3-cc: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

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
