Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB120EC82D
	for <lists+stable@lfdr.de>; Fri,  1 Nov 2019 18:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfKAR6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Nov 2019 13:58:46 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32937 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfKAR6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Nov 2019 13:58:46 -0400
Received: by mail-wr1-f65.google.com with SMTP id s1so10452015wro.0;
        Fri, 01 Nov 2019 10:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qO3CIEPD6rww8FavrKZQtqlfMDnnlSCj9+4yATdrCLA=;
        b=vQo8RxWxHk0k8Zr9qJbG57J2vYCC8635g+BRHQyfqQDjKKi2MMvPPkbdJlOq4Sn/4F
         X5KQ0WPYkVMOpO1hunl8iHo1Qo2P7Z75ihltprHEFHUq67xuReulvOZ1CH4/4h8RUej5
         lJXymhrteNj68Uv/m3KTK0A+6Faj1HXu/yY0aMz8VBrJfed9uxnP0ZaHc2TY4rjU6FYn
         edG+KYwKEmgVKnOrqA9/6n4w92+yuoQxJCNG/i5HFXaSfTLxgfbTqBZh85bmas8cKJPY
         cQ9e/kweyKl8Gx+SAESVhIlaqGEPxsmmBaHoeQ1iFcIQiUrvFnJHOx6zsjNV6jRSzVMw
         0ZOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qO3CIEPD6rww8FavrKZQtqlfMDnnlSCj9+4yATdrCLA=;
        b=ROViasDbWN0GASwl384oSs5MPSXHwzjWtIuVxBdIzl+5FPO7NY1gUMUg+pIlVa+whk
         GVfZUJU83n7b2ZFFx8wPp8j8jPeiy0FDYL6UJLhd6lTsmX5JRksCSfOdz5SmgUq/cgOG
         ehwi68RJLt2FaOjF7sZjP3cXQZA4iUW0PYrrQmoYZZxvDZ8Jmt+4UZEUqTHUSPUU5lEp
         KRKZbBncFBE4jqz4lMYt0ml5a2eZ3cvNO9GMtBEYQNc7CUTstee68QvE/YNDvdfdQrm5
         QYmj5niGgozwaj4Qz5S/CW/rQZhuujf/iMj5ZUGNAcvWyCN9nHWOh4T5WL0IGi5i26or
         eXXQ==
X-Gm-Message-State: APjAAAUEdQQuyOl1YjByV/JPf0TAwowUlDjUljYwhydu0P42YHd93J4W
        C934hfRMbPlC7KR1XUs9cXhBhyAGMAyJG83yoCo=
X-Google-Smtp-Source: APXvYqwZFWtBSzVeyJWbB9ynwOGLbzopg4+ErmL9nrwEaSUYiQroYsqI3HIW0rQgQxws/IQuOwOpv8WE/awKqYkFoho=
X-Received: by 2002:adf:f80c:: with SMTP id s12mr11307715wrp.37.1572631124100;
 Fri, 01 Nov 2019 10:58:44 -0700 (PDT)
MIME-Version: 1.0
References: <20191027203259.948006506@linuxfoundation.org> <20191027203307.303661015@linuxfoundation.org>
 <3e9de35dda19c0ac207d49d24c2735655b1d8d64.camel@nokia.com>
 <CADvbK_dx=dT6j-XMA=p9QgJJp5YgA2zRCLuY08u4pz0v=vXorw@mail.gmail.com> <20191031120958.GP1554@sasha-vm>
In-Reply-To: <20191031120958.GP1554@sasha-vm>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 2 Nov 2019 01:58:33 +0800
Message-ID: <CADvbK_eRDP=zK7cTFDBmOe1_+-Q57Daet7V1OUY9FPaENDY3VA@mail.gmail.com>
Subject: Re: [PATCH 4.14 024/119] sctp: change sctp_prot .no_autobind with true
To:     Sasha Levin <sashal@kernel.org>
Cc:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "syzbot+d44f7bbebdea49dbc84a@syzkaller.appspotmail.com" 
        <syzbot+d44f7bbebdea49dbc84a@syzkaller.appspotmail.com>,
        "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 31, 2019 at 8:10 PM Sasha Levin <sashal@kernel.org> wrote:
>
> On Thu, Oct 31, 2019 at 05:14:15PM +0800, Xin Long wrote:
> >On Thu, Oct 31, 2019 at 3:54 PM Rantala, Tommi T. (Nokia - FI/Espoo)
> ><tommi.t.rantala@nokia.com> wrote:
> >>
> >> On Sun, 2019-10-27 at 22:00 +0100, Greg Kroah-Hartman wrote:
> >> > From: Xin Long <lucien.xin@gmail.com>
> >> >
> >> > [ Upstream commit 63dfb7938b13fa2c2fbcb45f34d065769eb09414 ]
> >> >
> >> > syzbot reported a memory leak:
> >> >
> >> >   BUG: memory leak, unreferenced object 0xffff888120b3d380 (size 64):
> >> >   backtrace:
> >> >
> >> >     [...] slab_alloc mm/slab.c:3319 [inline]
> >> >     [...] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
> >> >     [...] sctp_bucket_create net/sctp/socket.c:8523 [inline]
> >> >     [...] sctp_get_port_local+0x189/0x5a0 net/sctp/socket.c:8270
> >> >     [...] sctp_do_bind+0xcc/0x200 net/sctp/socket.c:402
> >> >     [...] sctp_bindx_add+0x4b/0xd0 net/sctp/socket.c:497
> >> >     [...] sctp_setsockopt_bindx+0x156/0x1b0 net/sctp/socket.c:1022
> >> >     [...] sctp_setsockopt net/sctp/socket.c:4641 [inline]
> >> >     [...] sctp_setsockopt+0xaea/0x2dc0 net/sctp/socket.c:4611
> >> >     [...] sock_common_setsockopt+0x38/0x50 net/core/sock.c:3147
> >> >     [...] __sys_setsockopt+0x10f/0x220 net/socket.c:2084
> >> >     [...] __do_sys_setsockopt net/socket.c:2100 [inline]
> >> >
> >> > It was caused by when sending msgs without binding a port, in the path:
> >> > inet_sendmsg() -> inet_send_prepare() -> inet_autobind() ->
> >> > .get_port/sctp_get_port(), sp->bind_hash will be set while bp->port is
> >> > not. Later when binding another port by sctp_setsockopt_bindx(), a new
> >> > bucket will be created as bp->port is not set.
> >> >
> >> > sctp's autobind is supposed to call sctp_autobind() where it does all
> >> > things including setting bp->port. Since sctp_autobind() is called in
> >> > sctp_sendmsg() if the sk is not yet bound, it should have skipped the
> >> > auto bind.
> >> >
> >> > THis patch is to avoid calling inet_autobind() in inet_send_prepare()
> >> > by changing sctp_prot .no_autobind with true, also remove the unused
> >> > .get_port.
> >>
> >> Hi,
> >>
> >> I'm seeing SCTP oops in 4.14.151, reproducible easily with iperf:
> >>
> >> # iperf3 -s -1 &
> >> # iperf3 -c localhost --sctp
> >>
> >> This patch was also included in 4.19.81, but there it seems to be working
> >> fine.
> >>
> >> Any ideas if this patch is valid for 4.14, or what's missing in 4.14 to
> >> make this work?
> >pls get this commit into 4.14, which has been in 4.19:
> >
> >commit 644fbdeacf1d3edd366e44b8ba214de9d1dd66a9
> >Author: Xin Long <lucien.xin@gmail.com>
> >Date:   Sun May 20 16:39:10 2018 +0800
> >
> >    sctp: fix the issue that flags are ignored when using kernel_connect
>
> Care to send a backport?
Sure, I haven't yet sent a backport for 4.14.y
After I do the cherry-pick, what's the next step? Post it upstream
with CCing someone ?

>
> --
> Thanks,
> Sasha
