Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC8F18EFE9
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 07:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgCWGs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 02:48:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbgCWGs1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Mar 2020 02:48:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A309A20736;
        Mon, 23 Mar 2020 06:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584946107;
        bh=qOFlhZkujaC+JRP+KmxtYFhSXy30kHvp1QbjUTFusoE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S0zzGYG+/Phb/0Ly9A+0B24iiyIaboKqCx9HCcV5zBR7HZRPVBYJm8Cct/6B/7uRo
         tJkcHncvw4MWEkxurkVKzRkMujdvxxvjD3Dn8G/4nJtk7MZYyB3acp/UapGU0Y86xH
         ngpYL4yzi5LWbGPkYvwmlCeAjNZsxb7wTYwEd4iM=
Date:   Mon, 23 Mar 2020 07:48:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Sasha Levin <sashal@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Kevin Hao <haokexin@gmail.com>
Subject: Re: [PATCH 5.5 00/65] 5.5.11-rc1 review
Message-ID: <20200323064823.GC129571@kroah.com>
References: <20200319123926.466988514@linuxfoundation.org>
 <fcf6db4c-cebe-9ad3-9f19-00d49a7b1043@roeck-us.net>
 <20200319145900.GC92193@kroah.com>
 <32c627bf-0e6b-8bc4-88d3-032a69484aa6@roeck-us.net>
 <20200320144658.GK4189@sasha-vm>
 <20200322195134.GA3127@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200322195134.GA3127@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 22, 2020 at 08:51:34PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > > Thanks for letting me know, I've now dropped that patch (others
> > > > complained about it for other reasons) and will push out a -rc2 with
> > > > that fix.
> > > > 
> > > 
> > > I did wonder why the offending patch was included, but then I figured that
> > > I lost the "we apply too many patches to stable releases" battle, and I didn't
> > > want to re-litigate it.
> > 
> > I usually much rather take prerequisite patches rather than do
> > backports, which is why that patch was selected.
> 
> Unfortunately, that results in less useful -stable.

Not at all, it makes for a _MORE_ useful stable, as we want to mirror
what is in Linus's tree whenever possible.

Come on now, we've been doing this for 17+ years now, it's not new.

greg k-h
