Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFEFC2F75F0
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 10:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbhAOJxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 04:53:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:49360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729581AbhAOJxV (ORCPT <rfc822;Stable@vger.kernel.org>);
        Fri, 15 Jan 2021 04:53:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8422323716;
        Fri, 15 Jan 2021 09:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610704362;
        bh=qZ9kzQnk4liwk0okqyEWjwhi0S0iga6x20uEL+HIqgk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lAn6SESys9kM8Zn1NZxs8FGSHCZFoeSHfSxxpl1TIl3UT/8f1PWvy8sqnzxlZZpPf
         rsK5T5onty8F/pCt6YSl8ARd3SKzPQfo3FuuvfBTuXOhmNK9icCeAox1IRT01tvylP
         gAV1iotFnFc2BB8ynCSJm4d6R08Mr6PTjhhS52pc=
Date:   Fri, 15 Jan 2021 10:52:39 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     lorenzo@kernel.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: imu: st_lsm6dsx: fix edge-trigger
 interrupts" failed to apply to 4.14-stable tree
Message-ID: <YAFl5wNX9R7a6yph@kroah.com>
References: <160915397497172@kroah.com>
 <20210111195625.ckrqusk73lyhx54s@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111195625.ckrqusk73lyhx54s@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 07:56:25PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Dec 28, 2020 at 12:12:54PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the same backport as 4.19-stable. Missed mentioning in that mail
> that it will also apply to 4.14-stable.

All now queued up, thanks.

greg k-h
