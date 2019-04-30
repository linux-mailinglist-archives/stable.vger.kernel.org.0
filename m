Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13BBBED9C
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 02:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbfD3ARS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 20:17:18 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:39827 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729083AbfD3ARR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 20:17:17 -0400
Received: by mail-wr1-f44.google.com with SMTP id a9so18609354wrp.6
        for <stable@vger.kernel.org>; Mon, 29 Apr 2019 17:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4bJgvMMoOj1QTzrPob5bQx1oCFv1EXHa1h+gjU5qNxI=;
        b=WvBdlUmnhuTZytSR4FA5mbA6t3cFZDaI03pqaHTOaeV5wf16phhaeez2pOYqPBsjrV
         gIxYCiUm3M9vlt4qVIlNDXkJICeMy7jiiDw/62qg8O4+/+ScIB6UCkBYk1iQcIn3qcoF
         bSIlHsd8pOmuCUENEN/pseUryd8m5NePwXcUfY0NNA61o4Ccysk0HJsBb1j1xm7opnHN
         q3gy9jAvhPEn/QGeCB7BoQkctQQWALfPXVLakt0JUr1tf2abxlBIe38V2HLwnK3cq1qh
         I9HYQmuw3RKVCbX4MmRg1MTUhgNL2XNCJa4VU06bdJvJBKdizTlVgTKCKIqpUDQvftDS
         y5cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4bJgvMMoOj1QTzrPob5bQx1oCFv1EXHa1h+gjU5qNxI=;
        b=KlseLfiWa2eVW82CC1tYXSSK6K0+HFBptKkmrkfg0fJeX+2KGI6Qif88Oiu7MCdn2U
         H6KDNqPLEskONXuC+hE2OatHdmaDbqSOXrx3eFnv7jmimqf4/YvIhGY2qAuykIdWztVv
         Rya5cyxXZB7l85bWeZVl+zPE87dOs7oen0uzC+OAN1rVJ8bsalvMO/un23RCYi/v8/IB
         Qh7udif7IMlosTX84VA1tRgRftvrrz8/6ZVPBXgxxNRSEDsTyJc8Eay+6fgUhLoBpLiU
         +5f4pAfRhG/egidGQO9TPpxkebMnJhN3dRJaTGVVI9Nn46dnR5vIisdD/o9zKnHBQq3s
         8jqQ==
X-Gm-Message-State: APjAAAVM2uWOvBGyDzy2k9EXjelTQwyURXiZUww5B5MX5+LDzgOJM4Av
        Sl/5Ntp76++thB5N9CJKWEcCg9i3ePy6nQ==
X-Google-Smtp-Source: APXvYqwDRMlQ1wPawOPvLPHc+aozrBA09sIoIZ4pRaZty9pY5EFa1y6i/1gajYWNsVRvWEJGzbvw4g==
X-Received: by 2002:adf:e309:: with SMTP id b9mr17314910wrj.165.1556583436004;
        Mon, 29 Apr 2019 17:17:16 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d16sm29885823wrs.68.2019.04.29.17.17.15
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 17:17:15 -0700 (PDT)
Message-ID: <5cc7940b.1c69fb81.a0a99.5154@mx.google.com>
Date:   Mon, 29 Apr 2019 17:17:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v3.18.139-11-ge86340d091f2
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-3.18.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-3.18.y boot: 50 boots: 2 failed,
 46 passed with 2 offline (v3.18.139-11-ge86340d091f2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-3.18.y boot: 50 boots: 2 failed, 46 passed with 2 offline (=
v3.18.139-11-ge86340d091f2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-3.18.y/kernel/v3.18.139-11-ge86340d091f2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-3.18.=
y/kernel/v3.18.139-11-ge86340d091f2/

Tree: stable-rc
Branch: linux-3.18.y
Git Describe: v3.18.139-11-ge86340d091f2
Git Commit: e86340d091f2c4c80dfaa9efaaf7a60e942dce35
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 24 unique boards, 12 SoC families, 13 builds out of 189

Boot Failures Detected:

x86_64:
    x86_64_defconfig:
        gcc-7:
            minnowboard-turbot-E3826: 1 failed lab
            x86-x5-z8350: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-7
            tegra20-iris-512: 1 offline lab

    tegra_defconfig:
        gcc-7
            tegra20-iris-512: 1 offline lab

---
For more info write to <info@kernelci.org>
