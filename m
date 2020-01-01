Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9999012E075
	for <lists+stable@lfdr.de>; Wed,  1 Jan 2020 21:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbgAAUvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 15:51:48 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41345 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727207AbgAAUvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jan 2020 15:51:48 -0500
Received: by mail-wr1-f65.google.com with SMTP id c9so37628606wrw.8
        for <stable@vger.kernel.org>; Wed, 01 Jan 2020 12:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=l2k7HVyunPGcsM+RXdAJoq+uiQ/77uMMZQde5L9MMmA=;
        b=cRI0uYSoTf6q88Z7wpsSlQzSjdGBW2l+OiJ5KA9fCa4geFhShK/pcjAukQ0+MUVMRa
         Vz/1aOuHNtHfxlqqo1UUc57P5Xwzy+ZcRnsvNEVS7pXY/ynVg9ZziMsoo69TTJ2l28J4
         8z2ppzMYPlnYK9Ur6kFwh/8rGLN+uIoZEzZBwDCOIsAUTVBmBGWvt8W0B3k1cz17wbNt
         dxVlir1WeBs4nsEAGeDwkYMJOjWjpCeFstVgeB14ovsDzLlVWXhViHZ6z1Z1ithWEjnA
         d3QMH3BDoxx/1mdwWzh3G1tafNnf6GGjGVs5YcX2AZq6e/pU47m5IdEAOarBW5p2pAap
         D3zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=l2k7HVyunPGcsM+RXdAJoq+uiQ/77uMMZQde5L9MMmA=;
        b=YOxHIcWx4pgmuK5M8m8PfvOFnLmOXyrgi9x7zDn5Q5bntZBGRje4zRxKUXhVdX9xZ/
         XUhcKwTBkZhp0UHL0Kr3FGWaVCMhs9aE3NCFVedcRoegksuSd3zGo0uRP0xnm/xQmi1Z
         I1iIcMg640KnuBfViI32lTYz+F60Edgh27oLBfiDibcnGckBfvW+ICH/9rDhIhKZgIlV
         a14K3sbFWCUaNoy6374e6qb1lYpS3mPU6zGm4p0rW2owDkSEcC2nHyt7WCaWgHRbSVJ6
         59RgmHQXm2LjgfXwpKQDHVc9AbP6EI/UJy2GYValdeKQ4BP0AJWS9Cc2Bq1NC+hmMLID
         nXag==
X-Gm-Message-State: APjAAAWtYItBjpZ1LQF8fc2gcoQKJAFXUMXXbmEkF8K6AZ95hoTLNAlv
        OYs8s9u3nP8D0I4MWy+TUV/EjbXJdWv+vw==
X-Google-Smtp-Source: APXvYqxVhn1rHmH2SdH5ilbg6btNub6/akkFRLqT9lgLDnenR+9uhhdO/ectZZAdLLWczFO8GzdWDQ==
X-Received: by 2002:a5d:6901:: with SMTP id t1mr73447530wru.94.1577911906259;
        Wed, 01 Jan 2020 12:51:46 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g199sm6592351wmg.12.2020.01.01.12.51.45
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jan 2020 12:51:45 -0800 (PST)
Message-ID: <5e0d0661.1c69fb81.1ff6a.dffe@mx.google.com>
Date:   Wed, 01 Jan 2020 12:51:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.92-73-gdad83dacc6c8
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 44 boots: 0 failed,
 43 passed with 1 untried/unknown (v4.19.92-73-gdad83dacc6c8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 44 boots: 0 failed, 43 passed with 1 untried/u=
nknown (v4.19.92-73-gdad83dacc6c8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.92-73-gdad83dacc6c8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.92-73-gdad83dacc6c8/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.92-73-gdad83dacc6c8
Git Commit: dad83dacc6c83071257a9dc4d4f450d9c9d2c64d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 34 unique boards, 10 SoC families, 12 builds out of 206

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v4.19.92)

---
For more info write to <info@kernelci.org>
