Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0625A3901A7
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 15:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbhEYNHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 09:07:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232969AbhEYNHp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 09:07:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 434E861181;
        Tue, 25 May 2021 13:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621947975;
        bh=iV8vkNH/39NC5UolxpPtuJt70HwzauhyD3Cf2WA/ocg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DTYSVZ3wdZ+9Cxk+eMBAKYrVCR022mXRyKmiUWKioOuJekqZl++IvNWSPJEn3WGxN
         aDspmk7uJ1mAXUC/IFlkUcISdTzOV1OcgG3VACE9AymAEEfNT8xK07dPGOZqfLD9vh
         AdhQJE9jmiFmA2cwqLP/pJGko6chw6rTSGndAbQI=
Date:   Tue, 25 May 2021 15:06:12 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jan.kratochvil@redhat.com" <jan.kratochvil@redhat.com>
Subject: Re: LTS perf unwind fix
Message-ID: <YKz2RIcTyD/FCF+a@kroah.com>
References: <682895f7a145df0a20814001c508688113322854.camel@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <682895f7a145df0a20814001c508688113322854.camel@nokia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 25, 2021 at 12:41:15PM +0000, Rantala, Tommi T. (Nokia - FI/Espoo) wrote:
> Hi Greg,
> 
> Can you please cherry-pick this to LTS:
> 
> commit bf53fc6b5f415cddc7118091cb8fd6a211b2320d
> Author: Jan Kratochvil <jan.kratochvil@redhat.com>
> Date:   Fri Dec 4 09:17:02 2020 -0300
> 
>     perf unwind: Fix separate debug info files when using elfutils' libdw's unwinder

What exact kernel(s) do you want it backported to?

thanks,

greg k-h
