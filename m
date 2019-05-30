Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47AC62F9EF
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 12:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbfE3KCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 06:02:46 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:45175 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfE3KCq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 06:02:46 -0400
Received: by mail-wr1-f53.google.com with SMTP id b18so3748088wrq.12
        for <stable@vger.kernel.org>; Thu, 30 May 2019 03:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aaZQjXzJwpX3RMd6UIYPHbiXXzszFeR9w1vm9S2HbJY=;
        b=okPomMOaF4wWAdWVwOqtK4YOZvSxJHKwYbMVjVojFdeAqf2p6Z6z0BbjW35BKO8xI8
         IQKa74fraWXYsQ1rQvVRl47CY/7b9d2EhPzGBQRz8Ztqr+NzNzzji9OOlNrCfvvtPzyp
         5HYE/0iBjaZHkr/iC5OuB/WBD0bMzAmZNuWgovLpYBeyzC1UI10kAWTaWrobJyKZn/eQ
         Vh2MU0/WkJ8+aaFRy757RRHWpygevq5Z9JaWIZgsgGnq39g9hReM6ZoWxsZx9/rdbEES
         a7rk7Td/2W1gyTKkGDFOIWa2OG+kOxOYb4HU0gq8xmuhagnjrkF9LSngdNgl3upA6eXb
         mH2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aaZQjXzJwpX3RMd6UIYPHbiXXzszFeR9w1vm9S2HbJY=;
        b=AOCQe9/+0tcXPjF/DjV93qwPL1FwE35AVw8Iz1lugpc/BLDS9z1l0cPFvnnTWT/P0K
         rL6a9a1ehJvrkgKVfldB+wlbOes9FjK48hcX1lJNK2lf4aEwFi7tdAvw9LJQLw7Jfsv1
         LtdlYCsnGrVU8vnwuQf+w1dACzOWSZdj8pFqk/JOGvqMRnjJVORHs8au7SZbOd/+gQuw
         jUoaOV7g1Qbm2YNW0xL3ixuJDnpbBZRepx71ENs9jzvo5u3tyuBKp0q6GshSeGThqAbh
         V3t0VYD/Tu6NsA4m5Rzx3f9dxlDeqQzv46FRs59M1V7oNjwDvI3VPQ6fEaeTz1DyHS5v
         BFHA==
X-Gm-Message-State: APjAAAWu/usFzkEHzNSSptIt/9lgxt3IWgAUh/WxOLEsGDT7NBdRU+PR
        TH7ib5YSJnG1SH98/pRa78MhnaNDrl5t5w==
X-Google-Smtp-Source: APXvYqxfpfjT9AokpeqENX7Y7dMRIf3g92VrqPKyXVftdkhzlY+7gxOEizPALGXwjHbx9ePUXyD6eA==
X-Received: by 2002:a5d:4a8d:: with SMTP id o13mr1943224wrq.350.1559210564486;
        Thu, 30 May 2019 03:02:44 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v5sm4724332wra.83.2019.05.30.03.02.43
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 03:02:43 -0700 (PDT)
Message-ID: <5cefaa43.1c69fb81.c1c52.87fd@mx.google.com>
Date:   Thu, 30 May 2019 03:02:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.46-277-gce4f69c2c1a5
Subject: stable-rc/linux-4.19.y boot: 116 boots: 0 failed,
 116 passed (v4.19.46-277-gce4f69c2c1a5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 116 boots: 0 failed, 116 passed (v4.19.46-277-=
gce4f69c2c1a5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.46-277-gce4f69c2c1a5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.46-277-gce4f69c2c1a5/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.46-277-gce4f69c2c1a5
Git Commit: ce4f69c2c1a58809446ca1cc59521671d7974f8a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 22 SoC families, 14 builds out of 206

---
For more info write to <info@kernelci.org>
