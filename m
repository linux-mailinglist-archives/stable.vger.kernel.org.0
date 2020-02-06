Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47167153F42
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 08:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgBFHaj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 02:30:39 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38866 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727904AbgBFHaj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 02:30:39 -0500
Received: by mail-wm1-f67.google.com with SMTP id a9so5689953wmj.3
        for <stable@vger.kernel.org>; Wed, 05 Feb 2020 23:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JfTTia71AR4ESuXHdpa4lc6o2hCanvoHq1OuoI05Pfo=;
        b=dXA3bonL+teUnnZxPoyq5+bYxkRnpTVm5W9NzWVlJQJpYsjx8WTGqGGKQ5g6ddVQHj
         LuBp7CUrbM9cD4WVKk6BV+O2NhLZLpJRLd8iNENZF05Wcao0hAfoAcfeoldZnQyc9NAQ
         X3tP431BdMwWZVUb01+RkL8FI0isdCaO94QS8pkZgyzWdQYWj1GgrRfXQXL8MMm4VUKf
         5ksX3RZkqkDxlfymdvRSVm3XMpTUIGNG9z1mESoyEaxejARAi4lXHxELV1SbsSl2LSgW
         Lri5HCE8/nFD9Ue0izpu0ptKGjBE2LMDXWnsPSTuO2igr2ya5c94UFSlE7w99GEQTHhK
         uAxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JfTTia71AR4ESuXHdpa4lc6o2hCanvoHq1OuoI05Pfo=;
        b=CMbSGiYQmSJyISsFNBIY+G1bhydFd7YyU5qVGI2eA+83kxUBTD9z1XMGH6VoO+BxZL
         2V+GpvkMJglnXSDiZgfdPb6FGEHD1/hd9nqH/lMpzRQmlJnlDjO4Jukb+CNsYFjm4Uoq
         sGYlSUvA+gwGLTECn2DKDTzSXxjHlTVScYl2ffCiMrtRv+bTD9AeOWAPTJEeKkr7gsxU
         jGSP2SbnlPEizzdzPtYGF75Swn5iWnmer6wtCodxMhiaFr5EVeqsvCEIrk4/wooRmVca
         M2HPdfeUzLAXAjP/AUrQBFGJ4B6RHwKQ6mJcnClXfMuhevZPLkhpADjONuLgdiGK2Dqx
         WOsQ==
X-Gm-Message-State: APjAAAVO+9Ko3rxku0RU8Le67nZ0OSYHT8LepIZa4RgtPDiKXOcd6X1q
        wlHBJvADwokf63ix5q45Z7D6fca73nAA/g==
X-Google-Smtp-Source: APXvYqzUXXXf/R1ch3gePoeaWVyRQaJ+c+heiKbJvGWKTBp04s91vQi/vDMQ7gOVqxC/lWWNFedYXQ==
X-Received: by 2002:a05:600c:2c53:: with SMTP id r19mr2699966wmg.39.1580974237075;
        Wed, 05 Feb 2020 23:30:37 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t9sm3121632wrv.63.2020.02.05.23.30.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 23:30:36 -0800 (PST)
Message-ID: <5e3bc09c.1c69fb81.34e9.cc91@mx.google.com>
Date:   Wed, 05 Feb 2020 23:30:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.213
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.9.y boot: 15 boots: 0 failed,
 14 passed with 1 untried/unknown (v4.9.213)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 15 boots: 0 failed, 14 passed with 1 untried/unkno=
wn (v4.9.213)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.213/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.213/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.213
Git Commit: 0e96b1eb0ea5e4e8cdcdde6f0c68f89dc1d08be7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 13 unique boards, 6 SoC families, 3 builds out of 26

---
For more info write to <info@kernelci.org>
