Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01A1A169907
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 18:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgBWRbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Feb 2020 12:31:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:35586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgBWRbr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Feb 2020 12:31:47 -0500
Received: from localhost (95-141-97-180.as16211.net [95.141.97.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C8E32067D;
        Sun, 23 Feb 2020 17:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582479105;
        bh=UTJGRrzzgelWDZrudUuwj8LYgaOFWVNGa71rqckh5L8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ah2jFu0K8cqVJ9Qwg2yz5CDtC3X+ly7l3oY9aY3Hmcw3fSs2W0ppHDys3JNmQAgbk
         31BsQ8kc3IYUf/dhGjNBlLtwTCQm1xfL3aUvNvJNtPjV43QUre9CDDXCvIBFpvj4/1
         0iTPatRa+ILudedApo02AoFtYGjVE9YOlUxQZbD8=
Date:   Sun, 23 Feb 2020 18:31:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/344] 5.4.22-stable review
Message-ID: <20200223173142.GB485503@kroah.com>
References: <20200221072349.335551332@linuxfoundation.org>
 <20200223154049.GB131562@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223154049.GB131562@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 23, 2020 at 04:40:49PM +0100, Greg Kroah-Hartman wrote:
> On Fri, Feb 21, 2020 at 08:36:39AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.22 release.
> > There are 344 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 23 Feb 2020 07:19:49 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.22-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> 
> -rc2 is out to hopefully resolve the reported problems:
>  	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.22-rc2.gz

-rc3 is out:
  	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.22-rc3.gz

