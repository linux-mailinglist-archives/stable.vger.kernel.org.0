Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC5D1239E0
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 23:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfLQWWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 17:22:09 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50827 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726750AbfLQWWJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 17:22:09 -0500
Received: by mail-wm1-f66.google.com with SMTP id a5so82171wmb.0
        for <stable@vger.kernel.org>; Tue, 17 Dec 2019 14:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rooGQlOwXpu0YFiXkGb/CI3p2XvWKRuArsHUnKwfPno=;
        b=Ei/Fif/2uYRJNyOuw+Zj95cO5PnJnwgwNWoQ1HTJH58dJtnnLsTdgHYeJ7+cwde/U6
         FgfQEXwYykOuE4uB3RbtyMoyYx7i75My1U1xTEjIOKTsLbcHdmswwG8BAVbVoDAjelFD
         v1WisqD4tHLYcS0YLATf7fBkBi5sGkFRxP56sRGZrwmwr+yaelZwbhQPWXaVpf9eY/FF
         AyHhNk4kCY7fPJQp5gDcMxdKELKnrUs6cn+nv7W+i5ckFjbFxyM4IrEzCLKJRi7kNlpp
         pJGligs2MkFnOl4pw5+9WJRoS0/udpYKWrVODYm+hKbHKJo/TvoUQwS5s1wYLNFvraN4
         xHJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rooGQlOwXpu0YFiXkGb/CI3p2XvWKRuArsHUnKwfPno=;
        b=I9pf04jHgogZVp8xhDyaSOTbg9xuRqeEpvNkNLuKonz5o+4gqW+pMyPYbElAPnfAaw
         yDr8J5Qt69peH6r+AyyHGsI8eRhzRKUyooaHMm0JvYaj7AnmCYPt7o+/qpCGFTBNoO3z
         wPK+FeASnoPnZUOOovawT0W6fbS/j0f9BjOzyPe+s+ER2yoivT7yhpJoqzEnEju37lej
         roW4FfjjR3+OQiO33eLBsDl6X4OHobeBINbmIC0CS6E1f0hHwvyV/QCLszEFpFGPpEPB
         ObL3tkdp41dt7FHvl84eqFHZy4y4VABYa0rj84mGzhKwTg5sL5iOstnQEkk6f8kT+b+E
         o3/Q==
X-Gm-Message-State: APjAAAV58i5Mge94sIEi0OP1HY4s8bqfuEz+z4zpREBtK9uHrOMF7YFX
        WqAyjl41ywj7Grrbr2HNKXW5WvifEBNjng==
X-Google-Smtp-Source: APXvYqxI/gDyNTi2dtOn0TqJ43rumdGG9cMJdQmsrVmjxQNbTXyJ1XA+nSKvixKrAQiNZDgHLTgF9w==
X-Received: by 2002:a05:600c:290f:: with SMTP id i15mr8170936wmd.115.1576621327467;
        Tue, 17 Dec 2019 14:22:07 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a184sm237079wmf.29.2019.12.17.14.22.06
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:22:07 -0800 (PST)
Message-ID: <5df9550f.1c69fb81.19355.1288@mx.google.com>
Date:   Tue, 17 Dec 2019 14:22:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.158-275-g0ddb1a505fdb
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 57 boots: 2 failed,
 54 passed with 1 untried/unknown (v4.14.158-275-g0ddb1a505fdb)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 57 boots: 2 failed, 54 passed with 1 untried/u=
nknown (v4.14.158-275-g0ddb1a505fdb)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.158-275-g0ddb1a505fdb/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.158-275-g0ddb1a505fdb/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.158-275-g0ddb1a505fdb
Git Commit: 0ddb1a505fdb4334b66b11d3aa91bc6faa1fa31d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 36 unique boards, 12 SoC families, 11 builds out of 193

Boot Regressions Detected:

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-collabora: new failure (last pass: v4.14.158-268-g66745e0=
00c83)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

---
For more info write to <info@kernelci.org>
