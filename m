Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479D14ECCF3
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 21:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245628AbiC3TKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 15:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349959AbiC3TKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 15:10:40 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65DBA11A36
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 12:08:54 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id r23so25608836edb.0
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 12:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sweetwater-ai.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qInx4Rp69ucp6wp8S1ootr5s+MPN2NDB9PchtSEOOJo=;
        b=IqtCzp+H40sf7grP2d0Ohr+lcqFP7jv9DCvaXClC3CHzwXgYwvsnb+2EQ3bdx++w/v
         8Zqp2J4yWyj/KEM0e6fVUMuBVaVB0jSYna/Q1kOfVT0WwISvf95q1FqAmRD7Kcag3BUg
         mHllTDirV9p4Dm3hCl+E5eaqAF8ri5uBUFUzL8vsVd+WNWlmQdSWw2pLiXWnDrJb1KqM
         ayBrwATc++o1sVeSbG6eRGxdHBQxgFanIUzYC2Sas8OrfaayiBY6U2jlU/9p9iXgex2K
         J/ha17gtDHK8emyKHfw94G0vngoxLibHl+Lm1BBMoyVonFnSohLPebeRTvx+rqQh6ese
         EZwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qInx4Rp69ucp6wp8S1ootr5s+MPN2NDB9PchtSEOOJo=;
        b=LiLCnGdaXBL4raA1RjHJTOzTTpaqBzrsI2qnc8zFtkcsJ2rkLQq/jlLm0JaxZ8vlmO
         dlln/wSazFuEFaR1vZRbq652yBtzRuGWMQndEobTa1fWQ8xyTcL2Zyo1GCCUwZ8d+tHg
         ZtCnqmoTTC3p5ZIkRt/ilRJB/+XJy7TnnAYk54rPFkT4XKJvmuIYL4LIMiReCb5duBiy
         +AdqY6xnAtIvXWEQ9i4qYhjM3/wXxlW4BIr1PP3TXV0ZuJujFxMgD7LAN59SBjI2pdz/
         iExlbptwJYOAp0/Nr3ZoToZZ91HqLeqlMrV3IsaB41kHrXrmnUl0UeFxp2XiyoOJwjO/
         5t0g==
X-Gm-Message-State: AOAM530StRqX03TfgIVnO80+esoUVUslMWz9QFElBNSvexoutvBZtv0+
        d58kvNgK5suE15S251QEV2lpZ414b/b1iMsfbNEx8Q==
X-Google-Smtp-Source: ABdhPJwthEGSwByou575qREkRRRH2hSWpgbaQMxE2vcjQ6aGTXWyupdrdTCiMlScpkAKNOhEIGToMigybZFjeimZ3DI=
X-Received: by 2002:aa7:c704:0:b0:418:ee8f:3fd0 with SMTP id
 i4-20020aa7c704000000b00418ee8f3fd0mr12485316edq.248.1648667332699; Wed, 30
 Mar 2022 12:08:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220328111828.1554086-1-sashal@kernel.org> <20220328111828.1554086-16-sashal@kernel.org>
 <CAOnCY6TTx65+Z7bBwgmd8ogrCH78pps59u3_PEbq0fUpd1n_6A@mail.gmail.com>
 <9e78091d07d74550b591c6a594cd72cc@AcuMS.aculab.com> <CAOnCY6QNPUC-VK+ARLb6i_UskV2CkW+AG5ZqWe_oMGUumL9Gnw@mail.gmail.com>
 <CAOnCY6Q9XoAMpeRfA_ghge3mXkGXFsm4fW64hxcbnMdJyx8Y2g@mail.gmail.com> <YkSpCy023rHoefi1@mit.edu>
In-Reply-To: <YkSpCy023rHoefi1@mit.edu>
From:   Michael Brooks <m@sweetwater.ai>
Date:   Wed, 30 Mar 2022 12:08:44 -0700
Message-ID: <CAOnCY6QUx-A5Cp+HXeOyHa5oBFq5zWmcJOg_yH3Ty20-13Xbcw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.17 16/43] random: use computational hash for
 entropy extraction
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     David Laight <David.Laight@aculab.com>,
        Sasha Levin <sashal@kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        nicholas Lyons <nicholas@arkeytyp.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Good point Ted, I agree we should have a defense-in-depth design that
plans on failure. I expect keypoolrandom to be resistant against this
attack as well.

In this threat model, p' is a Laplacian Demon. Any parallel
construction is aided by whatever source of information the attacker
can come by.  Using jiffies as a known-perimage aids Laplace's Demon,
as does a memory disclosure vulnerability.  Leplace's Demon can simply
"get lucky" and report both false-positives and false-negatives, but
in this model it should get more lucky over time.  Now we get into the
realm of statistics and predictive mathematics, which gets into
Langevin Dynamics and Einstein's early work describing Brownian
Motion.

Looping in a fellow Cryptographer Nicholas, who has a passion for
Laplace's work.

Regards,
Michael

On Wed, Mar 30, 2022 at 12:01 PM Theodore Y. Ts'o <tytso@mit.edu> wrote:
>
> On Wed, Mar 30, 2022 at 11:33:21AM -0700, Michael Brooks wrote:
> > The /dev/random device driver need not concern itself with root
> > adversaries as this type of user has permissions to read and overwrite
> > memory - this user even possesses permission to replace the kernel elf
> > binary with a copy of /dev/random that always returns the number 0 -
> > that is their right.
>
> The design consideration that random number generators do concern
> themselves with is recovery after pool exposure.  This could happen
> through any number of ways; maybe someone got a hold of the suspended
> image after a hiberation, or maybe a VM is getting hybernated, and
> then replicated, etc.
>
> One can argue whether or not it's "reasonable" that these sorts of
> attacks could happen, or whether they are equivalent to full root
> access whether you can overwrite the pool.  The point remains that it
> is *possible* to have situations where the internal state of the RNG
> might have gotten exposed, and a design criteria is how quickly or
> reliably can you reocver from that situation over time.
>
> See the Yarrow paper and its discussion of iterative guessing attack
> for an explanation of why cryptographers like John Kelsey, Bruce
> Schneier, and Niels Ferguson think it is important.  And please don't
> argue with me on this point while discussing which patches should be
> backported to stable kernels --- argue with them.  :-)
>
> Cheers,
>
>                                                 - Ted
