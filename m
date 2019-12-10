Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42F1C117D5A
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 02:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfLJBsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 20:48:35 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45091 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfLJBsf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 20:48:35 -0500
Received: by mail-wr1-f65.google.com with SMTP id j42so18173727wrj.12
        for <stable@vger.kernel.org>; Mon, 09 Dec 2019 17:48:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xwV3Ta+3XFqgpAYPko15SLJfnAcYtTuARdT/QirVv/0=;
        b=em4f7H5vj8uhMpJGo8IBkuDm9187FuOiFrsTpis4IqeH7BivzdGpFDDHZ27hsFH+Zw
         vv/g/PAGvwwOmAwM7ha2Bkwh7sM57mr+RdWHG1kRBDahFk+G1Di6j/ZgwSC4qWdb6jte
         zjp1OCcM7VukLDVYrw+Xk0nids0LDXGxNMvQhu8MRvs2TndDR/iBzBfYMSq1SfS3kl6N
         Q4hEEO4t67Joc67DFMrLl5y+sL9CXuq0lLSCAJt/JqKavuO2NI9Pks8uuNSyCYIh791Y
         ARdKHp9MobqkPKGAPAn2Dmp+5C8md5Jobtq5ocCtrpN3hAHF1z8pMP2vrqX6hbnW1NjS
         RkYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xwV3Ta+3XFqgpAYPko15SLJfnAcYtTuARdT/QirVv/0=;
        b=Mxrv6lqBNDreS+bBzecIdI91/oLg+OuXKnhlhVCBIqrktKSafTbSyRGlWV4t4qJCnv
         OjwY0a0wbc2t2+dW+HK0yacdU9WFcPkFoxxx0L214NNIqGpB1G28krsX9e313wKP69D3
         2Ic+tJr6RyZWNqdBOH1EuVF94zKF9Axoi3T+PEzEBDNUp4OXUMRHT1/Xd4t1raHFWysj
         rcMsJci4yZbVljYUO+V4aw0lBg1DoMmuPxmip0txjKQJKC1QnG3S/qF0BbQYVW06wzhX
         /zrfTJjFoCN+ETYksQQpQmybPCA5vqRIjzdbmkWseIe2716IOX4akUishGnLUDKO2zqC
         zVwg==
X-Gm-Message-State: APjAAAXr+hf9WE1T8+BVsK4Mj2VlPHe+caevUtqXB/4xwoWcVoSzVGB8
        RK1pGCxeg3T7Dh/3h0GeK4sb+BsAzdt1/A==
X-Google-Smtp-Source: APXvYqw4nRz/dqSNvuL6l84fQNRovEzEdULmXljlR+2CdKKC0MO7NPM/5OjYLrGqRH03R3VfpduVvw==
X-Received: by 2002:a5d:4d06:: with SMTP id z6mr4925513wrt.339.1575942512591;
        Mon, 09 Dec 2019 17:48:32 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 2sm1499249wrq.31.2019.12.09.17.48.32
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 17:48:32 -0800 (PST)
Message-ID: <5deef970.1c69fb81.e7148.7d9f@mx.google.com>
Date:   Mon, 09 Dec 2019 17:48:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.15-72-g90b45f59bef1
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.3.y
Subject: stable-rc/linux-5.3.y boot: 154 boots: 2 failed,
 145 passed with 6 offline, 1 untried/unknown (v5.3.15-72-g90b45f59bef1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 154 boots: 2 failed, 145 passed with 6 offline,=
 1 untried/unknown (v5.3.15-72-g90b45f59bef1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.15-72-g90b45f59bef1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.15-72-g90b45f59bef1/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.15-72-g90b45f59bef1
Git Commit: 90b45f59bef1f72284a49994a4d2c4c3445f352c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 91 unique boards, 25 SoC families, 19 builds out of 207

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-g12a-x96-max: 1 failed lab
            meson-gxl-s905x-khadas-vim: 1 failed lab

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
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
