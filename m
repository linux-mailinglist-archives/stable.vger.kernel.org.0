Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A64C2F9283
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 14:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbhAQNWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 08:22:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:51748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729061AbhAQNWW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Jan 2021 08:22:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93D0C2222A;
        Sun, 17 Jan 2021 13:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610889700;
        bh=riM90acQxAdtoJ3lgWp5vBzwCMeevI3YQqDy0Yd/EtM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t5jhMFGUdHrXLVkYA5mQ6Hc9kQRlORTgaQru90NTJ1YqQOYpyQtG/IwRUXbB1aTbd
         u2D3vcPhWTPdqXt8RO2ggyrYgz8em0n4Jpv4BfwVCvZISVla0rpB6gkekGqzwa26WX
         fVAjZD/5YG8nMqUpPNzA1T0ZENhCac3VxlSOawy0=
Date:   Sun, 17 Jan 2021 14:21:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/103] 5.10.8-rc1 review
Message-ID: <YAQ54hsnWcKlzhdt@kroah.com>
References: <20210115122006.047132306@linuxfoundation.org>
 <20210116075731.GA14187@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210116075731.GA14187@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 16, 2021 at 08:57:31AM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.8 release.
> > There are 103 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> CIP testing did not find any problems here:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Hey, CIP cares about 5.10.y?  Nice?  Thanks for testing.

greg k-h
