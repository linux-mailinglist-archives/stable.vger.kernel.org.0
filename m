Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C072F1FA1
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 21:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbfKFUSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 15:18:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:55378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbfKFUSX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 15:18:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEEFD214D8;
        Wed,  6 Nov 2019 20:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573071501;
        bh=RZc8ZIMEe2SCefuRLeimiRuazGPQHYNlwf5zWfHpY8o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S4njCz4cCOugJAg7XCTtPKSoLtiwTDJKSJIWekkzYNK5yqOg2t3om1F7o/GK/9Ib/
         wL7R00GiJi5KniNApXYupyAmsG+AyCx8G1WlGm0OQlIEOHhjCBMqZ22XZi5IhkLOse
         3YCzYdyYHCrcgnTwx8qVCKkP0oEx9kv7cdEuTeI8=
Date:   Wed, 6 Nov 2019 21:18:18 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/93] 4.19.81-stable review
Message-ID: <20191106201818.GA105063@kroah.com>
References: <20191027203251.029297948@linuxfoundation.org>
 <20191029162419.cumhku6smn2x2bq4@ucw.cz>
 <20191029180233.GA587491@kroah.com>
 <20191106185932.GA2183@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106185932.GA2183@amd>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 06, 2019 at 07:59:32PM +0100, Pavel Machek wrote:
> On Tue 2019-10-29 19:02:33, Greg Kroah-Hartman wrote:
> > On Tue, Oct 29, 2019 at 05:24:19PM +0100, Pavel Machek wrote:
> > > > This is the start of the stable review cycle for the 4.19.81 release.
> > > > There are 93 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
> > > > Anything received after that time might be too late.
> > > 
> > > > Date: Tue, 29 Oct 2019 10:19:29 +0100
> > > > From: Greg KH <gregkh@linuxfoundation.org>
> > > > To: linux-kernel@vger.kernel.org, Andrew Morton
> > > > Subject: Linux 4.19.81
> > > 
> > > > [-- The following data is signed --]
> > > 
> > > >  I'm announcing the release of the 4.19.81 kernel.
> > > 
> > > > All users of the 4.19 kernel series must upgrade.
> > > 
> > > Am I confused or was the 4.19.81 released a bit early?
> > 
> > I said:
> > 	Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
> > 
> > And I released at:
> > 	Date: Tue, 29 Oct 2019 10:19:29 +0100
> > 
> > So really, I was a few minutes late :)
> 
> I'm confused. You said "by Tue ... 08:27:02 PM UTC". That 8 PM is 20h,
> but did the release on 10h GMT+1, or 9h UTC -- 9 AM.... so like 11
> hours early, if I got the timezones right.
> 
> Does PM mean something else in the above context?

Ugh, no, you are right, I was ignoring the PM thing, I thought the -u
option to date would give me a 24 hour date string, and so I thought
that was 8:27 in the morning.

Let me mess around with 'date' to see if I can come up with a better
string to use here.  I guess:
	date --rfc-3339=seconds -u
would probably be best?

thanks,

greg k-h
