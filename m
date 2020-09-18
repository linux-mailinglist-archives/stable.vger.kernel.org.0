Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9E027033B
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 19:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgIRR0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 13:26:47 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:53774 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726115AbgIRR0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Sep 2020 13:26:47 -0400
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 13:26:47 EDT
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 08IHIwEN007851
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Sep 2020 13:18:59 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 4850A42003C; Fri, 18 Sep 2020 13:18:58 -0400 (EDT)
Date:   Fri, 18 Sep 2020 13:18:58 -0400
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 059/206] ext4: make dioread_nolock the
 default
Message-ID: <20200918171858.GA80112@mit.edu>
References: <20200918020802.2065198-1-sashal@kernel.org>
 <20200918020802.2065198-59-sashal@kernel.org>
 <20200918025859.GB3518637@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918025859.GB3518637@gmail.com>
/From:  "Theodore Y. Ts'o" <tytso@mit.edu>
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 17, 2020 at 07:58:59PM -0700, Eric Biggers wrote:
> On Thu, Sep 17, 2020 at 10:05:35PM -0400, Sasha Levin wrote:
> > From: Theodore Ts'o <tytso@mit.edu>
> > 
> > [ Upstream commit 244adf6426ee31a83f397b700d964cff12a247d3 ]
> > 
> > This fixes the direct I/O versus writeback race which can reveal stale
> > data, and it improves the tail latency of commits on slow devices.
> > 
> > Link: https://lore.kernel.org/r/20200125022254.1101588-1-tytso@mit.edu
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>I
> 
> Any particular reason to be backporting this?  I thought I saw some fixes for
> dioread_nolock go by, after it was made the default.  Are you getting all of
> those fixes too?

Agreed, making dioread_nolock the default has enough issues that it's
not something that I'd suggest backporting at this point.  It's a
fundamental behavioral change that it's not something we should change
in a stable kernel.

						- Ted
