Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDE6D4F581
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 13:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfFVLi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 07:38:28 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:44605 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbfFVLi2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 07:38:28 -0400
Received: by mail-wr1-f43.google.com with SMTP id r16so8963299wrl.11
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 04:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SYFNfJX4bAPc2m0EwmRQcJtJkmGV09o/ia23ZC+ccCU=;
        b=ORVWEL5OrIhR+2RBqvIMt+UevRF6Hw3P1LXXEoyZx4ugEEkRZdVyEYhxRFzdaArgJW
         BKzqOWNc3wyzPfYzNo04dgUSYuTlrnxIA5ofIh//vDbqzX3KwfMQsKDBGS0dFpf6UoXx
         NUWK/1h/pBbJp58D+HGfxRyGQw/B0MRfBLRl3nfwcAG8LL6tSVsOcMRFhtsys4d0hRCD
         K4mCcyc5yRMweoIyikh8G+eE3VxxLuElS30fbB/LZJxY8L5BmQ/Eb5LCTOQXolyw5peX
         INMR/DFYpr22awrdIuymItInkyGo18LHivAY68s+S9dNan6oBQw1UZHz3AnfPwhmaT6k
         Co+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SYFNfJX4bAPc2m0EwmRQcJtJkmGV09o/ia23ZC+ccCU=;
        b=iXaBNYEYsTFehaH3YhOdHao9RvvUFSST+/JEYtx8k7E2Fn7dWrg7RJ0UwZaTAztDrG
         9uPEkBP0cFkhXDsAzVumAbZDzXtHa5+4zwmXoMGZSznQctNtwqASbmka3x87aV7OJQgR
         NknYO4iR3BIa6izEJ81ZyhP7QyyXKJWq++2o1UG1HXv3PeMclGoj65+caxnuZ3Gcr5Co
         LbpwrS0YbLwN2ZEoYnnHbCYXPzE3UdBQ8po8k5nFgXglNvE5PlM6X/xz59WB7irQ1QvR
         akWhlPQvavKZeZ07eEWH0bsn/BaDgSbFP17Vx+/s2DoNsa7wPhfYWIkmXaqGY8v6jAfx
         LEkA==
X-Gm-Message-State: APjAAAVz31Z8LUic4XoC4gpoBU2cSjR/USDj0Kuqg0LzcEp1q+OB0rXo
        53IsBcalRuLvZfGWz3Mi3cz7XbK8vuGKKA==
X-Google-Smtp-Source: APXvYqzVaY6sSgWN8D40TeE26BCbVBc2mZEXKkAFDdRs+bL0JGZCYfIEezkYn9S+kUhIV8N+q88Fpw==
X-Received: by 2002:adf:e40f:: with SMTP id g15mr23131091wrm.174.1561203505627;
        Sat, 22 Jun 2019 04:38:25 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s188sm4106224wmf.40.2019.06.22.04.38.24
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 04:38:24 -0700 (PDT)
Message-ID: <5d0e1330.1c69fb81.1ca76.5d7e@mx.google.com>
Date:   Sat, 22 Jun 2019 04:38:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.13-2-g0055f3b59207
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 142 boots: 1 failed,
 134 passed with 7 offline (v5.1.13-2-g0055f3b59207)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 142 boots: 1 failed, 134 passed with 7 offline =
(v5.1.13-2-g0055f3b59207)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.13-2-g0055f3b59207/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.13-2-g0055f3b59207/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.13-2-g0055f3b59207
Git Commit: 0055f3b59207afbb065d59884d777f889df269a9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 79 unique boards, 25 SoC families, 16 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

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
