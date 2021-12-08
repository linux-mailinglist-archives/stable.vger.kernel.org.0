Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE93446DA50
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 18:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbhLHRta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 12:49:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36619 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229613AbhLHRta (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 12:49:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638985558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wIeLXqdZmXmJdAyKK++YFvyIGJhQ6Il+iKTK3tv7QPE=;
        b=Vc6KFdD/cwmcSJ+jQxDxSJjrlpu2ctVPQEPFQN85ienNRKbOfR3Un0Ull8fEYrvi8E3Upv
        aWBvMaTzXWWx3B9V5QSHQXmeBVB5q/H4lpQ60X7DOgCUL0M6upvlqCCEWodQJJOJ24d/31
        kcHj9CB0hcg+ozvXo8UmXn8huMAatE0=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-xepsoxX6OzuzuGMKTsLBwA-1; Wed, 08 Dec 2021 12:45:57 -0500
X-MC-Unique: xepsoxX6OzuzuGMKTsLBwA-1
Received: by mail-qv1-f70.google.com with SMTP id fw10-20020a056214238a00b003c05d328ad2so5065188qvb.2
        for <stable@vger.kernel.org>; Wed, 08 Dec 2021 09:45:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=wIeLXqdZmXmJdAyKK++YFvyIGJhQ6Il+iKTK3tv7QPE=;
        b=v99ndepT/XmdzAkXefRRc8ouF8BgYRwrYirbJa1kJ30hlNr62d46C903LESwMNOgnO
         5onX/+PqaMqCCO/0pF2fy1JodKZ7V+jW6mXCTeHNaZSbb65QLbWhhfFRRKEZhYLmkEgs
         LesNSYY2ao+nbfWmGAwFSbnivz6u6XIWHyOQK/M1jmmDxO/L2lEXYZEBuvbtxQOO3E6S
         lOn9eaeyeGF24CZzL6naVEM/C3xC5H7XMQxn0mMwfql41JZbNKeIq58Di7hCvdXZLkBw
         dS1PiR+NXawfdUWcBvBTWUO2mQHKtnsDpR8OMPCMjSE95CktvtuyBKejt8GRYs0NRK3P
         gwUA==
X-Gm-Message-State: AOAM531cd7v5rCG2qmnw+IOZxGBhfW3MG0bH1n8/Alc2++OUSWrMh9YR
        Y5OzVCjILA5AWObHzQPkfGvaGWcKyxXJcytToICUZEcQxdE1rfgClNv1nEQQ3cVPCRqrlv5vi4c
        of7INyZ8vPMUy4tIl
X-Received: by 2002:a05:620a:270e:: with SMTP id b14mr8035196qkp.475.1638985556249;
        Wed, 08 Dec 2021 09:45:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw7vlTIXXDmuezvrfKgcLR5IZ+HFtNcZM3oY6bWK8yknJ1E7zO2EI+z2E99l1Dicr/dgCYwMQ==
X-Received: by 2002:a05:620a:270e:: with SMTP id b14mr8035172qkp.475.1638985556033;
        Wed, 08 Dec 2021 09:45:56 -0800 (PST)
Received: from [192.168.8.138] (pool-96-230-249-157.bstnma.fios.verizon.net. [96.230.249.157])
        by smtp.gmail.com with ESMTPSA id q11sm2022683qtw.26.2021.12.08.09.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 09:45:55 -0800 (PST)
Message-ID: <1e764ec7f8b248545942251e1dbd4ff27d166466.camel@redhat.com>
Subject: Re: FAILED: patch "[PATCH] drm/i915: Add support for panels with
 VESA backlights with" failed to apply to 5.15-stable tree
From:   Lyude Paul <lyude@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     rodrigo.vivi@intel.com, stable@vger.kernel.org,
        ville.syrjala@linux.intel.com
Date:   Wed, 08 Dec 2021 12:45:50 -0500
In-Reply-To: <YbCrx22nKTboVF/M@kroah.com>
References: <16387074612176@kroah.com>
         <390babb7a9b7e27a9edbc909a4ea5bf6bf256da3.camel@redhat.com>
         <YbCrx22nKTboVF/M@kroah.com>
Organization: Red Hat Inc.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2021-12-08 at 13:57 +0100, Greg KH wrote:
> On Tue, Dec 07, 2021 at 06:23:49PM -0500, Lyude Paul wrote:
> > Huh, well this is strange. I'm assuming that you send these emails out as
> > part
> > of an automated script that tries applying patches and fails, but I think
> > something may have gone wrong here as I just tried cherry-picking
> > 04f0d6cc62cc1eaf9242c081520c024a17ba86a3 onto v5.15.6, and it applied
> > without
> > needing any manual conflict resolution. Any idea what might be going on?
> 
> You mean 61e29a0956bd ("drm/i915: Add support for panels with VESA
> backlights with PWM enable/disable"), right?
> 
> Anyway, yes, it fails to build:
> 
>   CC [M]  drivers/gpu/drm/i915/display/intel_dp_aux_backlight.o
> drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c: In function
> ‘intel_dp_aux_vesa_enable_backlight’:
> drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c:302:33: error:
> implicit declaration of function ‘intel_backlight_invert_pwm_level’; did you
> mean ‘intel_panel_invert_pwm_level’? [-Werror=implicit-function-declaration]
>   302 |                 u32 pwm_level =
> intel_backlight_invert_pwm_level(connector,
>       |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       |                                 intel_panel_invert_pwm_level
> cc1: all warnings being treated as errors


a-ha, totally forgot to build test it :P. Will fixup and send you a new
version in a bit, sorry for the noise!

> 
> thanks,
> 
> greg k-h
> 

-- 
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

