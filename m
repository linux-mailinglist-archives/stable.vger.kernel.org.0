Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285073EB96F
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241269AbhHMPru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:47:50 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:33208 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S236818AbhHMPru (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 11:47:50 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 17DFkcxM032109
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 11:46:39 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 8D68F15C37C1; Fri, 13 Aug 2021 11:46:38 -0400 (EDT)
Date:   Fri, 13 Aug 2021 11:46:38 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Willy Tarreau <w@1wt.eu>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, jason@jlekstrand.net,
        Jonathan Gray <jsg@jsg.id.au>
Subject: Re: Determining corresponding mainline patch for stable patches Re:
 [PATCH 5.10 125/135] drm/i915: avoid uninitialised var in eb_parse()
Message-ID: <YRaT3u4Qes8UY3x6@mit.edu>
References: <20210810173000.050147269@linuxfoundation.org>
 <20210811072843.GC10829@duo.ucw.cz>
 <YROARN2fMPzhFMNg@kroah.com>
 <20210811122702.GA8045@duo.ucw.cz>
 <YRPLbV+Dq2xTnv2e@kroah.com>
 <20210813093104.GA20799@duo.ucw.cz>
 <20210813095429.GA21912@1wt.eu>
 <20210813102429.GA28610@duo.ucw.cz>
 <YRZRU4JIh5LQjDfE@kroah.com>
 <20210813111953.GB21912@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813111953.GB21912@1wt.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 13, 2021 at 01:19:53PM +0200, Willy Tarreau wrote:
> 
> Plus this adds some cognitive load on those writing these patches, which
> increases the global effort. It's already difficult enough to figure the
> appropriate Cc list when writing a fix, let's not add more burden in this
> chain.
> 
> ...
> 
> I'm also defending this on other projects. I find it important that
> efforts are reasonably shared. If tolerating 1% failures saves 20%
> effort on authors and adds 2% work on recipients, that's a net global
> win. You never completely eliminate mistakes anyway, regardless of the
> cost.

The only way I can see to square the circle would be if there was some
kind of script that added enough value that people naturally use it
because it saves *them* time, and it automatically inserts the right
commit metadata in some kind of standardized way.

I've been starting to use b4, and that's a great example of a workflow
that saves me time, and standardizes things as a very nice side
effect.  So perhaps the question is there some kind of automation that
saves 10-20% effort for authors *and* improves the quality of the
patch metadata for those that choose to use the script?

      	       	   	      	     - Ted
