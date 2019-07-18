Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04FC66C9B7
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 09:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfGRHGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 03:06:23 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:38614 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfGRHGX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 03:06:23 -0400
Received: by mail-wm1-f44.google.com with SMTP id s15so3075201wmj.3
        for <stable@vger.kernel.org>; Thu, 18 Jul 2019 00:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sMWGdIBskAXlgSXElRU2iGkeNv9D4GYWdN+GpC7oXQM=;
        b=RWnfmfqtOsfOA5jSunVT+2/oMoow5l9GQ9QmTbaALKr5folyNvPeLxf2sbliDpyUYw
         gnAZWzB2HosKmCtCQIMvuTZdFqEGn/mNNT2h6BNJGwe5R8o6GzWd/rgYA0V2IK9rHsNF
         Wme71EtA6Llmsiq9KfQfag3lt+VefzX/lKhSmk/4pJgdX1YEPN1Fknx5QfQ6o29uQi3k
         cFiqD3fuaO329cTndEQjenxNFfKX2ZT1fR4tUKCVUg782PrbaCa5iFY5HSncIuvXnXIY
         34ZmFdbHJX6z7Y7U1UI8dgeSUFyhnwx8N2u+U8BugZYLjrf8NxuEzTT4tS6KfC8L+ChV
         jUvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sMWGdIBskAXlgSXElRU2iGkeNv9D4GYWdN+GpC7oXQM=;
        b=dKIMo5pak9fPRla7XryeSwopdVrs70PH3ggC6dbV2L3dWS/hcqJfljZcR4pNohUneB
         a/oPxzXYbayF6rRyIB6okYcfL0ekzlsL0GKASNxWOx9otRN9iePtdFJaHP9iKSjWqbCR
         55LbE7K1gabfJzg64jk8iwK70L16uexBvTucMDa5pNANA5HGN1u9myNp8hxBm1Outhj1
         JUWNycJnvhMlcgCsDdV6FOmXO8uFeZxHjjI54ZMp7bmt0dxjGr3YDn2dtRI3/l1cbUko
         Isq3loNXmSyOr26q7l0EuDOZmxZegMepynDg0U7p7jr4A5k9RPnhgO7hBaQOG5n71Imq
         e66w==
X-Gm-Message-State: APjAAAXIMQ8zPPBKpMvuaWoOH6Yw64lQhHuKn8mFy8FdtgsA0neTBAwH
        I16BkulYqhhumgK8/HTVfUXMT2fbXgs=
X-Google-Smtp-Source: APXvYqxjXjojhnUNFkq23wQu9FIXVshD9NvaHyiafyGvq9uyanFQA8t7aXoLgxskw4hRy1lv2rZQZw==
X-Received: by 2002:a1c:6c14:: with SMTP id h20mr36571281wmc.168.1563433580863;
        Thu, 18 Jul 2019 00:06:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t6sm25644625wmb.29.2019.07.18.00.06.19
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 00:06:20 -0700 (PDT)
Message-ID: <5d301a6c.1c69fb81.8aec5.0909@mx.google.com>
Date:   Thu, 18 Jul 2019 00:06:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.185-55-gcc08f2abafc7
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 105 boots: 0 failed,
 104 passed with 1 offline (v4.9.185-55-gcc08f2abafc7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 105 boots: 0 failed, 104 passed with 1 offline =
(v4.9.185-55-gcc08f2abafc7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.185-55-gcc08f2abafc7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.185-55-gcc08f2abafc7/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.185-55-gcc08f2abafc7
Git Commit: cc08f2abafc74b206e12ac1f1b11284ccc032572
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 23 SoC families, 15 builds out of 197

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
