Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A013548358
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 11:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbiFMJoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 05:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235093AbiFMJoF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 05:44:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8C88E1402F
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 02:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655113442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wX4MzqsPXkX7HniXRJt/CJ6zT4X1zB/XBHjLSZuk9fc=;
        b=OG+Usl6DWwIS1DaAd1QJN8WtE1mzIsC/HuUm54U1fLlkIHPGaxpFWJLxuZQCBqTOiDn8Gd
        lZXSLMqaeEHpblTzxkOLsl0HrLEBbWkbj8yYsPi3YESMijn1ROsOYO9CZFJie9wztvOCl+
        RWPoxb/ET5Oa1REHh0zyIOLRpD4GC+I=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-NuvHBV1PMI-N-yI9LNpvnQ-1; Mon, 13 Jun 2022 05:43:57 -0400
X-MC-Unique: NuvHBV1PMI-N-yI9LNpvnQ-1
Received: by mail-ed1-f71.google.com with SMTP id ee46-20020a056402292e00b0042dd4d6054dso3646936edb.2
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 02:43:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wX4MzqsPXkX7HniXRJt/CJ6zT4X1zB/XBHjLSZuk9fc=;
        b=IGOF+P8mVVmWbFWBFtDhkg0KGtvMraWYtpXKdTYSFwjahIIgiq6IX2xFq+5mFAavqr
         y9Da3gvQ+ibxdcqlWHRsv1uIrfGuyLZ0w6agprXdPSMgAkesmcwUXbN/pBleYV8TWKge
         ODf9whvdJ7kLXhC6lrMH42KbBhLveKweWew9rd9ytDBf+5G8f7fbKrIwWl/+b+fdTbOO
         6yVQtN9zmLpp4Sf4Rwhr71G1YLm59xIQ1qTO4lfqrBgj47xEkOg7a19NYhKuKcCpMHte
         HTqXnkYlH+nsFkM5XPxKeYOJ2HJD1jEgrSOW0UrwhpBD9+rqUcbkaHUuyW/CRRQsN7F+
         tfiw==
X-Gm-Message-State: AOAM531duIOb8m6wEbMD3h4e6dgaB0OnXXRrX1TpF2vbOAcaxT+MAvPy
        RYXDBfyePFUWLRwG/bmjHEVQDFQdoxZZPhJHJudzJv9r2cfutGXW62gTRt2KlIjkUsaj9baKLQk
        cy6rvyWQwx3UGkIai
X-Received: by 2002:a05:6402:2999:b0:434:edcc:f12c with SMTP id eq25-20020a056402299900b00434edccf12cmr5382514edb.96.1655113436554;
        Mon, 13 Jun 2022 02:43:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyucl+Fa6sSHJvwJ+ixOGvUrcz38xvg4Do1+iqzXe8iozHH+ehFlcdX7sHHtkmjzctuwWkPHg==
X-Received: by 2002:a05:6402:2999:b0:434:edcc:f12c with SMTP id eq25-20020a056402299900b00434edccf12cmr5382498edb.96.1655113436347;
        Mon, 13 Jun 2022 02:43:56 -0700 (PDT)
Received: from localhost (net-93-66-64-158.cust.vodafonedsl.it. [93.66.64.158])
        by smtp.gmail.com with ESMTPSA id e6-20020a170906044600b006fe98c7c7a9sm3586473eja.85.2022.06.13.02.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 02:43:56 -0700 (PDT)
Date:   Mon, 13 Jun 2022 11:43:55 +0200
From:   Davide Caratti <dcaratti@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, echaudro@redhat.com, i.maximets@ovn.org
Subject: Re: net/sched: act_police: more accurate MTU policing
Message-ID: <YqcG24495hOdOgm1@dcaratti.users.ipa.redhat.com>
References: <YqNcHbk0K20+qfxP@dcaratti.users.ipa.redhat.com>
 <YqNeoTphHJV5jRYy@kroah.com>
 <YqN6oALiUdh7vnCE@dcaratti.users.ipa.redhat.com>
 <Yqb/NsKSyDmQoS+h@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yqb/NsKSyDmQoS+h@kroah.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hello Greg,

On Mon, Jun 13, 2022 at 11:11:18AM +0200, Greg KH wrote:
> On Fri, Jun 10, 2022 at 07:08:48PM +0200, Davide Caratti wrote:
> > hello Greg,

[...]

> > > and what kernel(s) do you want it applied to?
> > 
> > the reported bug is in act_police since the very beginning; however, the
> > patch should apply cleanly at least on 5.x kernels. On older ones, there
> > might be a small conflict due to lack of RCU-ification of struct
> > tcf_police_params.
> > A conflict that gets fixed easily, but in case we need it I volunteer to
> > write a patch for kernels older than 4.20. @Ilya, what is the
> > minimum kernel usable for openvswitch with MTU policing?
> > 
> 
> It does not apply to 5.10 or earlier, so please provide a working
> backport for those kernels if you wish it to be applied there.

sure, I will do that.
thanks!
-- 
davide

