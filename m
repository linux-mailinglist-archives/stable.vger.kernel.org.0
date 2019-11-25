Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20271109379
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 19:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfKYSZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 13:25:47 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51109 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727269AbfKYSZr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 13:25:47 -0500
Received: by mail-wm1-f68.google.com with SMTP id l17so386561wmh.0
        for <stable@vger.kernel.org>; Mon, 25 Nov 2019 10:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=L18Z1pkukvs4+t/dQnfMfP/fIVsDfb5z1Omz/Ism5ts=;
        b=X9514pwmhBqfA+7SYh8Gv00FJqpkcpuuCPbq021pMG9nvFIflRoTJ7OMG5GcMwqYh5
         nfqVZHAnuR8JoDKGXcszM6Qq4p3Pa8q2F+l/LiFBd2pD8byT8SsrtPbOPgLlRIgTazVm
         pANtLdrtoVuO+9sWju/UdYo76GQIFUe8gYljAqeOY/xFj3HzKLzLeb79t3AyJ50cNn01
         /57q1JSPytMvhhSj2IF5mOKY49ctgBL0rjqdWBp8IJMjXI8RfNGWOp3kKvMcEEU51EQp
         TEHySey4OsE2rNAYttFgLNc/9XPyZJRTsjc9BJFsj0aXrsSCWr5llD0EZFouZ4TgENIG
         vqvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=L18Z1pkukvs4+t/dQnfMfP/fIVsDfb5z1Omz/Ism5ts=;
        b=KLxYWbHsS6byRN1uYMp0Xc0RmLV0PihCCUKKh8l/m11a2XV6tTH0xy7ssrF0KiE+AV
         nXWBVJDzaoXUSp5VLmj2LRshXueZAY/xAYekLE2xXVYEmFj0wRcSUp2xhR1FPhqAXRQg
         scjgZ1ucI/gnAogUBP2UlbP82CvzRAR2ml978kYLZHDBTcRPVwgqPFxj29BvFrz1MHK2
         +HWMsfO6C7r1VWUIakyz7SWOtjzAUscGhxGP+gE3UHemKPfF5OfDAQKtjmk9CTheVYvf
         vqSoSajAo6yQHHxcVAz2ZQ0F1wQdaJnZHITWnGYI0v3zRqM9eraK/PEDh5M2pktdpTMy
         baDw==
X-Gm-Message-State: APjAAAXZ82fy/8sGcQtPHOMZI2n9AmaXgVEessOX0c73YpERyl8so9T2
        R4+B9xGiQ2Co6yzSKkJaQe5BX5+qEyU=
X-Google-Smtp-Source: APXvYqwxQz+GSnU8WW4L1taEBxK16pIAcgaD8Nul8USX6bWzDwXapUFPSs11LTqeXfXQZdjM1jCpKA==
X-Received: by 2002:a7b:c7c7:: with SMTP id z7mr174841wmk.133.1574706344692;
        Mon, 25 Nov 2019 10:25:44 -0800 (PST)
Received: from dell ([95.149.164.72])
        by smtp.gmail.com with ESMTPSA id x8sm149912wmi.10.2019.11.25.10.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 10:25:43 -0800 (PST)
Date:   Mon, 25 Nov 2019 18:25:29 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 3/8] arm64: fix for bad_mode() handler to always
 result in panic
Message-ID: <20191125182529.GH3296@dell>
References: <20191122105253.11375-1-lee.jones@linaro.org>
 <20191122105253.11375-3-lee.jones@linaro.org>
 <20191125134700.GA5861@sasha-vm>
 <20191125144429.GF3296@dell>
 <20191125174103.GA2872072@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191125174103.GA2872072@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 25 Nov 2019, Greg KH wrote:

> On Mon, Nov 25, 2019 at 02:44:29PM +0000, Lee Jones wrote:
> > On Mon, 25 Nov 2019, Sasha Levin wrote:
> > 
> > > On Fri, Nov 22, 2019 at 10:52:48AM +0000, Lee Jones wrote:
> > > > From: Hari Vyas <hari.vyas@broadcom.com>
> > > > 
> > > > [ Upstream commit e4ba15debcfd27f60d43da940a58108783bff2a6 ]
> > > > 
> > > > The bad_mode() handler is called if we encounter an uunknown exception,
> > > > with the expectation that the subsequent call to panic() will halt the
> > > > system. Unfortunately, if the exception calling bad_mode() is taken from
> > > > EL0, then the call to die() can end up killing the current user task and
> > > > calling schedule() instead of falling through to panic().
> > > > 
> > > > Remove the die() call altogether, since we really want to bring down the
> > > > machine in this "impossible" case.
> > > 
> > > Should this be in newer LTS kernels too? I don't see it in 4.14. We
> > > can't take anything into older kernels if it's not in newer ones - we
> > > don't want to break users who update their kernels.
> > 
> > Only; 3.18, 4.4, 4.9 and 5.3 were studied.
> > 
> > I can look at others if it helps.
> 
> You have to look at others, we can't have regressions if people move
> from one LTS to a newer one.

Sure, I understand. Will do from now on.

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
