Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5836F32F935
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 10:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbhCFJyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 04:54:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:42382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229948AbhCFJyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Mar 2021 04:54:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 827B26501C;
        Sat,  6 Mar 2021 09:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615024484;
        bh=3t0Honwtg8QotuPdU+EvzMZGtHX9pE9lXKP9qXZj42Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dZSdyH//+HbOhAaqHrI526h37ni/0UpMha/omvB96LbuV6pgSlzeDKeQL+iyZoucB
         YT1lS+fszmXIDQM2CoQObz4zldcAO3UpDfYhYrYlU8mfKN9zYfi6ikwUvOFDG1YjAb
         TZCLi8oGik0utQ3t/UnNL7/Q8HpNEREyoyb/41o8=
Date:   Sat, 6 Mar 2021 10:54:40 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/102] 5.10.21-rc1 review
Message-ID: <YENRYLA3A6w5RQbH@kroah.com>
References: <20210305120903.276489876@linuxfoundation.org>
 <20210306032428.GB193012@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210306032428.GB193012@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 07:24:28PM -0800, Guenter Roeck wrote:
> On Fri, Mar 05, 2021 at 01:20:19PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.21 release.
> > There are 102 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building arm:realview-pb-a8:realview_defconfig:realview_pb:mem512:arm-realview-pba8:initrd ... failed
> ------------
> Error log:
> kernel/rcu/tree.c:683:2: error: implicit declaration of function 'IRQ_WORK_INIT'

Ugh, I thought I dropped that patch last round, I'll go do it again
later today, thanks for catching this...

greg k-h
