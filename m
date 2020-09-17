Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1883826DE77
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 16:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbgIQOlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 10:41:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727221AbgIQOk7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 10:40:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5A552075B;
        Thu, 17 Sep 2020 14:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600353028;
        bh=mNducYnn6GocnUGx9uKnVpsRRB0lS8iJe/gIbbhHKXo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zfeTIXW10NFEKUDSsvRvgfT+v9X8the3QrZhPj74dBUhnVXwhIxW06ctF2AjcO6Pj
         l4ouLnKeAkezIcfEH2astmXgqd6TH/67hor2RgZ6z5Enf72so+KRrxZ62yLFq6aZr+
         4/5XcwRfk33D2ph+XU4ilPdd66X2t2Taus23Ali4=
Date:   Thu, 17 Sep 2020 16:31:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/78] 4.19.146-rc1 review
Message-ID: <20200917143100.GA3941575@kroah.com>
References: <20200915140633.552502750@linuxfoundation.org>
 <20200916082042.GE32537@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916082042.GE32537@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 10:20:42AM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.146 release.
> > There are 78 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 17 Sep 2020 14:06:12 +0000.
> > Anything received after that time might be too late.
> 
> CIP testing did not find any kernel problems:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/190209473
> 
> (de0-nano failed, but logs reveal it timed out before reaching
> bootloader; likely board has problems.)

Thanks for testing.

greg k-h
