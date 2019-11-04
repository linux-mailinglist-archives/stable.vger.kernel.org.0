Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1114CED6E1
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 02:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbfKDBYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Nov 2019 20:24:37 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38862 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbfKDBYh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Nov 2019 20:24:37 -0500
Received: by mail-wm1-f68.google.com with SMTP id z19so10172140wmk.3
        for <stable@vger.kernel.org>; Sun, 03 Nov 2019 17:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jugQYyvxtrg8kvtfDpi7h7jAYPsQvBEtJvChNlZfJoo=;
        b=Yxom0hj1sNRHQ8vY0jW/de1mo4StbadLn4EwSvVOSb+rw0HIC3P32Yyt6fHv/QErr6
         GqQLKTtSNal4BmfUTwfrx9ppmZCgZ5V1//XFRlYIU52ifNWj5TGIV6On1b3qxRLQ+rTX
         cLBqsFkBfOzjFPYbRLxsLjPWltwPFrBjF6WTddGgScPGA6la4sAHgXbtcuktBreITydH
         PWrOwunkavrgQFCC3KFRM8n0KpG8c13KFOENY2f+rlxflPqn8ff3mIt7buZ5fXtKzYkS
         dz4tz2otZpxGAsDkPlDzI5HYuIpGEjIFxfOJkppQE9r3Q312ps+eT3SI5gWWYVBvfcrU
         4i4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jugQYyvxtrg8kvtfDpi7h7jAYPsQvBEtJvChNlZfJoo=;
        b=LJbvZeEC98tpIBRK0EQ+J1wbZYfJOXkT0ml+TDDAu719WPxIxhVs0XyfW73+PEjPQ4
         cOrpw+GOeVzYjIeaU6gDkZ1EcV4z3RvHO5ggalIoFubgCdaddNtLrbqvmEwP+biUVUWb
         4+KujqrXw2AJDpNRviSUikd3O74f+1+sDJI2Er/rVN2osQ2lLjPmT8xWHGvQSMVDKVuD
         JsLDJQOgndym23tZxMO5283SAv7mbSnqS5fR3OYLkvSmI6MeHWwL0+0K/oZXVRavuTeI
         qALRMWhchgIwxt0VUc7RB1SI7W36ro8wr11CJffVdAqa5qPYTraoJCe2irs9zxkw5fU0
         ALLQ==
X-Gm-Message-State: APjAAAU9wv2z7FJWNbeVBLxpXg7E0tIBKJPLnUEGjszLWnKv5XI8eHLV
        bS0iMZU0uwqr1hMXz9eH0nemnWGvJ/Oz1g==
X-Google-Smtp-Source: APXvYqzS5k/4x7JVoya8tnICFcW8J0iYX5lRNt35cv2DBxuh2YOZjZL0a+3BpVfXYyPcR5v1fs9Ovw==
X-Received: by 2002:a1c:5fc4:: with SMTP id t187mr20295788wmb.142.1572830674941;
        Sun, 03 Nov 2019 17:24:34 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t134sm18412041wmt.24.2019.11.03.17.24.34
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2019 17:24:34 -0800 (PST)
Message-ID: <5dbf7dd2.1c69fb81.1c953.5d37@mx.google.com>
Date:   Sun, 03 Nov 2019 17:24:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.198-29-g511902db5a46
Subject: stable-rc/linux-4.4.y boot: 80 boots: 0 failed,
 71 passed with 7 offline, 2 conflicts (v4.4.198-29-g511902db5a46)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 80 boots: 0 failed, 71 passed with 7 offline, 2=
 conflicts (v4.4.198-29-g511902db5a46)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.198-29-g511902db5a46/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.198-29-g511902db5a46/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.198-29-g511902db5a46
Git Commit: 511902db5a46649d6b128147a72e26b927d1e072
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 41 unique boards, 17 SoC families, 13 builds out of 190

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
