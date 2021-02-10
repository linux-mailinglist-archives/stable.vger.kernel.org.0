Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CA8316916
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 15:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbhBJO0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 09:26:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:37234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230486AbhBJO0j (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 09:26:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2001F64DC3;
        Wed, 10 Feb 2021 14:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612967158;
        bh=V+ZxzumuUwAkiVD0XMaFFcK4+NZRkLjUtMDzfSalWrg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CodizyAOUWqfxKWzL84DbgOmeNb/3VZO6rh4L5weKs1h9IyHiEu2CSDGeXHvjZ1bF
         g++u9KfuLwBCWbTmxwT+4fYmNrjBeopje995o2iaMcnQL550UnnDaBjsnXFhIeD/G9
         tSr5udcAxq4lLskQYyvCBU/6slJwyOdEswsY7hkE=
Date:   Wed, 10 Feb 2021 15:25:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     sibis@codeaurora.org, bjorn.andersson@linaro.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] remoteproc: qcom_q6v5_mss: Validate MBA
 firmware size before" failed to apply to 4.19-stable tree
Message-ID: <YCPs81SbcpNc6mRz@kroah.com>
References: <1597843356243112@kroah.com>
 <YCMPMtk5djNwhXn5@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCMPMtk5djNwhXn5@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 09, 2021 at 10:39:46PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Wed, Aug 19, 2020 at 03:22:36PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport, will also apply to 4.14-stable and 4.9-stable.

Thanks for the backports, all now queued up.

greg k-h
