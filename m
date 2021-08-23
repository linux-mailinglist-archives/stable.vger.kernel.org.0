Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED3C3F5864
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 08:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbhHXGoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 02:44:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232040AbhHXGoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 02:44:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD7B5610E9;
        Tue, 24 Aug 2021 06:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629787400;
        bh=cZtsXgWO7DMRgYrwV9KWwAx/OrCZbrHnFx1TdQp61tU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rxNm8D1o3kX7Ib7W1EdRY814sVfTge1SM00Kn6O2t85PEOuhQP4SxvRhMOzxGwy8d
         1f/vJD2+a4AupVKYBRw0SwTOF4pa2CW+s5jPDE/8Klks9V3W+/++0J8M3LWXZq+Xe6
         Iqhck00sSapK4AtOUoK3TjAz85ttdEhTWBtsod1Q=
Date:   Mon, 23 Aug 2021 21:04:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: Drivers for Qualcomm wifi chips (ath*k) and security issues
Message-ID: <YSPxO+VGnSopgn5G@kroah.com>
References: <20210823140844.q3kx6ruedho7jen5@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210823140844.q3kx6ruedho7jen5@pali>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 23, 2021 at 04:08:44PM +0200, Pali Rohár wrote:
> Hello Sasha and Greg!
> 
> Last week I sent request for backporting ath9k wifi fixes for security
> issue CVE-2020-3702 into stable LTS kernels because Qualcomm/maintainers
> did not it for more months... details are in email:
> https://lore.kernel.org/stable/20210818084859.vcs4vs3yd6zetmyt@pali/t/#u
> 
> And now I got reports that in stable LTS kernels (4.14, 4.19) are
> missing also other fixes for other Qualcomm wifi security issues,
> covered by FragAttacks codename: CVE-2020-26145 CVE-2020-26139
> CVE-2020-26141

Then someone needs to provide us backports if they care about these
very old kernels and these issues.  Just like any other driver subsystem
where patches are not able to be easily backported.

Or just use a newer kernel, that's almost always a better idea.

thanks,

greg k-h
