Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D4228DAA0
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 09:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgJNHq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 03:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbgJNHq3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Oct 2020 03:46:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9752020B1F;
        Wed, 14 Oct 2020 07:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602661589;
        bh=Midhh7OhLWdknc0jXF9rbM4Tjl22Uw4c60QmPeECqXA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HiLHMu1z3er8W5a7KayjS0SgrCxgyE74US5kcAYVZAWNcxKu4FUWQePH6imyO5W6Q
         aGUPvb355IQSJgcLzlIp/gU5VGSWxpXjFxztWgyG3xqg8v49lqkdnTw9qysl2WN3z0
         PauqRhwL4dTT8Mwhx5q385Dh+eS7rjPVEKzk8h8k=
Date:   Wed, 14 Oct 2020 09:47:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/39] 4.4.239-rc1 review
Message-ID: <20201014074704.GA3002862@kroah.com>
References: <20201012132628.130632267@linuxfoundation.org>
 <20201013181155.GB23594@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013181155.GB23594@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 13, 2020 at 08:11:55PM +0200, Pavel Machek wrote:
> On Mon 2020-10-12 15:26:30, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.239 release.
> > There are 39 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 14 Oct 2020 13:26:14 +0000.
> > Anything received after that time might be too late.
> 
> Tested-by: Pavel Machek  (CIP) <pavel@denx.de>

Why the '  '?

