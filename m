Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2ACBAEE11
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 17:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392787AbfIJPEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 11:04:04 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41189 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729982AbfIJPED (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 11:04:03 -0400
Received: by mail-wr1-f65.google.com with SMTP id h7so19956639wrw.8
        for <stable@vger.kernel.org>; Tue, 10 Sep 2019 08:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hdNGmYzw3jxxyHtTtdbbJsjr4pL6oJeI/RkSXeyruPs=;
        b=JZfhu7hZkuRZCUb7+AW0T/4BDlwVc53qI00uZf65D3kwYDNJVotk3nUIEXH8BYWi4q
         /+ZUymUAZvyfppeMXnETMYmBQS177aAmUMhf1IkReMRRcjt9D0d7FI3WXvqLhs7GTJub
         nr2IZ+f/SW+2tbxPulUhmP0IxxogubedQ9w4Ac6u7iQV7XbQHJk/XIEX3Ub3FqAmvdtL
         gf5u7HKFiClTx2jBVUSyTC4dvKzRSC8JQKY+k0uSoR7RFPhji27X4nsInHPW0vqtG6ru
         TpvezVfMqPqkdLC5kGRFkat1zgON87AcW41qrqrrXGvzPa7XqcuoeBbh7q9AZ+A0LWLr
         ZQjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hdNGmYzw3jxxyHtTtdbbJsjr4pL6oJeI/RkSXeyruPs=;
        b=PZ+8EuHVYZOCtIDaeDf9L4fL1qJPGHsH03VEYbjtLNL9L4W1khrR5GatHFwW8sZhjc
         bZMgXugNsoglQQG9keUTfXkcJ0wLU4aoEi//Tp4NxVi+2acHGYf70guiE+aerKQ3J6TV
         VTgSH3f1SRgE/slqEbeEQA1VCPWXLm1HAAuPJhICaSjIERRZAf9n5r362wzrgQhg4QDi
         w43kvsNaa16Q4MdP7NWLTofMmpv+INNQfgkFtsG0svUuPGJqWVlZI/dfFDBm/4EI52pa
         IciaB+8OOWdLj50L64v/sIwTukExwNccLKA087cDfY0ytorBXtr7kc8Y4RRCug1QlJL3
         cjLg==
X-Gm-Message-State: APjAAAWI1Ao7l7oYLXPG6PV/LpSJFtMzeqeWeXpCWNfhHO5ZyjE4A56q
        iCYQa4Ac3oseJWg/iq1PMpduvW2lIkb6Jg==
X-Google-Smtp-Source: APXvYqzytVMoPAzmct5rm8/gvT35ovAB4FkXJxEEr2P6bekC4+J8Ci/EvP716sMuIB439fU7/9GEZA==
X-Received: by 2002:adf:f846:: with SMTP id d6mr27372117wrq.67.1568127841540;
        Tue, 10 Sep 2019 08:04:01 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m62sm5483629wmm.35.2019.09.10.08.04.00
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 08:04:00 -0700 (PDT)
Message-ID: <5d77bb60.1c69fb81.587e3.94c7@mx.google.com>
Date:   Tue, 10 Sep 2019 08:04:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.192
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y boot: 59 boots: 0 failed,
 58 passed with 1 conflict (v4.4.192)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 59 boots: 0 failed, 58 passed with 1 conflict (v4.=
4.192)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.192/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.192/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.192
Git Commit: 882f8791e1412d81e5cc7a4c379c73195155b40f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 22 unique boards, 10 SoC families, 9 builds out of 190

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
