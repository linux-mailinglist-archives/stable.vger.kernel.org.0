Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCAA9496258
	for <lists+stable@lfdr.de>; Fri, 21 Jan 2022 16:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343808AbiAUPwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 10:52:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36824 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351413AbiAUPwY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 10:52:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F102B619D6;
        Fri, 21 Jan 2022 15:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5D8C340E1;
        Fri, 21 Jan 2022 15:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642780343;
        bh=ykWY3CQ5loDnJaNSBREfd1LKDuSZSc1F4lekddV79E0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ph441/On/z28TNrAo7GzI+jfLsNFVdqXJ6EF3G9jvvN/t7W6ECz3/Mw8uQ4qoSbjd
         lrZNSYeuWyBKd+JXCQllNNzzP6vJQdGT2GvE8o/9SXjXuZzTHYtJ5f6SF2413UUEEX
         5YnLzg7MTYkc9iUYBNI/1osvOfNZUl/dJRJm5amQ=
Date:   Fri, 21 Jan 2022 16:52:20 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/23] 5.10.93-rc1 review
Message-ID: <YerWtNO2SOcg2zou@kroah.com>
References: <20220118160451.233828401@linuxfoundation.org>
 <CADVatmPaK616c8FW_iGjzMU9Cd81BndvGj+Zb-1dA7a6eCPw3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmPaK616c8FW_iGjzMU9Cd81BndvGj+Zb-1dA7a6eCPw3Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 21, 2022 at 03:02:43PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Thu, Jan 20, 2022 at 3:05 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.93 release.
> > There are 23 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
> > Anything received after that time might be too late.
> 
> gmail says you have sent this mail on "Jan 20, 2022 at 3:05 PM" but
> https://lore.kernel.org/stable/20220118160451.233828401@linuxfoundation.org/
> says you have sent it on "18 Jan 2022 17:05:40". :(

gmail does not like vger.kernel.org, sorry.

> Is it possible to add my email on the Cc list for the stable review
> mails please..

Now added!

greg k-h
