Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1E3B6BFBDE
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 18:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjCRReG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 13:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjCRReF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 13:34:05 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CAC1BE7
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 10:34:03 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id o11-20020a05600c4fcb00b003eb33ea29a8so5128067wmq.1
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 10:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1679160842;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5of88HDhIx7CqzdMvTY1c+Tm7wFim5cST1Iwrzk4f9g=;
        b=W8kxFDDlx6R33ZEig/+eW9dYjgKnH7SCBxMXcye+3qTaEbhU1Raj30B8gYKMqUseeS
         nvKlJjbqMFxKrcw0oDkpgZXuV7nQjexdNKMq5lITTka47V2hDwK2Jv0vevOXVDcYYsh2
         dNkOk6GlqByBLa9YvL6dPFRb5s8p6zYLi3DHooCkQ1GIw+WWJJnM/I2PvxB/FsUfAZNA
         JT0EfKdxXpXRV/Z05qjRAB0V30WBkmgt0iXTtghKQAMgcfx5YWmfDAfWm3bE5vxyFSQX
         YhFIv+vJ3vVBNAmOPVDJytuTdLInZ6toDkWf/Jk3XRWJEaMMIDSOlnKnqJaYqthkt4bO
         z6Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679160842;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5of88HDhIx7CqzdMvTY1c+Tm7wFim5cST1Iwrzk4f9g=;
        b=fVH9ocoM+t3Ww3gE0Si3EP4X3RA0jXjOYBQicArVaUtml6YAvBgKk0VLT+vrB0/CGg
         dPvKD8LzzFhzopYvnywcK6o9I3yTEVLAouCSKXPkQerHeHrVDRNGwP0TwYc2RHnQJgar
         PaPNoF/iMaF07inaKKC1IOhxVtfGtyVeOiYeOAxjGtry2lFT1IT5jOH/3WyebVM5s4Rp
         q8BCTEbhibBhby39z0FWhmj8A3VqhRYyzfJTdzoVExar18tg7immgPKqMCZVb73nIeq2
         P3WUwSAnp7iU5ciB3PCnrbyIrgg5ttzjiGuHBCNFlBHmhmv/yMp+UN76QJyFDqWS88P0
         5Ang==
X-Gm-Message-State: AO0yUKXKjjCX13LQQbzsa4HsN3y3Bj5P0Y/HI/+TjGfPYYTNfoybVZ8m
        SgTmv7La0RY0v3m1c4u+onnPyw==
X-Google-Smtp-Source: AK7set+3NmT9+Dcxxcz356Bs1iWJ3INmsCJbzZBOovUl3q7tKJeQaceBb2rFDmMvKSTioQ8woB1u7A==
X-Received: by 2002:a1c:4c0d:0:b0:3df:fcbd:3159 with SMTP id z13-20020a1c4c0d000000b003dffcbd3159mr5173349wmf.3.1679160842273;
        Sat, 18 Mar 2023 10:34:02 -0700 (PDT)
Received: from airbuntu (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id u7-20020a7bc047000000b003ed2276cd0dsm5291888wmc.38.2023.03.18.10.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 10:34:01 -0700 (PDT)
Date:   Sat, 18 Mar 2023 17:33:59 +0000
From:   Qais Yousef <qyousef@layalina.io>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH 0/7] Backport uclamp vs margin fixes into 5.15.y
Message-ID: <20230318173359.agw5rq7gwwjdvnat@airbuntu>
References: <20230308162207.2886641-1-qyousef@layalina.io>
 <ZBF74StdWaGP/KSP@kroah.com>
 <ZBGHpGccMmxHnUns@kroah.com>
 <20230315125304.g6yuhltvewnfneqs@airbuntu>
 <ZBLIvuqi0LYWIPBN@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZBLIvuqi0LYWIPBN@kroah.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/16/23 08:43, Greg KH wrote:
> On Wed, Mar 15, 2023 at 12:53:04PM +0000, Qais Yousef wrote:
> > On 03/15/23 09:53, Greg KH wrote:
> > > On Wed, Mar 15, 2023 at 09:03:45AM +0100, Greg KH wrote:
> > > > On Wed, Mar 08, 2023 at 04:22:00PM +0000, Qais Yousef wrote:
> > > > > Portion of the fixes were ported in 5.15 but missed some.
> > > > > 
> > > > > This ports the remainder of the fixes.
> > > > > 
> > > > > Based on 5.15.98.
> > > > > 
> > > > > Build tested on x86 with and without uclamp config enabled.
> > > > 
> > > > Now queued up, thanks.
> > > 
> > > Wait, should we also queue up a2e90611b9f4 ("sched/fair: Remove capacity
> > > inversion detection") to 5.10 and 5.15 now as well?
> > 
> > It has a dependency on e5ed0550c04c ("sched/fair: unlink misfit task from cpu
> > overutilized") which is nice to have but not strictly required. It improves the
> > search for best CPU under adverse thermal pressure to try harder. And the new
> > search effectively replaces the capacity inversion detection, so it is removed
> > afterwards.
> > 
> > I'd like to have it but find_energy_efficient_cpu() looks a bit different for
> > a straightforward backport and opted to avoid the risk.
> > 
> > Happy to reconsider though.
> 
> Ok, just wanting to verify as that commit looked like it was needed
> after these.
> 
> But, as I've just now dropped both 5.10.y and 5.15.y sets of patches,
> this is going to need to be redone anyway, so perhaps put that note in
> the 00/XX email when you resubmit so that I don't get confused again.

Will do. There were no failure for the 5.15 set though. The reports were
against 5.10 only.

I retested 5.15 series against:

	1. default ubuntu config which has uclamp + smp
	2. default ubuntu config without uclamp + smp
	3. default ubunto config without smp (which automatically disabled
	   uclamp)
	4. reported riscv-allnoconfig, mips-randconfig, x86_64-randocnfigs

And they all compiled without an error. Happy to retake them or prefer a resend
anyway though nothing has changed?

Just finishing testing 5.10 and will send v2 with the updated cover-letter.


Thanks!

--
Qais Yousef
