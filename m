Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A863A8428
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhFOPlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:41:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230352AbhFOPlT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:41:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4AF66145F;
        Tue, 15 Jun 2021 15:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623771555;
        bh=j4NV5b5tSiIu4d3wvHca6j07bcg89F5ZYuu8B/HEpWs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UnD0yijqwPVhI9tcCZRHAg2COiwrxHGOjLyRS+d5YDNGc670K8vznWF1E+AQdc6Co
         Po6kwhOSxlQboSIM8Otqyph491J/CXlruvyo8+dq3VmIpbtC6ULMF/d0j5/+OInQdD
         eEAkhhYfqcqp6QkJvCmDWQS/nOmENlm56gUTTyRI=
Date:   Tue, 15 Jun 2021 17:39:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Philip =?iso-8859-1?Q?M=FCller?= <philm@manjaro.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: [systemd] v248.2 and later won't boot 4.19 kernel series
Message-ID: <YMjJocK3UcCLVl8H@kroah.com>
References: <a53e11ac-b2af-4410-9a7b-59a6ba8efca5@manjaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a53e11ac-b2af-4410-9a7b-59a6ba8efca5@manjaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 15, 2021 at 04:59:27PM +0200, Philip Müller wrote:
> Hello all,
> 
> with commit "mount-util: shortcut things after generating top-level bind
> mount" c2c331056a7c331a5478124b3cd6a34c9f539839
> (5c5753b9ea5cc012586ae90d357d460dec4301a4 in master) systemd 248.2 and
> later won't boot 4.19 kernel series. I tested 4.19.194 so far.
> 
> Lennart's  guess is that this is the mount table brokeness on old
> kernels, that newer libmount worked around. i.e. /proc/self/mountinfo on
> old kernels showed partially old data and partially new data, and
> confused the heck out of everyone. "proc on 20" with mount options
> "(rw,25)" doesn't look right at all.
> 
> If we look at 4.14 and 4.4 kernel series, those boot. 4.9 I've still to
> test, as that one didn't boot either for me.
> 
> So an idea what is missing in 4.19 kernel series? Other kernels work.

Do newer kernels work?

Any chance you can run 'git bisect' to find the offending kernel patch?

4.19 is really old, is this a stable-update-issue, or a "something
changed since 4.19 was released" type of issue?

> Systemd issue is this one: https://github.com/systemd/systemd/issues/19926

I'm running systemd 248.3 just fine here on 5.13-rc6, so this seems
odd...

thanks,

greg k-h
