Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4AE169871
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 16:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgBWPk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Feb 2020 10:40:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:39088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727069AbgBWPk2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Feb 2020 10:40:28 -0500
Received: from localhost (95-141-97-180.as16211.net [95.141.97.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A70E206E0;
        Sun, 23 Feb 2020 15:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582472427;
        bh=Z8JTCN9ynirPfFpiNMj7oH3o0KhFkMgy/VcRwAhOc5I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K2WabDH2aI4xVlE0R9iHOxaACB3CRi2Z+rTzXraiRD1qjTn+Dg31TaS8LM6ji/a1F
         f7QDEzWWB6M1/57/3Cum06OPamU6q/PQMYkvTyXCHTt9UQouXybEoRzFu4T9zDuDNM
         C8rEUV7ul4mCKB5WjMY9zetqNTMO0HSDyPC1yvKg=
Date:   Sun, 23 Feb 2020 16:40:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.5 000/399] 5.5.6-stable review
Message-ID: <20200223154024.GA131562@kroah.com>
References: <20200221072402.315346745@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 21, 2020 at 08:35:25AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.6 release.
> There are 399 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Feb 2020 07:19:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> and the diffstat can be found below.

I've released -rc2 with a bunch of changes that I hope should resolve
the issues reported:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.6-rc2.gz

