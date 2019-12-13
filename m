Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 366E711E4C8
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 14:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfLMNjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 08:39:21 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44006 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727346AbfLMNjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Dec 2019 08:39:21 -0500
Received: by mail-wr1-f68.google.com with SMTP id d16so6649322wre.10
        for <stable@vger.kernel.org>; Fri, 13 Dec 2019 05:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=14rnrNBx4s+Kj0T7y5suEjfb+f/4xKjvS7PmECnOqWw=;
        b=GrI/dkXyYk5ISi699KuSYXDSpQotYwArfhPbOttETbdsTY/5hKNieDhdixk/92Uv6Z
         Ma6jg4ulXP0fiEX2488X7ofsu8kzzkawSRmXOOnd6XP2sD/xt1vcM9TnAX/DOPAfVPrL
         MYNmlFGxWtmpghw3zIHMsImN+SCCjTUGtN4oUsv3fJoqZ9eMcnh9SCuP/3ePvTD1YiOs
         6sIT4dXcdl0NYra5ehY7TbZpqC9vDeBAIxs4DZJIO6xoX46M8XplhfpSxD3BADroW3CN
         QJoXk1bw6vPkRXlezi93hYC2UYVXj7bsN+2UzaJJBFVgSRm5FdawFUMRvuAuvWvssIbt
         Ls+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=14rnrNBx4s+Kj0T7y5suEjfb+f/4xKjvS7PmECnOqWw=;
        b=fqV+sJBLKa3SAzPg0ApeF0Xm4xfoP/4yQ5+WZpPwY4psKOt9BZLH8gGa6z7sGhjUKE
         hj3iooLGKb9241tzzIZ+/CVmu+vTnyI3lNCaRmORqZPPDV6H341VpAUxqClWrVdh1FKz
         t/4DrfqliFRZ6QANZMzMSlBSWRNsHqfWn8QNymWNvecQsZwhbiQ0lk851lDJpOqs+MLG
         vYY4pbw/9k66q9iEskbYvQzfUIH1BhLaeAHnYQJ82Fu9QHX2zUBnG1/aGNs52mPWdpRp
         VXw93mja3B0RbR91egUTd7njTKHvs7V91pb17QBGx/EateXNYGqrW5KQJ7KoOY69icMr
         ZIYA==
X-Gm-Message-State: APjAAAXolnOXLyajosgVoLoIVC+rVKtFJKd2QtFAN6MyQLynWFTfclla
        tNYej/nrhI+ux8mFsrKCS9xx7RIviChKvg==
X-Google-Smtp-Source: APXvYqx4lKJDgUlGSw6HiHlXBtQnHORXdksr62/OonePn8acOFwPUlMaOdTe4FciTgJt1UOzvyMJng==
X-Received: by 2002:a5d:4e0a:: with SMTP id p10mr12679967wrt.229.1576244359016;
        Fri, 13 Dec 2019 05:39:19 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j130sm5611219wmb.18.2019.12.13.05.39.17
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 05:39:18 -0800 (PST)
Message-ID: <5df39486.1c69fb81.e2d9.de95@mx.google.com>
Date:   Fri, 13 Dec 2019 05:39:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.89
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 85 boots: 1 failed,
 82 passed with 2 untried/unknown (v4.19.89)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 85 boots: 1 failed, 82 passed with 2 untried/unkn=
own (v4.19.89)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.89/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.89/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.89
Git Commit: 312017a460d5ea31d646e7148e400e13db799ddc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 51 unique boards, 17 SoC families, 15 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.19.88)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v4.19.88)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

---
For more info write to <info@kernelci.org>
