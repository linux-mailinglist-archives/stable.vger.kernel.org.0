Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FA73C859E
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 15:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbhGNN5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 09:57:00 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:48103 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbhGNN5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 09:57:00 -0400
Received: by mail-il1-f200.google.com with SMTP id c7-20020a92b7470000b0290205c6edd752so1162859ilm.14
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 06:54:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=5iBy0lYSGa09oNnLjcIT0TpubGTNL6rsWEE+k4WZlK0=;
        b=Mwl5lMMLFYHM/EiflV3WJhUdBzI/8PoSMrYrPWtcqhj5VpBU2k+vl29W5bA5tyULNF
         JU3PshyHOnSr6R0MVTuEUW7BYOq9EWTfCzHcNbBSgpob3xUct+VZ9yubZZ8D2Z7gBqg/
         +Tn0XY8i+BL8HVgkc+MNZ+OkQhvsebvCTq0ZgTQaj7FYfpSK41xhYD/jfqEON4de83Vm
         efUtcsu9x+cqWTe2bmXuPtFrNB1zzePF9rbFJ8axP4LvBg3eynPTFWgmvoS7X/44Cg3E
         fdAEeBEc4BgdBQvl0S/p7eKtgr/aKfEzKmiMr8swRHUPPGkMFEYwwLh+ZtSd+jVpqbW2
         mBEw==
X-Gm-Message-State: AOAM533mRSAEYwaRIUj1BUfK57v1v81hnbICLx+Po9562BjN/mBvPHtA
        RaNDutTw6ImwuOk+bHXvt3PkzKh6nvRhpFBAWiUs4xS9adLF
X-Google-Smtp-Source: ABdhPJxdriFY6cRso6foqyHhWvZJZlr8sMQZFvXXGupXDK0NKiVdeKKS73K8wdaZOOY5jX5ldI66/IVlGmnDFv2tDrcjXqj1djd6
MIME-Version: 1.0
X-Received: by 2002:a92:360b:: with SMTP id d11mr6696974ila.111.1626270848535;
 Wed, 14 Jul 2021 06:54:08 -0700 (PDT)
Date:   Wed, 14 Jul 2021 06:54:08 -0700
In-Reply-To: <20210714135157.mz7utfhctbja4ilo@wittgenstein>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003c529d05c715b0e3@google.com>
Subject: Re: [syzbot] KASAN: null-ptr-deref Read in filp_close (2)
From:   syzbot <syzbot+283ce5a46486d6acdbaf@syzkaller.appspotmail.com>
To:     brauner@kernel.org, christian.brauner@ubuntu.com,
        dvyukov@google.com, gregkh@linuxfoundation.org,
        gscrivan@redhat.com, hch@lst.de, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable-commits@vger.kernel.org,
        stable@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to checkout kernel repo https://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git/ on commit 595fac5cecba71935450ec431eb8dfa963cf45fe: failed to run ["git" "checkout" "595fac5cecba71935450ec431eb8dfa963cf45fe"]: exit status 128
fatal: reference is not a tree: 595fac5cecba71935450ec431eb8dfa963cf45fe



Tested on:

commit:         [unknown 
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git/ 595fac5cecba71935450ec431eb8dfa963cf45fe
dashboard link: https://syzkaller.appspot.com/bug?extid=283ce5a46486d6acdbaf
compiler:       

