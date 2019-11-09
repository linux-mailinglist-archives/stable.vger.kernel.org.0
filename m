Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43CD5F6020
	for <lists+stable@lfdr.de>; Sat,  9 Nov 2019 16:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbfKIPul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 10:50:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:50902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726078AbfKIPul (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 10:50:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 200E321848;
        Sat,  9 Nov 2019 15:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573314640;
        bh=ghP7hezOEkBuj+6TnHcy9n+XyvowNqz/FYGWIMcbo9U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r/f/UEiN0FYab/oWq4EjiFidLxmP4k4a6zNkBVeWF43dYzbAX0btFPLElulh8b1fp
         MXqPsfi9OJyCXl5471XcCycLnop8ExfxeIzLMJyiSHJxXIoNlQTK4sxIAcK5tASrA1
         jHnSSpcbfp4zzb7trvGJeyDoUYd2/tJpfJC099Ws=
Date:   Sat, 9 Nov 2019 16:50:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.3 000/140] 5.3.10-stable review
Message-ID: <20191109155037.GA1367023@kroah.com>
References: <20191108174900.189064908@linuxfoundation.org>
 <d7a6de48-3022-bdc4-8a94-941a2f8fd38f@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7a6de48-3022-bdc4-8a94-941a2f8fd38f@roeck-us.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 09, 2019 at 07:41:36AM -0800, Guenter Roeck wrote:
> On 11/8/19 10:48 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.10 release.
> > There are 140 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun 10 Nov 2019 05:42:11 PM UTC.
> > Anything received after that time might be too late.
> > 
> Build results:
> 	total: 158 pass: 158 fail: 0
> Qemu test results:
> 	total: 391 pass: 391 fail: 0

Wonderful, thanks for testing all of these and letting me know.

greg k-h
