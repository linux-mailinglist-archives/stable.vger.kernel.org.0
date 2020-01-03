Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0A912F9EE
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 16:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgACPpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 10:45:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:39872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727539AbgACPpV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jan 2020 10:45:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 255AC21734;
        Fri,  3 Jan 2020 15:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578066320;
        bh=iq1Twbqj7FIJKJlRQnhfVitva3hiAIvKZgahrbTOPeY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DUXQWZE0hh32tb6Qnaqv50moEJfXYD2EUDfklpYH2wiiP/FOWq2s3UtkOCJfHl7ad
         GLGYcuLyLMaNyDiBnBhE2FD1DDy8VdRBPJJEPI8NiFML6E30M140sC5jcW7ASm/7af
         K3q7vy9b7oBqtOKWAlmjVeodC0axBXP3FQl+Gbmc=
Date:   Fri, 3 Jan 2020 16:45:18 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>, LTP List <ltp@lists.linux.it>,
        Jan Stancek <jstancek@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 5.4 000/191] 5.4.8-stable review
Message-ID: <20200103154518.GB1064304@kroah.com>
References: <20200102215829.911231638@linuxfoundation.org>
 <CA+G9fYuPkOGKbeQ0FKKx4H0Bs-nRHALsFtwyRw0Rt5DoOCvRHg@mail.gmail.com>
 <CAK8P3a1+Srey_7cUd0xfaO8HdMv5tkUcs6DeDXzcUKkUD-DnGQ@mail.gmail.com>
 <CAK8P3a24EkUXTu-K2c-5B3w-LZwY7zNcX0dZixb3gd59vRw_Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a24EkUXTu-K2c-5B3w-LZwY7zNcX0dZixb3gd59vRw_Kw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 03, 2020 at 04:29:56PM +0100, Arnd Bergmann wrote:
> On Fri, Jan 3, 2020 at 4:25 PM Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > On Fri, Jan 3, 2020 at 4:03 PM Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > >
> > > On Fri, 3 Jan 2020 at 03:42, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> >
> > -ENOENT is what you get when hugetlbfs is not mounted, so this hints to
> >
> > 8fc312b32b2  mm/hugetlbfs: fix error handling when setting up mounts
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-5.4.y&id=3f549fb42a39bea3b29c0fc12afee53c4a01bec9
> 
> I see that Mike Kravetz suggested not putting this patch into stable in
> 
> https://lore.kernel.org/lkml/befca227-cb8a-8f47-617d-e3bf9972bfec@oracle.com/
> 
> but it was picked through the autosel mechanism later.

So does that mean that Linus's tree shows this LTP failure as well?

This does seem to fix a real issue, as shown by the LTP test noticing
it, so should the error code value be fixed in Linus's tree?

thanks,

greg k-h
