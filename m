Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1816367745
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 02:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfGMAeT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 20:34:19 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35797 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727261AbfGMAeT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 20:34:19 -0400
Received: by mail-wr1-f67.google.com with SMTP id y4so11574046wrm.2
        for <stable@vger.kernel.org>; Fri, 12 Jul 2019 17:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pluJnqFx/N6ow8/lU6OaniEaSZjN0QNdZrF7BnMffwQ=;
        b=lDhT/g00YTmVAXpZANvNx8+8IbZlu3CqEbCot3M510fT7elKUHOUCZ2kAnR8T8Pjdc
         TDzCRVyT3gbZ+1rE5S3YPr1jlrYb0HSKG4g8xGKkGdXRgzE9Mm7uHcWQew/cOh4zOUXD
         v3M6TebCJpjYLXcwEtVDCha6rg6VrnTuTPDIGj5UYokGJ2fcXDQSb+v4BIrspC8MMPHD
         7leXYhCiaAaUPlY+JZYsDZt+Eles0iKioXNAXDj58kcA4tyytINKlCDSNVBrAoA/sA9C
         QHujh7m5WKOnh7Xor1AOY2iVxG0DzOP58oxPdSRMhmxVXWEQbPTlpArHdB+aA74me9OR
         pAQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pluJnqFx/N6ow8/lU6OaniEaSZjN0QNdZrF7BnMffwQ=;
        b=EZ5edh7QK6Fy6HS6/fXBkgy8WoFPe2FaJbH6XOc8Sku9wHNjzC96mXW3VgLvSwxHn8
         2filWC8TR373CK7ZcdvwZE7FnYJrMLKGD0P2PUTM2gt96izXD1LpEGYsQQZqUzb7eXVL
         XogAbtbp0/dZnfeugoosbzLCGHTuFitGWKBnOTvGYJR2BXcQ+x/xL62LxURblXja9cGd
         gixQXx6x/hMym3RwafE7hYXMKHdpdW93sVtBeQkWJlpvOTcoGb+/y5Y/mqQDGBo0Ak3Y
         BVHPGTNy9AqfWj3kzJyV25jE6su3hXTvpocCqzz3+oqiCFLXLlKBTPtDIhhvb3Xgv5Bf
         kNfA==
X-Gm-Message-State: APjAAAWg8pdtStnndN6tp/uJvvWjSZD9LUmqgMEKjznfz/0TzrbLklPp
        MKUlYW3HRnf+0V774ZdTXC9QczMvC2Q=
X-Google-Smtp-Source: APXvYqwOegiiBh1eqU+rgB7/7t8jkhKkYeI6ae2IRBPuo9QVMlgWKwgOfg/uzaI4BxPao/nnLJu9mQ==
X-Received: by 2002:a5d:680d:: with SMTP id w13mr14096724wru.141.1562978057272;
        Fri, 12 Jul 2019 17:34:17 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p26sm13622346wrp.58.2019.07.12.17.34.16
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 17:34:16 -0700 (PDT)
Message-ID: <5d292708.1c69fb81.afdf0.1227@mx.google.com>
Date:   Fri, 12 Jul 2019 17:34:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.185-28-g58970591296f
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 92 boots: 4 failed,
 88 passed (v4.4.185-28-g58970591296f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 92 boots: 4 failed, 88 passed (v4.4.185-28-g589=
70591296f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.185-28-g58970591296f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.185-28-g58970591296f/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.185-28-g58970591296f
Git Commit: 58970591296fb18bd416251751a8fc665f8d9297
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 20 SoC families, 14 builds out of 189

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

---
For more info write to <info@kernelci.org>
