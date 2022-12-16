Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D736B64E5DC
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 03:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiLPCLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 21:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiLPCLp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 21:11:45 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC79389D6
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 18:11:44 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2BG2BMNq009691
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 21:11:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1671156685; bh=e02A3aKKE1KFtmTpiDh0G9R+xSN1Czem5UA155kzumk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=Gy0di33jqH4RW1/P2M/zt/kI5vJa6AopjA3rbIFhWiWiWftWk1H3lWGBEuoJiU7v8
         Xk2y/tvY8Cj8R71Pkx36zeWRhN0gndP8kL/2vIF61QxVO4I5jwbK8TLOWCfsehcrL6
         rWFQskdFARu2CQohek4PtWq0MSh1CQN6bIT1BVnPERG92dg8CmO+rmnMChTebwxy4z
         eHMvkSmeVgVBwrhQRhL3YiN6SjFCaonqd8vqeiPvl4atn7G2dcppfBgEuB5UdnXFg+
         wkEM9EETSp8l92rI89M3Z6grkboB1+BwIcNHVFJrDOp7PRqVnfQfpJNiD7SB5OatZj
         8a4zaLSfdu8VA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 8834915C40A2; Thu, 15 Dec 2022 21:11:22 -0500 (EST)
Date:   Thu, 15 Dec 2022 21:11:22 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     syzbot <syzbot+15cd994e273307bf5cfa@syzkaller.appspotmail.com>
Cc:     adilger.kernel@dilger.ca, gregkh@linuxfoundation.org,
        lczerner@redhat.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, sashal@kernel.org,
        stable@vger.kernel.org, syzkaller-android-bugs@googlegroups.com,
        tadeusz.struk@linaro.org
Subject: Re: kernel BUG in ext4_free_blocks (2)
Message-ID: <Y5vTyjRX6ZgIYxgj@mit.edu>
References: <0000000000006c411605e2f127e5@google.com>
 <000000000000b60c1105efe06dea@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000b60c1105efe06dea@google.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SORTED_RECIPS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 15, 2022 at 08:34:35AM -0800, syzbot wrote:
> This bug is marked as fixed by commit:
> ext4: block range must be validated before use in ext4_mb_clear_bb()
> But I can't find it in any tested tree for more than 90 days.
> Is it a correct commit? Please update it by replying:
> #syz fix: exact-commit-title
> Until then the bug is still considered open and
> new crashes with the same signature are ignored.

I don't know what is going on with syzkaller's commit detection, but
commit 1e1c2b86ef86 ("ext4: block range must be validated before use
in ext4_mb_clear_bb()") is an exact match for the commit title, and
it's been in the upstream kernel since v6.0.

How do we make syzkaller accept this?  I'll try this again, but I
don't hold out much hope.

#syz fix: ext4: block range must be validated before use in ext4_mb_clear_bb()

Syzkaller, go home, you're drunk.

					- Ted
