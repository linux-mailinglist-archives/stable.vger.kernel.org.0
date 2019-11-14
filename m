Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E32FFBFE4
	for <lists+stable@lfdr.de>; Thu, 14 Nov 2019 06:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbfKNFxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 00:53:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:55048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbfKNFxg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Nov 2019 00:53:36 -0500
Received: from localhost (unknown [124.219.31.93])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0326D206EF;
        Thu, 14 Nov 2019 05:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573710814;
        bh=Xgz30iKxQRd0GmFUCyF7YPAyanz8lf1JP9Mom7yE9r4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J0XNmZ15b70yc2XNpvkSuw2RpGI9ylJQi9gba9NNc2hgj10ACl+ju8gaDUcDC0iFF
         /aLH2/7VmLClSziGel24ZA0ABe50QYLZphMjNjc8+WVUyrJ9IEN/arvq0PZpmDa7Rg
         Y5OzFGHsIEGDRlLlNTewvRr623ZX8mQiR7juuA04=
Date:   Thu, 14 Nov 2019 13:53:21 +0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Amit Pundir <amit.pundir@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Stable <stable@vger.kernel.org>,
        Jonas Gorski <jonas.gorski@gmail.com>,
        Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] MIPS: BCM63XX: fix switch core reset on BCM6368
Message-ID: <20191114055321.GA353293@kroah.com>
References: <1573642620-31192-1-git-send-email-amit.pundir@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573642620-31192-1-git-send-email-amit.pundir@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 13, 2019 at 04:27:00PM +0530, Amit Pundir wrote:
> From: Jonas Gorski <jonas.gorski@gmail.com>
> 
> commit 8a38dacf87180738d42b058334c951eba15d2d47 upstream.
> 
> The Ethernet Switch core mask was set to 0, causing the switch core to
> be not reset on BCM6368 on boot. Provide the proper mask so the switch
> core gets reset to a known good state.
> 
> Fixes: 799faa626c71 ("MIPS: BCM63XX: add core reset helper")
> Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
> Signed-off-by: Paul Burton <paul.burton@mips.com>
> Cc: linux-mips@vger.kernel.org
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: James Hogan <jhogan@kernel.org>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
> ---
> Cherry-picked from lede/openwrt https://git.lede-project.org/?p=source.git.
> Build tested on v4.{19,14,9,4}.y and v3.18.y for ARCH=mips bcm63xx_defconfig.

Now queued up, thanks.

greg k-h
