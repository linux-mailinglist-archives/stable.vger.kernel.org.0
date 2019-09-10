Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6F9DAF315
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 00:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfIJWzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 18:55:41 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:41821 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbfIJWzk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 18:55:40 -0400
Received: by mail-wr1-f47.google.com with SMTP id h7so21324307wrw.8
        for <stable@vger.kernel.org>; Tue, 10 Sep 2019 15:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vHIHNhrv1A8eYhp6AdifigUjyO1F561dODPKxtiOw+Y=;
        b=dr1W99ghYb0qsMpvWJm11qkN3+8/2F6zU0KpBeYVsqk8ozLOrv824S0D5KOGEcZnyA
         E/AtajbX+zUscUdSnSD9pNNrhwqqFvvrpS6GzrAkDny3/ajpbF2ZTqU+1pG2OLE80B9G
         DKtoQeJeNKOfHNhZlhh1O2/zrsFwj+l0LRY1NDHL4W8S/oXGd/W/Eh4dzneM/USmK4KS
         tZs3YooSj/ioVPv3RY+uH6G1frnK98DLF7dptxQ+Npr9un3ZLo6rRGgLsoj0H8d71uS3
         m5OguIZ0SeLQARTUyq0vUVXHXbp254kEslpLjkT1fgKzVlL8UWDrb6TNd9LH39jfchTL
         Rfbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vHIHNhrv1A8eYhp6AdifigUjyO1F561dODPKxtiOw+Y=;
        b=NymYFa/7EKD24N4B7n7tq8zzE5nRnOomYv+rQGDnZScJ+tngbVguBeIZPlN6+Q8aBo
         r+dwRPm1L5vJT4kbdjp5CBIKe2VU15FWMTAyMHhZUqK3GDgT8ZrwUf6WL2glFQ4qf/I0
         ccDz27slSY9eVuA7QW4JbvUqezSU4JRveEk4SgUtvwTweV1MayHZzZRUDVq+WA5y28WU
         gwVP8JQKrRvEwSep9LlCjO67rbzC9VS2leQdVbQ26jkm+TOyaGwi61C+b6Tqr+QbKzwr
         ayUJszhYm65/2AR8ZLsSYs7LXcmSREtWYZMAxj4JtraKIsjpUf1+ACQAi2HySg7LQ1rj
         hJhA==
X-Gm-Message-State: APjAAAXCKbpXYK4qyheKudGzqkt6lRc6QWozE00WpJC5ojKnp9JQYpsd
        QYGWTTKZRlA/422irg6yku6AfgIYDrImzA==
X-Google-Smtp-Source: APXvYqyzlr5IcRBWMQUW+KvdcBTHbzWXKs/7bZvQDa5JYpCH94h1jy/PEKyoHnOkgIyiapnMyn/7oQ==
X-Received: by 2002:a05:6000:108e:: with SMTP id y14mr28014719wrw.344.1568156138568;
        Tue, 10 Sep 2019 15:55:38 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 207sm1667143wme.17.2019.09.10.15.55.37
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 15:55:38 -0700 (PDT)
Message-ID: <5d7829ea.1c69fb81.e4adb.962f@mx.google.com>
Date:   Tue, 10 Sep 2019 15:55:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.192-3-g5335c70a705c
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 50 boots: 1 failed,
 49 passed (v4.4.192-3-g5335c70a705c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 50 boots: 1 failed, 49 passed (v4.4.192-3-g5335=
c70a705c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.192-3-g5335c70a705c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.192-3-g5335c70a705c/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.192-3-g5335c70a705c
Git Commit: 5335c70a705ce100ae0a91ec15d0722b35800c67
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 21 unique boards, 10 SoC families, 9 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

---
For more info write to <info@kernelci.org>
