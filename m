Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14DE62A2FE5
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 17:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgKBQes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 11:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbgKBQes (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 11:34:48 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90453C0617A6;
        Mon,  2 Nov 2020 08:34:48 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id j18so11581243pfa.0;
        Mon, 02 Nov 2020 08:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vrmeGdXXI4MmZipYNwnT4bkxk/6PwnXu3FmDdm+QL5Q=;
        b=lDwEZpJe0OZUjLBKgW6z3x/gIEXQni7wy2DG8D8WKYtPIaL+0lzsto5NeV/mnp0Ir8
         iTSCQQmtjwq1oQQld0ljOPwgTpTbqV+P0m83MS0R+ZpMBuxtq2mxxwt2z7DQvKK5LZm3
         +nEYX2riVV1ZYm1l8ZmlKYMqg8jaTW8ok9N0Glndfv+v+5IMxIExujZET/j5s+CMtC2g
         3AAP9IofuKgKrceicupEGzb+XGNKiBS2PHTtHyBS5ftLuYhCO1xjzcRLmXsaET7qk2wi
         JuQhwbzygFkCmLdVsRcNzAhzg0ye2b4hdMNF2cITPWrFUyazJu7OZz7pAl41vofSPbl1
         naXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vrmeGdXXI4MmZipYNwnT4bkxk/6PwnXu3FmDdm+QL5Q=;
        b=DkYr3Aa3urKqAcQD+CtiyjpV4g2PHHsfLLFxOlb0ep4WoZZJ1Je4M0zAkYvd/ktNr2
         chfmn2+Syf1WJ3Ah1qHwVl0Dd8qryVdLdNR5eOp32z7InOeFKOKuv/w+RpBmD5FSvglp
         Jjz597bCy5W4J3bPAwVW2m00m4iY8wNZscph/uT+yXXC/CjgemmGYBnFKpVJZOAPoqFH
         gRHpDBVTsv8ga5F1qVhPpW6a+P1Pi8Udpz6sOutpH3SA6dK94QExD9uARKkvKPfdAlXP
         4Ywg8QI1iJ7nQ41KVkz65qnzoKNd7mjGfjVjYiYb2uezcqRTCa/UuvS8fT1momFodqoE
         TzpQ==
X-Gm-Message-State: AOAM532GNQXxqg4gLe/LRqesYW8JQo2QaIN8bEbnkaTswZAffaL0D6yz
        IA3ZCx/giH6ayPinr8YGf1eJuZ/FvV0T
X-Google-Smtp-Source: ABdhPJx+jyJTp6DLFWtMejtjdB1PY1zUTyEadHf/pR4R5ukGNYfSA18vjkglrf/Edbjof+qGg1WvQw==
X-Received: by 2002:a63:4960:: with SMTP id y32mr13876111pgk.369.1604334888171;
        Mon, 02 Nov 2020 08:34:48 -0800 (PST)
Received: from PWN (59-125-13-244.HINET-IP.hinet.net. [59.125.13.244])
        by smtp.gmail.com with ESMTPSA id 194sm4242354pgf.72.2020.11.02.08.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:34:47 -0800 (PST)
Date:   Mon, 2 Nov 2020 11:34:39 -0500
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH 1/1] Fonts: font_acorn_8x8: Replace discarded const
 qualifier
Message-ID: <20201102163439.GA1564189@PWN>
References: <20201030181822.570402-1-lee.jones@linaro.org>
 <CAKMK7uFN31B0WNoY5P0hizLCVxVkaFkcYjhgYVo1c2W+1d7jxA@mail.gmail.com>
 <20201102110916.GK4127@dell>
 <CAKMK7uFhpt5J8TcN4MRMeERE9DtNar+pBAmE6QRvD0zkGR5iNQ@mail.gmail.com>
 <20201102113034.GL4127@dell>
 <CAKMK7uHo2MMmBUic9EiFqcUh8mJeu1+=ZQfH7bWA=zdJTyRyvA@mail.gmail.com>
 <20201102161734.GA1563823@PWN>
 <20201102162447.GE4488@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102162447.GE4488@dell>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 02, 2020 at 04:24:47PM +0000, Lee Jones wrote:
> On Mon, 02 Nov 2020, Peilin Ye wrote:
> 
> > On Mon, Nov 02, 2020 at 03:50:49PM +0100, Daniel Vetter wrote:
> > > Maybe Peilin is going to include the full re-cosntification in a
> > > cleanup series, dunno.
> > 
> > Sure, I will do it in a separate patch.
> 
> Are you happy to conduct a proper clean-up on top of this patch?
> 
> This is currently broken in all of the LTS kernels, which I would like
> to have fixed post-haste.

Sure I will do it now. Thank you,

Peilin Ye

