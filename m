Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60FB26A56EF
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 11:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjB1KlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 05:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjB1KlU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 05:41:20 -0500
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECEB24106;
        Tue, 28 Feb 2023 02:41:19 -0800 (PST)
Received: by mail-ua1-x935.google.com with SMTP id l24so797700uac.12;
        Tue, 28 Feb 2023 02:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677580879;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8DbVfOckXlAwnJnMHcsh1q8vZl9XSwnyP9AZsJxgsg4=;
        b=dYmNo5q063Mxj4sRwSDBshps42BgANMZzJ8NIms3DO9OZ1erbLJBn1bI/++dPPOZ9j
         SMQJ+pP6S74SUAZviENXfMIns2uD1CbtpvsuY71WE1Z1e/1HQ+VuhRa2/kVSb8hlCK20
         SjGV3LqPnDl+bPFgpdzIRJgTG5HsdMfMV60qhikfRuMuTtChaFNOamja2scFf5vnk/E9
         aalmU0sinLAviHRrTkJksfXmzEu+iI3jDD4N7NL5d0SJA7iHWM+ipoyrvDTk+CxcGIAT
         CNC3shgktuDolX46+Z+j31Uk+SGKZjQ/VAQsKRnAAKjsj318ozW7A0fNNms1XgWW53ud
         Pc4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677580879;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8DbVfOckXlAwnJnMHcsh1q8vZl9XSwnyP9AZsJxgsg4=;
        b=Nwg6boTwnoKy5ppHpqCIpYIfKFgTrG3u7wfv5N298DVV4w98bF+C0H6N46auCj4Rd8
         nV47UlKtBFC4stjCYTHzd0wovtbD3aH1ydjA59y8cJS26wdFQi3RcMPvK0t53lcHkHrU
         8gKNkha7YaCoGQnNBBPcSIHiKPBH1R6Jqo2jMt/cLD7X0GejwIKvnBYthC9S8K+Q9Jto
         fsOmniiukKBHYIkR2SOlB+dgnSAbqDHIU9AzT05dwI2WFM6doJjFoOIHEP1ZWLGam6Zy
         V/rV/Nf4Ch05T197dlEgCdnAKO+ysbZ3iTvCSijbhk98BAZKMNrWqgfESjQ9ft1U2MNR
         zGVA==
X-Gm-Message-State: AO0yUKWEYOsccuVXlXx3ON+CuN/aB6OVRPuLeb0pqM5kmy72GB7tGJJc
        eBo8JzaZzOPbeOcGwjnhRp9mRHfFUx79IAaIWAc=
X-Google-Smtp-Source: AK7set+qBzkp5toODpAUw2ZZQlYyfMm2QZP7Sb0CMFTpsGk2V4xMYDfU3UbLNa2hh9TtB5fTmaYulOtIXe9TiOz9lbo=
X-Received: by 2002:ac5:c85c:0:b0:40e:fee9:667a with SMTP id
 g28-20020ac5c85c000000b0040efee9667amr1014736vkm.3.1677580878928; Tue, 28 Feb
 2023 02:41:18 -0800 (PST)
MIME-Version: 1.0
References: <Y/rufenGRpoJVXZr@sol.localdomain> <Y/ux9JLHQKDOzWHJ@sol.localdomain>
 <Y/y70zJj4kjOVfXa@sashalap> <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain> <Y/0U8tpNkgePu00M@sashalap>
 <Y/0i5pGYjrVw59Kk@gmail.com> <Y/0wMiOwoeLcFefc@sashalap> <Y/1LlA5WogOAPBNv@gmail.com>
 <Y/1em4ygHgSjIYau@sashalap> <Y/136zpJSWx96YEe@sol.localdomain>
In-Reply-To: <Y/136zpJSWx96YEe@sol.localdomain>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 28 Feb 2023 12:41:07 +0200
Message-ID: <CAOQ4uxietbePiWgw8aOZiZ+YT=5vYVdPH=ChnBkU_KCaHGv+1w@mail.gmail.com>
Subject: Re: AUTOSEL process
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> > I'm not sure how feedback in the form of "this sucks but I'm sure it
> > could be much better" is useful.
>
> I've already given you some specific suggestions.
>
> I can't force you to listen to them, of course.
>

Eric,

As you probably know, this is not the first time that the subject of the
AUTOSEL process has been discussed.
Here is one example from fsdevel with a few other suggestions [1].

But just so you know, as a maintainer, you have the option to request that
patches to your subsystem will not be selected by AUTOSEL and run your
own process to select, test and submit fixes to stable trees.

xfs maintainers have done that many years ago.
This choice has consequences though - for years, no xfs fixes were flowing
into stable trees at all, because no one was doing the backport work.
It is hard to imagine that LTS kernel users were more happy about this
situation than they would be from occasional regressions, but who knows...

It has taken a long time until we found the resources and finally started a
process of reviewing, testing and submitting xfs fixes to stable trees and this
process involves a lot of resources (3 maintainers + $$$), so opting out of
AUTOSEL is not a clear win.

I will pencil down yet another discussion on fs and stable process at
LSFMM23 to update on the current status with xfs, but it is hard to
believe that this time we will be able to make significant changes to
the AUTOSEL process.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/20201204160227.GA577125@mit.edu/#t
