Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3364115051
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 13:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbfLFMXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 07:23:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:43206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbfLFMXj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Dec 2019 07:23:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC19A21823;
        Fri,  6 Dec 2019 12:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575635018;
        bh=4SaNeyBgCMVwBZ5U53sdUg+xixOLn/gSE2bbw6AahA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UaYKf43au27jDELHj8VHdYaD3gzAg3+5qgxAaBt1V5o8nL0D0sygiKXFpJRGyabSU
         atFu25ZgoBCAC4NWFKCPEgXW3F5BdkPO/TM2v6lxG85AjsOfY7s4zM3rTR6ypL3zty
         sqUnEnWf9tOd5PSMwxuj0VgHuubev8BbibZWphMI=
Date:   Fri, 6 Dec 2019 13:23:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     stable@vger.kernel.org, linux-tegra <linux-tegra@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: Re: stable request: 5.4.y: arm64: tegra: Fix 'active-low' warning
 for Jetson
Message-ID: <20191206122335.GA1339268@kroah.com>
References: <16724779-0514-ca92-58b2-95f4e244c6f7@nvidia.com>
 <28364ffa-586e-bdcd-acf3-119742c92185@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28364ffa-586e-bdcd-acf3-119742c92185@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 06, 2019 at 11:04:38AM +0000, Jon Hunter wrote:
> 
> On 06/12/2019 10:55, Jon Hunter wrote:
> > External email: Use caution opening links or attachments
> 
> Sorry ignore the above nonsense. Looks like a nice new 'feature' that
> was sprung on us. I should be able to get this removed for future.

Odd, I don't see that on your email at all, perhaps you got it on the
return to you?
