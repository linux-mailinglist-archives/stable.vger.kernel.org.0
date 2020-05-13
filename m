Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3591D1B49
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 18:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732543AbgEMQk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 12:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732510AbgEMQk5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 12:40:57 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F758C061A0C
        for <stable@vger.kernel.org>; Wed, 13 May 2020 09:40:57 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id u5so5409266pgn.5
        for <stable@vger.kernel.org>; Wed, 13 May 2020 09:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jhhCDxcflw/bk46Jk/JZ3Qx09JeH0eqsLuk4o/r5RoM=;
        b=q5qen9y+zcZoOAhquj12PzknsjnKeBNUudXUzr089U+2iaHxDh3WkpGlQL7kCfbDGv
         +VyXPZ4j9Z9kcwiPTuCdNwn2Krd8/ZPp7dznJI7OcCMQCUciT9JYlbgpmGQ8miPIAddc
         ZUqJ+fHRLOhLG63D0oKzlgr7W7V4FgEzlD/n/cOeBeUpdFiScUQBVpo/jN7T2Xf37wmo
         PKGVgGu0xBf9oQ8rQaWlYqovtgoxRWpYFz+Oy+Zvu8jmIw8v7xWbC/jgkzkq7tn9X/6g
         ZYB4pH474g9gWdrQOi92DHK1yF/hGeuBu4RILEr77FOU3h94Fa4up8hV7YGo+FBLmJfW
         RHzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jhhCDxcflw/bk46Jk/JZ3Qx09JeH0eqsLuk4o/r5RoM=;
        b=eKrQ4CLeJVTMnjIISI/cWPN8F62DlWxp0wZV/quQysfCQKHfHkZ+Mzt4skrEHSbcqX
         bLdeG4ycpx3mas1mblULAjm5K0q877QnrMezKqFcZQIhyjLN33w3fiZHdLLNsQYQR4cn
         f3LsVe/WdlFfKPBnqJ7CUz3Ldnd7vi48etcrPQYPCUuEFUuq865Uf8gO2fLxNAhiYfTQ
         AMrcY/hUqrzF4upCPj0Yb+fTHAcjpTqhnQMKPknfnKQZF4c5GPEYQGdUz8G09TDL3ZZY
         ulU6MWC/sBvvy+zr8QhqmwPmVMyLCczU31kRzDh1Aj+xdoJ8Fn3nXRwRM5z4eEaTFU/F
         La/A==
X-Gm-Message-State: AOAM5302MCP1WuwN5T2YAI5+gnhRHF212kFbfeCpUnQlGijzbEhTO7z6
        dI7Nv/jiiav5mokEO96FTgA2E9RBwGc=
X-Google-Smtp-Source: ABdhPJx0UYoDv0ZqgKo5hfihCK1U+GOK43wC7iH6+x9wmZ2pIxClxZTZeVGSWdCMY4Ebpsd9goT08g==
X-Received: by 2002:a63:d74a:: with SMTP id w10mr147586pgi.417.1589388056573;
        Wed, 13 May 2020 09:40:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w1sm174658pgh.53.2020.05.13.09.40.55
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 09:40:55 -0700 (PDT)
Message-ID: <5ebc2317.1c69fb81.36e7.0793@mx.google.com>
Date:   Wed, 13 May 2020 09:40:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.223-36-g32f5ec9b096d
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 93 boots: 2 failed,
 83 passed with 4 offline, 4 untried/unknown (v4.4.223-36-g32f5ec9b096d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 93 boots: 2 failed, 83 passed with 4 offline, 4=
 untried/unknown (v4.4.223-36-g32f5ec9b096d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.223-36-g32f5ec9b096d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.223-36-g32f5ec9b096d/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.223-36-g32f5ec9b096d
Git Commit: 32f5ec9b096d350c7dc7644c95912a599f6e8bbf
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 17 SoC families, 16 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v4.4.223)

Boot Failures Detected:

arm:
    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
