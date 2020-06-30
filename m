Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4CB20F42C
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 14:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387444AbgF3MK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 08:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733049AbgF3MK2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 08:10:28 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5D1C03E979
        for <stable@vger.kernel.org>; Tue, 30 Jun 2020 05:10:28 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id k6so19885099wrn.3
        for <stable@vger.kernel.org>; Tue, 30 Jun 2020 05:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=FD52fpKpmNTmj/eDctUjclppU7Js+EVdmC5hC/OVtFs=;
        b=NRljYN3HW/WdxS5Cts2ZA1j9271Z4nuhudB7sc3qeex1o0rC4eS3e9/2IDg4OHBSpt
         I6GPXfIVRCfVtMBMIhfKHdwZh1wMClH31m1cA98lsylFqZlMr5XC+BccCiR80sF5rhKM
         ivTqMcy01KWwsNLX6MF0MA/gn0gGRdfbkAlnhj0Hw7qhftsPD5UIXNfiQFjtlBVBHcQB
         CZ6yZnfXUjf+Sn7Jxf3e7rZlnyIdpj1STZYpfzZIGZvbhwTmbAieciek4EMvm5+zAk6X
         8caviwiMHY9L6sWYEOzdPXdvwyjXkHlSeZQOfjNL3I7vmvJ85dQavE0PU8lPXwHDb2tI
         j/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=FD52fpKpmNTmj/eDctUjclppU7Js+EVdmC5hC/OVtFs=;
        b=B4dakC6h6x60LHaa0NE0XEaxkcfeEte1IoeipeDyrYmmKzQvUu4PIsT9+5U6Hp+7Wg
         DWMenzdrZoHextKmUq1lWXEaj06xBgygI9H9JXgTqmStO9JZGD1BV14d7IdrS/5c/Ah7
         mvUnlFByztTDjtQ70x4YUXcLO6Q049w0tY5gIlyccv+pXzfUeV6yie7cNE6+nKSwfm6e
         4NhwGv8bslQ8DGXwztr28eruQjXq3eio4B/sqBrX6aDCZXzb86n3CZMohCdqo8ZgwM9E
         U0Q0svmmZoCT2iGVLLvmqiXQ7bKcpS0ApT1X1sof9QQInizuUTzGNONF2VODJHbo2sXm
         Fj5Q==
X-Gm-Message-State: AOAM53365/h/+jYCP5Ec+ADklvIr/BqkQNZOYXg8B0D4dsIE5GsQaKnm
        J5BYvbeGaHcVr0J1OrhrFJOI5Q==
X-Google-Smtp-Source: ABdhPJz98/zx/sFcc8HjZmijVDlgtpVyakDWmF8x5eWobYBYe0oCo6r4iRmDuGV3NWZ4UxoqyWdSaQ==
X-Received: by 2002:adf:9286:: with SMTP id 6mr21663556wrn.361.1593519026493;
        Tue, 30 Jun 2020 05:10:26 -0700 (PDT)
Received: from dell ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id 133sm3671366wme.5.2020.06.30.05.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 05:10:25 -0700 (PDT)
Date:   Tue, 30 Jun 2020 13:10:23 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 08/10] mfd: atmel-smc: Silence comparison of unsigned
 expression < 0 is always false warning (W=1)
Message-ID: <20200630121023.GL1179328@dell>
References: <20200625064619.2775707-1-lee.jones@linaro.org>
 <20200625064619.2775707-9-lee.jones@linaro.org>
 <20200626205627.GU131826@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200626205627.GU131826@piout.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 26 Jun 2020, Alexandre Belloni wrote:

> Hi,
> 
> On 25/06/2020 07:46:17+0100, Lee Jones wrote:
> > GENMASK and it's callees conduct checking to ensure the passed
> > parameters are valid.  One of those checks is for '< 0'.  So if an
> > unsigned value is passed, in an invalid comparison takes place.
> > 
> > Judging from the current code, it looks as though 'unsigned int'
> > is the correct type to use, so simply cast these small values
> > with no chance of being false negative to signed int for
> > comparison/error checking purposes.
> > 
> 
> I've been thinking about that one but shouldn't the proper fix be in
> GENMASK? My understanding is that this happens because l is 0 and I
> don't think GENMASK would ever expect negative number. What about simply
> checking that h != l when l is 0?

Looks like Rikard Falkeborn recently submitted a patch to 'fix' this
issue.  However, Linus slammed it, decrying that it's the warning
that's wrong, not the code.  Looks like the type-limits warning might
be getting downgraded to W=2 instead (although I don't see a patch
yet).

I'm going to drop this patch.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
