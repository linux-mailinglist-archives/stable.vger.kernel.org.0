Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12B57EE619
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 18:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbfKDRhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 12:37:07 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:37046 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbfKDRhH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 12:37:07 -0500
Received: by mail-wr1-f48.google.com with SMTP id t1so12172225wrv.4
        for <stable@vger.kernel.org>; Mon, 04 Nov 2019 09:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=w7r0LjzllQQTwysTmv6X/IPV8I2SxJrnfllR0KsPQJ0=;
        b=V/Ipd+dzRH2kUy3T4ywIqLj57AYG/Aentti1Fp+IMMJX0P5mI3xufFUXghrosO+3At
         0vIRvj5JnPc1+2O832FdwzVR8C8fdZ/3gslhBfM08BqFqNVZ6AJOvpWdlD70iod5iPrl
         q9yXDJJqqWRBns7Dhhc3KUoLeiVgouKrWmcWBEl3KV27ByECAvAktRCyEWgqDL3wuKpQ
         xvhq5Sy2AskgEO12eiKY5hQYAXHJqLovhcKXq/Nvem0BICswcsFD3bXobEg1eK361Kkw
         lgQF3d8s2lS09Rmxp96+ZD1Kjq5OLfP9OWTs0RVD/JyXJyBgHwzREJxXPX7aMfQzHxjz
         ieuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=w7r0LjzllQQTwysTmv6X/IPV8I2SxJrnfllR0KsPQJ0=;
        b=ZlxM9C9Pw4OMBl+mUypuImfRJBiGRxIVMn6SJP5scGw3L14ILFt/OcJZUL14sDGGCQ
         kNK6viXJuqfr5bduELEl30zoFy74ONzkVxUyqrbzqr6u4nCE5VI2mO4ekRWCM9dIqt9t
         O/KQ2tyTpreOynW+NVUUFADGLzGNu/E9K4fKaA87ZCzCyOTKtNufERawcwatJ8+HLwnx
         BaWVoldwLyQLXa4umja2u+4xE3ezUzr3tIK4oM0KaEo9bkMLrjg7uLGLvchxcAwktcFt
         yoEq09qtz7o036+20D0uhnd5qNkq9IV4/k5I9SWJjpjiOyWBhZTXh2pPB1vUhB+/9+x/
         1ljQ==
X-Gm-Message-State: APjAAAXeb989yTr1JDQXv2f37N6m3oNeLhg6FbpT9sQ4tuPP7RLXRu+G
        BQ5eQNli5JUCbYAUrfOueNmM4JojEww2gA==
X-Google-Smtp-Source: APXvYqxZKFCHoOEEjp09a1WHr0oRttLpfp6Q8/ymqFGL4GkuKK4pnwTFWV2lS1MGA/wiQfRS94FRjQ==
X-Received: by 2002:a5d:6702:: with SMTP id o2mr22847566wru.339.1572889025031;
        Mon, 04 Nov 2019 09:37:05 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g69sm19007487wme.31.2019.11.04.09.37.04
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 09:37:04 -0800 (PST)
Message-ID: <5dc061c0.1c69fb81.85e0b.8bac@mx.google.com>
Date:   Mon, 04 Nov 2019 09:37:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.151-95-g3f14236a3fe8
Subject: stable-rc/linux-4.14.y boot: 11 boots: 0 failed,
 8 passed with 3 offline (v4.14.151-95-g3f14236a3fe8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 11 boots: 0 failed, 8 passed with 3 offline (v=
4.14.151-95-g3f14236a3fe8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.151-95-g3f14236a3fe8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.151-95-g3f14236a3fe8/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.151-95-g3f14236a3fe8
Git Commit: 3f14236a3fe8cfb5c238b250eee737f9c78c402d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 10 unique boards, 2 SoC families, 2 builds out of 201

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
