Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23E57AD017
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 18:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfIHQ6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 12:58:37 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33306 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfIHQ6h (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 12:58:37 -0400
Received: by mail-wr1-f67.google.com with SMTP id u16so11341672wrr.0
        for <stable@vger.kernel.org>; Sun, 08 Sep 2019 09:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=5cxYzNBRMBcx8NZ7jDdRQwdLkktnjDO1pmwjV4xyOFQ=;
        b=STnPZu4MJUDFo/H+AJzT2c6FxgejdhLawW5ESpKrzsBb3R6JNR0tj0BvJoXQSusIVz
         BwjCBGGx5hlYWlPGlE+J1ctY3KPoa4BIV0LBw+YPW8PvxR58CFjmpS3KoBfeX6+ADayf
         NFfWET5/z5XgQl+qsaFuOr5SWMRA4HqqTfq4+BFFcjxUU+K/XhRZOCsh9P4GbUBXWJUp
         OgPc6Gdx2GBREitlujPOlQiOONqif8OuBnn5oSpZL7JHiA9J747p3lhgs+niVIzX2YtE
         k5ZwDQv5jEcZvjLP79Q3JZiQjP3JwYuFyU2d0MLGbXiFVG1aCKwsTie8ulm2uq40iSn/
         Mb/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=5cxYzNBRMBcx8NZ7jDdRQwdLkktnjDO1pmwjV4xyOFQ=;
        b=PEW0a1rxsPm9a992OSESD/yk5bALqRtxtgHSEoulI69WyKPSa7a2YTfZOlIrpzV149
         HfhcYPJzvZcQsj0UNj5j46W019qdpwqsHtkY93TbjTf1sCDUcMp1J8xbBsI61K52Dc4B
         f3vmf2Va3BUxgdklqRr19zXB/XLJ1AYmYNLgxNhcOjUZ+kt9IZvAeVD3wrm1kwgTgb7s
         g4uOaKDq7UyWg0KKqHOh5TlAT5ZhElg7/FAfn2Hu4cvEBrWFXvyN3kSripChke5ZTgmq
         wtmTLosseJ1jzyNBWKjKgWpeIvYR1kOG+4JjrwwIOcqIK3lPI1bfdtyoZqaS5g45hgiu
         Z2ag==
X-Gm-Message-State: APjAAAXvILX9FouMP0oik317owa5qiDWUTXMGGLs/pHlabouqNuZw0yV
        IDGSe/t/9VOLY9yLoII5zM1r1w==
X-Google-Smtp-Source: APXvYqznobkFxLMFKQk/FPWI7sBsvopZv9PbJBAvA9I8T261yuDZObDj9/eNeeq6eOpfuhSGRTPgSQ==
X-Received: by 2002:adf:ead2:: with SMTP id o18mr15108845wrn.107.1567961915054;
        Sun, 08 Sep 2019 09:58:35 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t203sm15346562wmf.42.2019.09.08.09.58.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 09:58:34 -0700 (PDT)
Message-ID: <5d75333a.1c69fb81.94c91.883e@mx.google.com>
Date:   Sun, 08 Sep 2019 09:58:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.142-40-g6b6c4e3151f3
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
In-Reply-To: <20190908121114.260662089@linuxfoundation.org>
References: <20190908121114.260662089@linuxfoundation.org>
Subject: Re: [PATCH 4.14 00/40] 4.14.143-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 80 boots: 0 failed, 80 passed (v4.14.142-40-g6=
b6c4e3151f3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.142-40-g6b6c4e3151f3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.142-40-g6b6c4e3151f3/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.142-40-g6b6c4e3151f3
Git Commit: 6b6c4e3151f31a94bec9c9c14906b1fd3cef2d87
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 37 unique boards, 16 SoC families, 10 builds out of 201

---
For more info write to <info@kernelci.org>
