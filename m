Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8371B2A2FB7
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 17:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgKBQYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 11:24:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726886AbgKBQYv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 11:24:51 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13A6C061A04
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 08:24:50 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id x7so15342446wrl.3
        for <stable@vger.kernel.org>; Mon, 02 Nov 2020 08:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=6B9B6xuPKWn9Z1hQbFYBWRVk7wJc1I2DJdaNL5Vf090=;
        b=xJpkjKZJXEIWzSsoKii8LKrf4Jcm8iKK9Yb8XxpMDNCkMT/a1/Uy+tWMzrtzwzC4Rl
         IP13GfWoBi/R9e7gogLcaXGCEc0esLWDkQsf3Mk9lxL026lnwlzoLVIAwOFrdUTNxx1o
         +QvqLw9Xf60kT8FlCXG0PCdu1XH5fLxpxRDJOMSITkXfYYbnjHwBZ4dFGwSLVHzhNCDl
         YkovEbjpX9Ju7H1HWjOuXhdCc41aTfL2154Muj6dDiW9sw9ECWZEGkhIsGpugeq08O1k
         tDSuvqD+xxSi9yjyNNFrVGtA4pj6Fnp17kKAyrmQVIwhbM2IgWClwWRZP+XWu2zYp009
         VNog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=6B9B6xuPKWn9Z1hQbFYBWRVk7wJc1I2DJdaNL5Vf090=;
        b=cD7C2Y9S2b8jA48MaWL0pqNiRkIQPLXyFh+d7x6gpOq+8KltC3CKIswtqtpHWyfaM8
         1JolD4j/HfFw4HYX7FP+/qwKnzXa7HoQeXMQ7bgZle1u9AuPgy2vzjTEdjcCXPxNRSHm
         9RJLhbIOF8rE/Y6eFgPEBO9NeJ5Q14suOREpR4SWWUwDn3vZk3ADpdCli5nmj28nE/q5
         o5L0+hB8HzsoJyrhMLJM/3K9HmxJFeIG8pUGRwyYvZEkzGNzm/YuhXrk2AbSl3YxKEnn
         UcJ61XCf3abgNKItWKE5gr7Wgal7TF6xZQy7H6oAs1cZcjHfGnT1i1carcIW7NdhDkXj
         hLVw==
X-Gm-Message-State: AOAM533Q7yZ+s7WmI/dyxCaHLS8evGFCIw58SYS+tFBoxFHMvFTKo/ok
        mSGLw63C8tZR3Nl9LiGdJpYtMw==
X-Google-Smtp-Source: ABdhPJz1CKgAn04v8cOE+DaSgJh0msqgAlx0sD70ALpMQonZFOno+U4Xz68tjpbcSViHuDBVoOKrnw==
X-Received: by 2002:adf:93c1:: with SMTP id 59mr20968071wrp.369.1604334289467;
        Mon, 02 Nov 2020 08:24:49 -0800 (PST)
Received: from dell ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id y201sm17228166wmd.27.2020.11.02.08.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:24:48 -0800 (PST)
Date:   Mon, 2 Nov 2020 16:24:47 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH 1/1] Fonts: font_acorn_8x8: Replace discarded const
 qualifier
Message-ID: <20201102162447.GE4488@dell>
References: <20201030181822.570402-1-lee.jones@linaro.org>
 <CAKMK7uFN31B0WNoY5P0hizLCVxVkaFkcYjhgYVo1c2W+1d7jxA@mail.gmail.com>
 <20201102110916.GK4127@dell>
 <CAKMK7uFhpt5J8TcN4MRMeERE9DtNar+pBAmE6QRvD0zkGR5iNQ@mail.gmail.com>
 <20201102113034.GL4127@dell>
 <CAKMK7uHo2MMmBUic9EiFqcUh8mJeu1+=ZQfH7bWA=zdJTyRyvA@mail.gmail.com>
 <20201102161734.GA1563823@PWN>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201102161734.GA1563823@PWN>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 02 Nov 2020, Peilin Ye wrote:

> On Mon, Nov 02, 2020 at 03:50:49PM +0100, Daniel Vetter wrote:
> > Maybe Peilin is going to include the full re-cosntification in a
> > cleanup series, dunno.
> 
> Sure, I will do it in a separate patch.

Are you happy to conduct a proper clean-up on top of this patch?

This is currently broken in all of the LTS kernels, which I would like
to have fixed post-haste.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
