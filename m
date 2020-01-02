Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10CEC12EB5E
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 22:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgABV2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 16:28:40 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40499 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgABV2k (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 16:28:40 -0500
Received: by mail-pg1-f196.google.com with SMTP id k25so22479118pgt.7
        for <stable@vger.kernel.org>; Thu, 02 Jan 2020 13:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hvpWTN6e4RnlgXWsJ95hXmR8kwS5bjTaUI17lXlqFb4=;
        b=K5NDO+/7A5gcJkr0169Vk6rRb+F08BFqVKjgtY3hle/mN3yW5qgCpM2+qsse+iVAjg
         SDoedQVZSUuAdQAxIlC4NufghQ7ADyHK2RO7yv31diYUxORr+EepiR0a7yM849QxqbZP
         mQRu8hsnZFCKRbNnvcei24IgiNjy2ZjfB1TcP7U0qpAsNo7HzlrhodPoGbOZGuhmA4OO
         zQe0LrfhnEXXsNBX121NYvWzyrLct/jV4I3VENp8XAPukiju9UTuPOJknKkUVpqd1uCi
         mfHh9sHu8iiM4paLqGhzoeBDRX+NrtX0Te2T1rUFYbK4SprV2+OyeJ0LVwMtV9q9sjpa
         mp1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=hvpWTN6e4RnlgXWsJ95hXmR8kwS5bjTaUI17lXlqFb4=;
        b=cCslWa+5Lt3PIpdk0ZcT5Au4Ik9hxAg6F0sY3sBxQMXKiI9C1aCuNCjTAo9X2t8VzF
         O5wJr1oNJrCB3SD9RJp7vgjvSuh4+oBsVh/07ETXp10DvOokR7n8ZYBfY8qCCyNBblH8
         iJTC4AesrT5xrs2lnXXERG06q7o+MGd03+CzFsl7RHugHSZTQU3VXEyJlL6XpAfFq3R4
         trUrNrwXt74X+ev5okrpvgMcK1XKfWf8i6TqIDSkbKxJD0S7D5BD061KcV6nrnSDVORh
         X5ruEuWUENPKnvUHZQCVP/0njjSvNWsrmki8qHXO7lm9SoUFLCToUxLoZWhtsZquqeLg
         ohhw==
X-Gm-Message-State: APjAAAXLkY/2iWTnRfKDuF0nuOeT+5bGPk54FQ6CvlnWyMZGtYl3vkk2
        UpDgc/HUoGx3cyQAEKiP0I4=
X-Google-Smtp-Source: APXvYqxoKDzOwCnUMaJ9zy15JFpUknLmupbULghr0LLxSB0UKHZvQ1fRW3Ub3/gVRkESCOPWXHVSXg==
X-Received: by 2002:a63:f107:: with SMTP id f7mr92451094pgi.76.1578000519308;
        Thu, 02 Jan 2020 13:28:39 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w11sm64002644pfn.4.2020.01.02.13.28.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 02 Jan 2020 13:28:38 -0800 (PST)
Date:   Thu, 2 Jan 2020 13:28:37 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>, Stephen Boyd <sboyd@kernel.org>
Subject: Re: Clock related crashes in v5.4.y-queue
Message-ID: <20200102212837.GA9400@roeck-us.net>
References: <029dab5a-22f5-c4e9-0797-54cdba0f3539@roeck-us.net>
 <20200102210119.GA250861@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102210119.GA250861@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 02, 2020 at 10:01:19PM +0100, Greg Kroah-Hartman wrote:
> On Wed, Jan 01, 2020 at 06:44:08PM -0800, Guenter Roeck wrote:
> > Hi,
> > 
> > I see a number of crashes in the latest v5.4.y-queue; please see below
> > for details. The problem bisects to commit 54a311c5d3988d ("clk: Fix memory
> > leak in clk_unregister()").
> > 
> > The context suggests recovery from a failed driver probe, and it appears
> > that the memory is released twice. Interestingly, I don't see the problem
> > in mainline.
> > 
> > I would suggest to drop that patch from the stable queue.
> 
> That does not look right, as you point out, so I will go drop it now.
> 
> The logic of the clk structure lifetimes seems crazy, messing with krefs
> and just "knowing" the lifecycle of the other structures seems like a
> problem just waiting to happen...
> 

I agree. While the patch itself seems to be ok per Stephen's feedback,
we have to assume that there will be more secondary failures in addition
to the one I have discovered. Given that clocks are not normally
unregistered, I don't think fixing the memory leak is important enough
to risk the stability of stable releases.

With all that in mind, I'd rather have this in mainline for a prolonged
period of time before considering it for stable release (if at all).

Thanks,
Guenter
