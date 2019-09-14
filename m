Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7B11B2A77
	for <lists+stable@lfdr.de>; Sat, 14 Sep 2019 10:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfINIbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Sep 2019 04:31:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726841AbfINIbd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Sep 2019 04:31:33 -0400
Received: from localhost (unknown [84.241.204.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D1562081B;
        Sat, 14 Sep 2019 08:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568449891;
        bh=VG9mm12lbjrvxc8zfvCezXa86P3B/4mOoNr56OD6yCg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mQV3+L5OigdA7ByFYeyjI5TzmTOg8YTmgno4KKzYNkDE1QwTuuOndoMJ16XUferLT
         x/We8K+fvvvKYaPruVmstvKWosVoDzomS/7kaY5LftOSRBB4Fgs1Pa7klP156rzWV/
         SC96elI2UMSkLm4sHGsnmYFG2+/BQL+sbBI2LWxo=
Date:   Sat, 14 Sep 2019 09:31:26 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH 4.9 00/14] 4.9.193-stable review
Message-ID: <20190914083126.GA523517@kroah.com>
References: <20190913130440.264749443@linuxfoundation.org>
 <aefa6832-073e-493c-8576-5b2f06e714fb@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aefa6832-073e-493c-8576-5b2f06e714fb@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 14, 2019 at 01:28:39AM -0700, Guenter Roeck wrote:
> On 9/13/19 6:06 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.9.193 release.
> > There are 14 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun 15 Sep 2019 01:03:32 PM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Is it really only me seeing this ?
> 
> drivers/vhost/vhost.c: In function 'translate_desc':
> include/linux/compiler.h:549:38: error: call to '__compiletime_assert_1879' declared with attribute error: BUILD_BUG_ON failed: sizeof(_s) > sizeof(long)
> 
> i386:allyesconfig, mips:allmodconfig and others, everywhere including
> mainline. Culprit is commit a89db445fbd7f1 ("vhost: block speculation
> of translated descriptors").

Nope, I just got another report of this on 5.2.y.  Problem is also in
Linus's tree :(
