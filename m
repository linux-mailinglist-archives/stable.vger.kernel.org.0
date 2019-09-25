Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E073BD6AA
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 05:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411519AbfIYDXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 23:23:13 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34704 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404183AbfIYDXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Sep 2019 23:23:13 -0400
Received: by mail-wm1-f68.google.com with SMTP id y135so3047605wmc.1
        for <stable@vger.kernel.org>; Tue, 24 Sep 2019 20:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Kp2rZ1PqpMj8HrU4k7u08TxT3drBYHHtwfCs78DD4xs=;
        b=A4p22AxpAHz6D0MZ7KZeYK0rNZODQoV7wj5Q74khFyFcrx7HcVk/+UWJ2OeqwSe4yt
         U3QIny/MlBGjpQlJ+TMRNdoNHg4Dj9Mxyu8WtPnytuMWEjaKNLYIlzbtNfYKL5s/M8ic
         dSfprMZwMnTvbw7zXIP4sIyMHt/tcdFO9EATESJPOOP5pFkuxlmyV+iiSKmj7TcZzZvZ
         WNmaumrBXwNvWNwm03QRyQzxFznnouSIZQU3woi3cEFhfGjhyKqFFc48sm7fpUBC7c40
         2bdvrRvN5A5YSgfTeIGWK7s9qE44S+x/GjEFjKbGANUjzuE0jLaDSpFEf2tNLZYHj9Uu
         SmIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Kp2rZ1PqpMj8HrU4k7u08TxT3drBYHHtwfCs78DD4xs=;
        b=JYyzX2i7yjrUO80U2ZC9Cmp/XFWOahOq8ZN35UCB4YW5rYmVb0tW1btECZDh9cIk9m
         2cU29OvRne6KDIOfaNonI+6Ksq5dqLM687/RW3U8JI7HM76/hKRsbGQQUXZy1by9BS6G
         8vuoRQV+DKB5ZNxbdJN0CCvMo8O67Tb+fnhUckZURk8jbQq5yqqVpguV5Fa1Gl41kMhR
         oh+t3miEAaEtez7U0gLDxIrTV3oepjjgrt7DANcQpOBexiiTOEu4W199IZOTMSETPDeL
         2iEQDVhaEM+C3UcNUjKzLteN54jHss6xYb3lPQQz8xtr4uwkleVgxP+M6WTytpLuHZCc
         PfmQ==
X-Gm-Message-State: APjAAAU4SX9xbJoSPpSyD7NHcsdFyTf0sjRoayYEc/wpDtQ5kMal+9eA
        Bgn7WOR/vN6HIdqYshmqGi7LjzokIDiZCw==
X-Google-Smtp-Source: APXvYqxuw3Ll64fFmBWVJRV5P76eDa8WsJQiTOSsT+Zc8rzfV3jD4U2JtM3XO5j1G2ZwDLMsqEb+Ng==
X-Received: by 2002:a1c:2144:: with SMTP id h65mr4697840wmh.114.1569381790778;
        Tue, 24 Sep 2019 20:23:10 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e9sm5695601wme.3.2019.09.24.20.23.10
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Sep 2019 20:23:10 -0700 (PDT)
Message-ID: <5d8add9e.1c69fb81.64de9.b033@mx.google.com>
Date:   Tue, 24 Sep 2019 20:23:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.17-22-g9dcf62869383
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 141 boots: 1 failed,
 129 passed with 10 offline, 1 untried/unknown (v5.2.17-22-g9dcf62869383)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 141 boots: 1 failed, 129 passed with 10 offline=
, 1 untried/unknown (v5.2.17-22-g9dcf62869383)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.17-22-g9dcf62869383/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.17-22-g9dcf62869383/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.17-22-g9dcf62869383
Git Commit: 9dcf62869383244d12bc6757695f9ff0df5fc76d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 84 unique boards, 27 SoC families, 18 builds out of 209

Boot Failure Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-cubieboard2: 1 failed lab

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
            sun7i-a20-bananapi: 1 offline lab

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
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
