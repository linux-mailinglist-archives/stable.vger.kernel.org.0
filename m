Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16673493C8
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbfFQVd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:33:26 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45945 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729812AbfFQV0F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 17:26:05 -0400
Received: by mail-lj1-f195.google.com with SMTP id m23so10777126lje.12;
        Mon, 17 Jun 2019 14:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SgrTuP6AQJPtUFPq6sFHz2StVLkigVx7MIwgSvRBi6w=;
        b=l/ElTctsOi+gGau20KA8uGy9YGXLuScH8X8b1uZiNffsaZIVn790yRgvbVNt18Vswg
         Hksl10Z1eZT0BUcY1/FloOBQ16pqcnEFzIjCMH6spvZbQ9BOS4f/LN4UhPtIa6MF/oLd
         d3XWZr0jfQQv+SOg08BGYSL8ZlWOYncwEk46Fey8W0uzMXsEmnjSCTASr7tuEYNfa2ZM
         WHHLdOPQ83V8oNsDZhm5maZrlD9liREWpos1XBZRpvj2Tc5CnxrIvW3t2KXYGo2D0kl5
         BchRpImz1DkVhujje0XDQVFOHa4kpzL9fTKC6DWmg8lf0coYbcANLGwfTAXaPRoX9y3M
         rNgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SgrTuP6AQJPtUFPq6sFHz2StVLkigVx7MIwgSvRBi6w=;
        b=m7KKUBCGd+h8ShRLK6pkLG1Mp1zRnlydU1kl9WHeb9VJ6JPFSvWUR1b228nPhjCuKB
         2/rUv1+G9nD1DrsVQ3Tau4rmLYI47t0jNTpmESeSnD0Uf7VkLkTyc6t11I8NL8R8apJK
         tVADbjquvaQQrCCrYrkryuIjJ95byTPRmqpDunLXVi9OQjiUIWHU+r7McVkTve13fkiH
         SBoh+qYrfLJKLbM0B6kVyeU5PbgLBr4ponVa3xeXSloqo/jOOTgGm51Je1jFb/5Jy4J8
         O6MWaBQ1eAd+6HGed90RRQoyhz/pxOo5v/gYIf5ZsSeuOBPWddX8haNhzU/lJI8LOfuu
         WxmQ==
X-Gm-Message-State: APjAAAXr0e0b1t2gSA4QtuATxE0ob3uv5Okj65sd4R8vT9LxDUcjxm8Z
        ci7yDt5oz9Q/4YusaMS0vA6pzqPRDnO1LWQyqg==
X-Google-Smtp-Source: APXvYqxFledApKEXfw6Y6/el0MQeLQCJnRLGw147lUZtU+VV3t9B7No5NNn3uVNh8KWzfoCBP2jJpf2I1ZF2RDOZzp4=
X-Received: by 2002:a2e:9997:: with SMTP id w23mr27645106lji.45.1560806762821;
 Mon, 17 Jun 2019 14:26:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190614030229.22375-1-lsahlber@redhat.com> <CAH2r5muLjnEer+6Fn2ikLRF6BuK2F2qCzXTHS5Kakhbk7mS4Lg@mail.gmail.com>
In-Reply-To: <CAH2r5muLjnEer+6Fn2ikLRF6BuK2F2qCzXTHS5Kakhbk7mS4Lg@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 17 Jun 2019 14:25:51 -0700
Message-ID: <CAKywueSaqY2qDvzbtL5ua8v18n1uY=SZDi5F4bUQRQ_Ft2ptfA@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix GlobalMid_Lock bug in cifs_reconnect
To:     Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Acked-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky

=D1=87=D1=82, 13 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 20:57, Steve Frenc=
h <smfrench@gmail.com>:
>
> tentatively merged into cifs-2.6.git for-next and to the github tree
>
> On Thu, Jun 13, 2019 at 10:02 PM Ronnie Sahlberg <lsahlber@redhat.com> wr=
ote:
> >
> > We can not hold the GlobalMid_Lock spinlock during the
> > dfs processing in cifs_reconnect since it invokes things that may sleep
> > and thus trigger :
> >
> > BUG: sleeping function called from invalid context at kernel/locking/rw=
sem.c:23
> >
> > Thus we need to drop the spinlock during this code block.
> >
> > RHBZ: 1716743
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/connect.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 8c4121da624e..8dd6637a3cbb 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -476,6 +476,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
> >         spin_lock(&GlobalMid_Lock);
> >         server->nr_targets =3D 1;
> >  #ifdef CONFIG_CIFS_DFS_UPCALL
> > +       spin_unlock(&GlobalMid_Lock);
> >         cifs_sb =3D find_super_by_tcp(server);
> >         if (IS_ERR(cifs_sb)) {
> >                 rc =3D PTR_ERR(cifs_sb);
> > @@ -493,6 +494,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
> >         }
> >         cifs_dbg(FYI, "%s: will retry %d target(s)\n", __func__,
> >                  server->nr_targets);
> > +       spin_lock(&GlobalMid_Lock);
> >  #endif
> >         if (server->tcpStatus =3D=3D CifsExiting) {
> >                 /* the demux thread will exit normally
> > --
> > 2.13.6
> >
>
>
> --
> Thanks,
>
> Steve
