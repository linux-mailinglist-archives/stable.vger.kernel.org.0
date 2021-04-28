Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830DA36D303
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 09:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbhD1HWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 03:22:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48065 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229643AbhD1HWy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Apr 2021 03:22:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619594530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uyUv8KCIqiWEn/ycVVSuXUXWBjwtvxSoWo1VwEkGZHI=;
        b=UO8hxD8nDepeA+JOr9VaCAFxBx08V6Wfzc0WBOtmeJ6l6P+U6eYtVIPAwg5ELhrUI1VSig
        R/u77XHjdFjcYAPUKF2xActxtURJay6hSy+XFhZds3yL5cZy/YNYwF9Q2BfRgc3h8upCqT
        89H2mkYMDwwt1WRKfKaqPnj12i9xVlk=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-lJuimdWDMOifDf_mwV7EcQ-1; Wed, 28 Apr 2021 03:22:08 -0400
X-MC-Unique: lJuimdWDMOifDf_mwV7EcQ-1
Received: by mail-io1-f69.google.com with SMTP id k20-20020a5d97d40000b02903e994fab1f1so30789391ios.17
        for <stable@vger.kernel.org>; Wed, 28 Apr 2021 00:22:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uyUv8KCIqiWEn/ycVVSuXUXWBjwtvxSoWo1VwEkGZHI=;
        b=B49/tKdDOvkWBmpbI+7faICXQi/Urus8jj8JltB/55zuIVhcjTHXdzLRvny/Y5GlKj
         Ooqab0Xbsj4vy9ZAyqAxLBrwDxsCDu2Rjvnq4PiBQ8qC1aQ7uU/2foCcQws7js8D96pS
         Sr8nNcWBPYdZy7bqZ+2kJjKQkqi+F/+BYyeAO9af4bwn7CYCBL6IFKm37DT9CBdxKeZD
         eK4EswNRkkpLvURhTRVVeRGSC+bcEEthVdk8y4MnMaR/7Eg1ju1hGZbCD5DU75ZOJ7Gd
         vBuW/XvfcMDAniMXQmc0F4LLcaIFy6udRLvGC9xCRg0ktYB2VvFxduV2rKg8E6QReh23
         wVuw==
X-Gm-Message-State: AOAM530zbO9xCa1dgQA3X5fF1WGHnDhGXGpQ7sTCarePDOCBq79nCWYq
        c9xU7WjFiRa0CpVZJGAocyb2iyfFrNgPMbY7SiUu8iSAbWOPiVbMvHvv6l3JdV9c+z5R7EYdgkn
        Hn39BvQo1y6NPG4n5JTCELM12dIlVArc0
X-Received: by 2002:a92:da0f:: with SMTP id z15mr20448582ilm.226.1619594527683;
        Wed, 28 Apr 2021 00:22:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVECfNsqiX08l45sda2tYySi7bJlF6Ina+TOKm1xfR4BzNcwcJW3kuFUcefD/gtxLDDj1BXNaVcnAkPGW7iUo=
X-Received: by 2002:a92:da0f:: with SMTP id z15mr20448562ilm.226.1619594527441;
 Wed, 28 Apr 2021 00:22:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210427085246.13728-1-mwilck@suse.com> <0ff2dbc0-0182-f54d-b750-084feac53601@suse.de>
 <20210427162521.GA26528@lst.de> <f82b7f7c-ef12-27bb-1349-d23ea22e50a9@suse.de>
 <3a0b10f45ac75df3f744dd04ac874021488f42b1.camel@suse.com> <CAFL455=m_4tLZwbh1qRGPgE8ufBfKuq84zKkZmCntX56A17kog@mail.gmail.com>
 <e11706e498a583b764ff9e9b1b7de409f996ad07.camel@suse.com>
In-Reply-To: <e11706e498a583b764ff9e9b1b7de409f996ad07.camel@suse.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Wed, 28 Apr 2021 09:21:56 +0200
Message-ID: <CAFL455=fqaaymf8PrmT4W_qkvcH0roymwFeE2g-ihAg4tcrKCw@mail.gmail.com>
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

st 28. 4. 2021 v 9:06 odes=C3=ADlatel Martin Wilck <mwilck@suse.com> napsal=
:
>
> Yes, that's what I think has happened. timer_setup() doesn't clear any
> pointers in the list of pending timers pointing to this entry. If the
> newly-initialized timer is then added with mod_timer(), it becomes
> linked in a second timer list. When the first one expires, the timer
> will be detached, but only from one of the lists it's pending in. In a
> scenario like the one we faced, this could actually happen multiple
> times. If the detached timer remains linked into a timer list, once
> that list is traversed, the kernel dereferences a pointer with value
> LIST_POISON2, and crashes.

Yes I think it makes sense.
timer_setup() modifies the timer's base in the "flags" field, then mod_time=
r()
could add the timer to the wrong base structure.

Maurizio

