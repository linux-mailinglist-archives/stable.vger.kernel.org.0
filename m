Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D7D36D24E
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 08:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbhD1GkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 02:40:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51571 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229643AbhD1GkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Apr 2021 02:40:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619591968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mw29yMzqVHFx3JmMEZ3wEvw64Bi3lRDgayDcOCxCtDA=;
        b=IZhJX2B4fNBoTP4Ke85WjAnv1mNNtZgn7FKA/K/5qabD4rzP3YqFdzoSSnKChOTRoiBT7U
        sbyFRpmzaVBwykQefM6afd5Vrxdmn83lQuY9V/HgLYGltu1sVGwkjzqZKTKKtkCUxzgqzh
        pjyvCFrmv1YmbrzdtBmYbTlK7Vp6d1U=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-FqVPzzhdMuikC3PvHejfAg-1; Wed, 28 Apr 2021 02:39:24 -0400
X-MC-Unique: FqVPzzhdMuikC3PvHejfAg-1
Received: by mail-io1-f70.google.com with SMTP id v18-20020a5ed7120000b02903f36dccaebcso21182179iom.15
        for <stable@vger.kernel.org>; Tue, 27 Apr 2021 23:39:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Mw29yMzqVHFx3JmMEZ3wEvw64Bi3lRDgayDcOCxCtDA=;
        b=Y8dD/mPL8Ay1PG1NteEOFNAhE1FUM1SnXuYquP82ZsrFXGyXzXyf5A5l37SpeTZrZD
         L59V+eFxAa40n4Hrs/BXe5rYCtBLoFBdmumoFHtWhanKrgjJ53fBmHwhh8PIA2AcMOOB
         RigtbWPB7Wzf5OJmHRKSS18i0IrE5XiON4kg3IKlyP9Z3TxA+oLQdMET99iw/ywe+3PQ
         Nq/EV4NRkZMRT6EhxLID6u7O7Gtk3smcL2okUFyjmi8b4df3lJMy9D3TLXeoKEKAiPrt
         KeW7CyFFr7/L0798WiZ3qP+Gx+eQ0sLGfx91oNOWsqh57VZyrqghyQijcjlKLBnFF1aT
         Eplw==
X-Gm-Message-State: AOAM531EwQxEmTFWeGDsJOZDt3r9W6V2VovF6Z7Nshv0dSWdUpLEWASB
        ffroD4zZf+dy7i2Eq3c89B4HgOBE+2zybTegMaQt8UyZwW1l4/CtIUtstr1zN9mef7jUccqgMe7
        zODYYnI7Mbd4jgbcWVchA5AsaZGrb46xk
X-Received: by 2002:a92:da0f:: with SMTP id z15mr20353936ilm.226.1619591963404;
        Tue, 27 Apr 2021 23:39:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTwGQQ3WEX3wX/F87PZ0G5dHvrgWDVMrJBcQZakolNKVRibOUCrbtBRYoImGE7DVkyhPITlkNklkcfy97s/cg=
X-Received: by 2002:a92:da0f:: with SMTP id z15mr20353925ilm.226.1619591963154;
 Tue, 27 Apr 2021 23:39:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210427085246.13728-1-mwilck@suse.com> <0ff2dbc0-0182-f54d-b750-084feac53601@suse.de>
 <20210427162521.GA26528@lst.de> <f82b7f7c-ef12-27bb-1349-d23ea22e50a9@suse.de>
 <3a0b10f45ac75df3f744dd04ac874021488f42b1.camel@suse.com>
In-Reply-To: <3a0b10f45ac75df3f744dd04ac874021488f42b1.camel@suse.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Wed, 28 Apr 2021 08:39:11 +0200
Message-ID: <CAFL455=m_4tLZwbh1qRGPgE8ufBfKuq84zKkZmCntX56A17kog@mail.gmail.com>
Subject: Re: [PATCH v3] nvme: rdma/tcp: fix list corruption with anatt timer
To:     Martin Wilck <mwilck@suse.com>
Cc:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chao Leng <lengchao@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        linux-nvme@lists.infradead.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=C3=BAt 27. 4. 2021 v 22:02 odes=C3=ADlatel Martin Wilck <mwilck@suse.com> =
napsal:
> The code doesn't use add_timer(), only mod_timer() and
> del_timer_sync(). And we didn't observe a crash upon add_timer(). What
> we observed was that a timer had been enqueued multiple times, and the
> kernel crashes in expire_timers()->detach_timer(), when it encounters
> an already detached entry in the timer list.

How can a timer end up enqueued multiple times?
It's safe to call mod_timer() against both an active or an inactive timer
and mod_timer() is thread-safe also.

IMO the problem is due to the fact that timer_setup() could end up
being called against
an active, pending timer.
timer_setup() doesn't take any lock and modifies the pprev pointer and
the timer's flags

Maurizio

