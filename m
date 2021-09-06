Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90966401799
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 10:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240708AbhIFIKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 04:10:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240679AbhIFIKc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 04:10:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD0C161039;
        Mon,  6 Sep 2021 08:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630915768;
        bh=2rU8AFA62jI5s98cMHn3bmdHqREtcQP60uwSfcB4YU8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WQbWUHJYz3xBxDEVD2V75EP6CeiGUfr/MeUfmYAIdeS9+XhzDhp6N26YiBbkBQZSf
         RtCOhi9AnV7suDWt5Z+m094hH+rPyyd5kcjXiI8Y55bMTmx/YQZv/9M3a7m1UNUXxk
         ZaOHiAL/la/c3Ju+ZcRagpFEcqil+85NvXhqCSFg=
Date:   Mon, 6 Sep 2021 10:09:23 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org
Subject: Re: kernel/kexec_file.o: failed: Cannot find symbol for section 10:
 .text.unlikely.
Message-ID: <YTXMsxY9I6VdtVsS@kroah.com>
References: <CA+G9fYvMaHgSied79QBs3D=eDVETGH=3gxA8owCSRj313yEhVg@mail.gmail.com>
 <YTTbD+BKRpd0g4hq@kroah.com>
 <CA+G9fYs-K2f+eZW55u5uh1gQedTQpm=TGDNk7K1uOk8AeDNUQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYs-K2f+eZW55u5uh1gQedTQpm=TGDNk7K1uOk8AeDNUQA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 06, 2021 at 01:10:34PM +0530, Naresh Kamboju wrote:
> On Sun, 5 Sept 2021 at 20:28, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Sun, Sep 05, 2021 at 07:28:35PM +0530, Naresh Kamboju wrote:
> > > Following build errors noticed while building stable rc Linux 5.13.14
> > > with gcc-11 for powerpc architecture.
> 
> <trim>
> > Is this a regression?  Has this compiler ever been able to build this
> > arch like this?
> 
> Yes. It is a regression with gcc-11.
> 
> stable rc Linux 5.13.14 with gcc-11 - powerpc - FAILED
> stable rc Linux 5.13.14 with gcc-10 - powerpc - PASSED

Ah, ok, and does 5.14 or newer work properly?

thanks,

greg k-h
