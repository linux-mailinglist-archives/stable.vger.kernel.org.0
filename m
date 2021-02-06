Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3112B311C29
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 09:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhBFIc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 03:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhBFIcX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Feb 2021 03:32:23 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D501FC06174A
        for <stable@vger.kernel.org>; Sat,  6 Feb 2021 00:31:42 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id bl23so16381650ejb.5
        for <stable@vger.kernel.org>; Sat, 06 Feb 2021 00:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OeBcpRKfxnqjhEtBsUbzhS4cHL/9j4BOHklnfv499Os=;
        b=i+321qJF2JRFN0X/UMTnv5n9UGQLZXtKCHCDbGDvoAvGSaKt2dqzHpSUFROpMeh8V5
         F4P/gftjtCO6C6OoZGmOV05tHxhPeCear7A3hdv+ZEmagHj3HyuF5MBJTFfYIm42V8Gm
         /G8oWLvsCgP0P4OORw6O9XABRJ6m7a0xhmil5WsxusQ8vlNdj77ihHenDxpEeIx2ZevX
         lKKQF1a0ZukNVl+8H9O8i0wY3EGEYKJI67O4ODE2DnRyAt5f0Nr45Hg97TWDAvJdPJlG
         HAzBeZODAoFvssOtHVH/xLrU4PI6UHjdGj/jO4AaFdcXoKFDJl+jM33HHrGkgvkSreWa
         S0nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OeBcpRKfxnqjhEtBsUbzhS4cHL/9j4BOHklnfv499Os=;
        b=H9dL2acexh3RWk9g2nitWB7gYpGW7COO05h3kYcctcB33wTCLcBZNxpW5g824J41is
         Aet5LcDXXCCic9w2Z5+uGVq+wA+rfzG1Vl5tDxPvW+KmfyirlxOz9MEoa8CoTAcMbpud
         CaufVm+tuzeLtMgsVsxQZJpL258liGEdN18UEdDmetjwkIX7r20qkJFwHupzbWsZrCzj
         4hr3WLXWmI0PDkvJ2kJnZJdDS8iwhMVwsnr9jAEpEAoWQGJSr/TjQmR/f5HY+uq7F1Bq
         wobcg2OZcRTKUyBwpdwzQReyXtqnwtFde/lyTj1N5f7oBa/nRL3GCMwcpkmLwW3rtwrh
         E4HA==
X-Gm-Message-State: AOAM531Tc3U2jbzc4w2L36ruE26sGs1JkaT7v86d7geNYdAruQ7RfOVp
        kLKdnKAUaRyWquEYR4L4UwZ7aC6o6j8ntwEXFY9pcZB2voKEbg==
X-Google-Smtp-Source: ABdhPJwWMTssE3Lx87N8nwbqiblru/kezWD6HFDDePPNtlXtm9o6BFikluaWcsfbRKRM9QJeR1DbGzobvraT7JNAIGs=
X-Received: by 2002:a17:906:688f:: with SMTP id n15mr7999889ejr.71.1612600301569;
 Sat, 06 Feb 2021 00:31:41 -0800 (PST)
MIME-Version: 1.0
References: <CAEncD4esY38Z-Z9t=KOXriZczry7htCYfCh7+B=eC_kUds5miQ@mail.gmail.com>
 <YB4/ESyrjZJ1uMQK@kroah.com>
In-Reply-To: <YB4/ESyrjZJ1uMQK@kroah.com>
From:   Dave Pawson <dave.pawson@gmail.com>
Date:   Sat, 6 Feb 2021 08:31:30 +0000
Message-ID: <CAEncD4f6pceioDQghmwReRhmHPPMjFMmfJj_Xi_NBzsum17PYQ@mail.gmail.com>
Subject: Re: How to help with new kernel?
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kernel how to you mention?
http://www.kroah.com/lkn/  is that the one?
Guessing that is more up to date than the O'Reilly one?
 I have author access to O'reilly if that is easier / clearer?

regards


On Sat, 6 Feb 2021 at 07:02, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Feb 05, 2021 at 03:50:55PM +0000, Dave Pawson wrote:
> > Do you really want companies only?
>
> No, I will accept help from anyone who relies on the stable kernels.
>
> > If you detail how to install the new kernel
> > (and any other prerequisites) and if 'ordinary use'
> > is sufficient, I'm sure others would help.
>
> That is already well documented, heck, I wrote a whole book on how to do
> that and it's free online :)
>
> thanks,
>
> greg k-h



-- 
Dave Pawson
XSLT XSL-FO FAQ.
Docbook FAQ.
