Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401A7313293
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 13:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbhBHMlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 07:41:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:49466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232143AbhBHMkc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 07:40:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F45164E82;
        Mon,  8 Feb 2021 12:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612787991;
        bh=Jc94NUe/kCu7ffG+vvG2UIdDkec42WbVi/swYOdo1bQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lYfHlYDH3v4nmCUAMtTXrGWoY7K7/qJeN3CltMdWNLR4lyagMSzcfRbHholbaRH0d
         Pov6jPOECJY70eRrjM6iOcAMSg3Rj6yBEt2IqbubXwROurvCnZkDPF69aDNYOnwIdY
         kVrGyKvnA/vb0H3Qh7qQTg+tToOg6QXYG0dKAZGM=
Date:   Mon, 8 Feb 2021 13:39:49 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/57] 5.10.14-rc1 review
Message-ID: <YCExFYfm3WiGaRLv@kroah.com>
References: <20210205140655.982616732@linuxfoundation.org>
 <20210205231140.GA11591@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205231140.GA11591@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 06, 2021 at 12:11:40AM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.14 release.
> > There are 57 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> CIP testing did not find any problems here:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for testing some of these and letting me know.

greg k-h
