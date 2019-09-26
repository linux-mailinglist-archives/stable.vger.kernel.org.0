Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2740BF20A
	for <lists+stable@lfdr.de>; Thu, 26 Sep 2019 13:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbfIZLqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Sep 2019 07:46:15 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:38306 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbfIZLqP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Sep 2019 07:46:15 -0400
Received: by mail-wr1-f46.google.com with SMTP id w12so1685334wro.5
        for <stable@vger.kernel.org>; Thu, 26 Sep 2019 04:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yus2LsNGUtpURyFfeYNuyO/KKzTYtocL8wf5mMzRHUw=;
        b=p6ypyZ5z/EvfqpwYsmL1kUl0ilSkCVTJ5clLXT2AG2SZlbRa/x8DCODBlvwAtNgkKQ
         sXFDqZpXYB5stR9v/xygbV5Sxd5rPkPR61uHnOHheGdGsc5Sn2fM0KWf0g5jNSrwwtA7
         BtXJvnoaDsFhzuqtiCOPmLJt2zKHrd5lv+lSkHgbIVKckAK2GpyQwr3Cb/Cxnc8TH0yT
         UxzWw5FR46WEGQryDPjaCsyQm8jItquQJ5i9ZGE8ROSJh+mz3HdbIjph3HAIbfI/fOjq
         ZcrztWV2xJUov1yf/InWSfbV/x3TXHMEXamieGhyRHcHYWxLfZoKhYes8kg3Mj5xvzNz
         IpDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yus2LsNGUtpURyFfeYNuyO/KKzTYtocL8wf5mMzRHUw=;
        b=NAZBFGw1UjAXZBiUDa6saaQCPwNSz8N76dlX6VwBMBj4wAFvTRkEYJgdlCza2UeBee
         7BqM23hwNa/cOu7G9eP1wxt2gfvoCLwjPhlZdflnSDskDjMjqA6xm4HtOY1uCh3tMgHj
         WIPruH7OLO4u9+2IthytmyyyKDn9vE6ZWt6+dOBY8sd8R++lYnVrApqV5N81gUnKts3l
         xKQH1VJkJRExbvleIX7kDd96l9jQKinWd4YKdwPqqPjNO4d8cek5excRqWzg3HV7x5QA
         qrJ+8I6Er2YcklB6j7WehdMNWgDCCQU+MThN9SPQ5+QK0ZS2NUDIL8Dp9pMLKydSrF05
         +T2g==
X-Gm-Message-State: APjAAAXw8xBh3SNI11vACtIT6xVrXiB8Fpsskre6cwPQ9qIiJ02jV4/h
        HUX3MIdfRpdsBz2yf6D2bv4I3zdZNbo8FA==
X-Google-Smtp-Source: APXvYqyAQQvciizPGLwMrrcsmwvCOnYW+fVot/wyfXKLhmJuREp3BsyqQtYY8sDkWIPXbFdJyTyB7w==
X-Received: by 2002:adf:ea88:: with SMTP id s8mr2806045wrm.114.1569498372913;
        Thu, 26 Sep 2019 04:46:12 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f13sm1609967wmj.17.2019.09.26.04.46.12
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Sep 2019 04:46:12 -0700 (PDT)
Message-ID: <5d8ca504.1c69fb81.76a9b.65b0@mx.google.com>
Date:   Thu, 26 Sep 2019 04:46:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.75-33-gdab8e08e7087
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 132 boots: 0 failed,
 123 passed with 9 offline (v4.19.75-33-gdab8e08e7087)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 132 boots: 0 failed, 123 passed with 9 offline=
 (v4.19.75-33-gdab8e08e7087)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.75-33-gdab8e08e7087/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.75-33-gdab8e08e7087/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.75-33-gdab8e08e7087
Git Commit: dab8e08e708737aaecc3133159d2e5cb45cdb771
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 24 SoC families, 16 builds out of 206

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            sun50i-a64-pine64-plus: 1 offline lab

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
