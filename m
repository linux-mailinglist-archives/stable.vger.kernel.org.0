Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADF81C1907
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 20:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbfI2SxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 14:53:17 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:50717 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729109AbfI2SxR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Sep 2019 14:53:17 -0400
Received: by mail-wm1-f45.google.com with SMTP id 5so10897998wmg.0
        for <stable@vger.kernel.org>; Sun, 29 Sep 2019 11:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=edoAIkAZL7speqG34C2NioOQY0eVyzL3Fpq0+FfX9zU=;
        b=GQ4r6XUNeHN6ai7npblkhlD2VPIELg8Jlo70BKIOvkVx9TCA+QiL46AG9NsDDAeu6i
         ipIia8yxRGUa0MWv2fBsO8q0zYgJzpHPe1MNzMKmNlfwu+ypjbng23xb0HfoI1ZO5rke
         I1Q/JoXRQcTH2AbaWUrzLPnJ7DlOt9ENHlN3vhpBq8fDhe9rPpmkh9WfS4HjKFlEZuJr
         kaHghwuHaHavs4N7ERtg1g3BegkkewLp9d7CNQaVBYK/PaDjp5Z75qARpc06BTiFIwEt
         AtvLXr0BRSQiMntvZ6F0fC2lvToQ3PjepMtg1mf3dN1249h/BdolR8E914ZLmzgNnAkb
         l4MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=edoAIkAZL7speqG34C2NioOQY0eVyzL3Fpq0+FfX9zU=;
        b=duxC31DP4sAwe059WcfXBHOODU0CDxbwIqjgpGu0MYVHwGOPs7Ux2oq2N93dLuKPlN
         NGm/mf+6P9wwnA8HGmzpFOh5QgwyI70rePOJO2hWWSgVW5bz7dCZPFoJPzy/rMu8x9yf
         F4xaSadh1+nRZplLaEi5/GjAyKuOkFyCfHMCLkJ+EbnK7MrxpaMt51uEZZbIZU89x3Ma
         kAwQv6c7bzb1K/3DelLtT+nBYv8NlUXe289pURRq3BqcTtmJnktf1P7gE4sbEAgTdA4R
         AK7Gu24vZZPEeLde2EQ4XjvrDL3TjeSndOUVYJYEtn8Ul5ovHCuVAS9HTfTH/D1pID3p
         CAgg==
X-Gm-Message-State: APjAAAUK7i2RT8dlchtnHoSxLAr70I+JeySXr8kvzjcFPCJ8yHq/RLsW
        MCb2JDaT4k1ra8wJVtPy3ee2KBoCzmI=
X-Google-Smtp-Source: APXvYqxpKfI8fj6nu2HJZy8n5l+k0zW/z6HJZ9nV5XlrOXUKfdhALMCmmj2s0SOmLzAvKxzYDu0DUQ==
X-Received: by 2002:a1c:7519:: with SMTP id o25mr9460495wmc.16.1569783193933;
        Sun, 29 Sep 2019 11:53:13 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y8sm5454828wrm.64.2019.09.29.11.53.13
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Sep 2019 11:53:13 -0700 (PDT)
Message-ID: <5d90fd99.1c69fb81.a33f4.998d@mx.google.com>
Date:   Sun, 29 Sep 2019 11:53:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.2.17-46-g70cc0b99b90f
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.2.y boot: 83 boots: 0 failed,
 83 passed (v5.2.17-46-g70cc0b99b90f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 83 boots: 0 failed, 83 passed (v5.2.17-46-g70cc=
0b99b90f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.17-46-g70cc0b99b90f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.17-46-g70cc0b99b90f/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.17-46-g70cc0b99b90f
Git Commit: 70cc0b99b90f823b81175b1f15f73ced86135c5b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 15 SoC families, 13 builds out of 209

---
For more info write to <info@kernelci.org>
