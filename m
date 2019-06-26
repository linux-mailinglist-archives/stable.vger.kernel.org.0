Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4169B55D1D
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 02:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfFZA4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 20:56:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfFZA4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 20:56:36 -0400
Received: from localhost (unknown [172.104.248.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5BED2085A;
        Wed, 26 Jun 2019 00:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561510596;
        bh=1Yn03Rjc0Dsl67UmKg+X4ZaAmh6r+eCtufUORVgVs8c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TcFccI61SGi2+Jo02D7xnTTBPS6heNLYVVimjxhM6Li3T5yQvL4Kl/XYe2Ytdb8tZ
         Wp6EOQOdWqGgfvPxrx9iaDRUjidp5nBqkStZIo8G12IKNyGXJjBlT2zI7VUyCGoGRf
         RrEedvEAn78UZ6Aas2pvw9iE7TF9twgk3SJet4PA=
Date:   Wed, 26 Jun 2019 08:50:43 +0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Josh Hunt <johunt@akamai.com>, edumazet@google.com,
        stable@vger.kernel.org, jbaron@akamai.com
Subject: Re: [PATCH 4.14] tcp: refine memory limit test in tcp_fragment()
Message-ID: <20190626005043.GB21530@kroah.com>
References: <1561483177-30254-1-git-send-email-johunt@akamai.com>
 <20190625202626.GD7898@sasha-vm>
 <4c6d6697-b629-243c-824b-8080ee1e1635@akamai.com>
 <20190625224050.GE7898@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625224050.GE7898@sasha-vm>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 25, 2019 at 06:40:50PM -0400, Sasha Levin wrote:
> On Tue, Jun 25, 2019 at 01:29:35PM -0700, Josh Hunt wrote:
> > On 6/25/19 1:26 PM, Sasha Levin wrote:
> > > On Tue, Jun 25, 2019 at 01:19:37PM -0400, Josh Hunt wrote:
> > > > Backport of dad3a9314ac95dedc007bc7dacacb396ea10e376:
> > > 
> > > You probably meant b6653b3629e5b88202be3c9abc44713973f5c4b4 here.
> > 
> > I wasn't sure if I should reference the upstream commit or stable
> > commit. dad3a9314 is the version of the commit from linux-4.14.y. There
> > may be a similar issue with the Fixes tag below since that also
> > references the 4.14 vers of the change.
> 
> We try to just reference upstream commits when possible. I can edit
> these if this patch will be merged.

I think for this issue we will do as was mentioned in other responses in
this thread.

But, to the topic of original sha1 ids, I think I need to document how
we have been using these in a much better way.  It's a very powerful way
to determine what is fixed where and allows people to properly audit
fixes and how they propagate around different kernel trees, distros
included.

I've been talking to other projects and they like how we have been doing
this and want to copy it, so I guess it's time to actually describe what
we do here :)

thanks,

greg k-h
