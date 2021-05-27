Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8E2392BAC
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 12:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236145AbhE0KYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 06:24:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236149AbhE0KYN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 06:24:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 656E6613B4;
        Thu, 27 May 2021 10:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622110960;
        bh=fu41OOBwvVAsIvlj0TmcDCa0Ztt6umjGSj3AvUXq19E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dtZyddnBMfnZCBlVVCOlltjIv5psuHEuCiNxrNGPtooBYB8VyQjDtydDxwa5KhXql
         CodqGRLbyM8W4QYHEjK49DwTVj5tI9I+baRDPUuaE/tYYAtduoP9zRHE20MLgS68FI
         GEQrgK7fKKA0yMSVT0GKZ/kfXa9AHzFonk/wgsWo=
Date:   Thu, 27 May 2021 12:22:37 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jan.kratochvil@redhat.com" <jan.kratochvil@redhat.com>
Subject: Re: LTS perf unwind fix
Message-ID: <YK9y7dd+wsp2OLD/@kroah.com>
References: <682895f7a145df0a20814001c508688113322854.camel@nokia.com>
 <YKz2RIcTyD/FCF+a@kroah.com>
 <45b140543ccb85ab184ed17befca4a9e64661051.camel@nokia.com>
 <YK9jhtj/hwTKU5+N@kroah.com>
 <ef44cde0f3493eb9ab2efe951bc03e4e6ccc416b.camel@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef44cde0f3493eb9ab2efe951bc03e4e6ccc416b.camel@nokia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 27, 2021 at 10:04:51AM +0000, Rantala, Tommi T. (Nokia - FI/Espoo) wrote:
> Hi Greg,
> 
> Please apply these two commits to 5.4.y
> (other LTSes are probably fine too, but I didn't test):
> 
> 
> commit bf53fc6b5f415cddc7118091cb8fd6a211b2320d
> Author: Jan Kratochvil <jan.kratochvil@redhat.com>
> Date:   Fri Dec 4 09:17:02 2020 -0300
> 
>     perf unwind: Fix separate debug info files when using elfutils'
> libdw's unwinder
> 
> 
> commit 4e1481445407b86a483616c4542ffdc810efb680
> Author: Dave Rigby <d.rigby@me.com>
> Date:   Thu Feb 18 16:56:54 2021 +0000
> 
>     perf unwind: Set userdata for all __report_module() paths
> 
>     [...]
> 
>     Fixes: bf53fc6b5f41 ("perf unwind: Fix separate debug info files
> when using elfutils' libdw's unwinder")
> 
> 
> These commits fix some broken backtraces when using the perf tool.

Also queued up for the 5.10.y tree as you do not want to move to a newer
kernel and have a regression.

thanks,

greg k-h
