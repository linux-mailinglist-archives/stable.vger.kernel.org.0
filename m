Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2B4492D1B
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 19:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiARSSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 13:18:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbiARSSt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 13:18:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02875C061574;
        Tue, 18 Jan 2022 10:18:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B477DB8173F;
        Tue, 18 Jan 2022 18:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9666C340E0;
        Tue, 18 Jan 2022 18:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642529926;
        bh=iYc3f1Yn77HYG2PAOhBLn8hldp4BZ7PpTNw/u3x8n+w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rKOzPdmPq0KhH+KMmoOGHcC/UveU7liTb2/oqUyL7cznc6lYb6LWEWVq89Qlaf4va
         G8vBpuKm/mTS7O2mzqBoX7Fwd/3csXHA1u0tYRt8xIhEKWTJXsVXNyaeMU9BEoQufD
         tm96qGh0c1/MeM+2oor8bkzTrjteqrlx/UNUTIoc=
Date:   Tue, 18 Jan 2022 19:18:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/23] 5.10.93-rc1 review
Message-ID: <YecEgzBLtKvzcHQS@kroah.com>
References: <20220118160451.233828401@linuxfoundation.org>
 <20220118173524.GA17462@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118173524.GA17462@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 06:35:24PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.93 release.
> > There are 23 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> CIP testing did not find any new kernel problems here (but we still
> hit the gmp.h compilation issue):

If it bothers you, patches are always welcome.

thanks,

greg k-h
