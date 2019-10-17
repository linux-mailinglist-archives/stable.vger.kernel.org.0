Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF3EADB198
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 17:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395426AbfJQPzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 11:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393660AbfJQPzb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Oct 2019 11:55:31 -0400
Received: from localhost (unknown [192.55.54.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C8E821835;
        Thu, 17 Oct 2019 15:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571327731;
        bh=diocG/Rt1f0gK06qV1OaITtWGAh2IgnLkH3mfgWfeiw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gUxoLl8qzUNejKGWlB4SsovetEBlGJcSI9/aLK9FnNBb+ELDsHLrp3e++ZOOo+Ltb
         ySJNoSp/3fspJlVzUy7QomxQcUWzn3/Ci+ReWVzE+xAhAlY89a4ZRuldyUq/8CwWz6
         55XGuaKNN/7sQpyPQSNe55FHn2Rwm9ybb6hQniyk=
Date:   Thu, 17 Oct 2019 08:55:30 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.3 000/112] 5.3.7-stable review
Message-ID: <20191017155530.GA1079687@kroah.com>
References: <20191016214844.038848564@linuxfoundation.org>
 <acdb7f75-fa39-32ee-0e6d-ba0098a2ca35@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acdb7f75-fa39-32ee-0e6d-ba0098a2ca35@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 17, 2019 at 09:13:00AM -0600, shuah wrote:
> On 10/16/19 3:49 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.7 release.
> > There are 112 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 18 Oct 2019 09:43:41 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.7-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.

Thanks for testing all of these and letting me know.

greg k-h
