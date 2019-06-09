Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0BC53AC5D
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 00:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbfFIWXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 18:23:17 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:55395 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfFIWXR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 18:23:17 -0400
Received: by mail-wm1-f54.google.com with SMTP id a15so6698946wmj.5
        for <stable@vger.kernel.org>; Sun, 09 Jun 2019 15:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=d/RmkqEoxtDlAKVj7UfYxgHCespbC8C4CWJwXa/3140=;
        b=x+3NCmZtCPd4Jt0+Z9iW5DgJMrwG57HKcSzZ/0fM9GbuS0ICdCi6W0Md0irEqu6mX1
         PSd9fG21iGRHhsYasFF4uV/EiEIaE4TDUZ1G6cVOcEFIUKTgRNTRB6WeJzDsnHOM37wK
         0v+JU/4OHxCBtonOW8oXniLb0btQZTttIcMy3ySI53I5OYZG8o4z09h7fshXSgc1B149
         03pnWnYx/ik1thB0mc9tKqT9OiyIwgtHftM2M/VfLvi4fcqrxm5wKhzdBsANg0HJkM+O
         BX0GQZR6fnbi+i15fqxMLnec4iWAXwoZ5EMIQ/HcMQZgA+MgvV8Rj6PWSVJ2sswt+zLB
         Qpog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=d/RmkqEoxtDlAKVj7UfYxgHCespbC8C4CWJwXa/3140=;
        b=Sl+OnZDR1oLaC9GIwgW7Zn7cOf8uFYh+DgvzqatUCKmqV5Yy6//jWAZizjROvTp5OO
         WCSeztHy9H4zRmLbHbB+7WW7U9qeAJ6gBK5zQcaxryW+Ox46jEdPWofv5bkr5drr5Kon
         OnN1UzESzOBaDfT+ojlfQlpR2p5vJwTc2z6NGPFAXf9+aSF3V3jHhR+pfKvRtLCnq2Vr
         +N2J8zRnB/jIWORFoOOQRAJ9g0yaefaVMy89wWuomeQ/JtY2iBA+aD5E+IkJBIAShbVS
         qARNd/vuhhsPBeEINSEZJYjOLLNsftarsc+UPep9y3er+5U9t8zefgxOrvLUxdg2ziMw
         Cq1g==
X-Gm-Message-State: APjAAAX9T8JwwBJiL6FfHwjc9pfpjoCy9h6JnUZ/C6QOHDpy/9Bq2Pbv
        StL9Xv5NbO62OBZOlIdArlbIcnulPMk=
X-Google-Smtp-Source: APXvYqwMLuG1Eo0NP+7/YzA1SdL3BkGKFVmmoIk2+3UPYRzOYYhjwBjChZSU0V0nwm4wvm2De6St0w==
X-Received: by 2002:a05:600c:2507:: with SMTP id d7mr10920760wma.2.1560118994742;
        Sun, 09 Jun 2019 15:23:14 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y17sm19856060wrg.18.2019.06.09.15.23.13
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 15:23:13 -0700 (PDT)
Message-ID: <5cfd86d1.1c69fb81.191b9.4776@mx.google.com>
Date:   Sun, 09 Jun 2019 15:23:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.48-126-g4954dbe53dd3
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 127 boots: 0 failed,
 127 passed (v4.19.48-126-g4954dbe53dd3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 127 boots: 0 failed, 127 passed (v4.19.48-126-=
g4954dbe53dd3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.48-126-g4954dbe53dd3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.48-126-g4954dbe53dd3/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.48-126-g4954dbe53dd3
Git Commit: 4954dbe53dd310cc698cab437bfe8bd965d26685
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 24 SoC families, 15 builds out of 206

---
For more info write to <info@kernelci.org>
