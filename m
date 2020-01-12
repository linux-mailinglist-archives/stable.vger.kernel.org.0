Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB9A138725
	for <lists+stable@lfdr.de>; Sun, 12 Jan 2020 17:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733105AbgALQ60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jan 2020 11:58:26 -0500
Received: from mail-wm1-f48.google.com ([209.85.128.48]:38515 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730190AbgALQ60 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jan 2020 11:58:26 -0500
Received: by mail-wm1-f48.google.com with SMTP id u2so7078040wmc.3
        for <stable@vger.kernel.org>; Sun, 12 Jan 2020 08:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hkMDrhDEJt5tE5zlWo72QOYJxgQEW3omQyjaRvkP/VQ=;
        b=Piydfz5YkjZyzroP3zFsjwYlRAs5We0iXhQwvW07r+qkAa3mhpW40Dve7lBepS+zgg
         OPp+cIi7YVEaz/fMq9xfdFe+zw360l/GHHZYAjSbOVWtyz6CSHSG3d2p1W6JRhKInNWK
         C89ToBWOx1kAtjda+edjqeinTuYtzD/xadBgX+Ryd4+lzz95yway9DigfmEU3GU7x2fB
         xeCE8uC1xs1Cjl/XRWGuhcId3X9xtyDgZZdmaTdMhCVuwNbWvw7cgBFGr6RSI/WjV1tj
         tpjHlyHGoqh0RUkuYwEtY6d1OG2JIH2uL/nHrpycZwsNEpODc/LnLvHIeHqF5yWLB6f6
         4qww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hkMDrhDEJt5tE5zlWo72QOYJxgQEW3omQyjaRvkP/VQ=;
        b=dK80SHw4zGUTJ4usBuwRHrmrfbAge1MYQ1nvXrdSqYrr8ZM1X7CWUXNVbF+tfSZtjt
         ohhaeADPKmUv9vM66f02eLo54wpPIyWU1pKg5xVEZc4Dr+bnbT4/hy9E/Ott8HN1fY2j
         +0SrIAWpcUed4EB6RSQXrmrVd+p4QZX98++LNKikyIvfOfO9U8x+L+US/XHI1nLtCIIJ
         GvUT8+eGE3MmgpByFARUj78IIgVNiKHgGbZEo2U6QxiNTBkPpoFazKUEUDZCu8Zc1pUy
         aiQO38OWyGpQ3y6mLj3LXuHrcaZzbwe/HM3GQ7Por44++u3WNdFC+j6NG3nmPQXcPMBw
         JdEw==
X-Gm-Message-State: APjAAAXOHgNsPCElGiaaB4sVbhq2c35vxOD6qz9SpLwiN4BJxNB9ckuq
        VMmBL215KM18FouE1Z8phalBAAI49kWlEg==
X-Google-Smtp-Source: APXvYqw1ogMoYAsCNbffNskAZ7mgnZi4KWnIhvaiaXgsqITlwNvN0ATFfppz1fpcG4g/MQIJMPB3fw==
X-Received: by 2002:a05:600c:224d:: with SMTP id a13mr15638259wmm.70.1578848304291;
        Sun, 12 Jan 2020 08:58:24 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h8sm11668502wrx.63.2020.01.12.08.58.23
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2020 08:58:23 -0800 (PST)
Message-ID: <5e1b502f.1c69fb81.6ecc1.ff71@mx.google.com>
Date:   Sun, 12 Jan 2020 08:58:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.209
Subject: stable/linux-4.4.y boot: 23 boots: 0 failed, 23 passed (v4.4.209)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 23 boots: 0 failed, 23 passed (v4.4.209)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.209/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.209/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.209
Git Commit: 3e8701c52068b6f224f103ab28d9c827b4d1257d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 17 unique boards, 6 SoC families, 7 builds out of 189

---
For more info write to <info@kernelci.org>
