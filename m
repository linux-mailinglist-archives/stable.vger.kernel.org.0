Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B027CF81E9
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 22:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfKKVNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 16:13:51 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45989 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfKKVNv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 16:13:51 -0500
Received: by mail-wr1-f66.google.com with SMTP id z10so10911452wrs.12
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 13:13:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SX0afSAOe0iCt5C/kh8cpjB9fT4fkkd+/inc8xVjqns=;
        b=BxdE3G+RWvARdfsLkOyY7sMTmpLRMpL3TQm/jyuI/BTwEnJwSOuTpiKqJ0O9B2KLwt
         GuQ9n1KhTvIomv/HNJdI0Qyy9OxGgA1+wBUFbpLsgbrs30nmHl57KqL9Dm/RgSt3J1zO
         dS/31MMldWezr5RfQUW9YG0rHj4v+kySEg7zIk/MH6fL81iFO+CBcjwycnAwMfGYj3CO
         mh9DVqoddfY6p0WskGtq1k3+hj4ZIJGvAQmOTUZDPZL0nLJs16+wQE5t1Hage/SInV/C
         Uu/9uPLtsROHunbVFfkeFZEGLFmZOTUHIo4CDXYea2qIOW0Ez9jkzhDkSj1eo6J+oFXS
         S5Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SX0afSAOe0iCt5C/kh8cpjB9fT4fkkd+/inc8xVjqns=;
        b=IzGcf9KG1wdpmZzLCOYuuuXYNJ7hv3SeHhSgXZrTDLaU+d5AHfpmCdrqMrddOyyVcG
         wyUcucS74xK2MdqgcQbe2Gs0+83q/R9IEu4p6GKoTY4FiCfPdLhmznyhHek/aQ1yrWxd
         zLwQKguWNxGtD4XO/rpj4BeaPGnNOf4wI2iUfn7uXvkoT6KMaNz1ui4GglGfRFn4F8be
         oYEKXeR+GUjPDW9xRsZMMwGIL5k44kc0BPDl1S/MKrsFsP++ns0Li7Oodx3ZdVjVqFcF
         AbNqrmkC+9HCW9bIVJp/0rSWdSdcJzvSTf+h4sTlLKO5mK8hfHO4/s3TM0U5p1Wr3nAb
         B7PQ==
X-Gm-Message-State: APjAAAW7xnW6nQ+JTZJLgJX1+c+T3J9ycvkBFn20g9WFMicmKkLoqHK1
        nX2X3Z+oBJ43YRU0TrxlmPUCN9qrKRFpBg==
X-Google-Smtp-Source: APXvYqzRDwapYLwqk/eoLg5ZN1I/xHcpISMaTWn86cvitRrl9COmWhPT7YdNJeVB6zLjAqnnm/C9Mg==
X-Received: by 2002:adf:9d88:: with SMTP id p8mr18286000wre.286.1573506829700;
        Mon, 11 Nov 2019 13:13:49 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g4sm18348063wru.75.2019.11.11.13.13.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 13:13:49 -0800 (PST)
Message-ID: <5dc9cf0d.1c69fb81.f5431.76e8@mx.google.com>
Date:   Mon, 11 Nov 2019 13:13:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.83-69-ga356d03470cc
Subject: stable-rc/linux-4.19.y boot: 69 boots: 1 failed,
 67 passed with 1 untried/unknown (v4.19.83-69-ga356d03470cc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 69 boots: 1 failed, 67 passed with 1 untried/u=
nknown (v4.19.83-69-ga356d03470cc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.83-69-ga356d03470cc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.83-69-ga356d03470cc/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.83-69-ga356d03470cc
Git Commit: a356d03470ccdaffd5be411ad08b4e1a05544d2f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 38 unique boards, 13 SoC families, 10 builds out of 206

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.19.81)

    sunxi_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v4.19.83-52-gcdd26fc9c7=
f7)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap4-panda: 1 failed lab

---
For more info write to <info@kernelci.org>
