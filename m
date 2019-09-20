Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77EFDB8999
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 04:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389939AbfITC7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 22:59:23 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:40297 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388700AbfITC7X (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 22:59:23 -0400
Received: by mail-wr1-f46.google.com with SMTP id l3so5153937wru.7
        for <stable@vger.kernel.org>; Thu, 19 Sep 2019 19:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Wb4nM1o4hpn6TDve7X6UVxGQm0c4ZWpt+c+J43uiITo=;
        b=mnML0FG7MMEFFxOIKVCtNsonmx1Kp92Inxiwqddo/FYQO7UAsjDK3AmO/FQyzmMZU9
         Pc6nT55zO3vWy48bMXqsDqzeI7j+dcdxvr6LBGGpuCL7BCXosZvyr9glm5uq7RsBaBxQ
         tddwWarDQsknzf7g57UH1Ppa8NvRD3GSNivTODW1Vc7T5XOVDGZs2bZ1AWXXyTmdYo58
         PbJ3FxlYkfQUgPzF7KfxuDpRkastX7gsLGgRlf0nIVHXtWMnEhNAMjiH++Wx2ImNgPY3
         EhPp+JzT0vjjo8wCn4mBR/3euAoFH8mrCFnnvuOPIw0ogtE1KI2fFlf6NeWVSlMeWzu6
         oQ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Wb4nM1o4hpn6TDve7X6UVxGQm0c4ZWpt+c+J43uiITo=;
        b=G5LSrgiN1XxJnz0ep7rY2HuhOGdtgwnjHzDEZeZm++9g8JfxqWggHHjrITU+ezCmPi
         XZGlc3hxuICj4gtGjF3BDx+dtK+jpfzOClYsxVL0LY/u99FC/2ueQP+G6TjoZdhO8yed
         O6ZyPtcOdp+mVBHcJOJlZkDj3huU85/3xOS+LKytYK1VFgZ1agneZZ8t9ihRb2A6onGT
         hLXAgnAV4vhE4I6GeRG0pM0w8J/z03Ud6eYWWyytKvbkjSOjE8878ZC5BvfAj8Z+Ssfg
         l9NJSazIOXjIhk70+/hsS0rGQjZ232z8Tt/UBe6Ra+++qmoncIRgK2SbRfOaQHJIX5+s
         oiGA==
X-Gm-Message-State: APjAAAXUQPgCiVj0XytSq9Tt9WJ78j3pfQPEvVJJQTDmDraPD8ZaIpkO
        ULAvYZRwPm0VHA4O4xGV29I7Lh3iayI/wA==
X-Google-Smtp-Source: APXvYqwvfuwKt982iG2PjAkbYNxUEJACiiKJDurpTaQSU6Wp0F2FqCHQxreEFPFPlTZsSLhxsTcpSg==
X-Received: by 2002:a5d:49c2:: with SMTP id t2mr9519848wrs.351.1568948360872;
        Thu, 19 Sep 2019 19:59:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b15sm435102wmb.28.2019.09.19.19.59.19
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 19:59:19 -0700 (PDT)
Message-ID: <5d844087.1c69fb81.db037.187e@mx.google.com>
Date:   Thu, 19 Sep 2019 19:59:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.193-75-gfebb363e252b
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 54 boots: 0 failed,
 54 passed (v4.9.193-75-gfebb363e252b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 54 boots: 0 failed, 54 passed (v4.9.193-75-gfeb=
b363e252b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.193-75-gfebb363e252b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.193-75-gfebb363e252b/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.193-75-gfebb363e252b
Git Commit: febb363e252bd50629d7efc675ba30286a33f209
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 24 unique boards, 14 SoC families, 10 builds out of 197

---
For more info write to <info@kernelci.org>
