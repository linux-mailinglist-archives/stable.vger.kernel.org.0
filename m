Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6A75EF514
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 06:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387504AbfKEFnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 00:43:05 -0500
Received: from mail-wm1-f54.google.com ([209.85.128.54]:35637 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387399AbfKEFnE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 00:43:04 -0500
Received: by mail-wm1-f54.google.com with SMTP id 8so11606633wmo.0
        for <stable@vger.kernel.org>; Mon, 04 Nov 2019 21:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4SOW2PoFDC+5EU9P1L5VhY7dqUymZAfiXnqCmxEB2J4=;
        b=vJDlUBLM4k1/5de9CHQYOTzxEueHX9N4c6YBLw8wIakWPbVjrjmwGnTwUD90WQyze8
         92lPuJ7+2+7yF34V1Jx5hqmcRLRyawV4rbbJ6QivfkvkLQlA534lMQKkJB5RRyvgl/i+
         HQy6NRBsJQ9vyTbK48r58krLXE9hIu+ACDcKNEfgjpTQto+wgfMDhBgnn5hpgO4oKokh
         NDzz5NnJ646wVQkGjwCYRzCppkZNWGk9/XzhHmDDWCfFC027WMVsGnTjVUmk8lsQ2ke0
         JdgaXUMKQzxm0hu8RtkQafdZiQ3ftNsaNPlOaTYIhNcu/qUy4tA6U7zC1QOiTOO9uXQE
         KXVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4SOW2PoFDC+5EU9P1L5VhY7dqUymZAfiXnqCmxEB2J4=;
        b=Wmc7J3pdAOePEUSuXSj2/Tb4dxJidh50xf+EIME3BZUY4esXYlonEMQ7U5gs6WBxLd
         URF9vUtbiGq3O1gRzXG6K4PgdMfN0vkv5C53FvaJdA64fxiV56b0OxFd1juSjZK9Z2JU
         dlWHf/4JIL5ghpSrQeRseMIQUJAZ9n9GSfdXGBX7QScYztXcqfYtItK/dP8md1d/L84d
         REDLwsAi4WlsW1UvEzv/r6Xzd3BbfegHsgXWeEavjCBq8DxYmcsyNE6IsEEt9PWF0LkE
         4QyKYNOCOvkjq6TTg+GfOZ54FlMXTIhjSMkUhfhxrwWmS8/Mc06ND2u88pp8gxhqF7FB
         Q8DQ==
X-Gm-Message-State: APjAAAUrxqQikef260Uqefad6KaIUhgLfxE04g9D+A1c7F5/eA3rGQoP
        DTVgLyu1FKHI/aLW5Gdi1Y5Zq2UBad7W/g==
X-Google-Smtp-Source: APXvYqwPoNSwzzfv73UcWXZSFc+iYtb5At/1X7JLLA3caw3vpmiYHaIggMnz411BDh9bNEx3gqYBkg==
X-Received: by 2002:a05:600c:214b:: with SMTP id v11mr2500424wml.149.1572932582570;
        Mon, 04 Nov 2019 21:43:02 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t10sm20696562wrw.23.2019.11.04.21.43.01
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 21:43:01 -0800 (PST)
Message-ID: <5dc10be5.1c69fb81.6270f.5f6f@mx.google.com>
Date:   Mon, 04 Nov 2019 21:43:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.198-63-g1787d5fb47ee
Subject: stable-rc/linux-4.9.y boot: 93 boots: 0 failed,
 86 passed with 7 offline (v4.9.198-63-g1787d5fb47ee)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 93 boots: 0 failed, 86 passed with 7 offline (v=
4.9.198-63-g1787d5fb47ee)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.198-63-g1787d5fb47ee/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.198-63-g1787d5fb47ee/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.198-63-g1787d5fb47ee
Git Commit: 1787d5fb47ee9c16fabc1473a713bfe3f3af7df7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 20 SoC families, 14 builds out of 197

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
