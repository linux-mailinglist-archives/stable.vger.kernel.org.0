Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F1763F553
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 17:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbiLAQee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 11:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232164AbiLAQed (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 11:34:33 -0500
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A44AA9E85
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 08:34:32 -0800 (PST)
Received: by mail-io1-f72.google.com with SMTP id z15-20020a5e860f000000b006c09237cc06so2002742ioj.21
        for <stable@vger.kernel.org>; Thu, 01 Dec 2022 08:34:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UKNN3axs1y811QkhsVcYtMf113asLOYvCITq8yCsIOI=;
        b=ymB/XOlFjy6IV3KNXnrNvJobwz47ntLRuHWkBzW9Qq6V2Ppe3WXk8c9RNiQSW9ayjC
         cvL+3U22xOgJOhtEXTRyS5Zkio6h43glSN5Y+OC7QQWS1Ej2KQzkOfAeHj5ejVXrY4to
         VocMrupUAlnzXMzFZ2V9M7ldE/X2QqfFtodfR95J5nLJb7ffW4w39QoWbOs9MeFwnD6t
         ZIv+/QV/uKzaX7T/v+bzlS+n8rGjjsX3PKPq2XDLGVyDXuGlEDE4lSEIKOeqRg7GzMbq
         PVgK+geAOa9DhcM+Uh+4ZOOOEqA/i36O+u5aIcT3Sa4lFrx9C8Wd47WXIU9YPzUIEavG
         d+xg==
X-Gm-Message-State: ANoB5pnQxsx0Nwr3YTfOyV+f+urCdRi4o04h35sXSCj64LSbng6U7hIw
        l/FfTU9EsPbZMumaL7LzZ10jn1s+qKU4yCasJ4wshM2otHmu
X-Google-Smtp-Source: AA0mqf4QsSf1RfaffekqeYnhim3TQSpIXqCXD7AhIKoXzfukEk/NduogwSXw23qNdA3B36SI0rQ3mzU6CxJ96hdkg4dHKHsaUPFE
MIME-Version: 1.0
X-Received: by 2002:a92:cbcd:0:b0:302:a682:4867 with SMTP id
 s13-20020a92cbcd000000b00302a6824867mr28386527ilq.214.1669912471753; Thu, 01
 Dec 2022 08:34:31 -0800 (PST)
Date:   Thu, 01 Dec 2022 08:34:31 -0800
In-Reply-To: <0000000000006c411605e2f127e5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000af5eb905eec6cb85@google.com>
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
