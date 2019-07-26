Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5139F76BC3
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 16:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbfGZOkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 10:40:02 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:38249 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbfGZOkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 10:40:02 -0400
Received: by mail-yw1-f68.google.com with SMTP id f187so20406395ywa.5
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 07:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g1vw/zhzgzlaAj9PAyNj5qk7UcGlQmJnfYzX/GRn8iY=;
        b=dEWr49kCy4JoyOMutCorZhU7tbpjeVLXFKLIK+CU7fb2p8P3CskwRmyEjVZVz4Od4K
         izOo1vnQCuHV+/k8Do4XKG/lB+3qLdqs5SIM1ta3fu7ydDxQkHvWMJFAzX2Kq7wSBPsS
         UuEvIcGbShgz6w16Tidzy6oeMimoJnPORvC8sp95O2GZSh/urZslg2Lnr3EWadgOYect
         JqsN9+7ag59WmQdR7rrjWntgLuBTL8jhEnvIkRb10URhmXE2T4iQsdfSMO7uJEEWjKxq
         ErQEc2WmJscX/h+fAMFzyzj9rlJPO3i/9zzBdZeath1fM/OvNFQTW6fwCjzbpMhPeKkJ
         tzlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g1vw/zhzgzlaAj9PAyNj5qk7UcGlQmJnfYzX/GRn8iY=;
        b=EkmvLfjjYYgM2n1cTr5twutRDJ4V/W5E3rNI+S/AjOoyaHR4VDR27TxJOJ5AW5luu2
         nLU13B4Nu/6eKiIfedCdAh0KzpnmQJ+bQsoHQ2ZB/fRlpQEcpqX7kqeWan2DdbMZ+JON
         j31iLi2KBfS98iaxlU6ROVTaHmz2alWWJm/gHgFkRa/Mriwtc9yy6YsFCc65KyF6g88s
         RBX3SnsLQ1YieMOTBDvDdDDLXAA4sMmEKzrq4xTA29DsK4G2WSNqGiXIUBuzuVkRwOtL
         fBETT6fCuSVO6cFclzI1eT/nhmkGeblakpbNdE966rOZNf4xmmFQGg/25SkPGBfGs98U
         10eA==
X-Gm-Message-State: APjAAAU50MZjq6nvmMWM7f0wgWPVmvibwPBTABBf7iuTtIm5rim4W2pH
        6E2TFeqmRKDg3yi2mwBF2XIHvIqvdueN0Yrg8hd00g==
X-Google-Smtp-Source: APXvYqyWfDGB9Bphyb5xRf5qrBhymbg7d9dBUICJ4NMqqAxbOeRxZgw7Xbt9ngN8ScnKmIb6stjlXSQ/aKv0yKU45Js=
X-Received: by 2002:a81:494f:: with SMTP id w76mr54854608ywa.21.1564152001169;
 Fri, 26 Jul 2019 07:40:01 -0700 (PDT)
MIME-Version: 1.0
References: <1564144694159130@kroah.com> <20190726124517.GA8301@kroah.com>
In-Reply-To: <20190726124517.GA8301@kroah.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 26 Jul 2019 16:39:48 +0200
Message-ID: <CANn89iKr7vYoLD_o-zhR72rQ8a4OQr=VW6oVRCYBDi1kmN6=dg@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] tcp: be more careful in tcp_fragment()"
 failed to apply to 4.14-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Andrew Prout <aprout@ll.mit.edu>,
        Christoph Paasch <cpaasch@apple.com>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jonathan Looney <jtl@netflix.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 26, 2019 at 2:45 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Jul 26, 2019 at 02:38:14PM +0200, gregkh@linuxfoundation.org wrote:
> >
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> >
> > thanks,
> >
> > greg k-h
> >
> > ------------------ original commit in Linus's tree ------------------
> >
> > >From b617158dc096709d8600c53b6052144d12b89fab Mon Sep 17 00:00:00 2001
> > From: Eric Dumazet <edumazet@google.com>
> > Date: Fri, 19 Jul 2019 11:52:33 -0700
> > Subject: [PATCH] tcp: be more careful in tcp_fragment()
> >
> > Some applications set tiny SO_SNDBUF values and expect
> > TCP to just work. Recent patches to address CVE-2019-11478
> > broke them in case of losses, since retransmits might
> > be prevented.
> >
> > We should allow these flows to make progress.
> >
> > This patch allows the first and last skb in retransmit queue
> > to be split even if memory limits are hit.
> >
> > It also adds the some room due to the fact that tcp_sendmsg()
> > and tcp_sendpage() might overshoot sk_wmem_queued by about one full
> > TSO skb (64KB size). Note this allowance was already present
> > in stable backports for kernels < 4.15
> >
> > Note for < 4.15 backports :
> >  tcp_rtx_queue_tail() will probably look like :
> >
> > static inline struct sk_buff *tcp_rtx_queue_tail(const struct sock *sk)
> > {
> >       struct sk_buff *skb = tcp_send_head(sk);
> >
> >       return skb ? tcp_write_queue_prev(sk, skb) : tcp_write_queue_tail(sk);
> > }
>
>
> Note, I tried the above, but still ran into problems a 4.14 does not
> have tcp_rtx_queue_head() and while I could guess as to what it would be
> (tcp_sent_head()?), I figured it would be safer to ask for a backport :)
>


tcp_rtx_queue_head(sk) would be implemented by :
{
  struct sk_buff *skb = tcp_write_queue_head(sk);
  if (skb == tcp_send_head(sk))
    skb = NULL;
  return skb;
}

I can provide the backport, of course.


> thanks,
>
> greg k-h
