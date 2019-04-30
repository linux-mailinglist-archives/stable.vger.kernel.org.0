Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA98EF45A
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 12:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfD3KlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 06:41:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbfD3KlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 06:41:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C33D42075E;
        Tue, 30 Apr 2019 10:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556620864;
        bh=5A29S3cnWeF4VgOVYXaq06PYgt6Ur5/12rFsJgdRx+c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AnPltY9zbOygFy8W7YFwRfPcdBDU87InA7ZUBB9blqQlm/dGEMzreXogDibUYAp3S
         RsJth5izYyFeiVNKUWKyhVI/RJI/AXSof62ydI7w66K8OXE1sxmk+IDGDf/7YmNvjq
         X/eeafWYjhBUE0OW1eBpbGk6UIAeb6tJdux/zXHA=
Date:   Tue, 30 Apr 2019 12:41:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Diana Craciun <diana.craciun@nxp.com>
Cc:     stable@vger.kernel.org, linuxppc-dev@ozlabs.org, mpe@ellerman.id.au
Subject: Re: [PATCH stable v4.4 0/8] missing powerpc spectre backports for 4.4
Message-ID: <20190430104102.GA28863@kroah.com>
References: <1556552948-24957-1-git-send-email-diana.craciun@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556552948-24957-1-git-send-email-diana.craciun@nxp.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 29, 2019 at 06:49:00PM +0300, Diana Craciun wrote:
> Hi Greg,
> 
> These are missing patches from the initial powerpc spectre backports for 4.4.
> Please queue them as well if you don't have any objections.

I applied the first 6 of these now.  If you could fix up the last two
and resend them, that would be wonderful.

thanks,

greg k-h
