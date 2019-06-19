Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 986D74B78B
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 13:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731660AbfFSL7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 07:59:33 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:56094 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727458AbfFSL7c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 07:59:32 -0400
Received: by mail-wm1-f52.google.com with SMTP id a15so1455541wmj.5
        for <stable@vger.kernel.org>; Wed, 19 Jun 2019 04:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ySsaN35wYSm5Plluc40G4e3oReJB8ZTlMVwRI8jBszE=;
        b=gr42P95EpzflJQYwO851ylKMWW1ji4ZWSbZJnkCowut3igWKNEC6oUaL/r+bgfJFo2
         VO3FCVt7l2BIsiyLeiR7MuaXe11lzcfnFw0oeuCfg+WCyN1qJiFyktryMKcTY0bqU8FS
         8qIyOasW2lpn7EfqW0pJs0f2MNoyLgoxV863kV1M8pOcdesP+a8wel6Sv8fitqwlA/88
         dzmzGHeAv6YHW6KU0fa4y992ACp7eHNwauUTjgcvSpBUgO0/6bWCn3MJHvX8t9gkBxlK
         8sq9E0AtUEbaZ/yQah+SKZxiDFbngnVvD+wrAfP2okHTu4JlVzX8a9YvP4xI91jde/Nx
         ChKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ySsaN35wYSm5Plluc40G4e3oReJB8ZTlMVwRI8jBszE=;
        b=pGud+2FQMS8fpEcFLOm2dg/+qGBH9UoIKALochvsNXkQYfr7tUzvY6pCw7Ir4Ht9Po
         xkS9mfpKb7RD/GfFG4VZ/BvMPSJD4pND4LMm0IWxYuxkkxpHEUPl6NbBmJQ8QsK0Z8UJ
         LwhgGYDDlm+f5eBJg3cgWbBEYDA/xLtKoFLlD8pWizkJM8bGVI6y9301iF7SxZ5fc3lT
         tC6x7qVXkx+UYNhgXdKJosiVmwWHXJlRo9hVYvHR0xpTZYUZMLipEWs5/fRYlnCQOLwx
         7C0qXfiDlfl/ZRRlZpSHv742rirL8QNhngDu9vevcpce2ndsQ/AN4pardITJkldeavsW
         Qh7w==
X-Gm-Message-State: APjAAAXosbb+UpLWnNGFpXTAQ73/da/dycLXLJ8v9L4t7Nd9zbshGI/t
        i7TCbqEvLS63XZVL6QsJgZ5V8TymzXEhkA==
X-Google-Smtp-Source: APXvYqyMk746Z1dW3YjwMz6aVG6zEe7VBPBYfFg5VGi8IpuiC5H0OK5FfeqG+89CuxAKczy/lrnuNQ==
X-Received: by 2002:a1c:2d5:: with SMTP id 204mr8527547wmc.175.1560945570487;
        Wed, 19 Jun 2019 04:59:30 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z6sm20013688wrw.2.2019.06.19.04.59.29
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 04:59:30 -0700 (PDT)
Message-ID: <5d0a23a2.1c69fb81.2aabf.cfbf@mx.google.com>
Date:   Wed, 19 Jun 2019 04:59:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.53
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y boot: 56 boots: 0 failed, 56 passed (v4.19.53)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 56 boots: 0 failed, 56 passed (v4.19.53)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.53/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.53/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.53
Git Commit: 9f31eb60d7a23536bf3902d4dc602f10c822b79e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 32 unique boards, 15 SoC families, 10 builds out of 206

---
For more info write to <info@kernelci.org>
