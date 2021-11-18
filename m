Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129FC455DC6
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 15:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbhKROTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 09:19:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:44120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232893AbhKROTj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Nov 2021 09:19:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48D596113A;
        Thu, 18 Nov 2021 14:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637244999;
        bh=4JwU3fX1uJCAvmiXSQ4bU1iDlshZoY0SKtPH3i2r2iM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S6hBMbUKmBgMC5CGDqYNPGS7vbtCk8eZ1I008a1bH3mCZrTxNGqHtI0CYccscVIFz
         zu56tJuKQ7cm18WKuguZ0MmiBS4VaX20QoynJJrhipcXiDaCccv8Pnmo6NO9y9M6U4
         t6P045SAfUzfvYXJ0RZYHfFzGue+UyPfNJkL3A/Q=
Date:   Thu, 18 Nov 2021 15:16:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Orson Zhai <orsonzhai@gmail.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>, orson.zhai@gmail.com,
        Orson Zhai <orson.zhai@unisoc.com>
Subject: Re: [PATCH V2 0/2] scsi/ufs: Cherry-pick 2 fixes for null pointer
 into 5.4.y only
Message-ID: <YZZgRcERU6pfOuyU@kroah.com>
References: <1637244422-29190-1-git-send-email-orsonzhai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1637244422-29190-1-git-send-email-orsonzhai@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 18, 2021 at 10:07:00PM +0800, Orson Zhai wrote:
> From: Orson Zhai <orson.zhai@unisoc.com>
> 
> Hi Greg,
> 
> Change v1->v2:
> 
> - Remove Change-id in commit message.
> - Fix build error for one struct member missing.
> 
> I am sorry for my careless about not testing for build before submitting.

Now queued up, thanks.

greg k-h
