Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A78745754A
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfF0AMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:12:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbfF0AMd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:12:33 -0400
Received: from localhost (unknown [116.247.127.123])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA0DB216E3;
        Thu, 27 Jun 2019 00:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561594352;
        bh=Osk+WBlid/WqtKaFRPzG0N2NFL3AjvaggN3s5qEAK0k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c8nVkfrYBLnr3Op6Kwmiifi2LKPP4yRdhElZEIT1vlVVvsbnoDJ2jIJs9XK6fkOrO
         aFpDfsTNm4tFe5DrMP5ZQVzOQkc0YMVWuYafp5+x37ZaOxxBR0OM0C6LUbfqcSvEdp
         nq8za9NVGNuuXPzn8ZI9cqSxi6Jc545NK+fMsngM=
Date:   Thu, 27 Jun 2019 08:12:25 +0800
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
Subject: Re: [PATCH 4.14 0/1] 4.14.131-stable review
Message-ID: <20190627001225.GF527@kroah.com>
References: <20190626083606.248422423@linuxfoundation.org>
 <CA+G9fYuaw+eZsGn=cOUWObmf4ZupjBd4U=w34s9k730O+dZjwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYuaw+eZsGn=cOUWObmf4ZupjBd4U=w34s9k730O+dZjwg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 26, 2019 at 08:15:07PM +0530, Naresh Kamboju wrote:
> On Wed, 26 Jun 2019 at 14:15, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.14.131 release.
> > There are 1 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri 28 Jun 2019 08:35:42 AM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.131-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Great, thanks for testing all of these and letting me know.

greg k-h
