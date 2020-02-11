Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58DA7158E39
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 13:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgBKMRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 07:17:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:48080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727264AbgBKMRo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Feb 2020 07:17:44 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12B132082F;
        Tue, 11 Feb 2020 12:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581423463;
        bh=zSIdn+GH8BgGNY92odmcvzLESVO6ymrDNMAN7/E0UgY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TmfjOvkzsyrCjuJUApLspybSs45ccTGEh/jfTYP9377FyhCs9s40J71CCMGJX++7U
         AYzRXZYo5dmENds8X53HX0BclvSgMIgPRgNK/kLAAXh71MdVgv4YKAu5o1fCOaHmSl
         8mc6ZnneNCfX9RVlZJo84nbVGfmZ5zE0xm7OUxY8=
Date:   Tue, 11 Feb 2020 04:17:42 -0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.5 000/367] 5.5.3-stable review
Message-ID: <20200211121742.GB1856500@kroah.com>
References: <20200210122423.695146547@linuxfoundation.org>
 <e641b25d-02c1-d169-bf36-511ded28ec09@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e641b25d-02c1-d169-bf36-511ded28ec09@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 10, 2020 at 03:40:36PM -0700, shuah wrote:
> On 2/10/20 5:28 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.3 release.
> > There are 367 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 12 Feb 2020 12:18:57 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.3-rc1.gz
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

Great, thanks for testing and letting me know so quickly.

greg k-h
