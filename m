Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7A464DEBA
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 17:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiLOQej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 11:34:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiLOQeh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 11:34:37 -0500
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E10C10B74
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 08:34:36 -0800 (PST)
Received: by mail-io1-f71.google.com with SMTP id j5-20020a5d9d05000000b006e2f0c28177so5929290ioj.17
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 08:34:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UKNN3axs1y811QkhsVcYtMf113asLOYvCITq8yCsIOI=;
        b=ky93PPN5ljf81EonpjyZKQJ3/yMQcSf9U2RSIINCqR+DBLInGrE+8YkdbMNoPpN2dU
         ARyI4d+Ki8zg1jKHhDvn76VLfVOho+VPxTHZue46ZkEKu+fi8+O/WA5bZsAVTesFLo5Z
         of5AjM+yHbBNy+LqLnMrE2Dl9pFC3/EbdFXsC+8GpGKx6VrlNWGiUitr4nMxlPgyHN3C
         7iAZ6mNN4QuPmRbXGMRF2frb76PqKoJ8+9R2YqVc+INEcZewoPylOwS0O8SdBUx2LPNj
         txCxeeZFY99UXsKQEBDb192GiQ+gFNnZ3Akb+PoxNEHlloYMt5gCntTrFWQIdUQojJUG
         ezrQ==
X-Gm-Message-State: ANoB5pknbP1tkEQ6hyMWEmgdLkNHwHl/l5xIeV8JSHqrvnn2nw2xiBCT
        rAMw4kFkIPM4MbnGcBOrxyO5XjwQn9jvWGY/L7WcZyP6xJXf
X-Google-Smtp-Source: AA0mqf5FzknCTRgZ5/NnD2luL2tffHnVuVk1MAMWE1nMsEVq82UTqE43Kw9M0nei31X8BWp1l13rVJn/Sof8OhGcbC4QuC/fffzN
MIME-Version: 1.0
X-Received: by 2002:a92:dc04:0:b0:303:1c4d:d32e with SMTP id
 t4-20020a92dc04000000b003031c4dd32emr23700450iln.286.1671122075910; Thu, 15
 Dec 2022 08:34:35 -0800 (PST)
Date:   Thu, 15 Dec 2022 08:34:35 -0800
In-Reply-To: <0000000000006c411605e2f127e5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b60c1105efe06dea@google.com>
Subject: Re: kernel BUG in ext4_free_blocks (2)
From:   syzbot <syzbot+15cd994e273307bf5cfa@syzkaller.appspotmail.com>
To:     adilger.kernel@dilger.ca, gregkh@linuxfoundation.org,
        lczerner@redhat.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, sashal@kernel.org,
        stable@vger.kernel.org, syzkaller-android-bugs@googlegroups.com,
        tadeusz.struk@linaro.org, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This bug is marked as fixed by commit:
ext4: block range must be validated before use in ext4_mb_clear_bb()
But I can't find it in any tested tree for more than 90 days.
Is it a correct commit? Please update it by replying:
#syz fix: exact-commit-title
Until then the bug is still considered open and
new crashes with the same signature are ignored.
