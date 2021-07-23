Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54893D3863
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 12:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhGWJcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 05:32:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47615 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231602AbhGWJcK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 05:32:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627035162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o3LHYIwGpCkKsSkV53n4TZ0vps5VvYe3NdwkzicqRUQ=;
        b=cnIWmb3ifDcxtcxklgu2eUmJhX3QOZYzsFEbMKtUuB+SswKFWnZHnkO5hPFOMMgWIZJCpm
        MwDZjmwkItVAyceIG1kxKRAzCVBHpGPerZAexPzTfSIkPi1Km9bOJAFp/L9wWFsfyY1pH5
        jVfutYOibAKm5Rh/daKclZ2F3a9CAck=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-qYiNNfG8MVmSP3V6uw8KEQ-1; Fri, 23 Jul 2021 06:12:41 -0400
X-MC-Unique: qYiNNfG8MVmSP3V6uw8KEQ-1
Received: by mail-io1-f72.google.com with SMTP id q137-20020a6b8e8f0000b02904bd1794d00eso1350919iod.7
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 03:12:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=o3LHYIwGpCkKsSkV53n4TZ0vps5VvYe3NdwkzicqRUQ=;
        b=uLL1RL15jCbxk3AxkD2TQnd++nBqCR2lfzvj7+Fxa8fmJFucyPkPMtuyxZRl4Xl/5A
         /3dLlO3DMFGR4CRda0OjrKrfSLbvdYk2jTH5gjPybAJQa/mxjYP+X+8sWE31fs7FeV83
         42/2+3yf4BkXOvaV/R/QcAspaTGVbVNfKaOf6daT9lZziTvAmdpHVU/TIip7+m84e5Pm
         FWU0ZQxkQ4oIvvvPm0wPe8sbJKCNrHOeF2FdpllhbyZCQbNB/7GmkVAyBLQfSlVh+8NR
         e0p4C4O0+QagrIl59N+Ds40Gmy/4iDcxyxcZg6ClLbxGKYdVW54tAoWD2Qf59h/GBThP
         aA5w==
X-Gm-Message-State: AOAM531/toOg0N0xRqj31ksQRt52FWoa+4IsDAqlEBvXbvRx0Tvh1AVT
        m5rbbiq/dxY+6VmB5uAgrkGEmatxL6GR4yejCEUGA1KEBzSew0CXi3Hz392D8Wji5Ml5mLPAA37
        k1CkElQrfwYILSyZDTBpWMKE7ljiPFORy
X-Received: by 2002:a05:6602:24d8:: with SMTP id h24mr3412208ioe.27.1627035160996;
        Fri, 23 Jul 2021 03:12:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqQKCSuAaJ76C0PJ046BjMgnp46FjUZbNbjxDzuYta92PdgNG6foRxytxTNIdxphLKV1SDWWCGdp1hySJbTEg=
X-Received: by 2002:a05:6602:24d8:: with SMTP id h24mr3412199ioe.27.1627035160822;
 Fri, 23 Jul 2021 03:12:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210723035721.531372-1-sashal@kernel.org> <20210723035721.531372-9-sashal@kernel.org>
In-Reply-To: <20210723035721.531372-9-sashal@kernel.org>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Fri, 23 Jul 2021 12:12:30 +0200
Message-ID: <CACT4oucVa5Lw538M2TEc1ZNU4mUZms+9fiTxw-p5-7J7xcM+kQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.13 09/19] sfc: ensure correct number of XDP queues
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, Jul 23, 2021 at 5:57 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: =C3=8D=C3=B1igo Huguet <ihuguet@redhat.com>
>
> [ Upstream commit 788bc000d4c2f25232db19ab3a0add0ba4e27671 ]

Applying this commit alone could be problematic, leading even to
kernel crash in certain situations.

The real fix is the previous one of the series:
f43a24f446da sfc: fix lack of XDP TX queues - error XDP TX failed (-22)

This one can be applied too, but not really a must-have.

> Commit 99ba0ea616aa ("sfc: adjust efx->xdp_tx_queue_count with the real
> number of initialized queues") intended to fix a problem caused by a
> round up when calculating the number of XDP channels and queues.
> However, this was not the real problem. The real problem was that the
> number of XDP TX queues had been reduced to half in
> commit e26ca4b53582 ("sfc: reduce the number of requested xdp ev queues")=
,
> but the variable xdp_tx_queue_count had remained the same.
>
> Once the correct number of XDP TX queues is created again in the
> previous patch of this series, this also can be reverted since the error
> doesn't actually exist.
>
> Only in the case that there is a bug in the code we can have different
> values in xdp_queue_number and efx->xdp_tx_queue_count. Because of this,
> and per Edward Cree's suggestion, I add instead a WARN_ON to catch if it
> happens again in the future.
>
> Note that the number of allocated queues can be higher than the number
> of used ones due to the round up, as explained in the existing comment
> in the code. That's why we also have to stop increasing xdp_queue_number
> beyond efx->xdp_tx_queue_count.
>
> Signed-off-by: =C3=8D=C3=B1igo Huguet <ihuguet@redhat.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/ethernet/sfc/efx_channels.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethern=
et/sfc/efx_channels.c
> index a3ca406a3561..bea0b27baf4b 100644
> --- a/drivers/net/ethernet/sfc/efx_channels.c
> +++ b/drivers/net/ethernet/sfc/efx_channels.c
> @@ -891,18 +891,20 @@ int efx_set_channels(struct efx_nic *efx)
>                         if (efx_channel_is_xdp_tx(channel)) {
>                                 efx_for_each_channel_tx_queue(tx_queue, c=
hannel) {
>                                         tx_queue->queue =3D next_queue++;
> -                                       netif_dbg(efx, drv, efx->net_dev,=
 "Channel %u TXQ %u is XDP %u, HW %u\n",
> -                                                 channel->channel, tx_qu=
eue->label,
> -                                                 xdp_queue_number, tx_qu=
eue->queue);
> +
>                                         /* We may have a few left-over XD=
P TX
>                                          * queues owing to xdp_tx_queue_c=
ount
>                                          * not dividing evenly by EFX_MAX=
_TXQ_PER_CHANNEL.
>                                          * We still allocate and probe th=
ose
>                                          * TXQs, but never use them.
>                                          */
> -                                       if (xdp_queue_number < efx->xdp_t=
x_queue_count)
> +                                       if (xdp_queue_number < efx->xdp_t=
x_queue_count) {
> +                                               netif_dbg(efx, drv, efx->=
net_dev, "Channel %u TXQ %u is XDP %u, HW %u\n",
> +                                                         channel->channe=
l, tx_queue->label,
> +                                                         xdp_queue_numbe=
r, tx_queue->queue);
>                                                 efx->xdp_tx_queues[xdp_qu=
eue_number] =3D tx_queue;
> -                                       xdp_queue_number++;
> +                                               xdp_queue_number++;
> +                                       }
>                                 }
>                         } else {
>                                 efx_for_each_channel_tx_queue(tx_queue, c=
hannel) {
> @@ -914,8 +916,7 @@ int efx_set_channels(struct efx_nic *efx)
>                         }
>                 }
>         }
> -       if (xdp_queue_number)
> -               efx->xdp_tx_queue_count =3D xdp_queue_number;
> +       WARN_ON(xdp_queue_number !=3D efx->xdp_tx_queue_count);
>
>         rc =3D netif_set_real_num_tx_queues(efx->net_dev, efx->n_tx_chann=
els);
>         if (rc)
> --
> 2.30.2
>

--=20
=C3=8D=C3=B1igo Huguet

