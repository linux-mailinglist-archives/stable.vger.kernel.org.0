Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5E1CCC881
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 09:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbfJEHGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 03:06:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbfJEHGj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Oct 2019 03:06:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 450C92084D;
        Sat,  5 Oct 2019 07:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570259197;
        bh=bZ3S6M+tppROGoeiqGHXYSquyaDbnGfsuUVX5YI/H28=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=EckSN4KsvyXNoIF5n8/51d2X7RhKVUa4SFrNXlgEBshi+Ck54zXOinWuO77OsM40U
         fquyE3tjjF0o2g0M5CtdNHwtQvlBDxVg/CElp99hvgjUib6FIP/kP9NNwh9rV27/YD
         V3FJ+FLO0cG6Eg9Krh7pCM852ZB/d1MMY8TXftVU=
Date:   Sat, 5 Oct 2019 09:06:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.3 000/344] 5.3.4-stable review
Message-ID: <20191005070633.GA929790@kroah.com>
References: <20191003154540.062170222@linuxfoundation.org>
 <20191004153707.m3bzk2wiyw4tn6vq@xps.therub.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191004153707.m3bzk2wiyw4tn6vq@xps.therub.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 04, 2019 at 10:37:07AM -0500, Dan Rue wrote:
> On Thu, Oct 03, 2019 at 05:49:25PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.4 release.
> > There are 344 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 05 Oct 2019 03:37:47 PM UTC.
> > Anything received after that time might be too late.
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Thanks for testing all o fthese and letting me know.

greg k-h
