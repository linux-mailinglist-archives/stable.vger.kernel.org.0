Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827D747A615
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 09:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234853AbhLTIgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 03:36:11 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:47970 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234688AbhLTIgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 03:36:11 -0500
Received: by mail-io1-f69.google.com with SMTP id o11-20020a0566022e0b00b005e95edf792dso6657933iow.14
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 00:36:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=O3LXneiNH9IRbWHAKK3lrVYWgtCFvwj/GzY0w5gPzSA=;
        b=pOd3oVQEtijCDrPj5Rx3PHOVxBcWBMO7qm/y9rqQSeR1PqLUJvifNzEBUZ3XLvXCXh
         J2/xv2chSJ+vOwUtCvbr7yex2YMbHxqUe2B9VEMdO5EmnAZeMfPaBilrByeWOiZfiFqW
         dyuN21GmJSs8OfxIQ1gJQJ15BcfD/+5sGUrgFjnFp9V1PQ2qdSRjjNDi6owRlYf+Eaeq
         qu7O54db+HL11KeQWHTmQ1WrsrfMAlUDKbWIBb6CFbTp+GqSGlnqTLxY782vYA2mkvWa
         IUOW1APhq7k/BFBcRUr8m7kSSXfkodTQU5JJZXo0Og/qFEWPvUQM+yis/GxzLHNBO9r8
         W4cA==
X-Gm-Message-State: AOAM531rwHyYYxVjvhQqwlWbNyE6A7RvxWz+LYmY3fDZFFqnAvCIyuWh
        9V58ggFZ0n78EnQ4vpPYZMkMKZfYLxk0FxjBr9uior19jjJ6
X-Google-Smtp-Source: ABdhPJwDzIY6BCSPt6NhocGT4u74Rfl+fDqzK2BHg2sNL8ykWf2a3GluAuPJNgfc8D5oS9lUEiWH1t820hqfmf5IFmT82jX2gq92
MIME-Version: 1.0
X-Received: by 2002:a05:6638:191c:: with SMTP id p28mr7354021jal.181.1639989370732;
 Mon, 20 Dec 2021 00:36:10 -0800 (PST)
Date:   Mon, 20 Dec 2021 00:36:10 -0800
In-Reply-To: <20211220090836.cee3d59a1915.I36bba9b79dc2ff4d57c3c7aa30dff9a003fe8c5c@changeid>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e0c8fb05d38fc731@google.com>
Subject: Re: [syzbot] WARNING in ieee80211_vif_release_channel (2)
From:   syzbot <syzbot+11c342e5e30e9539cabd@syzkaller.appspotmail.com>
To:     johannes.berg@intel.com, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+11c342e5e30e9539cabd@syzkaller.appspotmail.com

Tested on:

commit:         60ec7fcf qlcnic: potential dereference null pointer of..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git master
kernel config:  https://syzkaller.appspot.com/x/.config?x=fa556098924b78f0
dashboard link: https://syzkaller.appspot.com/bug?extid=11c342e5e30e9539cabd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1412bd93b00000

Note: testing is done by a robot and is best-effort only.
