Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4702B3FBAA9
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 19:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235853AbhH3RK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 13:10:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26150 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237951AbhH3RKW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 13:10:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630343368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C/p1OSWm2CX6t/EcjGNpZmpBR9OMpxp/jIg4r2klJBs=;
        b=amwbhucI1hY1z6WiV5evLyXN496/PoTStmM94F8Q0pMF5a5vhwaM+d/rhmuYwL6aS79Coy
        AR/iFzvzOaQCaodXGLfDaaCuW5Vr2MrqfHHdjqwnQ34YWOdR7EuY57YGMwOb9qtrKceLRs
        t8v3HAqiEXTSjkmzIfCplruhTQpvSwY=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-Qkc8YCeSP7GfOisdryWtzw-1; Mon, 30 Aug 2021 13:09:26 -0400
X-MC-Unique: Qkc8YCeSP7GfOisdryWtzw-1
Received: by mail-qk1-f197.google.com with SMTP id p23-20020a05620a22f700b003d5ac11ac5cso3703188qki.15
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 10:09:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=C/p1OSWm2CX6t/EcjGNpZmpBR9OMpxp/jIg4r2klJBs=;
        b=Zd0k7WyTW1O6/Y22QRZND1ZaFEJx9ZkKWpJxOp+3UI6kvet37PugnW4DLKLTAC1Kxc
         xlLBUCKQ19Ta5J/AoCRGWncXdXj3+EUvnlTisANwPx+H7JFvOCkXxp1V97Qp+mmnxzf2
         jBTXcsxpMWcKSRsfy2aEuHRRNlN+bzYK29Y2aEEHvzwECgTB/mNylSOVPvZ42RxYs31+
         wihQsHCJWeOxnSBFdD+IADNfQPhYVmG25ps6DyAoPaEFCERVufbicS8xjrLej2JPHln2
         GM7DQXsz6xX0DMr57MAvghPqjrMuq7d2baahhxxa5vDJYa5Th/lrQmKvDbTW4LnY/sYw
         yf5g==
X-Gm-Message-State: AOAM532qJRbYUk3mjebbdjusG+8LYiDfBOvefagpLsDwmyTx0FeEddod
        uOeU6LlrJs6iO/YFpXM1wBxfy6KnYESQp8cDhmvmrNHWgXmT58eCjV84w5gyJOfzdYqe/BEkYGp
        Kgrb9MI/H/pBbC8Gi
X-Received: by 2002:a37:8f04:: with SMTP id r4mr23370422qkd.351.1630343366109;
        Mon, 30 Aug 2021 10:09:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhvH3r1WkYkyhjkLLonaz0tUVij62Is1SewKkxp8wDoeh+XEGYZJb1rr+7K3QO3YKZJeC6uQ==
X-Received: by 2002:a37:8f04:: with SMTP id r4mr23370410qkd.351.1630343365881;
        Mon, 30 Aug 2021 10:09:25 -0700 (PDT)
Received: from [192.168.8.104] (pool-108-49-102-102.bstnma.fios.verizon.net. [108.49.102.102])
        by smtp.gmail.com with ESMTPSA id m68sm12047562qkb.105.2021.08.30.10.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 10:09:25 -0700 (PDT)
Message-ID: <0777c34ddbd22ae247d293cf013cb763947b0b50.camel@redhat.com>
Subject: Re: [PATCH AUTOSEL 5.13 20/26] drm/nouveau: recognise GA107
From:   Lyude Paul <lyude@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Date:   Mon, 30 Aug 2021 13:09:24 -0400
In-Reply-To: <c0e64fb9332b03c920de05be4c4c27f916ff6534.camel@redhat.com>
References: <20210824005356.630888-1-sashal@kernel.org>
         <20210824005356.630888-20-sashal@kernel.org>
         <6607dde4207eb7ad1666b131c86f60a57a2a193c.camel@redhat.com>
         <YSzMR4FnrnT5gjbe@sashalap>
         <c0e64fb9332b03c920de05be4c4c27f916ff6534.camel@redhat.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

oops-except for "drm/nouveau: block a bunch of classes from userspace" of
course. the rest are fine though

On Mon, 2021-08-30 at 13:08 -0400, Lyude Paul wrote:
> ahhh-ok, that makes these patchs make a bit more sense then. If Ben doesn't
> have any objections I'd say these are fine to backport then
> 
> On Mon, 2021-08-30 at 08:17 -0400, Sasha Levin wrote:
> > On Tue, Aug 24, 2021 at 01:08:28PM -0400, Lyude Paul wrote:
> > > This is more hardware enablement, I'm not sure this should be going into
> > > stable either. Ben?
> > 
> > We take this sort of hardware enablement patches (where the platform
> > code is already there, and we just add quirks/ids/etc.
> > 
> 

-- 
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

