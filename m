Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33453B0CDC
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 20:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhFVSaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 14:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbhFVSaM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 14:30:12 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6AAC061574
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 11:27:55 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id n12so9058779pgs.13
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 11:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=4WhtpOpZmdt3UEqX4nITheGaQTNBco04bK3sUmh5mfc=;
        b=Yywq+yR5SY/2jR8I3Dz9BRS5tH+2zhB/Z02yKAqQNFrZXpk+oX61MOeXvQNLdd1Sal
         pMgCYo6Xp1FgJbjpQq+edNQymu5JpG+dl97j8OesQ6M5XhqvF6/Pw1gzdmuaYqmq2ruu
         CrHfAeXUnPME59k/iza4IWinhQuOxZpAUtdtd5jjkUNeB7f3QENYhVOTDaRf/k8C0mEl
         7ieKG3EQz/HI4a4jY9P4zLm6nTKiBqoGENnAu3UG0Nzw50DuYIyUbIfbzd9pZOqHaIHP
         a41KTUilaCIETFBQmbNQP7Hsnz9M9YaScF0RNp6x8C2aI9wy0ZQsGIF0casEyuKB8fMC
         RwfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4WhtpOpZmdt3UEqX4nITheGaQTNBco04bK3sUmh5mfc=;
        b=KRn6aU7NdP6RvFa/wdlA+Jj1aoNvrUIl/AMK1ZKF47NZ0eyIY4D+Ch14EgY4DpiKdm
         88no8W7mhBbuFpCAoj1fbdocmTutkCEsN4x/BuB10Fik5GA1cq4qu8FJi66PCVaWI61I
         vmJyFgQ5pryAnWxvZi4nKbV+mUMgr7M6WJCn2txkagVN8WoEKZtaFyvQCMPSlswyKUgj
         ewx+cri3kXIxCS8NuB8WlREZbczgr8aSC19QQkkDmHlw08onvVW8tkKoCDCxOoSEbP6O
         wrQSdrI6EzU7jIdvNSIe4FAdcAvFrBxi/Zbw9iamP5hM/HP7CLiLXRj+wlF5h2oU+4Ky
         BMEA==
X-Gm-Message-State: AOAM533szS8Esw27Z4cCMlFKpwqaDWek5Z5Jp1zHO9MG7We2GYt4pEb9
        h2xlMNxglPAVr2u+XlH0YWHxHQ==
X-Google-Smtp-Source: ABdhPJzH/QXNv7FF1aCvpOPFknCOW/nXlnaTWjZnGmuh5dvPI88sZdTh4mB87KAM5BFBVP9fL/ZVaw==
X-Received: by 2002:aa7:9638:0:b029:303:1969:2290 with SMTP id r24-20020aa796380000b029030319692290mr5002786pfg.81.1624386474914;
        Tue, 22 Jun 2021 11:27:54 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::5:ebf0])
        by smtp.gmail.com with ESMTPSA id p14sm21597132pgb.2.2021.06.22.11.27.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 11:27:54 -0700 (PDT)
Date:   Tue, 22 Jun 2021 14:27:51 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Backport d583d360a6 into 5.12 stable
Message-ID: <YNIrp7A0LV0aLc5q@cmpxchg.org>
References: <11282373.oIR2C0Pl9h@spock>
 <YNIUP70J5yWPaguo@kroah.com>
 <5661831.TEGnOE2T3c@spock>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5661831.TEGnOE2T3c@spock>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 22, 2021 at 07:24:56PM +0200, Oleksandr Natalenko wrote:
> Hello.
> 
> On úterý 22. června 2021 18:47:59 CEST Greg KH wrote:
> > On Tue, Jun 22, 2021 at 06:30:46PM +0200, Oleksandr Natalenko wrote:
> > > I'd like to nominate d583d360a6 ("psi: Fix psi state corruption when
> > > schedule() races with cgroup move") for 5.12 stable tree.
> > > 
> > > Recently, I've hit this:
> > > 
> > > ```
> > > kernel: psi: inconsistent task state! task=2667:clementine cpu=21
> > > psi_flags=0 clear=1 set=0
> > > ```
> > > 
> > > and after that PSI IO went crazy high. That seems to match the symptoms
> > > described in the commit message.
> > 
> > But this says it fixes 4117cebf1a9f ("psi: Optimize task switch inside
> > shared cgroups") which did not show up until 5.13-rc1, so how are you
> > hitting this issue?
> 
> I'm not positive 4117cebf1a9f was a root cause of the race. To me it looks 
> like 4117cebf1a9f just made an older issue more likely to be hit.
> 
> Peter, Johannes, am I correct saying that it is still possible to hit a 
> corruption described in d583d360a6 on 5.12?

I'm not aware of a previous issue, but it's possible you discovered
one that was incidentally fixed by this change.

That said, there haven't been many changes in this area prior to 5.12,
and I stared at the old code quite a bit to see if there are other
possible scenarios, so this gives me pause.

> > Did you try this patch on 5.12.y and see that it solved your problem?
> 
> Yes, I've built the kernel with this patch, and so far it runs fine. It can 
> take a while until the condition is hit though since it seems to be very 
> unlikely on 5.12.

Is your task moving / being moved between cgroups while it's doing
work?

How long does it usually take to trigger it?

Would it be possible to share a simpler reproducer, or is this part of
a more complex application?
