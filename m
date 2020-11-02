Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80EDA2A2F82
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 17:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgKBQRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 11:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbgKBQRr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 11:17:47 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB0CC0617A6;
        Mon,  2 Nov 2020 08:17:46 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id c20so11517151pfr.8;
        Mon, 02 Nov 2020 08:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2MzVyafZD/d5S58iqSdaOROaljhCCbTE4cyjcOCGRyc=;
        b=eAgBQn8rRwIyQ5exdhH6P4I82a89cPPxF86BrrpM/IN+U6eN+AwhZ5B2xu/ixuQVSF
         2d4qkc5+Lfl3sJhTRupPr2A56nLUmVPZPcZrM3IVYRsb5LCeHy+YImVx4GFeXNT24kiL
         tmnuv1adCIPOLUM16TunUK8jwo04EBA1lK++TyB7N4QByOlTfXg6uWMwxf5Q9rLsVT4n
         0RzyYiqjubRWegLGHhdouFAxGoujULL6VE65atxIL/woopSnyiDo8+FIs3zvuNfJHlLB
         z5FCkZltWyYU3M6f5EB5KR+ZhqxKwwWmOzC/OJq2HWk4mE2+yEORoRY+2A5MqJ5cstPq
         xVCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2MzVyafZD/d5S58iqSdaOROaljhCCbTE4cyjcOCGRyc=;
        b=bqgBKYvNvGC6d/Z3KYAVWu8wLnf97rWpEy/D6+cL1cFLR1xip9sMaHtsqYLVXwSNGF
         T8C7rAcvCz/wmxr5f7lLFPK5WweKjUPb2tgLjjDoDyIw78J6Jp2Q6zZO0j0RpjPyKQST
         lWS9z8lPXwXaNKYNwPgrO39PDUwU4wqkAkZuB5DVlQrNLh9TDzHZ3IxownNu+ScVrSSq
         oJh9OTJpnF8F4NOgmQkHApgOMtXZJnUNeQUbkdYozzN5CW2hVnvpmEFUzTmlkaFCY1cu
         0bk18y05cdbI+x4RTglzgWgQixTe6OBt9qaki6EETibMsaUvFcDZOl1AYhtXk/mJU0ec
         Hilw==
X-Gm-Message-State: AOAM532N7kAB6+tspq7pvz6cf8Lwp2m8gRLNnSEXLgVDs0UoCohgz1bq
        3XTO6Li8buBLTS7eqxOWjg==
X-Google-Smtp-Source: ABdhPJxX8xbW2drAiJIg46qxzs2k97iF4UlLerUuQKowRTiwOnryMAFSTKKEYo0Rdc2mNgwUFzKuRg==
X-Received: by 2002:aa7:8545:0:b029:163:c9a5:97d with SMTP id y5-20020aa785450000b0290163c9a5097dmr22120606pfn.38.1604333866557;
        Mon, 02 Nov 2020 08:17:46 -0800 (PST)
Received: from PWN (59-125-13-244.HINET-IP.hinet.net. [59.125.13.244])
        by smtp.gmail.com with ESMTPSA id v3sm13784875pjk.23.2020.11.02.08.17.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:17:45 -0800 (PST)
Date:   Mon, 2 Nov 2020 11:17:34 -0500
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     Lee Jones <lee.jones@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH 1/1] Fonts: font_acorn_8x8: Replace discarded const
 qualifier
Message-ID: <20201102161734.GA1563823@PWN>
References: <20201030181822.570402-1-lee.jones@linaro.org>
 <CAKMK7uFN31B0WNoY5P0hizLCVxVkaFkcYjhgYVo1c2W+1d7jxA@mail.gmail.com>
 <20201102110916.GK4127@dell>
 <CAKMK7uFhpt5J8TcN4MRMeERE9DtNar+pBAmE6QRvD0zkGR5iNQ@mail.gmail.com>
 <20201102113034.GL4127@dell>
 <CAKMK7uHo2MMmBUic9EiFqcUh8mJeu1+=ZQfH7bWA=zdJTyRyvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uHo2MMmBUic9EiFqcUh8mJeu1+=ZQfH7bWA=zdJTyRyvA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 02, 2020 at 03:50:49PM +0100, Daniel Vetter wrote:
> Maybe Peilin is going to include the full re-cosntification in a
> cleanup series, dunno.

Sure, I will do it in a separate patch.

Thank you,
Peilin Ye

