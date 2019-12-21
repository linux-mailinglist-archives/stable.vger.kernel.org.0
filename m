Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06B78128981
	for <lists+stable@lfdr.de>; Sat, 21 Dec 2019 15:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfLUOSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Dec 2019 09:18:16 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39532 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbfLUOSP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Dec 2019 09:18:15 -0500
Received: by mail-wm1-f66.google.com with SMTP id 20so11850565wmj.4
        for <stable@vger.kernel.org>; Sat, 21 Dec 2019 06:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EOm2NV2EiC5fMc3GteQV/2fC0bQrISF0rWcXXMwIkCw=;
        b=meuSOt3KkS/oRI55aaYfma9py+9vr2cDkVMBVZN9c31I6/9qDpNldJvJer3z+7iX5F
         gYK/POFkKMzDRsWicgw82N4ruK13f8LV9ZMzvMfBiDfkrxzEHSnH3ZTXGmTEDnibuf8b
         tmBkVxhamgDL+dXAVI+YfWhtZ024xP4qx6wIN3T7Q7UnMhxkQJZbngl4E/9zWHsvZD9Z
         ZSAgD0KL9zMU47yIKXVtbMcGkmojTvEabRENPdvBqmqjsKfEEr8tCgx0FlvYPQ/beOtd
         +6WJKj3uQ5AyOoquWXeXLZLfBU8VPERFgKwHnhWpQaK9bxhbvpC+IDKNkrOxFbuBy2TM
         puwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EOm2NV2EiC5fMc3GteQV/2fC0bQrISF0rWcXXMwIkCw=;
        b=ffL/TC9Xd+Pu4S+K6dX3gJLdwzVnIh5Z2pkdFJPKwRFH/wABqo9XuuJzxI6T0GmOp4
         w4gIImksMQIIwBwmc81LwnIqcqU6EKO4bcAw2WMmbT/s4DoiUz3meZh6DGzk5D7d9S+Q
         mOgV73dDbsEZn+rUH+CAtu31U/mD3VjV9rcgBPJavWH8LD/Mew2UbcUBbyIR9iqDZUoU
         kW1ctX+V6S4xBzVMo1531979LpZd0KCF04WT8bjXTHsqz2fQjE4GvUfgNm/Si422npFy
         EDpgacQus9rrq0Jotqfvz7BH05eLkxZs/RLD72JKs+YLNKHAfYpoU1S7sZ72KmItjqwE
         +Z1w==
X-Gm-Message-State: APjAAAU9yMT3f4lvkUZ2OPjjwiAwpV4gcCo+S9uJF4zwhcDuWCKVQeag
        9VPCS/oEFtgYqPDMFCSMv3kjyhhy33Ij/g==
X-Google-Smtp-Source: APXvYqwW3gv6Qsyc084qe9nLZHv5FAGdhYznVsNnLQ0VLA4+x2BC6DAhGI98g316GhmXJzVh7XW5FQ==
X-Received: by 2002:a1c:200a:: with SMTP id g10mr2674578wmg.77.1576937893595;
        Sat, 21 Dec 2019 06:18:13 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i10sm13418602wru.16.2019.12.21.06.18.13
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 06:18:13 -0800 (PST)
Message-ID: <5dfe29a5.1c69fb81.b8ff3.2d0e@mx.google.com>
Date:   Sat, 21 Dec 2019 06:18:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.207
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y boot: 50 boots: 1 failed, 49 passed (v4.4.207)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 50 boots: 1 failed, 49 passed (v4.4.207)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.207/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.207/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.207
Git Commit: 45c347668ec580cfb0008ab53a7b4c4242166b2d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 29 unique boards, 12 SoC families, 10 builds out of 190

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
