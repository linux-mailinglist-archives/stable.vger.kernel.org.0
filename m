Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02A21EEA62
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 20:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgFDSjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 14:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgFDSjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jun 2020 14:39:12 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CD5C08C5C0;
        Thu,  4 Jun 2020 11:39:12 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id c1so4115958vsc.11;
        Thu, 04 Jun 2020 11:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5q6R61skmaUmxxBq8d7U2mAvRURoQSI07JE0eiuucbQ=;
        b=QNyM+gbpSige5VstWz/Omh6CLX8lhz7YNAX3V28I+BhGnTApz4VGceVp1Xe2D6xvOI
         2ndwVZyrV0jxu9GlI8T3qYsumNXCFTPTlSYvHQO7hiUt3t4w+5XEbDC9TrFvh1d0U7D+
         vHlCFw0iHsKbuqofDI4FVzuwvSidSEcvqwB4HAg5u1fB01RcTbMRfMBHCYbcC6pRLdIr
         qCNYinXCUQE/mckvOCrEIGEG1WNlixCtdMwFUSSwzPowETekhb7ISp6KD5Gio7wNRwZd
         UdN/IsTGINM83DnnjHAgU0H1evU0j+tkIj3PlJ/kyMyTrSKogc0MYrWGc2E02mtk2d/6
         VGpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5q6R61skmaUmxxBq8d7U2mAvRURoQSI07JE0eiuucbQ=;
        b=HQN9dlyhwmmSLfSi3V62DZkpMop9M4Ke9St5XSc9WJWw/HMVPgLB7S0opU8NvSWyq8
         eZ68sGDrL+3nQlqnIt3q/uqUDGxcUCxZL5wEuiHqrFxQ30G9kjXqj/7E6474gM37l790
         9Y+cGdeN4DF6PdtRCOOG6VnuLXv3IWHdVMjucOBvnQoQ8qYy62syXKXWXstrlCo0ea3E
         z4CotvJzFsjWJkMMu3UiHuBuGOuPvJ33plJYoZgc2C5bgF699TkY/rMtZJZPHZfnaF6x
         9TUU0thRhs1R4aFuHLBbnGZScnAwmVfRL/87cN5lBM5WG/GRP3pG5pC3CV785UsQBe1S
         o73w==
X-Gm-Message-State: AOAM531oMhtjyvqhgH4pz4kn8XQFkTWm6OlhzFzisqnnTHpcPx1LM8YZ
        6QZlxrogK/M9XDjdxxlKDIjOkFYDcHhHlnnVFIw=
X-Google-Smtp-Source: ABdhPJzJ/ojMJg2wlACU8XWNC4Gqfm/IMG3F7SitSKAxuXoe0yvbCNhzUBOi7JJmfWff5fp2tTL/8OXMUm9Gzn59Pbk=
X-Received: by 2002:a05:6102:3ce:: with SMTP id n14mr4674472vsq.113.1591295951292;
 Thu, 04 Jun 2020 11:39:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200518173450.097837707@linuxfoundation.org> <20200518173452.813559136@linuxfoundation.org>
In-Reply-To: <20200518173452.813559136@linuxfoundation.org>
From:   =?UTF-8?Q?David_Bala=C5=BEic?= <xerces9@gmail.com>
Date:   Thu, 4 Jun 2020 20:39:00 +0200
Message-ID: <CAPJ9Yc8YOeqeO4mo80iVMf3ay+CkdMvYzJY1BqXMNPcKzL6_zg@mail.gmail.com>
Subject: Re: [PATCH 4.19 12/80] pppoe: only process PADT targeted at local interfaces
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

Is there a good reason this did not land in 4.14 branch?

Openwrt is using that and so it missed this patch.

Any chance it goes in in next round?

Regards,
David

On Mon, 18 May 2020 at 19:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Guillaume Nault <gnault@redhat.com>
>
> [ Upstream commit b8c158395119be62294da73646a3953c29ac974b ]
>
> We don't want to disconnect a session because of a stray PADT arriving
> while the interface is in promiscuous mode.
> Furthermore, multicast and broadcast packets make no sense here, so
> only PACKET_HOST is accepted.
>
> Reported-by: David Bala=C5=BEic <xerces9@gmail.com>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/net/ppp/pppoe.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> --- a/drivers/net/ppp/pppoe.c
> +++ b/drivers/net/ppp/pppoe.c
> @@ -497,6 +497,9 @@ static int pppoe_disc_rcv(struct sk_buff
>         if (!skb)
>                 goto out;
>
> +       if (skb->pkt_type !=3D PACKET_HOST)
> +               goto abort;
> +
>         if (!pskb_may_pull(skb, sizeof(struct pppoe_hdr)))
>                 goto abort;
>
>
>
