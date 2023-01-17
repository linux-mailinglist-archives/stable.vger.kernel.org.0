Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77174670BCD
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 23:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjAQWnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 17:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjAQWmR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 17:42:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6CB474F8;
        Tue, 17 Jan 2023 14:29:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 295EEB81A37;
        Tue, 17 Jan 2023 22:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24E6C433D2;
        Tue, 17 Jan 2023 22:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673994577;
        bh=qS6ZJxg4vh5cOUtgwsaJZG2uxddKkuZqTHqVL43d+Es=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zdk7JMS9iaxlGp7q27SWD3wL86+NWu6/+7LYPuCR+h1ZmVM4tcjBgGeSX2hM3hxkJ
         4ceulhQZw4soZvhKlyhT15IjoF4inNRzp2oG5BGPIlYp056TfDrIJr128o+mVqmDEr
         ca4Mokh1BV7aUTA3rzgx/o3lC0Yc8xEemDOL0oonTL8NWPmPymZ9ViXEWY0WFbBF6k
         fbzC5PFCSTXW4DU+5RM1CP3nbf5CEs6M32TK+CFtonGTQMzcEQioFom1n2czQaesL9
         QsQaGVlti99waqI0WkjbxCEq+khFplHHNpAUcvXuBPXvJoNEPYRjRCH4LuODvZMSig
         A3UB2HJnSyMUw==
Date:   Tue, 17 Jan 2023 22:29:36 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 5.15 00/10] ext4 fast-commit fixes for 5.15-stable
Message-ID: <Y8chUKeNaULEhM+V@gmail.com>
References: <20230105071359.257952-1-ebiggers@kernel.org>
 <Y7a8B2+AjwxpmTfh@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7a8B2+AjwxpmTfh@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Jan 05, 2023 at 01:01:11PM +0100, Greg KH wrote:
> On Wed, Jan 04, 2023 at 11:13:49PM -0800, Eric Biggers wrote:
> > This series backports 6 commits with 'Cc stable' that had failed to be
> > applied, and 4 related commits that made the backports much easier.
> > Please apply this series to 5.15-stable.
> > 
> > I verified that this series does not cause any regressions with
> > 'gce-xfstests -c ext4/fast_commit -g auto'.  There is one test failure
> > both before and after (ext4/050).
> 
> All now queued up, thanks.
> 
> greg k-h


It's too late to fix now, but the commits in 5.15-stable all use
"Eric Biggers <ebiggers@kernel.org>" as the author instead of the From line in
the patch itself.  For example, patch 1 became:

	commit b0ed9a032e52a175683d18e2e2e8eec0f9ba1ff9
	Author: Eric Biggers <ebiggers@kernel.org>
	Date:   Wed Jan 4 23:13:50 2023 -0800

	    ext4: remove unused enum EXT4_FC_COMMIT_FAILED

	    From: Ritesh Harjani <riteshh@linux.ibm.com>

	    commit c864ccd182d6ff2730a0f5b636c6b7c48f6f4f7f upstream.

For reference, the upstream commit is:

	commit c864ccd182d6ff2730a0f5b636c6b7c48f6f4f7f
	Author: Ritesh Harjani <riteshh@linux.ibm.com>
	Date:   Sat Mar 12 11:09:46 2022 +0530

	    ext4: remove unused enum EXT4_FC_COMMIT_FAILED

Do you know how this happened, and how it can be prevented in the future?  I
think I sent everything out correctly, so I think this is something on your end.

- Eric
