Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 278B4E8EE8
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 19:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730036AbfJ2SCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 14:02:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729496AbfJ2SCj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Oct 2019 14:02:39 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2225220830;
        Tue, 29 Oct 2019 18:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572372156;
        bh=tam/vdvRmWiQuMdkTFiryx+Yc+aYI6npBacdppufB7k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VPs9HYjWRYYoKQ+Vv5fy48pbx5XYV5bRXDhkkucRcURDm6cNd2OUuCZHcgoBEB11p
         6K9w5ambrga/MjkkIb0I5oTibMswn5rDUHzp8lZYQZpBXBacCwJP2PzTcQ9XFZE6pY
         903CAziGMVRZFOWB1zHGVZWGKZC0ZwSobG+ig5eo=
Date:   Tue, 29 Oct 2019 19:02:33 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/93] 4.19.81-stable review
Message-ID: <20191029180233.GA587491@kroah.com>
References: <20191027203251.029297948@linuxfoundation.org>
 <20191029162419.cumhku6smn2x2bq4@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029162419.cumhku6smn2x2bq4@ucw.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 29, 2019 at 05:24:19PM +0100, Pavel Machek wrote:
> > This is the start of the stable review cycle for the 4.19.81 release.
> > There are 93 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
> > Anything received after that time might be too late.
> 
> > Date: Tue, 29 Oct 2019 10:19:29 +0100
> > From: Greg KH <gregkh@linuxfoundation.org>
> > To: linux-kernel@vger.kernel.org, Andrew Morton
> > Subject: Linux 4.19.81
> 
> > [-- The following data is signed --]
> 
> >  I'm announcing the release of the 4.19.81 kernel.
> 
> > All users of the 4.19 kernel series must upgrade.
> 
> Am I confused or was the 4.19.81 released a bit early?

I said:
	Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.

And I released at:
	Date: Tue, 29 Oct 2019 10:19:29 +0100

So really, I was a few minutes late :)

I generally just wait for the big testers to come back with responses.
If I have all of them looking good, I often times release early
depending on what is happening with my travel and other things.  But
this time, I actually took the whole time I said I would.

thanks,

greg k-h
