Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8288031705
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 00:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfEaWO7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 18:14:59 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:34279 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbfEaWO7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 18:14:59 -0400
Received: by mail-wm1-f45.google.com with SMTP id w9so612514wmd.1
        for <stable@vger.kernel.org>; Fri, 31 May 2019 15:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6uuHfuVD5rpSOcwp4ywIHCEX/jLRIDWD1Hnp3iV40Jk=;
        b=opQ52Q88rAd5KNEJp/zA0TmiTQct6q/JEaHVPq21xRxz6T7EUdOuX3Eheh8pbq37Kd
         E/bpJwP1OPkZotcUnZLvtOzWeca3SSuvSdy4Ws8CRuN/ACNrkT7Kzknya/8dlfHHm4ua
         U4hLPPUP3Fi9DIkz57zpz4MW1ImKXXA60scHk3fuob3izIH3BNPsHj1kFp9PuD7/2bYt
         qPXOzby/UZROHXsvdLqvhLBiV+4yYtW0Hnn9No+3OD0E85uIxWABuKtAa1uCYY5OQ+B9
         nhKjYnU/c45tL+3zbdfcCR0PluZFApew5MYkdyXjSjqdZaT7zHVr6Fi4AapSzJ9fGocs
         Od2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6uuHfuVD5rpSOcwp4ywIHCEX/jLRIDWD1Hnp3iV40Jk=;
        b=EuBkr0Mgxgr9fGDvnyG+h+bv5Qaug8qmntmMgawqIxvqOn6G4B7vnRDkSRz58kXmXL
         +v89GfDlzW1VBAzWFmg1aptm0kgA2aRKDuMhGsnHJLkg82UxhJKKTE2rMxS6bn63a7K5
         vPwrDYSQXgiiadUKCqEqRS9ftBXNxA35icjjw75BUk0JSq5spmbnx3IDhDKTdCXBKaxC
         HOolfq/pGpU7ZIfle3GVL5XAJ+RwGRz85v2oeZ2bSTGuxnRc5L8NerRXV8qVRFi8H3Jf
         HI6sMrUf4l80CxtVTYA38tB7SxYgOu52bc5KldKnsLXDpdwehXt8ulFNxGu3bfAqJ7pr
         5sDQ==
X-Gm-Message-State: APjAAAWe1AiFS79NuntONI22y1840w/M/ql+bqgdZz6F4Y+j+GCiC5vh
        nsFS3qNWMsy88hMTTGID5lNPzNg6ZeXpZw==
X-Google-Smtp-Source: APXvYqxuKB9D8Y7LjpWRXbfWn/5u6dOUNNY3wFP7BzzD8KiKXz3NNe8dH3N35U312J3DuqPZpkmxqw==
X-Received: by 2002:a1c:7511:: with SMTP id o17mr6968302wmc.39.1559340897083;
        Fri, 31 May 2019 15:14:57 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w10sm11356029wrr.67.2019.05.31.15.14.55
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 15:14:55 -0700 (PDT)
Message-ID: <5cf1a75f.1c69fb81.0355.dc4f@mx.google.com>
Date:   Fri, 31 May 2019 15:14:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.47
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y boot: 59 boots: 0 failed, 59 passed (v4.19.47)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 59 boots: 0 failed, 59 passed (v4.19.47)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.47/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.47/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.47
Git Commit: 0df021b2e841eded862ebc3b61532e7c73965535
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 30 unique boards, 16 SoC families, 11 builds out of 206

---
For more info write to <info@kernelci.org>
