Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F7E5FC726
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 16:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiJLOVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 10:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiJLOVs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 10:21:48 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA3CCAE58;
        Wed, 12 Oct 2022 07:21:46 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 29CELeMh028090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 10:21:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1665584501; bh=J6a6VIyEzUMRpbDIUXDP84uOVaF5el/zhaaj5YEX97w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=WVvV3nLkuRB9whMaM9Wup1SxN/8urRDrrGzGOmobE7mp74ahEuQ+tzt9L06e/LB5b
         2Vvxz1b2TCNKm3Iaw4ye2LWelkG9cAhsVPyTQjg3f9EnpDLtcqJuV/j3D5YFSYhJ1M
         Ps+J+lTkBqn9cmY61zkRKwVls0zPL4b7jj4IR+yaJpgQdmtYxzhaIRglj0ZsupcvwU
         BG40RDJ3utIrx0QPdT6e5gSWy8LTyG8n8krQHM/+TeC6afn2HBrsnekFGIe7J+Z21m
         8Pyni2WSq4AvkA6oRx00eCrIrSz/rFSyo2ensjKKI2s8QCrh6tvSu8sy4YumLFrYlt
         ndmnKziJphX8Q==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id F0C8515C3AC9; Wed, 12 Oct 2022 10:21:39 -0400 (EDT)
Date:   Wed, 12 Oct 2022 10:21:39 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] ext4: fix BUG_ON() when directory entry has invalid
 rec_len
Message-ID: <Y0bNc9XZA5wXNJMX@mit.edu>
References: <20221010142035.2051-1-lhenriques@suse.de>
 <20221012131330.32456-1-lhenriques@suse.de>
 <Y0a+Ommsgm4ogo7u@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y0a+Ommsgm4ogo7u@suse.de>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 12, 2022 at 02:16:42PM +0100, Luís Henriques wrote:
> Grr, looks like I accidentally reused a 'git send-email' from shell
> history which had a '--in-reply-to' in it.  Please ignore and sorry about
> that.  I've just resent a new email.

No worries!  The --in-reply-to wasn't actually a problem, since b4
generally will do the right thing (and sometimes humans prefer the
in-reply-to since they can more easily see the patch that it is
replacing/obsoleting).

b4 can sometimes get confused when a patch series gets split, and both
parts of the patch series are in a reply-to mail thread to the
original patch series, since if it can't use the -vn+1 hueristic or
the "subject line has stayed the same but has a newer date" hueristic,
it falls back to "latest patch in the mail thread".  So if there are
two "valid" patches or patch series in an e-mail thread, b4 -c
(--check-newer-revisions) can get confused.  But even in that case,
that it's more a minor annoyance than anything else.

So in the future, don't feel that you need to resend a patch if
there's an incorrect/older --in-reply-to; it's not a big deal.

Cheers, and thanks!

						- Ted
