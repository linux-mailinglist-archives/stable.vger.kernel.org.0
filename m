Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B717DC2D60
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 08:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732795AbfJAGSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 02:18:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732244AbfJAGSs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 02:18:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0C8A215EA;
        Tue,  1 Oct 2019 06:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569910728;
        bh=kfPZji0+3HvrO42fNpPrkUOd+8JyJK2N8aUJ6hLRLuY=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=ChDBWfyHATgJijtOUH/4MZcbZC9OpTnExDOE86d+0PU3gwr5ItpS7dLIesBrEtAE4
         GmkLlvSMoKtm9a4NbTGDiKe3nq54bKRXZAHKoy1P0jEQYs+Ro4/YcQBBqs0VZLs/F2
         rapGs95KuF/KrRP165GAl0OrIn8pxwFpmULRRCGI=
Date:   Tue, 1 Oct 2019 08:18:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.3 00/25] 5.3.2-stable review
Message-ID: <20191001061845.GB2815916@kroah.com>
References: <20190929135006.127269625@linuxfoundation.org>
 <20191001011137.ec2ascntddpgkr2n@xps.therub.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191001011137.ec2ascntddpgkr2n@xps.therub.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 30, 2019 at 08:11:37PM -0500, Dan Rue wrote:
> On Sun, Sep 29, 2019 at 03:56:03PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.2 release.
> > There are 25 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue 01 Oct 2019 01:47:47 PM UTC.
> > Anything received after that time might be too late.
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Thanks for testing all of these and letting me know.

greg k-h
