Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9743E303861
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 09:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390401AbhAZIwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 03:52:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:52502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728011AbhAZIvD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 03:51:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D2FC2220B;
        Tue, 26 Jan 2021 08:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611651009;
        bh=r+BwljJKc2c0oESTZmZi7mMn/3XezW/5bcvRvWpPKmQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j5xOdfrWMGB/+QsiMKnBEbfgqyeFSw15v5/4eowb/RfPG4nbf4E7wMtpHYAVviA0b
         0vQhY0NICMUf9m7hEFnhB5ZYNQVlSZo2BkWwSaXYFI3QkSze2+Q59mBkqEaRkd44Tq
         y8z568/S5zzMtqFFfE4b8dgEQUxGZaBNFzE4xzHE=
Date:   Tue, 26 Jan 2021 09:50:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 4.19 46/58] net: dsa: mv88e6xxx: also read STU state in
 mv88e6250_g1_vtu_getnext
Message-ID: <YA/XvmZrTj4NGqdJ@kroah.com>
References: <20210125183156.702907356@linuxfoundation.org>
 <20210125183158.687957547@linuxfoundation.org>
 <8447247a-6147-32b6-541d-0dd717ac9882@prevas.dk>
 <b3be188e-f874-72be-d3bc-2c0cc06aba53@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3be188e-f874-72be-d3bc-2c0cc06aba53@prevas.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 25, 2021 at 08:59:54PM +0100, Rasmus Villemoes wrote:
> On 25/01/2021 20.40, Rasmus Villemoes wrote:
> > On 25/01/2021 19.39, Greg Kroah-Hartman wrote:
> >> From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> >>
> >> commit 87fe04367d842c4d97a77303242d4dd4ac351e46 upstream.
> >>
> > 
> > Greg, please drop this from 4.19-stable. Details:
> > 
> >>
> >> --- a/drivers/net/dsa/mv88e6xxx/global1_vtu.c
> >> +++ b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
> >> @@ -357,6 +357,10 @@ int mv88e6185_g1_vtu_getnext(struct mv88
> >>  		if (err)
> >>  			return err;
> >>  
> >> +		err = mv88e6185_g1_stu_data_read(chip, entry);
> >> +		if (err)
> >> +			return err;
> >> +
> > 
> > The function that this patch applied to in mainline did not exist in
> > v4.19. It seems that this hunk has been applied in the similar
> > mv88e6185_g1_vtu_getnext(), and indeed, in current 4.19.y, just one more
> > line of context shows this:
> 
> Bah, that was from 4.14, so the line numbers are a bit off, but I see
> you've also added it to the 4.14 queue. Same comment for that one: Drop
> this from both 4.19.y and 4.14.y.

Odd, but ok, the Fixes: line lied :)

I'll go drop this from both trees now, thanks.

greg k-h
