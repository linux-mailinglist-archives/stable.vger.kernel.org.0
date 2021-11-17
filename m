Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B11454C98
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 18:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbhKQR63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 12:58:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231311AbhKQR63 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 12:58:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8E3160FED;
        Wed, 17 Nov 2021 17:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637171730;
        bh=yCqyiR3f8BPeFgG5svMHeznv+d2H+TfNDD4WW+XrCIc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LwIcpf2AehvzjZ+I1Fpmfnk6jID/JA7cEnb8BI/zEDXR8AyamuhdpaROawctCwlaI
         6xGPiV2mt6+gU1oj1t8EfVspcRTbWRSYJcCU5UwoQIja+wRLCfSxzJtdVU4jmaEBU3
         8hyKzF0B1GOAGn7pQwPCWScRigMwldA6Wp5LcyYM=
Date:   Wed, 17 Nov 2021 18:55:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Orson Zhai <orsonzhai@gmail.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>, orson.zhai@gmail.com,
        Orson Zhai <orson.zhai@unisoc.com>
Subject: Re: [PATCH 1/2] scsi: ufs: Fix interrupt error message for shared
 interrupts
Message-ID: <YZVCEPc1Fu8nee9y@kroah.com>
References: <1637059711-11746-1-git-send-email-orsonzhai@gmail.com>
 <1637059711-11746-2-git-send-email-orsonzhai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1637059711-11746-2-git-send-email-orsonzhai@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 06:48:30PM +0800, Orson Zhai wrote:
> From: Adrian Hunter <adrian.hunter@intel.com>
> 
> [ Upstream commit 6337f58cec030b34ced435b3d9d7d29d63c96e36 ]
> 
> The interrupt might be shared, in which case it is not an error for the
> interrupt handler to be called when the interrupt status is zero, so don't
> print the message unless there was enabled interrupt status.
> 
> Change-Id: Ic18aa63b43d9479a62e8e664a73e70380669b109

Why is this here?  :(

I'll go delete it...

