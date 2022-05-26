Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595895349AA
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 06:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241857AbiEZEQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 00:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238306AbiEZEQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 00:16:35 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECE82DFC
        for <stable@vger.kernel.org>; Wed, 25 May 2022 21:16:32 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id m2so359769vsr.8
        for <stable@vger.kernel.org>; Wed, 25 May 2022 21:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=efficientek-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:reply-to
         :mime-version:content-transfer-encoding;
        bh=vW6bMb1556WXkZgGX3ojWrzuIpwI2XwY/gRzSKQYJxA=;
        b=liSzWJqDLmKzTcdKauIgSk3HwujBQ9WyOn2VLGP2Icv5Z6xaPg+cf8zoa7LGvP0AVG
         Doehvg1EtSSQ+/gA1tG4GYAdQfkKsYbkaEZ7yxsq1c1CxneSJFVw0ExQJcVE6NHH5mBq
         sRhwACZYTn7JUbU9ZuI97S/Ba7/15o8zMtddu6IQ18hS/aHqAfPsRFi/LtbLonprrHSb
         mCWsxIiEEugVUj3jQC4mE04trf7ZU4YAE1p44rmOQvIe5uVzIraRlwv1DI/HpTo7xeq4
         tTRCRXilcUeDnBnsJPvjl+GwQZjMn5YjasVC7X0bDTY3S+ISey+zEw7TmL/4wM1p/Swy
         g/0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=vW6bMb1556WXkZgGX3ojWrzuIpwI2XwY/gRzSKQYJxA=;
        b=V+4BwglT8XvlJOvczu23ReaQznlnaxnYfxv/25uQ7tXgBh+Pv1UjnlhceAkqNnttlD
         fa2OZbeRcGLK8wwlsIkyvZMhN7DN0bT/uaUUz4Sj2vTSPenu33NM0eyYEM6OHjTmpn4e
         kfupR1parnJXgjQsf1bpPrg1vGUWRdJElCilX83ANV4TFjU+Qmr6PC3NZDKdbIB482PP
         kTErBDQa7Ii1ZKkeBCvi9+fKzywd40lGZS5U2Di6pOVmPsM+ufZ7vfWvjDHw0Zial/Rv
         DxsRzNjxYvWDRKcregkfV7xqjscCq9SULlJqf44nG3BvP74xgpRCzTEHWdyrjMw/fXvw
         htEg==
X-Gm-Message-State: AOAM532HZnJCc+f+eLm2tWuaxfdDH4S7a8hbyL2jGXEd+cQP5hMSrVwC
        63ijq3ctSbXgLsHRExls/YaS8A==
X-Google-Smtp-Source: ABdhPJx5rRlEM39dc6X7K8Sn4zjcjeRPZRYvm0HeCr7Y5GSOnGCm7qioYubzPl0HayWePUN5UnHn/g==
X-Received: by 2002:a67:df11:0:b0:32c:ba04:cf9a with SMTP id s17-20020a67df11000000b0032cba04cf9amr14325686vsk.18.1653538592063;
        Wed, 25 May 2022 21:16:32 -0700 (PDT)
Received: from crass-HP-ZBook-15-G2 ([37.218.244.249])
        by smtp.gmail.com with ESMTPSA id f2-20020ab02e82000000b003626f894dd8sm44643uaa.6.2022.05.25.21.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 21:16:31 -0700 (PDT)
Date:   Wed, 25 May 2022 23:16:24 -0500
From:   Glenn Washburn <development@efficientek.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, stable-commits@vger.kernel.org,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>
Subject: Re: Patch "um: port_user: Improve error handling when port-helper
 is not found" has been added to the 5.17-stable tree
Message-ID: <20220525231624.518dbb24@crass-HP-ZBook-15-G2>
In-Reply-To: <Yopl/v3SQoaaPmUJ@sashalap>
References: <20220519135207.392505-1-sashal@kernel.org>
        <20220520140515.35ab0497@crass-HP-ZBook-15-G2>
        <Yopl/v3SQoaaPmUJ@sashalap>
Reply-To: development@efficientek.com
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 22 May 2022 12:34:06 -0400
Sasha Levin <sashal@kernel.org> wrote:

> On Fri, May 20, 2022 at 02:05:15PM -0500, Glenn Washburn wrote:
> >Resending this because stable@vger.kernel.org using wrong header field.
> >Apologize for duplicates.
> >
> >On Thu, 19 May 2022 09:52:07 -0400
> >Sasha Levin <sashal@kernel.org> wrote:
> >
> >> This is a note to let you know that I've just added the patch titled
> >>
> >>     um: port_user: Improve error handling when port-helper is not found
> >>
> >> to the 5.17-stable tree which can be found at:
> >>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> >>
> >> The filename of the patch is:
> >>      um-port_user-improve-error-handling-when-port-helper.patch
> >> and it can be found in the queue-5.17 subdirectory.
> >>
> >> If you, or anyone else, feels it should not be added to the stable tree,
> >> please let <stable@vger.kernel.org> know about it.
> >
> >First, I should say that I'm not familiar with the process so I'm
> >likely to be wrong on any number of things. Second I'm the author of
> >this patch and I would like to see this included in the stable trees.
> >However, it appears to me that there is a problem in including just this
> >patch, as it depends on a previous patch which does not appear to be
> >applied[1].
> 
> Right, I've dropped it.
> 
> >The the afore mentioned patch that this patch depends on "env" is
> >declared and set. Without it, I'd expect this to fail to compile. As
> >such, I may be wrong in that the dependent patch was not already
> >included because I'd expect there to have been a compile test prior to
> >this patch getting to this phase.
> >
> >My suspicion is that the stable trees try to not include new
> >functionality, which the missing patch may have been considered to have
> >done, and thus was not included. If its deemed undesirable to include
> >the missing patch, this "if" block can be removed. Although, I think
> >the missing patch is valuable enough to include.
> >
> >The above goes for all the stable branches that this patch is set to be
> >included in.
> 
> Could you provide a list of patches that are needed here?

Sore. Strictly speaking, the only dependency is the patch mentioned[1].
Although, I'd suggest picking up this patch[2] that's related to
improving messaging on error conditions. I'm also unsure if the
provided links are what you're looking for in terms of how to specify
patches for you. Let me know more specifically if this doesn't suffice.

Glenn

[1]
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.18-rc7&id=db8109a8bb4a4b31e7f630d7667749d62ee4a087
[2]
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.18-rc7&id=82017457957a550d7d00dde419435dd74a890887
