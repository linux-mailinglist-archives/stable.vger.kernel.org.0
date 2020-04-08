Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 614841A1C50
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 09:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbgDHHJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 03:09:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgDHHJZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Apr 2020 03:09:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4F6620747;
        Wed,  8 Apr 2020 07:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586329765;
        bh=BuhkXQ0s0C51NfwZIsfiuK5YSd7040TiHqdVwv80cDk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KnRDYy8oyfy4vx6CQoNjBBsyP154IW3MM+mpgtrohE6OiWXwZCiILBOGw00dBqOys
         lvp/4rQj4MqanUImLtdEtJypDN47+9WxuLv5Ns3TsEGwkRGlRFXhTHrsN0Gu1lIEOu
         qUuifz7iWXqbj7M9qRmuG1evBTFfuBXB59fGSj8s=
Date:   Wed, 8 Apr 2020 09:09:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.6 00/30] 5.6.3-rc2 review
Message-ID: <20200408070922.GA1019278@kroah.com>
References: <20200407154752.006506420@linuxfoundation.org>
 <e30dcce7-93e7-801f-6cf4-72028bcbd56d@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e30dcce7-93e7-801f-6cf4-72028bcbd56d@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 07, 2020 at 07:44:54PM -0700, Guenter Roeck wrote:
> On 4/7/20 9:39 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.3 release.
> > There are 30 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 09 Apr 2020 15:46:32 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 428 pass: 428 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
