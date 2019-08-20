Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD4F96B1E
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 23:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730638AbfHTVHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 17:07:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730501AbfHTVHR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 17:07:17 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9144A22DD6;
        Tue, 20 Aug 2019 21:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566335236;
        bh=nQ4Q7lPZ+ByI5zMAUs+MDJdmWRvVUGYLzDW96RRtalo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a+fjuxuhDMGGpMaSRw5qubw6odxQahO0xlCjAAiRvHEhImnDO28pGhZ6Yj0XGTZ4z
         cKTz5dD9jxSHLT1rvhEaW9uQfMY8q48Y9gpwOl+F4f5LTfMrGPRlfcxUdB3YuMmydO
         UPb1t8aPHWUBzDiv7jwu7bz3ltqoLZ8/Gynqh5Fo=
Date:   Tue, 20 Aug 2019 14:07:16 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: Please apply commit 0f0727d971f6 ("drm/amd/display: readd -msse2
 to prevent Clang from emitting libcalls to undefined SW FP routines") to
 4.19.y
Message-ID: <20190820210716.GA31292@kroah.com>
References: <CAKwvOdm0sWCF=PiNJvKWxt7CaTXSF13cZNuYPhKC=Kq8ooi1HA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdm0sWCF=PiNJvKWxt7CaTXSF13cZNuYPhKC=Kq8ooi1HA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 20, 2019 at 02:00:21PM -0700, Nick Desaulniers wrote:
> Please apply commit 0f0727d971f6 ("drm/amd/display: readd -msse2 to
> prevent Clang from emitting libcalls to undefined SW FP routines") to
> 4.19.y.
> 
> It will help with AMD based chromebooks for ChromeOS.

That commit id is not in Linus's tree, are you sure you got it correct?

thanks,

greg k-h
