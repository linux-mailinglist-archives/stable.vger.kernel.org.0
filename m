Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8FF14C66A
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 07:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgA2GSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 01:18:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:41260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726020AbgA2GSK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jan 2020 01:18:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFEDD20702;
        Wed, 29 Jan 2020 06:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580278689;
        bh=XkuEW+/TigXRcsYVrdLzdqdSURlN6dAQKowNczMUKmA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jwYAvroFSrWgAksj+dLV6kqkPpcTbeLqUsvOriWj7HE5VDJ5qzsyJguVvOYMWZwxs
         lD5NhUVN/THgJPQ5THuDkryjIf51IFzxF7MGvAfHnSlMSAPLdZ7DxI/xhnAVBr5Fvs
         ByOyEd+rayErkvjRRz77Oos4TeUpiTbqzJo19f+A=
Date:   Wed, 29 Jan 2020 07:18:06 +0100
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
Subject: Re: [PATCH 5.4 000/104] 5.4.16-stable review
Message-ID: <20200129061806.GB3768602@kroah.com>
References: <20200128135817.238524998@linuxfoundation.org>
 <CA+G9fYtgz2NyCjRpF3aQv2nz1j6+4ETT6ZFNLG2bhRUPH8UxAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtgz2NyCjRpF3aQv2nz1j6+4ETT6ZFNLG2bhRUPH8UxAg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 29, 2020 at 10:27:07AM +0530, Naresh Kamboju wrote:
> On Tue, 28 Jan 2020 at 19:31, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.16 release.
> > There are 104 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.16-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
