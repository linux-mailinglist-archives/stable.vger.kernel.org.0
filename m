Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 493959F3AF
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 22:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbfH0UBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 16:01:55 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:39093 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbfH0UBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 16:01:55 -0400
Received: by mail-pf1-f178.google.com with SMTP id y200so99503pfb.6
        for <stable@vger.kernel.org>; Tue, 27 Aug 2019 13:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VHIU9lA7i92lkULAx9lxHjwFf+1Vu5i1JzkFKORP5+U=;
        b=D+SK7/40m+AL5Cty2uTposYAWu8iEm4adkanm3Hps3UQpe8t/Rwg6mEWZzKDUHGDT2
         KTq+r1+BzOHr6At5RvqG9w5eFrLWRg3g9Yd5nbk0VmFpdRz7ve0bfrhYGchMxJrumd42
         hX3MDz63KE10Vkt2/wzkmATgFf8V8YdOlJX1Jz4IKLGHN2uSx92aNZlev5R+cw/E51tE
         pecC2u/AAOcXqXyDihrlKuKYSx//7vBdDHT7JxU38VIuT63SijBqxLwxcBis8qf18YJq
         68e9sh9tBpdX3/6xvleTw9IxiCLQYtWhAMQMfpv4s7kFkhM/9PilziJSDl+g2CRNCgrF
         07DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=VHIU9lA7i92lkULAx9lxHjwFf+1Vu5i1JzkFKORP5+U=;
        b=OHxTjtd8ajceYyT9J/1NaBVV+YKBnvQnQZz23w2l1XN3XZjW3wkN3eYeblaBWpV2Rh
         r/UIpvvnMp53B8DMuwc3HzXrL/LBAIEIV6+EmgNnXf1FC4Upr/40szwxoChDALtGel7x
         usmUNPH+ZZQiHQDnKFFn98fLsxCLqM7UuTJCObYCVzaUIC5J2F4XWhR5X7d7LbwSRfOe
         0MVF626sR0zeghzM86WUMjyKRu596Wf3e1lHfEKI24t5phEE2yU0d5mveysEhp93qAgr
         cgm81Zgj8Iduu/pZXPuPq2qvV3wC066Nwy7ph2fm6f9Jhmp54kVvPDzQBzJqpa/7EW6S
         J3pA==
X-Gm-Message-State: APjAAAVjK9wmyOnM5tr43gFGBUhSuAuDp9mQH2Y/7aDYQ33mKpPoFsxF
        WgU+1OXgsXBkCOWyUB87ck4=
X-Google-Smtp-Source: APXvYqwTQQb6by5NFthak53emEGLpJJCmobEasq1qzZr7G7JpIT0xzCgZtxYLTpx4oiutV03WWNRZg==
X-Received: by 2002:aa7:8559:: with SMTP id y25mr180181pfn.260.1566936114454;
        Tue, 27 Aug 2019 13:01:54 -0700 (PDT)
Received: from localhost (108-223-40-66.lightspeed.sntcca.sbcglobal.net. [108.223.40.66])
        by smtp.gmail.com with ESMTPSA id i124sm139992pfe.61.2019.08.27.13.01.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 13:01:53 -0700 (PDT)
Date:   Tue, 27 Aug 2019 13:01:51 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Patches potentially missing from stable releases
Message-ID: <20190827200151.GA19618@roeck-us.net>
References: <20190827171621.GA30360@roeck-us.net>
 <20190827181003.GR5281@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827181003.GR5281@sasha-vm>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 27, 2019 at 02:10:03PM -0400, Sasha Levin wrote:
> On Tue, Aug 27, 2019 at 10:16:21AM -0700, Guenter Roeck wrote:
> >Hi,
> >
> >I recently wrote a script which identifies patches potentially missing
> >in downstream kernel branches. The idea is to identify patches backported/
> >applied to a downstream branch for which patches tagged with Fixes: are
> >available in the upstream kernel, but those fixes are missing from the
> >downstream branch. The script workflow is something like:
> >
> >- Identify locally applied patches in downstream branch
> >- For each patch, identify the matching upstream SHA
> >- Search the upstream kernel for Fixes: tags with this SHA
> >- If one or more patches with matching Fixes: tags are found, check
> > if the patch was applied to the downstream branch.
> >- If the patch was not applied to the downstream branch, report
> >
> >Running this script on chromeos-4.19 identified, not surprisingly, a number
> >of such patches. However, and more surprisingly, it also identified several
> >patches applied to v4.19.y for which fixes are available in the upstream
> >kernel, but those fixes have not been applied to v4.19.y. Some of those
> >are on the cosmetic side, but several seem to be relevant. I didn't
> >cross-check all of them, but the ones I tried did apply to linux-4.19.y.
> >The complete list is attached below.
> >
> >Question: Do Sasha's automated scripts identify such patches ? If not,
> >would it make sense to do it ? Or is there some reason why the patches
> >have not been applied to v4.19.y ?
> 
> Hey Guenter,
> 
> I have a very similar script with a slight difference: I don't try to
> find just "Fixes:" tags, but rather just any reference from one patch to
> another. This tends to catch cases where once patch states it's "a
> similar fix to ..." and such.
> 
> The tricky part is that it's causing a whole bunch of false positives,
> which takes a while to weed through - and that's where the issue is
> right now.
> 

I didn't see any false positives, at least not yet. Would it possibly
make sense to start with looking at Fixes: ? After all, additional
references (wich higher chance for false positives) can always be
searched for later.

Thanks,
Guenter

> I try to review a few each week and queue them up together with my
> autosel patches, but I guess I should step it up a bit.
> 
> Let me go over my list and try to catch up - I think I'll have time in
> the very near future.
> 
> --
> Thanks,
> Sasha
