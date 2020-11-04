Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7F52A6338
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 12:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbgKDLZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 06:25:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728066AbgKDLZZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 06:25:25 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CB7C0613D3
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 03:25:25 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id p5so29257368ejj.2
        for <stable@vger.kernel.org>; Wed, 04 Nov 2020 03:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=kwIxmB3LTVuXhoJJT9+oGgcs9w27IJzw7Apq/DRcRAM=;
        b=t9Gt+1wE/yKV8h2AxbkVbB3ND69vn80foiCF4I+YA6mGJuNEsL3OQi2IDY7Ob3Dgys
         4lnBjaRKMhT+oIFgEZsZHAcxbVbeCWotq0o4RRtW1WoO5NDrPnQDM8DY3FR6zd6kVZDk
         5nfRa7/AVoxb3MIIhbftM8UwfJ6M7FpK17Yfp+l1iXZzItohzWcdJzRycWM8LAY29Eu0
         hhlIC5D7dZt/b29BhV9PH226SIvz+rQcZC1NwumvAas6dnLw5aHT8ktEBtVK/mxRcwUo
         H53KhumrVWpkmVrgdJTE02t7KMAm+uzHc+PfbUb6kmAWvOVYkepYTc+/mJ2HoI2dp5a8
         6aFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=kwIxmB3LTVuXhoJJT9+oGgcs9w27IJzw7Apq/DRcRAM=;
        b=p4qtZDYaSJoBZWDVPxLqpWqyDcDcRn7acivGSIw/ekS8Bhj6Ed5vkp0+mAMnHCCmuV
         Xg2gfxfqfRxb4qojFmb2OLXaZQlSyERMzJrOT50mABbyjxTOvYuw5tVsVeJJCHZeZExB
         dCUjx6IZVQNmV4uBJMtifS49ucjFWgwBqp/4JuqiFyIWBg3nwIfgz3C0te1hOZRQ8RNt
         Ukn5n5Lze7nEnE9bTH4Ng7l29AJ95hZPdDSkeVDC92PBFD+dGZCJilNUCtMddV3qzpg8
         VdlUIXTO7xTgn+nnPucrKoRsBlhedAD/rfZjRLviW2UiKRxhTA7Q27azb4EHWZKTkD5f
         DlaQ==
X-Gm-Message-State: AOAM532fQICKCqtaBgqGWQetLh8i2Bt2QS1W40Y2bg5iFigCU48b8iWp
        RPmqHfVN01GSu/nMLQLp0ikP0FqcQMfH/o3Nzl7TsHrGtTfg5ItF
X-Google-Smtp-Source: ABdhPJxS9Tq9pHnjR4nT8shXk47P+NeubekhGQ42dxLQpkMtfign2/6XnfB9qmx6RHFbwv1M32sayGd0gCeXM3gcSPU=
X-Received: by 2002:a17:906:4742:: with SMTP id j2mr23848852ejs.247.1604489123213;
 Wed, 04 Nov 2020 03:25:23 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 4 Nov 2020 16:55:12 +0530
Message-ID: <CA+G9fYu4RdH7zdd5MU=E-o+azMRx-EqR-7VYuJCUastKRd0KCA@mail.gmail.com>
Subject: [stable-rc 4.14] shmctl04.c:115: TFAIL: SHM_INFO haven't returned a
 valid index: SUCCESS (0)
To:     linux- stable <stable@vger.kernel.org>,
        LTP List <ltp@lists.linux.it>, lkft-triage@lists.linaro.org
Cc:     Li Wang <liwang@redhat.com>, Jan Stancek <jstancek@redhat.com>,
        chrubis <chrubis@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

LTP syscalls test shmctl04 test modified in latest LTP release 20200930
and this test reported as fail. so reporting to LTP mailing list.
Failed on stable-rc 4.14, 4.9 and 4.4 branches but
passed on stable-rc 4.19, 5.4 and 5.9 branches for arm64, arm, x86_64 and i386.

shmctl04.c:115: TFAIL: SHM_INFO haven't returned a valid index: SUCCESS (0)
shmctl04.c:131: TFAIL: Counted used = 0, used_ids = 1
shmctl04.c:72: TPASS: used_ids = 1
shmctl04.c:79: TPASS: shm_rss = 0
shmctl04.c:86: TPASS: shm_swp = 0
shmctl04.c:93: TPASS: shm_tot = 1

Reported-by: Naresh Kamboju  <naresh.kamboju@linaro.org>

Test log link,
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14.203-126-g8c25e7a92b2f/testrun/3392140/suite/ltp-syscalls-tests/test/shmctl04/log

kernel: 4.14.204-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-4.14.y
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14.203-126-g8c25e7a92b2f

-- 
Linaro LKFT
https://lkft.linaro.org
