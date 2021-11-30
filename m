Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F7F463AD8
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 17:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243008AbhK3QEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 11:04:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23148 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230185AbhK3QEO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 11:04:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638288054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3xvWJ05rDVJlEI37bM9I9CFoclSIgoKtEqO80qhVKPA=;
        b=Ht9QyWFrweTwmKx/jv+Woxmjr4Jb2ru9nXCVemBv6RJHcM88cGGlfk3oNsgcIQrIwH735t
        mfN1NgDeLY+vPO+h40R68KO2299zBoDz4Ym1hFU6s6c9thO3ah1xCB45KhPt5T8F2hiYqm
        QOR2PllD4Gh7XzRfrHbZnTLnMVKOVeQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-117-MklDrfuCNkCOqThY7ooAMw-1; Tue, 30 Nov 2021 11:00:50 -0500
X-MC-Unique: MklDrfuCNkCOqThY7ooAMw-1
Received: by mail-ed1-f71.google.com with SMTP id 30-20020a508e5e000000b003f02e458b17so10612203edx.17
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 08:00:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=3xvWJ05rDVJlEI37bM9I9CFoclSIgoKtEqO80qhVKPA=;
        b=KcqtLVIOCjeUmYEAsHPCJI6aYX4n+DGXP999Qva2AoRoczHBGaQVQ1B1u6iywd0maj
         E6Vd/dXJdRlAgt7BZ7clWP9p/Gd2uRSc/eNpBk2Ns6KZnFXco2nziwRzqniCOo1P9Ifs
         nUdxgirpGDKuYxdbRZwunSc+8xvasHX/mcwtQK8NbObJRrKuB9V91sUIMEdkb5Xo4EiG
         HcqeRjKJq5MpzKNrCyFUM6lWPpyqKzI4xe1lyXm8UVLdKtH8S3yXlutFcTXX7AzL3uul
         8VXsLus1cCnP2quf5M08rQz+TXZo6imJBueTTRRJBDaX7FzQzSFeh9gtzUzeFULs4YIY
         YNMw==
X-Gm-Message-State: AOAM530r9ECV21mlZ/qoLYIiykCXo0Vx/hiuJOg5KzvYAeYo2ccN65T6
        oSIXQR9cVKfgl/nZ3RCARAiEzoiD4rRdV7X1rfqsCv+jXXxWypW9Yd8iEZ/HPKfGcaIH8cZbPc6
        hLe2pI+R0A7HQCQ8I
X-Received: by 2002:a17:907:d17:: with SMTP id gn23mr67412054ejc.25.1638288048317;
        Tue, 30 Nov 2021 08:00:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwCQoQaHvKD5TqMaO0KA+5raYgBz0M/C7dgcKuQ1dX7Frr5ECe9FkilwSFgvBdLGBlZzoFiOA==
X-Received: by 2002:a17:907:d17:: with SMTP id gn23mr67411996ejc.25.1638288047977;
        Tue, 30 Nov 2021 08:00:47 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id go10sm9506400ejc.115.2021.11.30.08.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 08:00:46 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 001D01802A0; Tue, 30 Nov 2021 17:00:45 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org,
        davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Hangbin Liu <liuhangbin@gmail.com>, Xiumei Mu <xmu@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH net 06/10] wireguard: device: reset peer src endpoint
 when netns exits
In-Reply-To: <20211129153929.3457-7-Jason@zx2c4.com>
References: <20211129153929.3457-1-Jason@zx2c4.com>
 <20211129153929.3457-7-Jason@zx2c4.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 30 Nov 2021 17:00:45 +0100
Message-ID: <874k7t8wgi.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> Each peer's endpoint contains a dst_cache entry that takes a reference
> to another netdev. When the containing namespace exits, we take down the
> socket and prevent future sockets from being created (by setting
> creating_net to NULL), which removes that potential reference on the
> netns. However, it doesn't release references to the netns that a netdev
> cached in dst_cache might be taking, so the netns still might fail to
> exit. Since the socket is gimped anyway, we can simply clear all the
> dst_caches (by way of clearing the endpoint src), which will release all
> references.
>
> However, the current dst_cache_reset function only releases those
> references lazily. But it turns out that all of our usages of
> wg_socket_clear_peer_endpoint_src are called from contexts that are not
> exactly high-speed or bottle-necked. For example, when there's
> connection difficulty, or when userspace is reconfiguring the interface.
> And in particular for this patch, when the netns is exiting. So for
> those cases, it makes more sense to call dst_release immediately. For
> that, we add a small helper function to dst_cache.
>
> This patch also adds a test to netns.sh from Hangbin Liu to ensure this
> doesn't regress.
>
> Test-by: Hangbin Liu <liuhangbin@gmail.com>
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Cc: Hangbin Liu <liuhangbin@gmail.com>
> Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Fixes: 900575aa33a3 ("wireguard: device: avoid circular netns references")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

