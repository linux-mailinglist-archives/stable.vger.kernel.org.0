Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E50711FF77
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 08:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfEPGU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 02:20:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbfEPGU5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 02:20:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1449E20862;
        Thu, 16 May 2019 06:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557987656;
        bh=UJAhG9Msn7RsRIsG+Yd7K+23iuAyVMRQtuMqvbrLhgA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jmwYasrkfwsb4dTN6I+i2OP/UkV97T80doWOA6rH74pRDMSWBLf1boNeKiD6DwxQ9
         mh37CT/L/xwvuxl5dubVmBUUweo8Vy3PsOpqn/zatbSihPFqAs+IM0ElgYwbXbNhhM
         pPfrENV30Vy+pTWeDb0vIZHyW1NbbboJoFkjP5L0=
Date:   Thu, 16 May 2019 08:20:54 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/46] 5.1.3-stable review
Message-ID: <20190516062054.GA16818@kroah.com>
References: <20190515090616.670410738@linuxfoundation.org>
 <f3eeb4bb-8ef3-ebf1-839e-6a9ac85d7335@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3eeb4bb-8ef3-ebf1-839e-6a9ac85d7335@roeck-us.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 15, 2019 at 08:38:08PM -0700, Guenter Roeck wrote:
> On 5/15/19 3:56 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.3 release.
> > There are 46 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 17 May 2019 09:04:22 AM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 349 pass: 349 fail: 0

Many thanks for the quick turn-around on testing all of these and
letting me know.

greg k-h
