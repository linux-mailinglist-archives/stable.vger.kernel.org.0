Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC8E018235F
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 21:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbgCKUjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 16:39:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726684AbgCKUjE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 16:39:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D7432074C;
        Wed, 11 Mar 2020 20:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583959145;
        bh=3zvOC0xwart9IFzT157lRejYehEqY/4ubrFtDGzzzlY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LoH8pMt4Dw0AFS8KGgyIqcgmjpsmqambaddkqm6cTingOhCGacmCLBfm2nm/yV/+f
         tYrwfeWe26/jjxjojoxhPAcAyhyI3mei4o0XjSVpGjaN5tXVO9XcNac5g21JGkZW4e
         JnxKv6FrIorhUJTUF0DH3GprpglDXr+HvsNnUBh4=
Date:   Wed, 11 Mar 2020 21:39:02 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/168] 5.4.25-rc3 review
Message-ID: <20200311203902.GA4080387@kroah.com>
References: <20200311181527.313840393@linuxfoundation.org>
 <632a5ea0-03de-7af5-7447-381ef6d713c2@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <632a5ea0-03de-7af5-7447-381ef6d713c2@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 11, 2020 at 12:05:25PM -0700, Guenter Roeck wrote:
> On 3/11/20 11:18 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.25 release.
> > There are 168 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 13 Mar 2020 18:14:21 +0000.
> > Anything received after that time might be too late.
> > 
> 
> csky builds still fail (v5.4.24-169-g005c54247945):
> 
> kernel/fork.c:2523:2: error: #error clone3 requires copy_thread_tls support in arch
>  2523 | #error clone3 requires copy_thread_tls support in arch

{sigh} I only added the patch to 5.5.y, will go add it to 5.4.y now too...

greg k-h
