Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0CB5105B2F
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 21:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfKUUf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 15:35:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:53210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbfKUUf5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 15:35:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9F442067D;
        Thu, 21 Nov 2019 20:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574368557;
        bh=EBEuWEXiND5r+hzvfssTP/k6Pzy7IzSaEwfFoMMhtG4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hTLafm0tmhYvG24r+oqQKAppv2cnWeGr379P8zg4tUDualXOU7iS51eNapOndq0w5
         rmJSK96IY+YHN360Q0l6q5Vqqc7aZxD9hJlRiCPZokZB8pnIbWJ3pUtkM4uJL56bDt
         3yhtdxUuCoQuhiBhQ3ZFobG2pvbcigDuiZGOqsp0=
Date:   Thu, 21 Nov 2019 21:35:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mathieu Poirier <mathieu.poirier@linaro.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [stable 4.19+][PATCH 01/20] i2c: stm32f7: fix first byte to send
 in slave mode
Message-ID: <20191121203555.GC813260@kroah.com>
References: <20191115223356.27675-1-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115223356.27675-1-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 15, 2019 at 03:33:37PM -0700, Mathieu Poirier wrote:
> From: Fabrice Gasnier <fabrice.gasnier@st.com>
> 
> commit 915da2b794ce4fc98b1acf64d64354f22a5e4931 upstream

That commit is not in Linus's tree :(

I'll stop here.  Please check all of these and resend the whole thing.

Also, does this series also apply fully to 5.3.y?

thanks,

greg k-h
