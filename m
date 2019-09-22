Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07B99BAA71
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731504AbfIVT0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:26:35 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35811 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbfIVT0f (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Sep 2019 15:26:35 -0400
Received: by mail-lf1-f66.google.com with SMTP id w6so8460536lfl.2;
        Sun, 22 Sep 2019 12:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L76YLWOFlYefoF5IWQJFPDzu3cQ5HwkEiAAUBOXMLzQ=;
        b=TFIB0SN25FbvDBAl2p7UFn323dHMWmd3HYy9kgMu2BY9wzKqQ6iDAu02siWKeNIsxU
         sUc6MHCUvSFs5+ErhBljqUKhg94RTiTPTaCPOHVYjJ1HbK1Sc99RG+JUi8wcy6mAz26C
         JNuFQWjZISb/E9vrhq+H5GqREYbw7l1mHi3u84BYNPVq0WAZ0PZqgFQuzVhElM8pGtVH
         ZxIwyQ1VvR66jQjJvJZSEjGeTlTKI+96Bb0Rudqqgbs2ds4gyJzxKn8hxij6SNZ44LDY
         FRgxxg2+E5QhPdM80NGmwhyNdYew9XzRVCHtuX78NosYNcBndLqRngfpvA9xngo3O43y
         HBsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L76YLWOFlYefoF5IWQJFPDzu3cQ5HwkEiAAUBOXMLzQ=;
        b=fx+kwKACJW4EYCLsqS/P6uI1NYhhubyF7STmf0YohQJBFqqDj2j4ROQAylRLz/A34X
         PejnnBJFj1JNQoUL+Fwd9OhsxY9TKBOYPqEZvNrCgDufOiMAKZOuNfRVbUFbLNVc+Jh4
         /MQQz2XNEPGlBfgAjaGeNOdoxgxwBMATxUl9n8VI/MOC2vkmjufeugBg0FBtl7axxzZJ
         9bMEw5rZlQyzcSCaz+/lpHYqNC2M8BFe/GS+A+BNQ7DYT6wF7oZTufLvxLkGGy6TdXDb
         L239r72UE4xQ1QAdTitmoVhqGVo3MYs/VJBv4UTEI7GKYnwWFEFi2VQNqL69DaUDoLnR
         /qbg==
X-Gm-Message-State: APjAAAXfIIOqY+Npqu3bf6aL0GcA5URz4QptLrlppix1PLyJWCa3mRJQ
        zN2FchQX53Fvzrt9E8FQnJ8qz18zgh6OT+SvBgCCqg==
X-Google-Smtp-Source: APXvYqytMKbvsvu/LrkGmF/Y+0KYVc/ZLb51eZuAhov/AxwUlYlpBAi1oZ1t2ZgwyXXR0xnVai/9uMWA1IJMxqaqgG4=
X-Received: by 2002:ac2:568c:: with SMTP id 12mr14378512lfr.133.1569180392530;
 Sun, 22 Sep 2019 12:26:32 -0700 (PDT)
MIME-Version: 1.0
References: <lsq.1568989414.954567518@decadent.org.uk> <20190920200423.GA26056@roeck-us.net>
 <8dbced01558cd8d4a1d4f058010e7d63e5f6810e.camel@decadent.org.uk>
In-Reply-To: <8dbced01558cd8d4a1d4f058010e7d63e5f6810e.camel@decadent.org.uk>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Sun, 22 Sep 2019 21:26:21 +0200
Message-ID: <CANiq72mYYzH1oS4h9GTODMP1ckZn2GnGTGirue1VLU1aw+Qo2A@mail.gmail.com>
Subject: Re: [PATCH 3.16 000/132] 3.16.74-rc1 review
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Denis Kirjanov <kda@linux-powerpc.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 22, 2019 at 9:04 PM Ben Hutchings <ben@decadent.org.uk> wrote:
>
> It looks like this is triggered by you switching arm builds from gcc 8
> to 9, rather than by any code change.
>
> Does it actually make sense to try to support building Linux 3.16 with
> gcc 9?  If so, I suppose I'll need to add:
>
> commit edc966de8725f9186cc9358214da89d335f0e0bd
> Author: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> Date:   Fri Aug 2 12:37:56 2019 +0200
>
>     Backport minimal compiler_attributes.h to support GCC 9
>
> commit a6e60d84989fa0e91db7f236eda40453b0e44afa
> Author: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> Date:   Sat Jan 19 20:59:34 2019 +0100
>
>     include/linux/module.h: copy __init/__exit attrs to init/cleanup_module

Yeah, those should fix it.

Cheers,
Miguel
