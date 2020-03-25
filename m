Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E814192FEA
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 18:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgCYRyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 13:54:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbgCYRyN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Mar 2020 13:54:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39BE1206F6;
        Wed, 25 Mar 2020 17:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585158852;
        bh=QGZiEA0zGV399sVDZaF9qMxI6xRLw4myU7zc9I2WKLY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d8tneQWCwjJBW71SGwMWSnCEptBeFTvfaBi80lM7p0D0DBLoPsenZNQm98WEl6XPF
         4UMXrXE+wszvRm4Qwe6NrjNgNeEx1u+vfnwtY469pJDMiccYcAeyQBJzWWw7Dc5K3o
         LeYwn1pFeh4rJ4vGN+ULxRbIdgNyJ9UvRpoGGc+Y=
Date:   Wed, 25 Mar 2020 18:54:08 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.5 000/119] 5.5.12-rc1 review
Message-ID: <20200325175408.GB3765240@kroah.com>
References: <20200324130808.041360967@linuxfoundation.org>
 <ec5380ae-add2-09af-1690-4edf509dd908@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec5380ae-add2-09af-1690-4edf509dd908@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 24, 2020 at 01:45:06PM -0600, shuah wrote:
> On 3/24/20 7:09 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.12 release.
> > There are 119 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 26 Mar 2020 13:06:42 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.12-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.

Thanks for testing these and letting me know.

greg k-h
