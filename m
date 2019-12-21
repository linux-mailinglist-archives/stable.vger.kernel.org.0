Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE20B128AA7
	for <lists+stable@lfdr.de>; Sat, 21 Dec 2019 18:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfLURh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Dec 2019 12:37:56 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51633 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbfLURh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Dec 2019 12:37:56 -0500
Received: by mail-wm1-f66.google.com with SMTP id d73so11979455wmd.1
        for <stable@vger.kernel.org>; Sat, 21 Dec 2019 09:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mgcnL0goCHjEKd3uySrtX6dRzfOtnmGIt7G1hyEl6dQ=;
        b=jZSCD4xxXzs9yWYGd75eR7cRAB21ovfWuYfkaJhknsU86234VQ6cuhYdKRICEV5LHd
         KVbK3NJJZy6iBZYHCbF5T9+p2HEvssnaFRAx/gMQrMrIet9Ts8SyVw6kLhY1DWnciA7Z
         DtJJR8BOzQWpbBN/9kH2XxSeiY7OkMohZn77ve1ZylzHRM0ulF9rFbl78+YSQ3O0vY/9
         UA53ljseZMTgs+KWU2cRNthppdxoNidr2fyJR0EHgdcynLcIEAbUjgEOiWZ6PVixuvpb
         QTzvsXlY+ijVEOm/uXh/ppAiwOf0QThzD0aQqsZqNVfzmGjIkpdA3IHLtd4O5O7Xz4aX
         R4Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mgcnL0goCHjEKd3uySrtX6dRzfOtnmGIt7G1hyEl6dQ=;
        b=PVmb/1BLhnWu5ewCE30NSbWOM0BYQwVjbPGO7l/tLPTdGIjMB778+4N+peYrOd695R
         2fkK10r2BdLSxMixlMsl9SIFs8bDQIu3bNQTVA2g0jJE7JR5rVeV4ZKrb4HtHmu/Ob2R
         ZoaN/v0Ci90ECuI9BhVoQjv2MkOnknQUuQlUG/1p/CCgTWmFW5+k9TrD9xXOFPvsHahG
         D33MqOnbdNczb023gMAo/evg41522mIIouwlwqTIS6Z7vM3iLQliM3apN80RNu5LxwaS
         KVj2emQxEvZFs/AjRzUm+4eXo01/rHpq+MhytJZIo78jd8zT3uCCfHrAVWoKaUf6jClq
         1I6Q==
X-Gm-Message-State: APjAAAWt6HiFvFGusTX1hLZ8nMzN9woVlFvc1jGJl77pgrVdloBpT/KX
        itmICbcXCBtrtPz0vpGn14dVCOrXDUX5pw==
X-Google-Smtp-Source: APXvYqzv8QBQK6yza0pWELXxIzDPrVFEnHPhTc2faNDDHMLYxDuuoPqHY4QavT7zkbxHFpA++zqXdQ==
X-Received: by 2002:a05:600c:2509:: with SMTP id d9mr23390243wma.148.1576949873866;
        Sat, 21 Dec 2019 09:37:53 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u18sm14349218wrt.26.2019.12.21.09.37.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 09:37:53 -0800 (PST)
Message-ID: <5dfe5871.1c69fb81.8707.754e@mx.google.com>
Date:   Sat, 21 Dec 2019 09:37:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.91
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 80 boots: 1 failed,
 78 passed with 1 untried/unknown (v4.19.91)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 80 boots: 1 failed, 78 passed with 1 untried/unkn=
own (v4.19.91)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.91/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.91/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.91
Git Commit: 672481c2deffb371d8a7dfdc009e44c09864a869
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 52 unique boards, 16 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.90)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
