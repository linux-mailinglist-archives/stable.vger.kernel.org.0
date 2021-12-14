Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F22474628
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 16:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbhLNPPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 10:15:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39618 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbhLNPPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 10:15:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59A61B81A2B;
        Tue, 14 Dec 2021 15:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA0DC34601;
        Tue, 14 Dec 2021 15:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639494941;
        bh=MPu8CAyDw/A53SmnHgiA9hbt+Vy7Py79VXTj5qrYPzE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gXqlfiefVw7up3CqVeBQwDTQeMR9/iSnNM67bZ6Ln7p3KJIjYsPD9UwLu8YDv8XMs
         VlgjPe0ZY/NGkhzwk/fu37uMxHbd38eBvOi0/bJMD4Ta/HPN1fmXCN9V27QDTtjKeX
         R9YokX/ZAZx2ETUO6b4fpQKQLbvE+Evwb9cLE1L0=
Date:   Tue, 14 Dec 2021 16:15:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Subject: Re: [PATCH 5.10 000/132] 5.10.85-rc1 review
Message-ID: <Ybi1GoXuiJkWWxIA@kroah.com>
References: <20211213092939.074326017@linuxfoundation.org>
 <52a7fa5d-6fa0-a0df-2e88-bd4bf443a671@linaro.org>
 <68145d95-1b6a-153e-42ba-43d18b705a70@canonical.com>
 <20211214070059.1017e7e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211214070059.1017e7e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 14, 2021 at 07:00:59AM -0800, Jakub Kicinski wrote:
> On Tue, 14 Dec 2021 07:43:18 +0100 Krzysztof Kozlowski wrote:
> > On 13/12/2021 19:17, Tadeusz Struk wrote:
> > > On 12/13/21 01:29, Greg Kroah-Hartman wrote:  
> > >> This is the start of the stable review cycle for the 5.10.85 release.
> > >> There are 132 patches in this series, all will be posted as a response
> > >> to this one.  If anyone has any issues with these being applied, please
> > >> let me know.
> > >>
> > >> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> > >> Anything received after that time might be too late.
> > >>
> > >> The whole patch series can be found in one patch at:
> > >> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.85-rc1.gz
> > >> or in the git tree and branch at:
> > >> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > >> and the diffstat can be found below.  
> > > 
> > > In this release cycle there were two similar nfc fixes:
> > > 
> > > fd79a0cbf0b2 nfc: fix segfault in nfc_genl_dump_devices_done
> > > 4cd8371a234d nfc: fix potential NULL pointer deref in nfc_genl_dump_ses_done
> > > 
> > > The list here only includes the second one. The first is still missing.
> > > The same applies to 5.15  
> > 
> > With my review tag for this other fix I mentioned it needs Fixes and
> > Cc-stable, but these were not added by Jakub when applying. It won't be
> > picked up automatically by Greg.
> > 
> > Jakub,
> > What's weird, the cc-stable was also removed from my commit which is not
> > good. Few other people add Fixes tag without Cc-stable when they want to
> > annotate it should not go to stable. This one should go to stable, so it
> > should have cc-stable (which I put there).
> 
> 😳 no idea what happened here, I remember adding the tags, sorry..

Not a problem, I've now queued it up everywhere, thanks.

greg k-h
