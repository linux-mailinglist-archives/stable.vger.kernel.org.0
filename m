Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 494844F859
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 23:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfFVV6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 17:58:31 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:41680 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfFVV6b (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 17:58:31 -0400
Received: by mail-wr1-f43.google.com with SMTP id c2so9889086wrm.8
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 14:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YRBriwyGMW+Xz1FMsW8qmKwa6h/cbprHHok81LNzxbQ=;
        b=Wd92t+aFPkEocfzDka8PsoHvJY8mWQL0HTJIPkOVWvFyqe8uTbGkntBwfHiVOtXd/P
         bZig7fDhtyP8VcWVrfWstBDSYoGCPa3SFuzSTFBIsIC97Qekq2YenzdZCDdfNroTiVNn
         rS7iaMEbZmYsoZoxi1ShkVoDPry1fCOAo0OG8r0BKxDOK2hFZJc1U6szdssvj2qYzGIW
         /Gv3RNtREG6zDG7LdGgHEug+mrkVdGAeiXApeHp/1RLcgETwuM0cwPvcQ663MTOU4LRn
         Otx+tLWCAzCUWsrUJAtGwJtAC8vEPl/SuOMM27BI6T42cl4C/4lpqBlWfsKfbpv9M7pA
         DieA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YRBriwyGMW+Xz1FMsW8qmKwa6h/cbprHHok81LNzxbQ=;
        b=uTz/TO7splDbN8ObiDaTqLm31ksu8LkxA+5lvXt7bwKQdqzcMri0u87i+/o4FAQJih
         o+7c4aotVO04Am7qLDaTHxmmdnCl8CnC+8G5jYgb64C+ouS4GVqyV3jjQpWsiwpzLItJ
         hMYCoO5QbA8+K2Soerhqb9Wnis0M378yfM7Rwaam2FyzpKk1014BhA6O3oI7YHovzPC4
         nDqZp2mY8zVit/J9R3yZvNEnwX3/wqJ6haH8VRLgdD6O7B7rZbPp78+nawWxPJDqUpyO
         Uyv7gPT5+eYV86lMrTTjNn5WjZRNEEd5sQItf9rM+w3K+2nQq9QhZUcwfZ0kKFYN6hRs
         SlCw==
X-Gm-Message-State: APjAAAXCc/nFER1DKWeSMtm/1ZBUSt0BhOsXmXoy316NIakst+P/gO0J
        Vb9BbGl+HI42XV1l4vr/pwUH7T97D98=
X-Google-Smtp-Source: APXvYqxp4ssWJwzpytqYw1rIKSi8k6q+yss+MYCLhKysrZUn4PihjQg75n+XGCAspCmTOoZK958a8g==
X-Received: by 2002:a5d:4681:: with SMTP id u1mr28575757wrq.102.1561240708881;
        Sat, 22 Jun 2019 14:58:28 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r5sm14559114wrg.10.2019.06.22.14.58.27
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 14:58:28 -0700 (PDT)
Message-ID: <5d0ea484.1c69fb81.67f57.0d1b@mx.google.com>
Date:   Sat, 22 Jun 2019 14:58:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.129-4-g618f57c53be3
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 118 boots: 0 failed,
 111 passed with 7 offline (v4.14.129-4-g618f57c53be3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 118 boots: 0 failed, 111 passed with 7 offline=
 (v4.14.129-4-g618f57c53be3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.129-4-g618f57c53be3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.129-4-g618f57c53be3/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.129-4-g618f57c53be3
Git Commit: 618f57c53be32daa70cf9d5845df888e2242481b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 63 unique boards, 23 SoC families, 14 builds out of 201

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
