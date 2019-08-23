Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF84A9B5A5
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 19:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733098AbfHWRjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 13:39:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbfHWRjj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Aug 2019 13:39:39 -0400
Received: from localhost (unknown [104.129.198.240])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08C19206B7;
        Fri, 23 Aug 2019 17:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566581979;
        bh=RObSH9KVTOX+Ckf2dVoeAzZy11tQYV/SPZ+FblwdgbQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2RepMwPWjfKZyEI+U77yRfbs3Yj2xtRbGMqhih/iuf5HYCR52Qo5z4aNWJWq2BQh3
         Wrh7PUCOp13gg4UidO3TszkHroVGNm2tqh8lcnnjZ1bzchS/P6cGNI7PzHz9LRlDpj
         tPQtBmT9WweItPz8RHMe+QvoXtN0dyMdEataR3dc=
Date:   Fri, 23 Aug 2019 10:39:38 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/78] 4.4.190-stable review
Message-ID: <20190823173938.GD1040@kroah.com>
References: <20190822171832.012773482@linuxfoundation.org>
 <b1b51135-74d8-35ff-6921-631f8e0e09e6@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1b51135-74d8-35ff-6921-631f8e0e09e6@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 23, 2019 at 07:27:13AM -0700, Guenter Roeck wrote:
> On 8/22/19 10:18 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.190 release.
> > There are 78 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 24 Aug 2019 05:18:13 PM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 170 pass: 170 fail: 0
> Qemu test results:
> 	total: 324 pass: 324 fail: 0

Wonderful, thanks for testing all of these and letting me know.

greg k-h
