Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E07C31D707
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 10:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhBQJ3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 04:29:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:52766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232135AbhBQJ3c (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Feb 2021 04:29:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80FEC64E5F;
        Wed, 17 Feb 2021 09:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613554132;
        bh=YEi/ewfZVB/AvVy5pg2wOR0kwCoSssyw5ehtHHmjonQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c3pP9o0cfVdJ0PJrdjvDd4YXT3ZUsW+NTqeE2uWNyKcqG0jNZT8D3dhePPtN1W5jJ
         A0/xDa/jKnWBN0dszACDWjvQJS8lOL36ZdB2xlydF6L4kFpCOoCH4H8xqNyKEtglMA
         isw9GfipyzQ+6jyR3InUtHPIoy9Iy2RHlrFKFOAw=
Date:   Wed, 17 Feb 2021 10:28:49 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 022/104] kbuild: simplify GCC_PLUGINS enablement in
 dummy-tools/gcc
Message-ID: <YCzh0SCwwHGJ9iGV@kroah.com>
References: <20210215152719.459796636@linuxfoundation.org>
 <20210215152720.193592547@linuxfoundation.org>
 <20210217090854.GA7693@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210217090854.GA7693@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 17, 2021 at 10:08:54AM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Masahiro Yamada <masahiroy@kernel.org>
> > 
> > [ Upstream commit f4c3b83b75b91c5059726cb91e3165cc01764ce7 ]
> > 
> > With commit 1e860048c53e ("gcc-plugins: simplify GCC plugin-dev
> > capability test") applied, this hunk can be way simplified because
> > now scripts/gcc-plugins/Kconfig only checks plugin-version.h
> 
> AFAICT referenced commit 1e860048c53e ("gcc-plugins: simplify GCC
> plugin-dev capability test") is not present in 5.10-stable branch, so
> I believe this should not be applied, either.

Good catch, now dropped.

thanks,

greg k-h
