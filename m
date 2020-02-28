Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0B7B1736B9
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 12:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725796AbgB1L7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 06:59:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:41160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgB1L7U (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 06:59:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D562324695;
        Fri, 28 Feb 2020 11:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582891160;
        bh=hbwOTvs0FRewGXs0JTjCEPKTJvdCoWek/2cboYpt4Ww=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BYnsB85XmBK9She/R2yzTwjfJAOBYIJCn3s2i5qksr/E+7hXH/zfVFhL+RDuEET+K
         BzOTAtl3m6BkjFavnKWe/iiRe+Cka/dwsw0jnaVc0dmV45yPkuo+K2Oi9QPbe2Xvos
         XZ60s95/gcKrJA46hr1WwU1Kj9MahHQTpKeiU8Ho=
Date:   Fri, 28 Feb 2020 12:59:17 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/165] 4.9.215-stable review
Message-ID: <20200228115917.GA3010957@kroah.com>
References: <20200227132230.840899170@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 27, 2020 at 02:34:34PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.215 release.
> There are 165 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.215-rc1.gz

-rc2 is out to hopefully resolve the powerpc build issues that were
found:
 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.215-rc2.gz

