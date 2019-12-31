Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 858CF12D641
	for <lists+stable@lfdr.de>; Tue, 31 Dec 2019 06:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725497AbfLaFT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Dec 2019 00:19:29 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38052 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbfLaFT3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Dec 2019 00:19:29 -0500
Received: by mail-pf1-f194.google.com with SMTP id x185so19284851pfc.5;
        Mon, 30 Dec 2019 21:19:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ivU65/NEHr8NxE4UXqjVcxeiWY4yLxxxVJAVJn7mSXQ=;
        b=Fcux44SQS4OoQSMT5bNFMTI1Q+II9zWTMCvej5mJq6XGNN+OEctS6arR+OHpNitIlT
         9dVSutg9z80Psr8IjMIZGIw+LIqVeSoTqpNEvWHw/DVo7EzPUIDd+P1+6EtgRM4KUdH1
         jmV4AROxOzZQYG98xF4lXAKi4huNjSwaKcotS8qsnVcc/rXkCfMy+oY2wVPMsyLhCjlk
         1y/OP25XdFcql5VC2bCmwKpR1AeUqM/OfqUmsf7ldX3Q0qtirs20XXxbaf8rB99cyhE3
         fE1QT0LubCW5e0jPg6ugAFSLRUSVTTvNA07diWI48kMbZngyIK6Bej8tP4T+STD/gmuj
         FOHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=ivU65/NEHr8NxE4UXqjVcxeiWY4yLxxxVJAVJn7mSXQ=;
        b=GU1M66RROlHOZ6zgdWqkWMPNLzo5EtUjLj+xGqAOgqxNtI3KwHAmaJQbRTw6/9Jz1e
         vKE9DLgXqffHf92w7e+/lzlJVuzAumarrbg9p3DP+2XggvMxRXCTMNNNEOtG0EMrZ6n4
         AlXf+uvn6/GtbzPV6dR0kKa64d783JJA3rKOu0JhcvKhmlvktoOy5iiOAeItz5rXA0Pv
         UxAsZryt/nTqbDwEO71ZiswqgfUTKuGzK0gficAv1geDhv7ME8ddMM7sifAeBkM+1K90
         XiepoOxWV70nuZqWDUrIoNsS+hOQvu2yRwZ3zZWZDGqnyCdXhu5hukclMTs5QPMWFIv4
         oEAg==
X-Gm-Message-State: APjAAAUKpOCYi7mftD8faNbuX0+kO3xWUi71htYggKHTPZJGmaSzQSEZ
        r2W+CqTcZn9+zve3nt2HOB4=
X-Google-Smtp-Source: APXvYqz3M2/xM3sOxlZIZCstEn6bRYobAENHqSxulQ92oXSDQh07sQJQRMAOpksPqEaoaCPWL7cg3Q==
X-Received: by 2002:aa7:9d9c:: with SMTP id f28mr75850263pfq.20.1577769568590;
        Mon, 30 Dec 2019 21:19:28 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d22sm52156637pfo.187.2019.12.30.21.19.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 30 Dec 2019 21:19:28 -0800 (PST)
Date:   Mon, 30 Dec 2019 21:19:27 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/434] 5.4.7-stable review
Message-ID: <20191231051927.GB15160@roeck-us.net>
References: <20191229172702.393141737@linuxfoundation.org>
 <20191230163437.sz4mb5gh7ed2htfa@xps.therub.org>
 <20191230174522.GA1499079@kroah.com>
 <20191230180849.222x3hg2tnpwz7dn@xps.therub.org>
 <20191230194204.GB1880685@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191230194204.GB1880685@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 30, 2019 at 08:42:04PM +0100, Greg Kroah-Hartman wrote:
> On Mon, Dec 30, 2019 at 12:08:49PM -0600, Dan Rue wrote:
> > On Mon, Dec 30, 2019 at 06:45:22PM +0100, Greg Kroah-Hartman wrote:
> > > On Mon, Dec 30, 2019 at 10:34:37AM -0600, Dan Rue wrote:
> > > > On Sun, Dec 29, 2019 at 06:20:53PM +0100, Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 5.4.7 release.
> > > > > There are 434 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > 
> > > > Results from Linaro’s test farm.
> > > > No regressions on arm64, arm, x86_64, and i386.
> > > 
> > > Thanks for testing all of these and letting me know.
> > > 
> > > But didn't you add perf build testing to your builds?  That should have
> > > broken things, so I am guessing not :(
> > 
> > We do build (and run) perf, and it worked for us. Which patch was the
> > problem? I can go look at why our config didn't hit the offending
> > code/build path.
> 
> See the thread from Guenter and from others on the perf patches
> themselves in this release for the details.
> 

perf is a beast. It only builds everything if a large number of
support libraries is installed on the build system. If not, it
only builds a small subset. I bet my test builds hit the failure
because I have some library installed on my build servers that
isn't installed on Linaro's servers.

This is why I can't cross-build perf; my cross build environments
don't have the necessary libraries installed.

Guenter
