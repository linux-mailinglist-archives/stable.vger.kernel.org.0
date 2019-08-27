Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6B169F296
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 20:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730407AbfH0Sod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 14:44:33 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42420 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730313AbfH0Sod (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 14:44:33 -0400
Received: by mail-wr1-f65.google.com with SMTP id b16so19814593wrq.9
        for <stable@vger.kernel.org>; Tue, 27 Aug 2019 11:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SWrAxug4aBlQOgFxV8BI+MahZ9Q/s6FKugLnNZ+wx14=;
        b=Sjyb7cyI4gnHgX/6R+XcQgK3k5EMyZFDEk0qAi668sb7FLNImNhxiUs/TnaVeo1oF+
         3PQvr3uzmVAXmmvBn2VYN6hpEbTlVbaZZFR36yt+2y0yr9UG0QYchbs7GeZNp+NFHB4/
         EwA6EXWD7FHZcXivWLrOg9tQFAmq7Ecy5yci34ld4WZbuxy05buQjH+Si8TLn/FhrOZ/
         8PO7BYZuFgigbPgsTMNkmez3QlUY5Ea8HIAQJ/MdlibMENnXPk49DDfwXdLu+42rA6cQ
         atvmC9XOUXhohrX/XO7Gftuh3UMKG2b2ETxrkrrPAIJwfYznX1S8QYoYJNv/w1PQjrmA
         M0dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SWrAxug4aBlQOgFxV8BI+MahZ9Q/s6FKugLnNZ+wx14=;
        b=Vwv0vl5OcmIomsgb+wlZDiVy8skD/3FaumWO8s9UmALaYpY3rnNyl0VPqkc+9PbxxU
         T5SFYLlMAMcB9f67u5tKYFljIVieYVQFSdkYTLR6QEGixuwTJF5eUBAiHACfDy1xg7yX
         qqYipu0MqfjWlYfdprWLrMCU6dc19NLt7eT8IiOPTiE6GGZytt4B2JikfmXIH3IIQ4Ol
         IfZej+3QVh/mfByj5eCw0NYpaZt1JfbUnLg+R9WpJsw4qJGqhMjGd/eztsCI3U40GKBC
         a7bVnn1MkVK80Tb0foay/f4o8Tr0Byb8U8fk1ruEkqrb2KzzU3xiHf7j5Y9mE0rKQ/Kv
         j7Ig==
X-Gm-Message-State: APjAAAX3aqtsivwJsJ07o/dUWrmhuN9SUkmpp7iOrTuWTew7o6c2YER8
        XTXJwnownvvXkiMu+DSseJHGAfOXm9cB/A==
X-Google-Smtp-Source: APXvYqyNdp46n5QC3fq7xzZ8HWeNwyxFqg8+OqU75fYYeEBFxxQIXERDzm1ATXg6TUgo0CzMV4ax6Q==
X-Received: by 2002:a5d:66d0:: with SMTP id k16mr30911463wrw.333.1566931471476;
        Tue, 27 Aug 2019 11:44:31 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 5sm125714wmg.42.2019.08.27.11.44.30
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 11:44:30 -0700 (PDT)
Message-ID: <5d657a0e.1c69fb81.abdff.08df@mx.google.com>
Date:   Tue, 27 Aug 2019 11:44:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.190
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y boot: 60 boots: 2 failed,
 57 passed with 1 conflict (v4.4.190)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 60 boots: 2 failed, 57 passed with 1 conflict (v4.=
4.190)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.190/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.190/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.190
Git Commit: 5e9f4d704f8698b6d655afa7e9fac3509da253bc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 23 unique boards, 11 SoC families, 10 builds out of 190

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-baylibre: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
