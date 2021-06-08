Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE1739F7AE
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 15:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbhFHNXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 09:23:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232767AbhFHNXF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 09:23:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41A0861249;
        Tue,  8 Jun 2021 13:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623158472;
        bh=XtVkVjwi34uHfJ/tolU9Prv2PQRc1LzVMW3Dy38annc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aCxmJrDyTf3Nd9+QubyApDebdzqHf3VBLhwB0hCab4i2tCRnRCrpjSfsqAl6kgSkT
         WQ6m7lHjZOTMdtDeDnMnIpJuV0LFxZ2o/r+Yqlpd8RKBvZaIsA7Tgm2bwKU/qJsdEq
         LsulHbpuczeumpsfgpxHb42mKOKzmzvFy5gDTtUU=
Date:   Tue, 8 Jun 2021 15:21:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marco Elver <elver@google.com>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Alexander Potapenko <glider@google.com>,
        kasan-dev <kasan-dev@googlegroups.com>
Subject: Re: [5.12.y] kfence: use TASK_IDLE when awaiting allocation
Message-ID: <YL9uxro0BJgLXYTZ@kroah.com>
References: <20210521083209.3740269-1-elver@google.com>
 <CANpmjNObVfB6AREacptbMTikzbFfGuuL49jZqPSOTUjAExyp+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNObVfB6AREacptbMTikzbFfGuuL49jZqPSOTUjAExyp+g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 07, 2021 at 04:23:34PM +0200, Marco Elver wrote:
> Dear stable maintainers,
> 
> The patch "kfence: use TASK_IDLE when awaiting allocation" has landed
> in mainline as 8fd0e995cc7b, however, does not apply cleanly to 5.12.y
> due to a prerequisite patch missing.
> 
> My recommendation is to cherry-pick the following 2 commits to 5.12.y
> (rather than rebase 8fd0e995cc7b on top of 5.12.y):
> 
>   37c9284f6932 kfence: maximize allocation wait timeout duration
>   8fd0e995cc7b kfence: use TASK_IDLE when awaiting allocation

Thanks, that worked!

greg k-h
