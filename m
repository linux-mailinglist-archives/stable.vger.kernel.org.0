Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40B67697C1C
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 13:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjBOMpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 07:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjBOMpx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 07:45:53 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB893251E
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 04:45:51 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id i7-20020a056e021b0700b003033a763270so13128411ilv.19
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 04:45:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V5gRBWvCrC4ivORDLYanYAKruxMNDrxF3nhXlCgZ6d4=;
        b=Kkw0AnzjGxqe9J4gRiooOyjTwpJWFCP7SlLH5VsFH/Kb+6xAHi5NjeAgzy0Fvnl7Hw
         G5XmoPL4YcLXF3tLTqsOtrtql2GbEwehP2jW40Ngb88v3gT24PfdNtrgR5rVYa+eyq2b
         J7pj+Le5ON9oLXupzmWWp91JcMe0zrbCe+FAeFQes7zFMAUZO7BciefBIZ+G/8j059jg
         2AwrTRvt1FDDOjcDjUZfyWxbtqMwQzTPBW0C3Aotn5vH6utIMJP/C9OiHyxRICOHLWpt
         AIjUftLz3zVnfO0+nIvo0jLmuUd2cMf3ts0fnsVv0Jo4b26M51mP1O64Ev29wkyKxKPC
         3cTQ==
X-Gm-Message-State: AO0yUKXSfjMegMmszdPD2Pr8e7fkBDfSU8sJ+ceamLOsdvnOclPOt4Jb
        4RKHmiomo2qqtgW/pw6pUBk+VCCliFLcryQOmSdwjAQCxuQG
X-Google-Smtp-Source: AK7set9TjvisiTIRVmOM6kk7oWlt9QxFsyDansPcekDaE9vTb1o4Jz8iKYvVdAHKEnBGb6wJBTvmELx9OL90n9hUVjrG8BHZYbwh
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3e0f:b0:3c4:a4d1:cc49 with SMTP id
 co15-20020a0566383e0f00b003c4a4d1cc49mr886208jab.3.1676465151294; Wed, 15 Feb
 2023 04:45:51 -0800 (PST)
Date:   Wed, 15 Feb 2023 04:45:51 -0800
In-Reply-To: <0000000000006c411605e2f127e5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d245a705f4bc75b4@google.com>
Subject: Re: [Android 5.10] kernel BUG in ext4_free_blocks (2)
From:   syzbot <syzbot+15cd994e273307bf5cfa@syzkaller.appspotmail.com>
To:     adilger.kernel@dilger.ca, gregkh@linuxfoundation.org,
        joneslee@google.com, lczerner@redhat.com, lee@kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        nogikh@google.com, sashal@kernel.org, stable@vger.kernel.org,
        syzkaller-android-bugs@googlegroups.com, tadeusz.struk@linaro.org,
        tudor.ambarus@linaro.org, tytso@mit.edu
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

But I can't find it in the tested trees[1] for more than 90 days.
Is it a correct commit? Please update it by replying:

#syz fix: exact-commit-title

Until then the bug is still considered open and new crashes with
the same signature are ignored.

Kernel: Android 5.10
Dashboard link: https://syzkaller.appspot.com/bug?extid=15cd994e273307bf5cfa

---
[1] I expect the commit to be present in:

1. android12-5.10-lts branch of
https://android.googlesource.com/kernel/common
