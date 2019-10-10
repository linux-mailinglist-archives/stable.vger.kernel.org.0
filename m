Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC8CD3425
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 01:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfJJXEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 19:04:13 -0400
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21489 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfJJXEN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 19:04:13 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1570748618; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=QmQgh8oVeL1UlhL4bRumEiLaTobIedhbyS6BDJxOnjd3bP+ocRyHZY8yhzAUhl5dXBNW8Nu1TAWYgBXvZEWhXTxfs+qlD0Z+7Q7iUxQrwYFPnNdtuwJBUjHZJmNs3XO38vLf7D/4nB69zjkTo8gftKc1Rf3tVc1EjzKWs49+SJU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1570748618; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=bGU1bteMJ1umjbur92OJItzq406PA1Ny/lYW7QJ9L94=; 
        b=TJ6zvuw0oYKMdZ13TkJZkThKfZCrhMG78bUsijNI9gzRgwqwO/S/FSDOZU68wXKCuxfLQqK2OADV2qL7U7JBClknJ0PfxewhQ2bk+yCxACCQ2HpUusj2IMzBoYixlz8O93znXuFiWEIHqEGM/U8L+KSs1knsrd8gAUg9C1kKpiA=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=didiksetiawan.com;
        spf=pass  smtp.mailfrom=ds@didiksetiawan.com;
        dmarc=pass header.from=<ds@didiksetiawan.com> header.from=<ds@didiksetiawan.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1570748618;
        s=zoho; d=didiksetiawan.com; i=ds@didiksetiawan.com;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        l=863; bh=bGU1bteMJ1umjbur92OJItzq406PA1Ny/lYW7QJ9L94=;
        b=vd2lRiPk6jhbBlj7LcjJQDxEgHHaALMTb/9yVOQC883fSe4SciejVzXdttcgVtKE
        PVv0CNdfaBSZ6kPVNmqpD2rqm5juKKHZI6JPTmOZGK7FS+/bQY/oKy+RaMHvMgG5k2b
        JwiNhp08owBq5VwqooU3XHHE7sUVeXR2RAkKcYKg=
Received: from thinkpad-e420s (120.188.6.98 [120.188.6.98]) by mx.zohomail.com
        with SMTPS id 1570748616019428.6066937022854; Thu, 10 Oct 2019 16:03:36 -0700 (PDT)
Date:   Fri, 11 Oct 2019 06:03:27 +0700
From:   Didik Setiawan <ds@didiksetiawan.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/114] 4.19.79-stable review
Message-ID: <20191010230327.GA19486@thinkpad-e420s>
References: <20191010083544.711104709@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-ZohoMailClient: External
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 10, 2019 at 10:35:07AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.79 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 12 Oct 2019 08:29:51 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.79-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
 
Compiled, booted, and no regressions found on my x86_64 system.

Thanks,
Didik Setiawan

