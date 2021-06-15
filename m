Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E990C3A862B
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 18:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbhFOQQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 12:16:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229943AbhFOQQK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 12:16:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08C2261603;
        Tue, 15 Jun 2021 16:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623773645;
        bh=VCcx4oqoxEtCrM5C9e51TQ7ZUcwRqL/PyOpDDq0/vLs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g0VPiXsApNr991AlmNCw9lZQsVPN6O2Gqb3xEVnHrVhnbFZRtiSCPsv+EspDSMvae
         I3PB4KnHTLny4wtSvlT1b0WhFeSATydkK9Tij9WkCMrh9E/cdSSOJd21YdmID3/9yh
         Uop7Okv76WZdwVvvjF9nntoLl3qDCpKzmZ5ZT46I=
Date:   Tue, 15 Jun 2021 18:14:03 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Philip =?iso-8859-1?Q?M=FCller?= <philm@manjaro.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: [systemd] v248.2 and later won't boot 4.19 kernel series
Message-ID: <YMjRy0Wm+iNHRo+D@kroah.com>
References: <a53e11ac-b2af-4410-9a7b-59a6ba8efca5@manjaro.org>
 <YMjJocK3UcCLVl8H@kroah.com>
 <165856f8-4a42-cdf3-e9cd-5fac51e8d168@manjaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <165856f8-4a42-cdf3-e9cd-5fac51e8d168@manjaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 15, 2021 at 06:05:30PM +0200, Philip Müller wrote:
> On 15.06.21 17:39, Greg Kroah-Hartman wrote:
> > Do newer kernels work?
> > 
> > Any chance you can run 'git bisect' to find the offending kernel patch?
> > 
> > 4.19 is really old, is this a stable-update-issue, or a "something
> > changed since 4.19 was released" type of issue?
> 
> Older and newer kernel series work. So 4.4, 4.14, 5.10 and 5.13 I've
> tested so far. No issues with 248.3 of Systemd. Have to see if any 4.19
> kernel boot with that version ...

Please always be specific as to what .y version of the above kernels you
are testing, as there have been thousands of changes from the "first"
4.4.0 release to the release that is supported today (4.4.272).

And note that there is not a 5.13 kernel released yet :)

thanks,

greg k-h
