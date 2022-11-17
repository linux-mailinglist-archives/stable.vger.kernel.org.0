Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD41662E208
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 17:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbiKQQfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 11:35:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240704AbiKQQfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 11:35:11 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9386252B7
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 08:34:26 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id a15-20020a056e0208af00b00300806a52b6so1532014ilt.22
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 08:34:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UKNN3axs1y811QkhsVcYtMf113asLOYvCITq8yCsIOI=;
        b=ytRJFAbLxYc/gey6tyPHu5sZGNkWO8VqbwA75D17qtJsYL/L9Nyxni9jFYvLAMVpZl
         xzzezgjUGZOE1wMWEGAK+plk+i8AyIeRDVWygUm9ZhZEqL6P2kpCbwegps8TABe9Hy8a
         GCevvWKew5F/30ujzjfkb28tTyx5aieNIqh4278dsH3fs5d+VAsxh9NMPNoIcPUVY6+C
         Vv4sZS6sXiYTJq1zOQq8R43iaT+0dZxn4iJqFjMXfYPKrrgKJwL+m5MrcFZ/HbxpxwjY
         XMCBOaeFFgUQR+U9fMrj+OlnYJKG6B+yEqFhzwgW6F4x4DNpiK+Cz0pSR3cOh0jFYZPC
         C/GQ==
X-Gm-Message-State: ANoB5pkjoz19hhbhjnPyx6TCWYNTSn2dcq+xFB4kUBPUMX8KNAJ1HhoP
        wLjYLP2V0f38eFiO1CGF+F7+e0WwtB8dZ0AFTfvWrFdLaf8v
X-Google-Smtp-Source: AA0mqf5cB8zjsOSC8LHfvAYaU0F7H15UOWRCuC2r5ny9Tj6mj8hA5jpRHTg/4LdRqCujB/GD3+SOVZwgGwscKi4bxIBPLJ2kZP0a
MIME-Version: 1.0
X-Received: by 2002:a6b:c990:0:b0:6dd:807d:89a3 with SMTP id
 z138-20020a6bc990000000b006dd807d89a3mr1779863iof.33.1668702866278; Thu, 17
 Nov 2022 08:34:26 -0800 (PST)
Date:   Thu, 17 Nov 2022 08:34:26 -0800
In-Reply-To: <0000000000006c411605e2f127e5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000949d0805edad29fc@google.com>
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
