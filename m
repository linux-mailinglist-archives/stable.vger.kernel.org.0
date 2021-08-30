Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C223FBAA3
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 19:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237924AbhH3RJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 13:09:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52947 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231890AbhH3RJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 13:09:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630343330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RJ2p1fjjD8ERbYVIX3Rp+Pa17H7hfIARQi230Atxhhs=;
        b=MR2kCycf8GQK9MlJgIFdPD1/6Mf/kjaXYdzpK3kiKEn4OuOdO++XGM6FZnBsqSIEmUQ9F2
        gu2KxB0OP1/FfMnCnY5f0m+BcrVjPy0gSfOPuq8dGeE9HxHbbD3CrXgRve1NAoLGPMoZQb
        vhMpEejMGaK7EQvuuHuQUesIVjG9cKY=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-tK5H8a7wPsO5RI_j48rc4Q-1; Mon, 30 Aug 2021 13:08:49 -0400
X-MC-Unique: tK5H8a7wPsO5RI_j48rc4Q-1
Received: by mail-qk1-f199.google.com with SMTP id 23-20020a05620a071700b00426392c0e6eso972233qkc.4
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 10:08:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=RJ2p1fjjD8ERbYVIX3Rp+Pa17H7hfIARQi230Atxhhs=;
        b=VFSqVY1VA6OpTK/TacLUPAS+frhqXTCr3EfWd507e2uW39Fya1HOgCCDokn5sHCGT2
         3z/KhPjbu96Zr52ptadoo0LCKTFwirvdtpKrNohsOHyJ0vojjKcAc1ifzCpxWWcuYPCS
         G1Wdamb22XdcvUmkhKL4r0W46Id5kuUcmUoY+gcztaKdvmh8fpZCcEa+/BS9GqkIOROZ
         G1TDzYL9/QPaFJnLvn8n5S5DhogE0+4EY7yoZ1NgAFt1jqkbTHXkc9S5AfjkstoqPxno
         78fAqS/Mz50t7eoFTJDVpb/7nSGuZMzLGIMlNt9szl7Kkm+CuIVaEZoAEi8lw1Gaiatt
         s5Nw==
X-Gm-Message-State: AOAM533+O3S2JyGCoj7V2R/JDHRoKP78ay7cFb0+llOTtpZhF9CPE2Z5
        CmkUce7NGnCGLGyySA8jxdhONlUkouqgRQceN24RWojX4fMxZ+QEVTQAgOvIQpO0JubmrPCUYMG
        AQG6cYvau3x5AQhcc
X-Received: by 2002:a05:620a:81d:: with SMTP id s29mr23761965qks.301.1630343329100;
        Mon, 30 Aug 2021 10:08:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/+cPlJFfzxjZYDasfknZytxGolZm+T7/j6hx198c4EYh9UytMtKYed3Gms4R3lAi7g+R6nQ==
X-Received: by 2002:a05:620a:81d:: with SMTP id s29mr23761951qks.301.1630343328961;
        Mon, 30 Aug 2021 10:08:48 -0700 (PDT)
Received: from [192.168.8.104] (pool-108-49-102-102.bstnma.fios.verizon.net. [108.49.102.102])
        by smtp.gmail.com with ESMTPSA id g7sm8835996qtj.28.2021.08.30.10.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 10:08:48 -0700 (PDT)
Message-ID: <c0e64fb9332b03c920de05be4c4c27f916ff6534.camel@redhat.com>
Subject: Re: [PATCH AUTOSEL 5.13 20/26] drm/nouveau: recognise GA107
From:   Lyude Paul <lyude@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Date:   Mon, 30 Aug 2021 13:08:47 -0400
In-Reply-To: <YSzMR4FnrnT5gjbe@sashalap>
References: <20210824005356.630888-1-sashal@kernel.org>
         <20210824005356.630888-20-sashal@kernel.org>
         <6607dde4207eb7ad1666b131c86f60a57a2a193c.camel@redhat.com>
         <YSzMR4FnrnT5gjbe@sashalap>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ahhh-ok, that makes these patchs make a bit more sense then. If Ben doesn't
have any objections I'd say these are fine to backport then

On Mon, 2021-08-30 at 08:17 -0400, Sasha Levin wrote:
> On Tue, Aug 24, 2021 at 01:08:28PM -0400, Lyude Paul wrote:
> > This is more hardware enablement, I'm not sure this should be going into
> > stable either. Ben?
> 
> We take this sort of hardware enablement patches (where the platform
> code is already there, and we just add quirks/ids/etc.
> 

-- 
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

