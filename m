Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 508581A6BD
	for <lists+stable@lfdr.de>; Sat, 11 May 2019 07:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbfEKFs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 May 2019 01:48:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727830AbfEKFs6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 May 2019 01:48:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A57D217F9;
        Sat, 11 May 2019 05:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557553737;
        bh=itXoTYB4xGUUfS/5Pyb0syU/300w0dOQlBIPHZaWCuo=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=xtJ7lW3UQtp83mMfNOod69VJMD/UipTZVUUVaSTDgfrH39S1Ag6nDqKBsWwqM/JOi
         Nir95xXWMMEIY0rnLEkX4WualjddxT9ABU2oOUKLLqkfdb53sew3pWsteJrU2jG2Jg
         IeGAGVJWPwWmhbv6ixwUlWnivpEpXDKRAzeIbFiU=
Date:   Sat, 11 May 2019 07:48:55 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/30] 5.1.1-stable review
Message-ID: <20190511054855.GC14153@kroah.com>
References: <20190509181250.417203112@linuxfoundation.org>
 <20190510162743.3m2psuvcugfqyt44@xps.therub.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190510162743.3m2psuvcugfqyt44@xps.therub.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 10, 2019 at 11:27:43AM -0500, Dan Rue wrote:
> On Thu, May 09, 2019 at 08:42:32PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.1 release.
> > There are 30 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 11 May 2019 06:11:35 PM UTC.
> > Anything received after that time might be too late.
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Great, thanks!
