Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 849CC210F9
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 01:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfEPXYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 19:24:11 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:39997 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727245AbfEPXYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 19:24:10 -0400
Received: by mail-wm1-f44.google.com with SMTP id 15so963960wmg.5
        for <stable@vger.kernel.org>; Thu, 16 May 2019 16:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zbxoyiJeajtfiUVJWzJrG1BjPLUOgw/FLOMR77QW87k=;
        b=k3HEqewKRMChx2P8DUJq/odhgjgYXB58eQIg925ZxoRqObsAZUmn71HdLAaLvZxhPc
         vqPfABP2w/lBgHfEyqa7Iv0RkZmfyr7SDb6mRsDOIKZnkuIyyHl7Z/flaSmu5rDxctyX
         ED0I/RPhpphaE/WkUR2KslNp4V9MZXEggZkjE1jMlq05wiwNHYSZq4EyoI+AtzbEIQxD
         xRBgh1HW0B0rWVhum4Is0nVbPmL7BvLnNa7+lEXKDUgXQXRgPfE8K8K6KYgVVPVJyAti
         pqKPWxPeBJHAb33J8+Nfx/S00dbG+ylYFOPdDHV4S7KxJ0A2KHwwe6MhuVyB3HJoCErp
         RzSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zbxoyiJeajtfiUVJWzJrG1BjPLUOgw/FLOMR77QW87k=;
        b=NHu+YCIuQc4eD8x0n3AjkGm2ZZZ6rATITamMIOrqFMLrzmozg2FOGq0u3l1ppM7KyI
         Q5/WhpJIF8qSfaUtQtA1TE+QdgA0iqZHTbiEhIA//CTzlnoiFxWiS8nOG9jLBAn9bliL
         dkig5OmpGOm9l/UERnkZj1Hujdy8Gg9G+zeoSvrOGaL9Z/BYjZwQORL71GU3x+zG0dQB
         dqYfAssYVPmSwib0lErH2t0G16rlg9DWpVEVUfzgXanylYn0j/1lq+NS+HbSOPh7+fpU
         bmEe04uw/onvbjwKfkjOKTTo81tVR9d3KYhvfNQUKi6aJz77XFCEvOUEMjrsSyDgAvRv
         nylA==
X-Gm-Message-State: APjAAAWHqi1OPXIK7dZNq0ilFXv00enLj7pqwHTbQVduUUPTxCsj05nz
        cs4H5NuHay7p8q6rKWHIB9BGUcHkjLuQrg==
X-Google-Smtp-Source: APXvYqzoP1PLyFeNscCQ/M5+WNTxMNQLDVYx44zz1ltRoxzhNyzwDXX19odFLZsJ/Jufvu8BvtttOQ==
X-Received: by 2002:a1c:9d0f:: with SMTP id g15mr149792wme.97.1558049049622;
        Thu, 16 May 2019 16:24:09 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o8sm9783693wra.4.2019.05.16.16.24.08
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 16:24:09 -0700 (PDT)
Message-ID: <5cddf119.1c69fb81.41d83.9f37@mx.google.com>
Date:   Thu, 16 May 2019 16:24:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.180
Subject: stable/linux-4.4.y boot: 43 boots: 2 failed, 41 passed (v4.4.180)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 43 boots: 2 failed, 41 passed (v4.4.180)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.180/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.180/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.180
Git Commit: 0f654c12cd720e65f1fb3174a7ee468f1daa09e7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 17 unique boards, 10 SoC families, 8 builds out of 190

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap4-panda: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

---
For more info write to <info@kernelci.org>
