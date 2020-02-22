Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE94168C73
	for <lists+stable@lfdr.de>; Sat, 22 Feb 2020 06:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgBVFMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 00:12:16 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:40034 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgBVFMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Feb 2020 00:12:16 -0500
Received: by mail-pj1-f66.google.com with SMTP id 12so1688813pjb.5
        for <stable@vger.kernel.org>; Fri, 21 Feb 2020 21:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j6hdHivjSOUEjrn4EF3DoV3OPzOPzAW4i5CNbgJbERI=;
        b=DsqRn1FyuUatE6u5VO52gJFVeZmW5v2EIvuUF96KyVoq2xTF0l9bw50fPxNIDEbsRo
         TZrJl6XcCGl0TvFB6Vza/4+7q4Rkn7KZqfHt4ROKGPlXTttwawJVNHlds8kvR8tGcJol
         5WPtk0mMt9ykcu8EO8PnNqXiQwvDkj41owqsuxlQzNWUhcIzCQLOokSL1Fv5KNp2zkwI
         VQ4b1totsRolOdBdDlj0dkMNioSycJQx0Tq5c2xFos9ABTtoRzSS7KAhlhRNs1ZUkYic
         FaQ3vz/MOWgLbmvNsFl0EuAisTQkjojL4d+PRX8+k8NwBw9vTMuUWWy+u0vZusx9zYI2
         /9RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j6hdHivjSOUEjrn4EF3DoV3OPzOPzAW4i5CNbgJbERI=;
        b=ebgb9b2QAccklA4DZvAv+0R2ZVACG86l4Q6mem+aeDk/OZ1hXUM5ojs8UIypdBg6w+
         EEbN7SIOJCR1jjB02KXMg5H7fdgGoM0WOxEPly2xS2onFEpX1EYvmNiqdoGwCGA1Esu+
         TApWuBIckpGtVpFwxhyWdisvjIDYmp4hpd/Acvhudgz+5feVKVO3Gd1t1CMO0g7dIHOJ
         UjjM8LhDcdOBRu+nOjov7tZ+q/uvwikUSWMhYOhGPAqt9LuVhD0pIIcWusQMrfJgIp5w
         sNqgbvs/R9N4zX+eimjkvj3SgU29t2Sr8WTWaL6xNwQKzFB4+21JtfUogXzzcUj1h7Z/
         gzQQ==
X-Gm-Message-State: APjAAAXjSTaZXfVYVkRNhxAk/tew7hmNY/+78VuPCT0udooQSLozWnKo
        z7JtwPc4zUtBZ0GTlebxXqCcOfO9TgI=
X-Google-Smtp-Source: APXvYqx6VFECUU646SOg4jUJ0G1U+f889/3kr69JUCwFrM4Dz44+i1uda4+qnS0yLRYblxpP8KkLMw==
X-Received: by 2002:a17:90b:46c4:: with SMTP id jx4mr7213065pjb.32.1582348334936;
        Fri, 21 Feb 2020 21:12:14 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b1sm4344746pgs.27.2020.02.21.21.12.13
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 21:12:14 -0800 (PST)
Message-ID: <5e50b82e.1c69fb81.b9b14.db96@mx.google.com>
Date:   Fri, 21 Feb 2020 21:12:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.105-192-g27ac98449017
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 61 boots: 1 failed,
 60 passed (v4.19.105-192-g27ac98449017)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 61 boots: 1 failed, 60 passed (v4.19.105-192-g=
27ac98449017)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.105-192-g27ac98449017/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.105-192-g27ac98449017/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.105-192-g27ac98449017
Git Commit: 27ac98449017eb9c569bcc95c65f29ca3948148f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 41 unique boards, 12 SoC families, 8 builds out of 118

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
