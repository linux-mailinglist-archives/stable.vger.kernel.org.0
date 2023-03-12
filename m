Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F776B67CC
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 17:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjCLQA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 12:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjCLQAz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 12:00:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC184B816;
        Sun, 12 Mar 2023 09:00:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36F1460F3A;
        Sun, 12 Mar 2023 16:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3BCC433EF;
        Sun, 12 Mar 2023 16:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678636844;
        bh=nbxNTesKWPwebrszPu7Fl9hCJ3NJCxcSoKeuua/b7nA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nW/4G4rtDiNnjMx0trpjZChXLuJtjpMmvG0SjWDpPGmUDTVK7T+bdNqFBilrdkB2e
         F7TGLqtfgZkiLkN5lBBCdqZAK7tqqFpQBJA0rnBYGY6z1ikrcPqZnW63lhxn7QDcCg
         o2miQUjKSMLUhoUYUEANhV2dFtWM9LFRuKs0GP4EYHUZnXj/DA/vn+L5kjvM0c4VJR
         r6lYhgAziH6iLzGguY5+kMTMAKA62ZDuAyIgPwgCQDDg/ZRLmE2POCw82tEhx4bjgF
         ohiqFyZsMjvwQSH0u6o5/77lp2MHQFHT9CajZDvPG/g6DHkt+0JKywxovMFyoWlnqq
         KVnaqDL/hHvWQ==
Date:   Sun, 12 Mar 2023 12:00:43 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org,
        Leah Rumancik <leah.rumancik@gmail.com>,
        "Luis R. Chamberlain" <mcgrof@gmail.com>
Subject: Re: AUTOSEL process
Message-ID: <ZA33K0U5zcoQW7Lx@sashalap>
References: <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap>
 <20230311161644.GH860405@mit.edu>
 <ZAy+3f1/xfl6dWpI@sol.localdomain>
 <ZAzH8Ve05SRLYPnR@sashalap>
 <ZAzOgw8Ui4kh1Z3D@sol.localdomain>
 <ZAzvPR1zev3tFJoH@sashalap>
 <CAOQ4uxhgHp7Eh4HC7ceqzyWp2PyD_G7-o-DukfA90WN456gDeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxhgHp7Eh4HC7ceqzyWp2PyD_G7-o-DukfA90WN456gDeQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 12, 2023 at 10:04:23AM +0200, Amir Goldstein wrote:
>On Sat, Mar 11, 2023 at 11:25 PM Sasha Levin <sashal@kernel.org> wrote:
>>
>> On Sat, Mar 11, 2023 at 10:54:59AM -0800, Eric Biggers wrote:
>...
>> >And yes, I am interested in contributing, but as I mentioned I think you need to
>> >first acknowledge that there is a problem, fix your attitude of immediately
>> >pushing back on everything, and make it easier for people to contribute.
>>
>> I don't think we disagree that the process is broken: this is one of the
>> reasons we went away from trying to support 6 year LTS kernels.
>>
>> However, we are not pushing back on ideas, we are asking for a hand in
>> improving the process: we've been getting drive-by comments quite often,
>> but when it comes to be doing the actual work people are quite reluctant
>> to help.
>>
>> If you want to sit down and scope out initial set of work around tooling
>> to help here I'm more than happy to do that: I'm planning to be both in
>> OSS and LPC if you want to do it in person, along with anyone else
>> interested in helping out.
>>
>
>Sasha,
>
>Will you be able to attend a session on AUTOSEL on the overlap day
>of LSFMM and OSS (May 10) or earlier?
>
>We were going to discuss the topic of filesystems and stable trees [1] anyway
>and I believe the discussion can be even more productive with you around.
>
>I realize that the scope of AUTOSEL is wider than backporting filesystem fixes,
>but somehow, most of the developers on this thread are fs developers.
>
>BTW, the story of filesystem testing in stable trees has also been improving
>since your last appearance in LSFMM.

Happy to stop by and collaborate!

I'll also be in Vancouver the whole week (though not in LSF/MM), so if
you'd want to find time for a workshop around this topic with interested
parties we can look into that too.

-- 
Thanks,
Sasha
