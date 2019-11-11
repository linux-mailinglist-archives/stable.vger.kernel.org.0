Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85E6FF7471
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 14:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfKKNBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 08:01:14 -0500
Received: from mail-wr1-f49.google.com ([209.85.221.49]:34715 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfKKNBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 08:01:14 -0500
Received: by mail-wr1-f49.google.com with SMTP id e6so14606378wrw.1
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 05:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DgAQIdz8yat1p8NCZnsxh3gUPZhcoQwBDbjD3KHvl0M=;
        b=iDIgrsGn+E9wo8C9FwMAb23T9WAzZmMvQ/4KV4UGPDS1+1atdTSLrvqYkaaSHLkLzd
         F4Y/IIy1Zgv4L8u4cFA5ivD+PRWbEVEB9OrmbOho9fqj22dF61AJ6e50Rji97vBfQBzm
         2l1/Y6WFyVa1h5cyTLX5waYrrH5Z/nwlibkmGtLYlgnGar0Kv1pm8RgaM25eFdYVu3W3
         1AGCiOiwWTZe18ykzMUtFk9pleTzhCeM3Usdij3Z/mEmJIwd1Q/cQMO626/ngek0oUC3
         r1QIULgv2rXPHgL49lhcy14KupuKoQH6cLR4osxoCybVieDdQIJlg4CtO7GD39/ZFvJ8
         1GtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DgAQIdz8yat1p8NCZnsxh3gUPZhcoQwBDbjD3KHvl0M=;
        b=Df8iPxkYiI40izDaQJ/ZrVK5ASWWOe2CuHgIZfWBbbMVadG5LCdEHXtHBi7xc9m3pJ
         QXyfQ77sZ6cLflb8c3cF+0NA6B83YweWNOCFuQpJ117AYGqj7U5J/3bGHj7y+NSvFS7T
         V2ibR9h0D0ABB43/e9a3uhnEHgrmhRWv9xx8Kj4GedPakmqu5w8OOC9KVAsdf6QJc+21
         Rl9Ng5drnn1vTw/MxZ98Ion0ndEfwQu16B5jpClU7aT4Xgj2y+gKJFc85sctU9e5ueFw
         jn5qj83FULqFojagsTxTCZXX1dGKimh3/G1wkTVtEHF/gV/A9Mu6PGt5Pn4tjgRvrNqp
         kd3g==
X-Gm-Message-State: APjAAAW3S1XYcxwSnBO+Cda2V5hrsE22xbSdUkMjKi33nuoXkT+3jQ/j
        be/XXyj3yX1RQEJ1yEhJZ9ei/AJ7K86+uQ==
X-Google-Smtp-Source: APXvYqzHE5X5xv297oL+miU5C+saKEvLnbaKkkhIyfPFglaXw3f/h0F+/wEpmUljLrTaKYKztiqMNg==
X-Received: by 2002:a5d:640b:: with SMTP id z11mr15165053wru.195.1573477272311;
        Mon, 11 Nov 2019 05:01:12 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x26sm15410462wmc.14.2019.11.11.05.01.11
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 05:01:11 -0800 (PST)
Message-ID: <5dc95b97.1c69fb81.8d2a8.832f@mx.google.com>
Date:   Mon, 11 Nov 2019 05:01:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.83-52-gcdd26fc9c7f7
Subject: stable-rc/linux-4.19.y boot: 117 boots: 0 failed,
 110 passed with 7 offline (v4.19.83-52-gcdd26fc9c7f7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 117 boots: 0 failed, 110 passed with 7 offline=
 (v4.19.83-52-gcdd26fc9c7f7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.83-52-gcdd26fc9c7f7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.83-52-gcdd26fc9c7f7/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.83-52-gcdd26fc9c7f7
Git Commit: cdd26fc9c7f7050c4ce9b2c4bb9a4863b56437a5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 22 SoC families, 14 builds out of 206

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
