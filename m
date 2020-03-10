Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEEE0180772
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 19:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgCJSxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 14:53:32 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33302 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgCJSxb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 14:53:31 -0400
Received: by mail-pl1-f193.google.com with SMTP id ay11so5804910plb.0
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 11:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eEjCOKd3BMJe3gYQGKfIVGTXUOMJGWjQTxzWleYp648=;
        b=DkeaiWVI/6Se3CKF4VR5ealA5lq51Qglfn7iiOnhRPY8i4IPN41siyBYxnZNI+pqUR
         HmtdmD+qNw5NNCbayRiZlgCz+pULljoaTSoZgQP6sIxqImi06diNwY4bWc15xpB9iDdp
         orhVtmLYyPXPfcVWR/B1TQP71NfpvuTjIwGH2YTJze14RGRMs/px+jsfstSBMbU7nPtW
         Ws5wDB2J85JqwIT0c1h0/mnZRmb1MCXtuOs2NMxq70N2THRo0y9RPK6bGAm6n6YPVDjR
         m6jvIcw84RBJzsnChct7Xhx2OMYTLARd8ozJ6eWYET+AUX4xh0As9ju8MuZu3dPn1TMx
         Xgpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eEjCOKd3BMJe3gYQGKfIVGTXUOMJGWjQTxzWleYp648=;
        b=t7S5DAyhCzcpqQJHm1LpTpUUgv8YhlOMBk1Zqjsw3fUk8kStRliSzSz5TkR/S4QHHH
         fLM4Dm7rEQ8yCmcyZKDEdZ7W7Jvn265Nw9xtVpT6u1bjpbYXV5FGJQH74UianvhrEEJO
         GAX/QHZxS3lRxT7hrx5bP6+NwNDwq2wGBKRuSEmo07GZSy3xaMPjXz2UT1WvWCfnC7uM
         6uA3SKM9Onexm1D/jvItrgEBiAfp2C2vQ09rnOBs382btfSCF0GfTdB5z26TL/ZOremb
         a8s9IEZaeYU4nZu2qZ7y64sqxyScmOzdxknsR0W9L7BSerHHZQCmVe0/NxIGU6/8A3pu
         r0aw==
X-Gm-Message-State: ANhLgQ0NoGZ1E5ZEUlW5rJAPjkceXPp8ONYf3LQ4GPEi4YeqFYjpf9kO
        vSqFot+mnLdkFO09seli4BpxsyzusMQ=
X-Google-Smtp-Source: ADFU+vvzHEGLwtFnNjJ00+YzHh6oU8zec+Vx0BktI7p9p4mG0N+LsXxIqqUSvII8bhuAs3C/s65z5g==
X-Received: by 2002:a17:90a:b10d:: with SMTP id z13mr3232106pjq.132.1583866410445;
        Tue, 10 Mar 2020 11:53:30 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 128sm35771589pfe.163.2020.03.10.11.53.29
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 11:53:29 -0700 (PDT)
Message-ID: <5e67e229.1c69fb81.28b22.3288@mx.google.com>
Date:   Tue, 10 Mar 2020 11:53:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.24-169-g01c3b21f542b
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 120 boots: 1 failed,
 115 passed with 3 offline, 1 untried/unknown (v5.4.24-169-g01c3b21f542b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 120 boots: 1 failed, 115 passed with 3 offline,=
 1 untried/unknown (v5.4.24-169-g01c3b21f542b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.24-169-g01c3b21f542b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.24-169-g01c3b21f542b/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.24-169-g01c3b21f542b
Git Commit: 01c3b21f542b6cacf7e747c966b888df1c28f421
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 88 unique boards, 22 SoC families, 18 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 31 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.24-123-g6201d69ba=
49e)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.24-123-g62=
01d69ba49e)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
