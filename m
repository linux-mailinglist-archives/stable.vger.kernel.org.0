Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B95F3E92BF
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 15:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbhHKNey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 09:34:54 -0400
Received: from linux.microsoft.com ([13.77.154.182]:37796 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbhHKNey (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 09:34:54 -0400
Received: from sequoia (162-237-133-238.lightspeed.rcsntx.sbcglobal.net [162.237.133.238])
        by linux.microsoft.com (Postfix) with ESMTPSA id C9C0720B36E8;
        Wed, 11 Aug 2021 06:34:29 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C9C0720B36E8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1628688870;
        bh=iJ8ub44l6VK5NjTbHxNb2jEQpC8aI8b5NdIRxFyGFkU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BG30X4OIWWd5u0SY3cdFhu/9wSK3owQChOAptr/0exvCtCMUU6VloO0gHK6mpXqqb
         /g9gnyv7798xU/TkiW+Jqu2d4K0a+OAqxUc2AoGsr76GbvI252D4czK5KyH29i9wyl
         5bAYKEifcOPoTaCWHrfauo8LE8XbD4Ygfc0Q7sQY=
Date:   Wed, 11 Aug 2021 08:34:27 -0500
From:   Tyler Hicks <tyhicks@linux.microsoft.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>
Subject: Re: [PATCH 4.19 36/54] tee: add tee_shm_alloc_kernel_buf()
Message-ID: <20210811133427.GG5469@sequoia>
References: <20210810172944.179901509@linuxfoundation.org>
 <20210810172945.369365872@linuxfoundation.org>
 <20210811072434.GB10829@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811072434.GB10829@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-08-11 09:24:34, Pavel Machek wrote:
> Hi!
> 
> > commit dc7019b7d0e188d4093b34bd0747ed0d668c63bf upstream.
> > 
> > Adds a new function tee_shm_alloc_kernel_buf() to allocate shared memory
> > from a kernel driver. This function can later be made more lightweight
> > by unnecessary dma-buf export.
> 
> 5.10 contains follow-up patches actually using the export, but 4.19
> does not. I believe it should be dropped from 4.19.

That's correct. Those follow-up patches that made use of this function
were only needed back to 5.4.

Tyler

> 
> Best regards,
> 								Pavel
> -- 
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany


