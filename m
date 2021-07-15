Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D066B3C9D71
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 13:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241594AbhGOLJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 07:09:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232607AbhGOLJD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 07:09:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B544E613BA;
        Thu, 15 Jul 2021 11:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626347169;
        bh=QkOkdUcOViEhBVsoPhE8IodYpSf+Cok4kd3koRr61RI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GshbyFE8OMeovccRyU/24dc0jWn06Lmw5IX9tYxWZ6+YK2P9LDadKo5vQtDONor5a
         zfHQS+3AdlqSd/ViGiX1J+Y6M/gxJff5BQYHi6XCoRqSkwuobdmNTtOvjeZIzGriKd
         Tn4APXo5sCYRBHrDLOmrXqKxFHzGXK04lXX6wwAQ=
Date:   Thu, 15 Jul 2021 13:05:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        perf-users <perf-users@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, Leo Yan <leo.yan@linaro.org>
Subject: Re: perf: bench/sched-messaging.c:73:13: error: 'dummy' may be used
 uninitialized
Message-ID: <YPAWlsL4a5uqrDWU@kroah.com>
References: <CA+G9fYubOg+Pu8N3LYFKn-eL3f=gn4ceK9Asj1RdBDntU_A2ng@mail.gmail.com>
 <YO2upa4SZWS59KeB@kroah.com>
 <CADYN=9+vr=xHsY8yinyWUTN+xyEG=v8-xf4y2psDarFKWDU6xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADYN=9+vr=xHsY8yinyWUTN+xyEG=v8-xf4y2psDarFKWDU6xA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 13, 2021 at 05:32:17PM +0200, Anders Roxell wrote:
> On Tue, 13 Jul 2021 at 17:18, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Jul 13, 2021 at 08:40:28PM +0530, Naresh Kamboju wrote:
> > > LKFT have noticed these warnings / errors when we have updated gcc version from
> > > gcc-9 to gcc-11 on stable-rc linux-5.4.y branch. I have provided the steps to
> > > reproduce in this email below.
> > >
> > > Following perf builds failed with gcc-11 with linux-5.4.y branch.
> > > - build-arm-gcc-11-perf
> > > - build-arm64-gcc-11-perf
> > > - build-i386-gcc-11-perf
> > > - build-x86-gcc-11-perf
> > >
> > > Build error log:
> > > --------------------
> >
> > <snip>
> >
> > I imagine this is fixed in newer kernel versions, so if you could
> > provide the git ids of the patches needed to fix this up in 5.4, that
> > would be great!
> 
> You were correct, I did a bisect [1] and found
> d493720581a6 ("perf bench: Fix 2 memory sanitizer warnings").
> 
> commit d2c73501a767514b6c85c7feff9457a165d51057 upstream.
> 
> Cherry picked it and I was able to build it on arm64 and x86.

Great, now queued up, thanks.

greg k-h
