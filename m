Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1338C4EB0D9
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 17:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236598AbiC2Pkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 11:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234581AbiC2Pkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 11:40:55 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ECE111BD98;
        Tue, 29 Mar 2022 08:39:08 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 22TFcn3E001516
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Mar 2022 11:38:50 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id AE79A15C3ECA; Tue, 29 Mar 2022 11:38:49 -0400 (EDT)
Date:   Tue, 29 Mar 2022 11:38:49 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Subject: Re: [PATCH AUTOSEL 5.17 16/43] random: use computational hash for
 entropy extraction
Message-ID: <YkMoCe+uX6UxfaeM@mit.edu>
References: <20220328111828.1554086-1-sashal@kernel.org>
 <20220328111828.1554086-16-sashal@kernel.org>
 <YkH5mhYokPB87FtE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkH5mhYokPB87FtE@google.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 28, 2022 at 06:08:26PM +0000, Eric Biggers wrote:
> On Mon, Mar 28, 2022 at 07:18:00AM -0400, Sasha Levin wrote:
> > From: "Jason A. Donenfeld" <Jason@zx2c4.com>
> > 
> > [ Upstream commit 6e8ec2552c7d13991148e551e3325a624d73fac6 ]
> > 
> 
> I don't think it's a good idea to start backporting random commits to random.c
> that weren't marked for stable.  There were a lot of changes in v5.18, and
> sometimes they relate to each other in subtle ways, so the individual commits
> aren't necessarily safe to pick.
> 
> IMO, you shouldn't backport any non-stable-Cc'ed commits to random.c unless
> Jason explicitly reviews the exact sequence of commits that you're backporting.

Especially this commit in general, which is making a fundamental
change in how we extract entropy.  We should be very careful about
taking such changes into stable; a release or two of additonal "soak"
time would be a good idea before these go into the LTS releases in particular.

     	      	     	  	       	  - Ted
