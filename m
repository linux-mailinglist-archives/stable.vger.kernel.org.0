Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92485351A23
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 20:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236684AbhDAR60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 13:58:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236642AbhDARzA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Apr 2021 13:55:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91A6C610CE;
        Thu,  1 Apr 2021 13:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617282261;
        bh=jIGp9GBFtmAMbm3Q4ucbtlxJPxOxpLrp/Jd+o4UxF9s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kxKOJSSMc85QWM46k9hpbqMcs+qQRWIo8LT3+lESaS1B8+wxtR1pFSOuwXCy5XddJ
         VeCLH99qPWYK2fMZG+4BZlv6Sio/0LEdDLLvCc4g4Jnd7nmwRrHUINzxXxRoztEVbD
         SXMcGiWV6kgEnTmskgi8r6aHE0GxjAEf+7Oy8waI=
Date:   Thu, 1 Apr 2021 15:04:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     balbi@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-usb@vger.kernel.org,
        wcheng@codeaurora.org
Subject: Re: [PATCH] Revert "usb: dwc3: gadget: Prevent EP queuing while
 stopping transfers"
Message-ID: <YGXE0gQoj8HOzpuw@kroah.com>
References: <20210322121932.478878424@linuxfoundation.org>
 <20210401115558.2041768-1-martin.kepplinger@puri.sm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401115558.2041768-1-martin.kepplinger@puri.sm>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 01, 2021 at 01:55:58PM +0200, Martin Kepplinger wrote:
> This reverts commit 9de499997c3737e0c0207beb03615b320cabe495.
> 

You do not put a reason here, so I can not take this :(

Please fix up and resend.

thanks,

greg k-h
