Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C21EAF393
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 02:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbfIKAO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 20:14:26 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:32998 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfIKAOZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 20:14:25 -0400
Received: by mail-wm1-f51.google.com with SMTP id r17so910983wme.0
        for <stable@vger.kernel.org>; Tue, 10 Sep 2019 17:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=u6GvJrFhZXHdjVWcPHGWH/csgmt5BqzCj6MFDV0KBN0=;
        b=edl6vT6Y2b/XBe/Ms49LaUhxshK8F2tYBDKJu37wQLZbzvvCmQ+CC8Ir+eF3iqbm5P
         azdJA8ZbthhbVEAg424JSLAvLFQKVME13E+q6qwPfeM4uU3QOphvqN8k1rQ0tMgTYdXC
         F0vI3A+Pqu5aA6t+BsuyAqewT7veepc5rxAF3R64jwzNeYVY105tUcRk+WwrDGvMo556
         46PkQ/MXEumMrLGbWn3EaZoQQ27ZEwgtFifSdMSlu2ZjR/QpodBC8N90nEpa0tbuwxjB
         tSCKPf9/L7uVCQ2HiFQRZM9g0stxuq/vbzZplh8mOqxzMr/0P+7/BCkunbogBl3Z1qHC
         HM3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=u6GvJrFhZXHdjVWcPHGWH/csgmt5BqzCj6MFDV0KBN0=;
        b=NAkCbPQH4k7KgUJqI1k+sJpjyn2NNmmYHHooJ/dfSJge+u/wnsk1aS2DOIGetiSx7n
         53+zrLWwPyNuaJdbXySUyaR50r1MeADXvuPGnFKQQd1xIzlFN1t++FlwvvJ1BvAvBinZ
         BjTTmlNk9pQNuJwWajiXxqHqOJcYvHLiluYzSNOYpsa61BVdWAeMQQOfAOmsHXSC3AQR
         J2PoskhxSwZig83ybXIyxO9YFbIw7xEtT6P8g0poM7+4VCmxJL/YntH8CPskYIPyBexZ
         FLMD/mp0ZpIUgKFNdjwAT/7ygftK3mvbn26qxlwr5Ch4wXLwo+pqQL0klRznlsDpeKDZ
         sFag==
X-Gm-Message-State: APjAAAV7rFTx+v+JX1sMpyKvlPAqglUGswMb3EStA04DmSyhmajGPuIC
        RijeZW0FqRSSoyqOKKqPTO+7S08GAR1q1w==
X-Google-Smtp-Source: APXvYqwqB1gy9laOV0Eddc/lZr7RTXjxZkCD/oqlRo1FXq6MoFn2HfZRbyDCk3Ax8nruKWTaOlQlxA==
X-Received: by 2002:a1c:7ec4:: with SMTP id z187mr1514986wmc.94.1568160862013;
        Tue, 10 Sep 2019 17:14:22 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s19sm29742951wrb.14.2019.09.10.17.14.20
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 17:14:21 -0700 (PDT)
Message-ID: <5d783c5d.1c69fb81.b1d8a.ee01@mx.google.com>
Date:   Tue, 10 Sep 2019 17:14:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.192
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 108 boots: 0 failed,
 100 passed with 8 offline (v4.9.192)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 108 boots: 0 failed, 100 passed with 8 offline =
(v4.9.192)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.192/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.192/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.192
Git Commit: 5ce2e060020bf0efa1ce8a261a4d51abe70dc9ea
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 55 unique boards, 22 SoC families, 14 builds out of 197

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
