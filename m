Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC62261B92
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 10:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbfGHIIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 04:08:02 -0400
Received: from mail-vk1-f194.google.com ([209.85.221.194]:46746 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727286AbfGHIIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 04:08:01 -0400
Received: by mail-vk1-f194.google.com with SMTP id b64so2292353vke.13
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 01:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZOR8clYW+rncXTX2zDaB/JyvqUChf4gA7xNaU/YBSOg=;
        b=HjwQkZGofNQdyJdhdsVJlTLKDMPO0orD/dj2rtP84s0BLxKprbw2Q0dPlIchoaQk1Q
         G58ky89Ofz0eHD4HVvHRwHNfU9isBY0fIdt3WYIJC3EbFjKwqFFqBa7gqM5w4PUQpZ61
         oPcCg1OYdgDCOhMgzIBHKZxAgWyNtsYps3kRElLlJb/aUAEV2h1RuR8baolPBQ8XUv7+
         IZlQ7xdB401Vlqa39KXXlpK63Sa21h5vdTbM8X4/Td9P3eC3oGy/cnHM59B0rP5KX8my
         CjR7J0rOwlm2GG2eurjO6bedWoMrLyvIEr3Jxm1dBPknhkUI9blYTV10DefQZajdhoA8
         s+Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZOR8clYW+rncXTX2zDaB/JyvqUChf4gA7xNaU/YBSOg=;
        b=R72g01fn/SZMya50vlj1bXyFxCASoeiCwdwyyZt/VXx6sNnOXMaQSNJlMdw+9LCkS2
         ZO7mduuczicT9RJuPhNNf5pIGd0S95KhcRt9D9G80CxXcQNYBsxxPFJGYy5VUdHakdCk
         MSF688H9LvYGfhRDZHWBx/w3CVMmmlTfRfWbRdhBsWIDehoxi6G1L5nGtME1TJRkifif
         AdKd66jfh/t7YkRUVAIWxZY/Pl71qyW8rmRnhGIIjRTS8oqvBilEfcjmF8LuVz1WZGx6
         pkwOaSAaFq+CKQKqMXOnrVxNOrxEL5jfZrj8zfI8az2FdPS+3onryhc3h0C/w3HfMQA8
         Ef/w==
X-Gm-Message-State: APjAAAWONL3VE2creXp7my5ZSldJau32orCcHWVtIeD+XMSTjOnf2DLd
        nCUb/kIPV85xpuK5ehOQ0cn/QOSns1E76yz+k/CwRA==
X-Google-Smtp-Source: APXvYqxvi+ZGKZk70HDy/wcOVHFF+mkZN0c9aifSzp8ZeR05ajx0gubx1sPnRzwxwHIKL4hXvHNHgKeeEsePgZx9XtI=
X-Received: by 2002:a1f:acc5:: with SMTP id v188mr4725232vke.16.1562573279892;
 Mon, 08 Jul 2019 01:07:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190708063252.4756-1-jian-hong@endlessm.com> <F7CD281DE3E379468C6D07993EA72F84D1861A6D@RTITMBSVM04.realtek.com.tw>
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D1861A6D@RTITMBSVM04.realtek.com.tw>
From:   Jian-Hong Pan <jian-hong@endlessm.com>
Date:   Mon, 8 Jul 2019 16:07:23 +0800
Message-ID: <CAPpJ_eebQtL0y_j98J2T7m9g77A61SVtvD8qnNN42bV0dm4MLA@mail.gmail.com>
Subject: Re: [PATCH] rtw88/pci: Rearrange the memory usage for skb in RX ISR
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@endlessm.com" <linux@endlessm.com>,
        Daniel Drake <drake@endlessm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tony Chuang <yhchuang@realtek.com> =E6=96=BC 2019=E5=B9=B47=E6=9C=888=E6=97=
=A5 =E9=80=B1=E4=B8=80 =E4=B8=8B=E5=8D=883:23=E5=AF=AB=E9=81=93=EF=BC=9A
>
> > Subject: [PATCH] rtw88/pci: Rearrange the memory usage for skb in RX IS=
R
>
> nit, "rtw88: pci:" would be better.

Ok.

> >
> > When skb allocation fails and the "rx routine starvation" is hit, the
> > function returns immediately without updating the RX ring. At this
> > point, the RX ring may continue referencing an old skb which was alread=
y
> > handed off to ieee80211_rx_irqsafe(). When it comes to be used again,
> > bad things happen.
> >
> > This patch allocates a new skb first in RX ISR. If we don't have memory
> > available, we discard the current frame, allowing the existing skb to b=
e
> > reused in the ring. Otherwise, we simplify the code flow and just hand
> > over the RX-populated skb over to mac80211.
> >
> > In addition, to fixing the kernel crash, the RX routine should now
> > generally behave better under low memory conditions.
> >
> > Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=3D204053
> > Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> > Reviewed-by: Daniel Drake <drake@endlessm.com>
> > Cc: <stable@vger.kernel.org>
> > ---
> >  drivers/net/wireless/realtek/rtw88/pci.c | 28 +++++++++++-------------
> >  1 file changed, 13 insertions(+), 15 deletions(-)
> >
> > diff --git a/drivers/net/wireless/realtek/rtw88/pci.c
> > b/drivers/net/wireless/realtek/rtw88/pci.c
> > index cfe05ba7280d..1bfc99ae6b84 100644
> > --- a/drivers/net/wireless/realtek/rtw88/pci.c
> > +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> > @@ -786,6 +786,15 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev,
> > struct rtw_pci *rtwpci,
> >               rx_desc =3D skb->data;
> >               chip->ops->query_rx_desc(rtwdev, rx_desc, &pkt_stat, &rx_=
status);
> >
> > +             /* discard current skb if the new skb cannot be allocated=
 as a
> > +              * new one in rx ring later
> > +              * */
>
> nit, comment indentation.

Thanks.  I will fix this.

> > +             new =3D dev_alloc_skb(RTK_PCI_RX_BUF_SIZE);
> > +             if (WARN(!new, "rx routine starvation\n")) {
> > +                     new =3D skb;
> > +                     goto next_rp;
> > +             }
> > +
> >               /* offset from rx_desc to payload */
> >               pkt_offset =3D pkt_desc_sz + pkt_stat.drv_info_sz +
> >                            pkt_stat.shift;
> > @@ -803,25 +812,14 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev=
,
> > struct rtw_pci *rtwpci,
> >                       skb_put(skb, pkt_stat.pkt_len);
> >                       skb_reserve(skb, pkt_offset);
> >
> > -                     /* alloc a smaller skb to mac80211 */
> > -                     new =3D dev_alloc_skb(pkt_stat.pkt_len);
> > -                     if (!new) {
> > -                             new =3D skb;
> > -                     } else {
> > -                             skb_put_data(new, skb->data, skb->len);
> > -                             dev_kfree_skb_any(skb);
> > -                     }
>
> I am not sure if it's fine to deliver every huge SKB to mac80211.
> Because it will then be delivered to TCP/IP stack.
> Hence I think either it should be tested to know if the performance
> would be impacted or find out a more efficient way to send
> smaller SKB to mac80211 stack.

I remember network stack only processes the skb with(in) pointers
(skb->data) and the skb->len for data part.  It also checks real
buffer boundary (head and end) of the skb to prevent memory overflow.
Therefore, I think using the original skb is the most efficient way.

If I misunderstand something, please point out.



> >                       /* TODO: merge into rx.c */
> >                       rtw_rx_stats(rtwdev, pkt_stat.vif, skb);
> > -                     memcpy(new->cb, &rx_status, sizeof(rx_status));
> > -                     ieee80211_rx_irqsafe(rtwdev->hw, new);
> > +                     memcpy(skb->cb, &rx_status, sizeof(rx_status));
> > +                     ieee80211_rx_irqsafe(rtwdev->hw, skb);
> >               }
> >
> > -             /* skb delivered to mac80211, alloc a new one in rx ring =
*/
> > -             new =3D dev_alloc_skb(RTK_PCI_RX_BUF_SIZE);
> > -             if (WARN(!new, "rx routine starvation\n"))
> > -                     return;
> > -
> > +next_rp:
> > +             /* skb delivered to mac80211, attach the new one into rx =
ring */
> >               ring->buf[cur_rp] =3D new;
> >               rtw_pci_reset_rx_desc(rtwdev, new, ring, cur_rp, buf_desc=
_sz);
> >
>
> --
>
> Yan-Hsuan
