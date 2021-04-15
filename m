Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7AA136117D
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 19:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhDORyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 13:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbhDORyn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 13:54:43 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0D6C061574
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 10:54:19 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id i81so25121121oif.6
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 10:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MZypM2t9l4gIlVld1qgqMTpgVoFc7wgEBxIOTYk487k=;
        b=fovBMNzEh3KjM2DaYas9paqhZ/gw1dsTigGeQNI+eJ9TRVoJo643GAsiEPcNPflQ4k
         xHNYKikX9qTA2xLts+aAPj8WHysQdaDsE/W4KRPGlnu75TrvokB3WDKdZZX7fVm+Zh5V
         GiXAu5dzP3DOkWFGy5BugoatPvvi7FSOcBBsJmA6gm5Aom0z/grNtzUq1n0JqHDWKvuu
         YzaEvgfqMmFM8QSodvZZcipWvzA2RNVsLL+14rdRYWS93gNx8Efz8K2o/02P+kEuHfhG
         d/vvJgbexPygLv3MHGb4jWBpV3AgcPDbxL7ZlHJ2r7E5dyg4B3piyIitVacPKWm+ixx/
         GKeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=MZypM2t9l4gIlVld1qgqMTpgVoFc7wgEBxIOTYk487k=;
        b=piC9LZCDC/ghfatt17VQLbEIuDVJ2gUG/dmxmtYonJHxug7PGkLP9mZ5jrSP+XR8Qc
         5ScNwGpJu0tytWkLTLyGrfxq0I6fUZZ/Z3p0DW/YZ2KNl3vfwuyPnvwgBltJ4OkI8Hc/
         Qv6vkQP1rsmEPQLktjMy0Bx4cLZK3AEcZQNuS6ZGkLPjZBR+eqw38bzu/4gkPKsqeTmT
         Yd0wQXnPfkU7cnrX5ep/NtazJEwfj31rFi/SygoQ/Ny/2l7Tm8gL5Nw0TKK3Ix9hTtqX
         VAMC6Y9k1fsGUpn63RAXLJfMgcmex47E7jB/HE2Pp7PkdDKYmoNs6UiWLJ/CRCb8Bqxm
         hsxw==
X-Gm-Message-State: AOAM531MO3SqI6Rw5JKnW/QETV42vfk1SgPezdHABiz8vtdmwRBmBmqL
        nQeL92Zgdl91Gjf8chb/N/UXMpP7A7c=
X-Google-Smtp-Source: ABdhPJzdqDoDGQPiOp7getTfk6j8kS7U9ehE3znceAgGWHDOMX+BHwvenaHbf2ZyCeYNwa8Vzk9cmw==
X-Received: by 2002:aca:4c45:: with SMTP id z66mr3289506oia.39.1618509259387;
        Thu, 15 Apr 2021 10:54:19 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e44sm791646ote.21.2021.04.15.10.54.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Apr 2021 10:54:18 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 15 Apr 2021 10:54:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: netfilter/x_tables patches for v4.4.y..v4.14.y
Message-ID: <20210415175417.GA30883@roeck-us.net>
References: <1780f159-140b-231f-8af5-ccec049dc8b0@roeck-us.net>
 <YHhr1WuX4/0l+9lP@kroah.com>
 <20210415174950.GB30478@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415174950.GB30478@roeck-us.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 10:49:50AM -0700, Guenter Roeck wrote:
> On Thu, Apr 15, 2021 at 06:37:41PM +0200, Greg Kroah-Hartman wrote:
> > On Thu, Apr 15, 2021 at 09:28:15AM -0700, Guenter Roeck wrote:
> > > Hi Greg,
> > > 
> > > please consider applying the following two patches to v4.4.y, v4.9.y, and v4.14.y
> > > 
> > > 80055dab5de0 ("netfilter: x_tables: make xt_replace_table wait until old rules are not used anymore")
> > > 175e476b8cdf ("netfilter: x_tables: Use correct memory barriers.")
> > 
> > The second patch here says that it's only needed to go back until:
> > 	    Fixes: 7f5c6d4f665b ("netfilter: get rid of atomic ops in fast path")
> > 
> > Which is only backported to 4.19.  So why do older kernels need that, is
> > the fixes tag wrong?
> > 
> 
> Outch, it looks like 80055dab5de0 was fixed later with cc00bcaa5899, which in
> turn was fixed with 443d6e86f821. Ok, back to the drawing board, but it may
> just be easier to forget about this. I'll let you know.
> 
I tried to apply cc00bcaa5899 on top of the above, and got lots of conflicts.
Please ignore this request; it adds more risk than gain. Sorry for the noise.

Guenter
