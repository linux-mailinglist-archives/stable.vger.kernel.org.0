Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7293D387F
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 12:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhGWJiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 05:38:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46563 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230135AbhGWJiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 05:38:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627035526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wAtWjoPMs7b2mfoHjDz+Kbot8us4IZ8w5i6dg1usQ+I=;
        b=bRJ+rGYhu10F5VCA6QcsxBUElfmLVTKn46kyz5D3OU5/DrCbWhAErknma4SM+bBSmzVr2J
        FaW/6R/v04r3Tv2qe1+BnHYUqOCrAiWCfTi8E5TN60V61bQrcYqhGuDe5vuCsVcp90gTfO
        MN8LgHXkQ+pp6KkVK19/zz00AW5dGsQ=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-OkjZHxGWNJeL62R_S_9Vww-1; Fri, 23 Jul 2021 06:18:44 -0400
X-MC-Unique: OkjZHxGWNJeL62R_S_9Vww-1
Received: by mail-io1-f72.google.com with SMTP id w3-20020a0566020343b02905393057ad92so1278564iou.20
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 03:18:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wAtWjoPMs7b2mfoHjDz+Kbot8us4IZ8w5i6dg1usQ+I=;
        b=ESQgkuIX0Nr1H2mTuHNV62Da1Fn79beJk5dDod39mnBWh69V0VvXfv1r7UKm/oLQyG
         8nb6zfjPCpLU8QtP3BLEYv5x8PXk5mXaPV3FQ++x548gZZii7ctSIBtZR2T0o5KLFmys
         AdKh8molf9SCr1E7TnGoBNN3ZUyDANbF65J08FhsRrDosM3XI52phaD8WW3q0AuwqFkt
         e5eQSCcArOQ8q0BxMEP3iDoHSuLYOhFh5dXo93WqwW8wR2uird+Ah/VPay0Da9hLl8gf
         7/mXPivyo8UIdeR7mKqD8/MWDH3PYzIlY6qIBGF9OxiSa2GfK3UxMdFt783PLEizCa8A
         LveA==
X-Gm-Message-State: AOAM5337qA6+SNDPJBpZs8oDkzvHS1rQ2rnepHexDdVBTwTnXuDHndg8
        l+VoAmIxJOlJO9I6XNhtAjS6IsaIe/e9RNG8iZlEaIRfjK93OfyXMvz14c1WLDNDfJvc9ug1ob5
        GT4SzkLfRs2jVmP4JA+JZ9OI1e1GNq4bv
X-Received: by 2002:a92:8747:: with SMTP id d7mr3114543ilm.173.1627035524405;
        Fri, 23 Jul 2021 03:18:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnLBvtdojuHWZ+mNPTTTHfo9sbPOXAPakPJPZrby6KidLaTImlo80uTrFXXtrK0loo+mBtHtFm2LaSGMOgU7E=
X-Received: by 2002:a92:8747:: with SMTP id d7mr3114532ilm.173.1627035524289;
 Fri, 23 Jul 2021 03:18:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210723035721.531372-1-sashal@kernel.org> <20210723035721.531372-9-sashal@kernel.org>
 <CACT4oucVa5Lw538M2TEc1ZNU4mUZms+9fiTxw-p5-7J7xcM+kQ@mail.gmail.com>
In-Reply-To: <CACT4oucVa5Lw538M2TEc1ZNU4mUZms+9fiTxw-p5-7J7xcM+kQ@mail.gmail.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Fri, 23 Jul 2021 12:18:33 +0200
Message-ID: <CACT4oudPRf=RjqxncVrWGpMNfYTUhHOEbydtTq1O-R70P47guA@mail.gmail.com>
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

On Fri, Jul 23, 2021 at 12:12 PM =C3=8D=C3=B1igo Huguet <ihuguet@redhat.com=
> wrote:
> This one can be applied too, but not really a must-have.

Sorry, I have to correct myself. Both must be applied:
58e3bb77bf1b sfc: ensure correct number of XDP queues
f43a24f446da sfc: fix lack of XDP TX queues - error XDP TX failed (-22)

Otherwise, if there are some left-over TXQs because of round up,
xdp_tx_queue_count coud be set to a wrong value, higher than it should
be.

Regards
--=20
=C3=8D=C3=B1igo Huguet

