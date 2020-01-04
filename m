Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7406B130403
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 20:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgADTaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jan 2020 14:30:20 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39585 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgADTaU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jan 2020 14:30:20 -0500
Received: by mail-wm1-f68.google.com with SMTP id 20so11357916wmj.4
        for <stable@vger.kernel.org>; Sat, 04 Jan 2020 11:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8d3sOS13yO+0v1f+6+6/80iuKqVWi2EgUS05bPTsm4E=;
        b=vu2uFokD7vwtgdbUscd2huzsh4pjAeQJf0O+rksgMBTFpuQR9egzTlMlGrt8oMgDZG
         Pq3IqI7Is2wwij0dExzypWw2HK9PwQivCh/TJMRkBQ1RiR2aAwM42WtDZX0kIu+qtNqP
         ihw6PzMOgcMzMArrwaHMrMS4PiNVPSJx8TRI8OPi/aWOLSHZkveLxuPRGgNPqK/pBOkK
         qOnbCcrIOLrtM8oPeVih0MZpf5KXqCug0fVkNrDSa5r1raIgl1fI6RuUB7/28wxKEPAN
         lqezlVZ8K4ilYE8gy1sovQWJDwjm3X7PYcHRs7loQWZtnuXXnpk6AbcMiB0dC9JEKFV/
         nubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8d3sOS13yO+0v1f+6+6/80iuKqVWi2EgUS05bPTsm4E=;
        b=Aip6T7iGVzSsXepR6BLR+vMnplpMavRL3n+af521J7vy/EduGJb/haalUdIyfm45vC
         b0QNF96ei7pe5BQCw3znnk4kMalANzviQfsMxIa19tsHos88YMqIDyLwHtHzjp4mzWSd
         ufOm0h9OYkMn1MPBkgWwQ7XiLOUWqkbka2H3uR7GMR/hjTbCqsv2yHdZEE92IIB3N1LN
         7dVNePzmuM41v5S+QHY3YbVJyIRHv53P/jR1AJBkb3RbesccyQavNssL0DTkziW4Ewcq
         nUaaLLDC2qvfrgyhgcZTAvU9neu50n9qvAnWtVFgjj7+DBxagjfRkIL907WZY/xaiNXv
         f2Dg==
X-Gm-Message-State: APjAAAWVoPkEfUcH6B9kRL3t9YhgQ2ozQVrCoG5ogPw+fcSlO7Iky2/n
        119HpXbYptQ5KkaKmBU0MpnRNkOcSDc=
X-Google-Smtp-Source: APXvYqxwXPnt7qmO6dkQNCVyPUVCH80gk+atf00n9H+l95GH5scqCswtYwDrhV9H5I4/u+jpKxCl3g==
X-Received: by 2002:a1c:770e:: with SMTP id t14mr27822634wmi.101.1578166217943;
        Sat, 04 Jan 2020 11:30:17 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y139sm17672619wmd.24.2020.01.04.11.30.17
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jan 2020 11:30:17 -0800 (PST)
Message-ID: <5e10e7c9.1c69fb81.bcd11.ef55@mx.google.com>
Date:   Sat, 04 Jan 2020 11:30:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.207-171-g9142f346a4e1
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 24 boots: 0 failed,
 23 passed with 1 untried/unknown (v4.9.207-171-g9142f346a4e1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 24 boots: 0 failed, 23 passed with 1 untried/un=
known (v4.9.207-171-g9142f346a4e1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.207-171-g9142f346a4e1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.207-171-g9142f346a4e1/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.207-171-g9142f346a4e1
Git Commit: 9142f346a4e1b69329e76f42c265f7ccee35e5f9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 19 unique boards, 7 SoC families, 9 builds out of 197

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun7i-a20-olinuxino-lime2:
              lab-baylibre: new failure (last pass: v4.9.207-172-gea0b96c29=
17e)

---
For more info write to <info@kernelci.org>
