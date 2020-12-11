Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308AA2D7871
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 16:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391551AbgLKPAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 10:00:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:58360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406447AbgLKO7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Dec 2020 09:59:37 -0500
Date:   Fri, 11 Dec 2020 15:41:40 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607697647;
        bh=AXIAM02wmM6iQWxUW8OjB1zQK+fWZXnOkZ5ipCoN3KM=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=t2RTvnuvCUv6mGP+7uy3szlSOr4SNlNpISW8CZHqk9HA9tjwb2BARCEg5oOsPPFbC
         aCWQbu8Yx1jVfjjR7kbr2rYgYjhB8rYuSn2sZgwase3FnrKV6HVTckRe59QRXNFOFx
         OPqMl1RHOCw4QAaJw/uZFTPcdwvV1cGHCV0ZRzT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/39] 4.19.163-rc1 review
Message-ID: <X9OFJAQGJYIbX9z0@kroah.com>
References: <20201210142602.272595094@linuxfoundation.org>
 <20201210210652.GA4812@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210210652.GA4812@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 10:06:52PM +0100, Pavel Machek wrote:
> On Thu 2020-12-10 15:26:39, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.163 release.
> > There are 39 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> CIP testing did not find any problems here.
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for testing and letting me know.

greg k-h
