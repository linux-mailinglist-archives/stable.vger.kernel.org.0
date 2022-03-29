Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55AC14EB351
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 20:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240507AbiC2Sav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 14:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240239AbiC2Sat (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 14:30:49 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAECB13CEA;
        Tue, 29 Mar 2022 11:29:05 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 22TISouK030141
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Mar 2022 14:28:51 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 87C3315C3ECA; Tue, 29 Mar 2022 14:28:50 -0400 (EDT)
Date:   Tue, 29 Mar 2022 14:28:50 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Michael Brooks <m@sweetwater.ai>
Cc:     Eric Biggers <ebiggers@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Subject: Re: [PATCH AUTOSEL 5.17 16/43] random: use computational hash for
 entropy extraction
Message-ID: <YkNP4mNOxA6pBqyi@mit.edu>
References: <20220328111828.1554086-1-sashal@kernel.org>
 <20220328111828.1554086-16-sashal@kernel.org>
 <YkH5mhYokPB87FtE@google.com>
 <YkMoCe+uX6UxfaeM@mit.edu>
 <CAOnCY6TNVHLX06mvMZFnNwVx3yE20qnqeGY7fbTx4c2XbyVVEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOnCY6TNVHLX06mvMZFnNwVx3yE20qnqeGY7fbTx4c2XbyVVEw@mail.gmail.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 29, 2022 at 10:34:49AM -0700, Michael Brooks wrote:
> I agree with Ted,  this patch is just to start the discussion on how
> we can safely remove these locks for the improvement of safety and
> security.  Both boot and interrupt benchmarks stand to benefit from a
> patch like this, so it is worth a deep dive.
> 
> Feedback welcome, I am always looking for ways I can be a better
> engineer, and a better hacker and a better person. And we are all here
> to make the very best kernel.

I think you're talking about a different patch than the one mentioned
in the subject line (which is upstream commit 6e8ec2552c7d, authored
by Jason)?

						- Ted
