Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAEDD9F477
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 22:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbfH0Usp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 16:48:45 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43970 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727887AbfH0Uso (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 16:48:44 -0400
Received: by mail-pl1-f195.google.com with SMTP id 4so116719pld.10
        for <stable@vger.kernel.org>; Tue, 27 Aug 2019 13:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=x71Uvmd4BSv+Fh4M3OJi1PCwaPR90IH2aHrOg1rwKRs=;
        b=Hbi4C4hsGu/WeyWF8XihGNIWFPo7iedshKcxt5Blj49EVUSqVWvkWU6V9HVWsM3cDo
         18dFZ+RyMplqptyxqZvJdzCrgyRGjuJSacfIWtZyFEzsg+5ueibG+2wZjcXlCQ9czCyS
         rRhWxYZFej0s1JaHxtU1iS75vY3ScIQcCMSXApR2jl5bcXHAUewag12qUjXkqrmaIXFB
         Wx+ARWEZ9gyXjU5OHlS29LIk4/gBjapRpLU2Gqp5kH5XwptjLas6HjHdunfZBihWm0pD
         jpVhtJur5VDmnvqjojqJSEG6xISrQfPRAqxD77RQ2iXt/w8JlLU/lrqhp+edgBIC1s16
         5pCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=x71Uvmd4BSv+Fh4M3OJi1PCwaPR90IH2aHrOg1rwKRs=;
        b=ldbEaU9oCiimDPBDZ0lx3SxsVi4sl3kxLwp22OoYAPpa4jqt4Nm3fZyo5iXQDBYN7l
         Sdq/YErQzuqarZfPHHRgBf9sXss8xMjgLrmeF1yeohgpDtK8368RHRe+ZQziwQDqzZRU
         L2fVOIHd6EGoVAobdPn3MqI14INs68P2aJzddfwc+v2F0nn3MutPDOlijCQomkJDwBco
         CpVxkafwk90nO577PqlWDa1FpKVf3ktfL3WHquet/f5JqxREi2CqULR/fbvXNcVUnBuq
         09il8MMHtlQSFbhOomX0V29yPNfGsaug0x9x+PPMvxQSYcmk3zTJLi7g9PbVHkrtzyjw
         HlNg==
X-Gm-Message-State: APjAAAU6PUcymkUCuHkw8/9uRemiolTP7WdpUfHIfcTlHsSDAePdCgGW
        B4Trhy2l8WdNWTAtJxBuAbA=
X-Google-Smtp-Source: APXvYqyGMBCXYT4UfxpXVChD1XtUeyseN/NENk+4AufaRJtDvNB13ipWIAFHGFhreOJFLgS5oRdKrw==
X-Received: by 2002:a17:902:830c:: with SMTP id bd12mr835218plb.237.1566938924108;
        Tue, 27 Aug 2019 13:48:44 -0700 (PDT)
Received: from localhost (108-223-40-66.lightspeed.sntcca.sbcglobal.net. [108.223.40.66])
        by smtp.gmail.com with ESMTPSA id 1sm180710pfy.169.2019.08.27.13.48.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 13:48:42 -0700 (PDT)
Date:   Tue, 27 Aug 2019 13:48:41 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: Patches potentially missing from stable releases
Message-ID: <20190827204841.GA21062@roeck-us.net>
References: <20190827171621.GA30360@roeck-us.net>
 <20190827181003.GR5281@sasha-vm>
 <20190827200151.GA19618@roeck-us.net>
 <20190827202901.GB1118@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827202901.GB1118@kroah.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 27, 2019 at 10:29:01PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Aug 27, 2019 at 01:01:51PM -0700, Guenter Roeck wrote:
> > On Tue, Aug 27, 2019 at 02:10:03PM -0400, Sasha Levin wrote:
> > > On Tue, Aug 27, 2019 at 10:16:21AM -0700, Guenter Roeck wrote:
> > > >Hi,
> > > >
> > > >I recently wrote a script which identifies patches potentially missing
> > > >in downstream kernel branches. The idea is to identify patches backported/
> > > >applied to a downstream branch for which patches tagged with Fixes: are
> > > >available in the upstream kernel, but those fixes are missing from the
> > > >downstream branch. The script workflow is something like:
> > > >
> > > >- Identify locally applied patches in downstream branch
> > > >- For each patch, identify the matching upstream SHA
> > > >- Search the upstream kernel for Fixes: tags with this SHA
> > > >- If one or more patches with matching Fixes: tags are found, check
> > > > if the patch was applied to the downstream branch.
> > > >- If the patch was not applied to the downstream branch, report
> > > >
> > > >Running this script on chromeos-4.19 identified, not surprisingly, a number
> > > >of such patches. However, and more surprisingly, it also identified several
> > > >patches applied to v4.19.y for which fixes are available in the upstream
> > > >kernel, but those fixes have not been applied to v4.19.y. Some of those
> > > >are on the cosmetic side, but several seem to be relevant. I didn't
> > > >cross-check all of them, but the ones I tried did apply to linux-4.19.y.
> > > >The complete list is attached below.
> > > >
> > > >Question: Do Sasha's automated scripts identify such patches ? If not,
> > > >would it make sense to do it ? Or is there some reason why the patches
> > > >have not been applied to v4.19.y ?
> > > 
> > > Hey Guenter,
> > > 
> > > I have a very similar script with a slight difference: I don't try to
> > > find just "Fixes:" tags, but rather just any reference from one patch to
> > > another. This tends to catch cases where once patch states it's "a
> > > similar fix to ..." and such.
> > > 
> > > The tricky part is that it's causing a whole bunch of false positives,
> > > which takes a while to weed through - and that's where the issue is
> > > right now.
> > > 
> > 
> > I didn't see any false positives, at least not yet. Would it possibly
> > make sense to start with looking at Fixes: ? After all, additional
> > references (wich higher chance for false positives) can always be
> > searched for later.
> 
> I used to do this "by hand" with a tiny bit of automation, but need to
> step it up and do it "correctly" like you did.
> 
> If you have a pointer to your script, I'd be glad to run it here locally
> to keep track of this, like I do so for patches tagged with syzbot
> issues.
> 

I'd have to rewrite it to work with stable branches. Its current
primary goal is to assist the rebase of one chromeos branch to
a later upstream kernel release. I just repurposed part of it and
use the generated databases to identify patches tagged with Fixes:.

I'll be happy to do that and make it work on stable branches in
general if you think it would add value.

Thanks,
Guenter
