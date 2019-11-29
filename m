Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E11E10D2AC
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 09:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfK2IwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 03:52:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:54424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbfK2IwF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Nov 2019 03:52:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02E26217BC;
        Fri, 29 Nov 2019 08:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575017524;
        bh=a2gXV0Y9r/sziEevLu0eEMI6cg/pB6OcEoU21Emm4eI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RdlkLZWG3mVweXi4I+tOXH9UxYu5/160Q7iHZ6zHpdhm+Rx5hXn5dVyhtgk9Z6oQJ
         pmT8gyKgQkieDiiS+m0G36nMdyIUvsOqL0tfZ5VPq6Xg8iXIKMx+EW4c3N2k+Uadsx
         iUuNyv80IY2YFymTs1TOXlC5NjaKNDaeUWqofjxI=
Date:   Fri, 29 Nov 2019 09:52:02 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/66] 5.4.1-stable review
Message-ID: <20191129085202.GB3584430@kroah.com>
References: <20191127202632.536277063@linuxfoundation.org>
 <1d97b6c7-6fa0-4a74-b48a-c54ef120148b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d97b6c7-6fa0-4a74-b48a-c54ef120148b@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 28, 2019 at 08:40:04AM -0700, shuah wrote:
> On 11/27/19 1:31 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.1 release.
> > There are 66 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.1-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.

Great, thanks for testing these and letting me know.

greg k-h
