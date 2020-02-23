Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 068EE1698C2
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 18:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgBWRFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Feb 2020 12:05:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:54222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbgBWRFc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Feb 2020 12:05:32 -0500
Received: from localhost (95-141-97-180.as16211.net [95.141.97.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ED3D206E2;
        Sun, 23 Feb 2020 17:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582477530;
        bh=uvLFdQGH2ekEMSKWX3iQl3I4lFxy0ApQ8WhIThdkaGc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vxR9syzov2lvUrfcsNgKSJUIsEe7Lk2KOSsNOkyDh1v/V85/AlaZUo6sDiTMYPhz7
         65zgCMcgVOF9g8Vr/0xeBjFi7HtTJWwn8LfAOoUghSYcplONzSNiSLqLRBpKVz4NRg
         GEI6SLJNJVyfGgJXiG8liM/rGQ1DSO51RihGzGyQ=
Date:   Sun, 23 Feb 2020 18:05:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.5 000/399] 5.5.6-stable review
Message-ID: <20200223170528.GA275658@kroah.com>
References: <20200221072402.315346745@linuxfoundation.org>
 <66e39cf3-03a4-73b9-2886-1fdd0ab86866@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66e39cf3-03a4-73b9-2886-1fdd0ab86866@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 21, 2020 at 12:50:21PM -0700, shuah wrote:
> On 2/21/20 12:35 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.6 release.
> > There are 399 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 23 Feb 2020 07:19:49 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.6-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > 
> 
> Compiled and booted on test system. No dmesg regressions.

THanks, glad all of them worked for you :)

greg k-h
