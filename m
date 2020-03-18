Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCA31898B9
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 11:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbgCRKAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 06:00:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgCRKAb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 06:00:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5D6E20767;
        Wed, 18 Mar 2020 10:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584525630;
        bh=5c2FXHcEPPONO3hnWx4jiIZQLap5qdvdpB6yL1YUluI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rQ55VDnayXBKYbZlpDqzWlFoBpLE2SJSfBAI07qcmpPDPIxACE3tOLkMYYvmQhVrJ
         2INnIpg+9K1FwONwSQFNZPUJ6yp2gFy5TZhpZaA5KExVkATDCcz6nLGGSEnqI45DKu
         NMF6suP5B1POriGrISPYbtMqrelH4by09r/LZVRQ=
Date:   Wed, 18 Mar 2020 11:00:26 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.5 000/151] 5.5.10-rc1 review
Message-ID: <20200318100026.GC2034476@kroah.com>
References: <20200317103326.593639086@linuxfoundation.org>
 <CA+G9fYsNxuHUFmPwOn9JmJN+-NM1TF-io8SnSs+XehCB+vrTEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsNxuHUFmPwOn9JmJN+-NM1TF-io8SnSs+XehCB+vrTEw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 18, 2020 at 01:51:56AM +0530, Naresh Kamboju wrote:
> On Tue, 17 Mar 2020 at 16:37, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.5.10 release.
> > There are 151 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 19 Mar 2020 10:31:16 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.10-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Thanks for testing all of these and letting me know.

greg k-h
