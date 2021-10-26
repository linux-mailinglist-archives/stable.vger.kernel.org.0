Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D6543B50B
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 17:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhJZPHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 11:07:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231656AbhJZPGT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Oct 2021 11:06:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54D4D60E74;
        Tue, 26 Oct 2021 15:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635260635;
        bh=CCfenIjzL1BxW1DlpEwjd74Oivlc3fO+hoghBCXFEIM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G9rckG1c5DXD7JU6NqBEABkHngm2rHL9YG1Ko9x+Sem0VnHiBNnz2voVBlDvFLTFj
         RVeBHjktKyHIT2nG4JoxL3LcpWfAQ8R/wbSTQdlATpLOS4N+CbQ8hZ3CNEtpZI54yJ
         1PLP0iHFOsMSxA28Aq9992G/ws7w8Ro8L8CDsKIA=
Date:   Tue, 26 Oct 2021 17:03:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] usbnet: sanity check for maxpacket
Message-ID: <YXgY2cirSesI+L+E@kroah.com>
References: <e3ae5f6e-1e96-9d7e-c126-6b4fb00f83a0@linaro.org>
 <YXeVmDtzkC1sUBCv@kroah.com>
 <68be83ab-c0b1-78f7-0234-8e915339d570@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68be83ab-c0b1-78f7-0234-8e915339d570@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 26, 2021 at 07:52:00AM -0700, Tadeusz Struk wrote:
> On 10/25/21 22:43, Greg KH wrote:
> > > It should be applied to stable kernels: 5.14, 5.10, 5.4, 4.19, 4.14, 4.9, 4.4
> > It's already in the latest stable -rc releases, do you not see it there?
> 
> I haven't checked the rc releases, just the latest stable versions.
> Now I also see Sasha Levin's submissions on the stable mailing list archive.
> All good. Sorry for the noise.

Also note that there is a bug in this commit, so it was dropped from the
stable queues until the fix for this hits Linus's tree.

thanks,

greg k-h
