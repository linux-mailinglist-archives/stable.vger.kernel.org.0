Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 009A567CD4F
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 15:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjAZOMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 09:12:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjAZOMV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 09:12:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C4A4A229;
        Thu, 26 Jan 2023 06:12:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65F9061820;
        Thu, 26 Jan 2023 14:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FEBC433EF;
        Thu, 26 Jan 2023 14:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674742335;
        bh=gskoA6PnQf76CojrUW6+F5J1cqjXsrt0xXR9X2h7wRI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nkA9hy/lCSJ6ylkJ66bmjR5eX+RbFcPfIJHaaT+58cmnLf3om3iYWog0rHudPFwu8
         vb2AGz/eEw0EjZ27clPGMTKvpYFAtgxLbwn0UgdSlNZNuVFyQcpedXOXZ+Kya+UdVb
         GjPln/hO43a8i5XykOd8uO59/L6k+SicskN7U/L27OTPQsyYyDgzfy3HfOqivrJd0M
         ZzXlmotIbVW0+d+ua+G47Lli2j3QrH6fKzkyVQ0cENWFkorT9Bnq5UVLd5tHjaPjxS
         3AJVVf6ZdsjV4nMIKmz3r/WALuRzG4NfGY1x4vrtRtWr4a9Ph7eKYpgmtDZBfvzkbX
         F1jz7X1HVhk8w==
Date:   Thu, 26 Jan 2023 09:12:14 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel test robot <oliver.sang@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Andreas Dilger <adilger@dilger.ca>,
        Jason Donenfeld <Jason@zx2c4.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.1 35/35] ext4: deal with legacy signed xattr
 name hash values
Message-ID: <Y9KKPoEKbp4dwfJg@sashalap>
References: <20230124134131.637036-1-sashal@kernel.org>
 <20230124134131.637036-35-sashal@kernel.org>
 <CAHk-=wjZmzuHP10Trg_7EBnix4mFLfODPM+FsZz0Jjj+YAFDeg@mail.gmail.com>
 <CAHk-=wi5GPS3poC_YRy93X38AqkvsFENAviMXHWjgOgo5k7p3g@mail.gmail.com>
 <Y9FSW2n1wPIwVjAN@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y9FSW2n1wPIwVjAN@mit.edu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 25, 2023 at 11:01:31AM -0500, Theodore Ts'o wrote:
>On Tue, Jan 24, 2023 at 09:23:56AM -0800, Linus Torvalds wrote:
>> On Tue, Jan 24, 2023 at 8:50 AM Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>> >
>> > This patch does not work correctly without '-funsigned-char', and I
>> > don't think that has been back-ported to stable kernels.
>> >
>> > That said, the patch *almost* works.
>>
>> So I'm  not convinced this should be back-ported at all, but it's
>> certainly true that going back and forth between the two cases would
>> be problematic.
>
>Yeah, I wouldn't backport this patch, since it also requires changes
>to e2fsprogs that will take a while to propagate to stable distributions.

Ack, I'll drop it. Thanks!

-- 
Thanks,
Sasha
