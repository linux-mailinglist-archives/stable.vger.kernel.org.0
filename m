Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0727E647D94
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 07:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiLIGNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 01:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiLIGM7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 01:12:59 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2143E389FE
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 22:12:59 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2B96CfdR004641
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 9 Dec 2022 01:12:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1670566364; bh=T59azuiB5UNmS9YVB/fHdvT3f2atOSWgkSqOH73lu4c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=AFIwcjw5JA/yOawcoK3DOork1FR2TgzJwtPFuwY8Ew7UpxcUyZR8koeRoJsRs2pQG
         9X9pAs4IiE0pOjpGrSsQOSGpKnbHug1BzafZ/gFG0Bom2uBDsYijdIykwz2eYeZdVy
         cxy8Tm8W13NTAyzK/oKXf+xOzH8qCCS+MMT1TvKSlMjRn4Dag3EvojzIYZvpsG+YQR
         YpAAAKqt9kwNduX+8eajwFLs2vJWKsZbdr0XYI6687yh9AQEobzFm4AWQ7/W4R+CBQ
         JpbKZr9da5IxbA+T7pKY3VcD/PKjIVIImBbus8NLhKZKA/y8zPIjNO5W0YpoKuDG8P
         xkKqJdlE+ctqg==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 271D515C3AE9; Fri,  9 Dec 2022 01:12:41 -0500 (EST)
Date:   Fri, 9 Dec 2022 01:12:41 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Jan Kara <jack@suse.cz>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org,
        Thilo Fromm <t-lo@linux.microsoft.com>,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH] ext4: Fix deadlock due to mbcache entry corruption
Message-ID: <Y5LR2ffwz39donWu@mit.edu>
References: <20221123193950.16758-1-jack@suse.cz>
 <20221201151021.GA18380@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <9c414060-989d-55bb-9a7b-0f33bf103c4f@leemhuis.info>
 <Y5F8ayz4gEtKn0LF@mit.edu>
 <20221208091523.t6ka6tqtclcxnsrp@quack3>
 <Y5IFR4K9hO8ax1Y0@mit.edu>
 <e2a77778-7a2b-2811-95ff-be67a44afceb@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2a77778-7a2b-2811-95ff-be67a44afceb@leemhuis.info>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 08, 2022 at 06:16:02PM +0100, Thorsten Leemhuis wrote:
> 
> Maybe I should talk to Greg again to revert backported changes like
> 1be97463696c until fixes for them are ready.

The fix is in the ext4 git tree, and it's ready to be pushed to Linus
when the merge window opens --- presumably, on Sunday.

So it's probably not worth it to revert the backported change, only to
reapply immediately afterwards.

						- Ted
						
