Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3A42A2FC2
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 17:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbgKBQZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 11:25:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbgKBQZy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 11:25:54 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1300BC0617A6
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 08:25:53 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id k10so13982048wrw.13
        for <stable@vger.kernel.org>; Mon, 02 Nov 2020 08:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=bK5W0XSlSTx37itQb8Tn21VybnLQ6iBteojBQ7Be2NM=;
        b=st8zikmvIfdaMGd862jzP8rJ/lAc/2eYiylH5dggvNEv1PnoOFzwzBwMVOlh1kdKWA
         jsvpWeyEwZSJH1Wco1Qk+KFlUzNX4opGrwavfXwxiljL8Ek/u3MD8eeQA/GPb5oS2D4J
         +SypPKxSYCEf78/n6Z8SRRt2Ks628tuc6fjpEmts6JkcktMsQAvboldYGHMBWyXI44PO
         sUb9JNz/pS1SNJz6S4NGS34Ovn4D3tfhLrAxxDwLuTkJPz+aKnNOEhQ9t86XIijo15I8
         buoezAcNudp9/Le7WtjGBsUbHCtPkusK0fMMQDW9WkjYtKjyL+PEfTQFSwAguiBx6DNd
         EEPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=bK5W0XSlSTx37itQb8Tn21VybnLQ6iBteojBQ7Be2NM=;
        b=QxIGNYjOt2Y0QjC7y4rJRhKqwHdInkzB3pppoq1unmxAr4NMSXBh+WnD+JJ1yAtYvB
         6A0DWZStvvVFBQdwSrnyaSIL96V1VONE2cpIy6MgTjesVjaPpepqnhiycE76kL0jz5/l
         0DpzGL5nydgTKO5r6cHN9Er49O82e0lZohQhuH/70tzeNDFrZ2Pcm/nmxSzruhHG4h9o
         6aCeD7a6nUTit/BBzAuv0YnNK1c72RV8RrAaRSqO3b1tO43aoDPPLemDFanYVRzLRxtm
         Eys4c3Kub3r2lL96mHIpZ5r6GOKnmdONPSpBMm5/RuhN5lSjYpoN9EUzw+qY2PCHd4RT
         GJyg==
X-Gm-Message-State: AOAM532cGRThCcq/W4CEBXQIdEL4pLNE7/ZHIPKHKgGG3Ps1va1LAxZ3
        PKYFkCHh1w2m12LblHxfVOtqaw==
X-Google-Smtp-Source: ABdhPJzzMUP3fgGF01v3WIXvb8mosrwsf0BxqPiPBsQtyhSrBfRI5l590eNHyMNIg0ZUiJySmIn5Eg==
X-Received: by 2002:adf:f20e:: with SMTP id p14mr20484980wro.376.1604334351828;
        Mon, 02 Nov 2020 08:25:51 -0800 (PST)
Received: from dell ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id u23sm4767878wmc.22.2020.11.02.08.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:25:51 -0800 (PST)
Date:   Mon, 2 Nov 2020 16:25:49 +0000
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
Message-ID: <20201102162549.GF4488@dell>
References: <20201030181822.570402-1-lee.jones@linaro.org>
 <CAKMK7uFN31B0WNoY5P0hizLCVxVkaFkcYjhgYVo1c2W+1d7jxA@mail.gmail.com>
 <20201102110916.GK4127@dell>
 <CAKMK7uFhpt5J8TcN4MRMeERE9DtNar+pBAmE6QRvD0zkGR5iNQ@mail.gmail.com>
 <20201102113034.GL4127@dell>
 <CAKMK7uHo2MMmBUic9EiFqcUh8mJeu1+=ZQfH7bWA=zdJTyRyvA@mail.gmail.com>
 <20201102161734.GA1563823@PWN>
 <20201102162447.GE4488@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201102162447.GE4488@dell>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 02 Nov 2020, Lee Jones wrote:

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

Of course, if it's *just* a matter of making all of the structures
const again, I will do that myself and post a fix either this evening
or tomorrow morning.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
