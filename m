Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5BC05A404C
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 02:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiH2AQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Aug 2022 20:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiH2AQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Aug 2022 20:16:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B7E2A973
        for <stable@vger.kernel.org>; Sun, 28 Aug 2022 17:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661732193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SzkAkorlo+AmttOHZ6iqjGEde1HkM0doNAcGjEIWZ4o=;
        b=UgpOLiMhLm2QiGP+kik5FokYWZQ1uJ1WpQDfo48pGtywOBFSlIoE9dSHfe5MF7kkMQBTHX
        mD8j5H9RhR3KCERfymdZbohYQHYfd8MsmnsTQVkKzepZL71wJM4zEVLwtiGWSHDf7lt+7L
        2ADqL+jG9ZdD+Oa/6IcqDLgNdfo5xJY=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-634-vqW6ZV5ZMLqg0NS-K6KiKQ-1; Sun, 28 Aug 2022 20:16:31 -0400
X-MC-Unique: vqW6ZV5ZMLqg0NS-K6KiKQ-1
Received: by mail-qv1-f70.google.com with SMTP id d10-20020a0cf6ca000000b00496744bc8e6so4131802qvo.2
        for <stable@vger.kernel.org>; Sun, 28 Aug 2022 17:16:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=SzkAkorlo+AmttOHZ6iqjGEde1HkM0doNAcGjEIWZ4o=;
        b=hpAUAbvGsH1oZuUsiOi0KB7ntNP4HxNRWhy+/3IVJaApAUl5JTQ1x8HLbso7yIeLEx
         /8FW7eGdiQGVAqoWQ7U6SYrQmlmh03E3ZMV4BEa1nslwFQGzxCb9rGAzmBFQN13YvAYo
         NG81mx/7mGCpTwag+lJ7xVFOhJoIrPznoEoQFMdX6X3Ma7KNS/F2+8YhN9LoS5QJnfFu
         R7Yz5hAKlk43X+E0PRN8tOFn1XHC/roQLLyXsRobuiRZCZb27TH/vXHQxfU5NE/g0+kQ
         BS1FMagob4SJP8M4fyd6uhuJOMHRWMJUpSliBOQQcAVWZ9EXuwY/QfackRFyirRwV2Kv
         Tb7A==
X-Gm-Message-State: ACgBeo0DAEgtWcfNpYQzDEnmig1v8/318RH5lf6aGsFs7gEWDS5lNkqY
        HV05qYqnA4u8BLjhTI8pMcruEPlLLH5I04LTQN9zeowjpHRD3tz1k18ZGNgTc1OoFo2q2s6owhH
        qPqbdAlTe+p9MA/wdOT8u8yVkcz1/RZUP
X-Received: by 2002:a05:622a:1302:b0:344:8a9d:817d with SMTP id v2-20020a05622a130200b003448a9d817dmr8364106qtk.339.1661732191495;
        Sun, 28 Aug 2022 17:16:31 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6YH2nJIo0b6SviiSUMGBKXXeJaHL95jdsa0u6iUg5nlt6EWo3hqWiTPzDu5EZVS+GBLuTCvNVZOaiGzM0z1Ys=
X-Received: by 2002:a05:622a:1302:b0:344:8a9d:817d with SMTP id
 v2-20020a05622a130200b003448a9d817dmr8364092qtk.339.1661732191317; Sun, 28
 Aug 2022 17:16:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220826142954.254853-1-miquel.raynal@bootlin.com>
In-Reply-To: <20220826142954.254853-1-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 28 Aug 2022 20:16:20 -0400
Message-ID: <CAK-6q+imPjpBxSZG7e5nxYYgtkrM5pfncxza9=vA+sq+eFQsUw@mail.gmail.com>
Subject: Re: [PATCH] net: mac802154: Fix a condition in the receive path
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, Aug 26, 2022 at 10:31 AM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
> Upon reception, a packet must be categorized, either it's destination is
> the host, or it is another host. A packet with no destination addressing
> fields may be valid in two situations:
> - the packet has no source field: only ACKs are built like that, we
>   consider the host as the destination.
> - the packet has a valid source field: it is directed to the PAN
>   coordinator, as for know we don't have this information we consider we
>   are not the PAN coordinator.
>
> There was likely a copy/paste error made during a previous cleanup
> because the if clause is now containing exactly the same condition as in
> the switch case, which can never be true. In the past the destination
> address was used in the switch and the source address was used in the
> if, which matches what the spec says.
>
> Cc: stable@vger.kernel.org
> Fixes: ae531b9475f6 ("ieee802154: use ieee802154_addr instead of *_sa variants")
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  net/mac802154/rx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> index b8ce84618a55..c439125ef2b9 100644
> --- a/net/mac802154/rx.c
> +++ b/net/mac802154/rx.c
> @@ -44,7 +44,7 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
>
>         switch (mac_cb(skb)->dest.mode) {
>         case IEEE802154_ADDR_NONE:
> -               if (mac_cb(skb)->dest.mode != IEEE802154_ADDR_NONE)
> +               if (hdr->source.mode != IEEE802154_ADDR_NONE)
>                         /* FIXME: check if we are PAN coordinator */
>                         skb->pkt_type = PACKET_OTHERHOST;
>                 else


This patch looks okay but it should not be addressed to stable. Leave
of course the fixes tag.

Wpan sends pull requests to net and they have their own way to get
into the stable tree when they are in net.

Thanks.

- Alex

