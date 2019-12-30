Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70A2412D2EB
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 18:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfL3RoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 12:44:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:49046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727236AbfL3RoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Dec 2019 12:44:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E8C72053B;
        Mon, 30 Dec 2019 17:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577727843;
        bh=FLgp/j+ukUhU6HmICGjCgGWT/HfCkbO248F0WJRq/2w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uxrEXUpZbo+UuahivUnhFPnFFZkL6C3kJePXM4rVToNr3o1vL28pgw69MSCCefqyA
         kQiJxmrEtgGRdroYwyQxdQuqHun7an+FOdXylVdv52v4MpidD6J8lbiCdUD/gCttA6
         fRz+R/+XfdpPFI5b6FX60RtmybbeyRnyMaW3S95M=
Date:   Mon, 30 Dec 2019 18:44:01 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/219] 4.19.92-stable review
Message-ID: <20191230174401.GB1498696@kroah.com>
References: <20191229162508.458551679@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 29, 2019 at 06:16:42PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.92 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 31 Dec 2019 16:17:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.92-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.

I have pushed out a -rc2 to resolve some reported issues:

 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.92-rc2.gz

