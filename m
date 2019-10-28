Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A152E6C1A
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 07:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730294AbfJ1GA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 02:00:56 -0400
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21437 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfJ1GAz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 02:00:55 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1572242409; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=dB0bWUOERgGvT48DiOHzsKDaiV/DBnXlOQMIOZ4J+Tq4cjwF5rNgUSmEPDPfRFjKk10y6nZPLNHd6mCk6QQadcCAyeV2dgm2Pre/yv/7qh1lYw5dCsAaYuHGe0qDIA65fluBvMh8K4Gv2rYx5pZvlh7olPZE7wmHphbE3noaPPY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1572242409; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=+K/LZwImnPy9DLEwMasEs/dRwXl/m7WGIau4MogUkRc=; 
        b=aoeMYjS+ByuvjpItNDCO+/H/HZP8sPCz7oQn7heFP8/830SLdk2l5WZ6BAHkIfiR8Vxd9skKXKlLy0CDsQzzuvGRES8vtH5mAyPakmoAaDr7hsJYE0EhzeR63eFJgCE7mB6nF/ZtqelNMZoafX4N0NR84qsYx5y6paigi2J/uek=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=didiksetiawan.com;
        spf=pass  smtp.mailfrom=ds@didiksetiawan.com;
        dmarc=pass header.from=<ds@didiksetiawan.com> header.from=<ds@didiksetiawan.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1572242409;
        s=zoho; d=didiksetiawan.com; i=ds@didiksetiawan.com;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        l=862; bh=+K/LZwImnPy9DLEwMasEs/dRwXl/m7WGIau4MogUkRc=;
        b=W23eHQzZ4YGWIT028KQojAVgH+H+XjCrUS1Vm7cY1Obkfd7/duzPTuJy/Z179GmA
        CasL0sKJCb1gweppm0xhGC9CRbiUbQAfRgDF9tGhxfdCHEsjCLtasDNNRAhhRPPYBMw
        E7TOeX9NYWpDGtygDitP6UgezNpJak/K8AsfI0to=
Received: from notebook (117.102.74.82 [117.102.74.82]) by mx.zohomail.com
        with SMTPS id 15722424079661003.1516840715439; Sun, 27 Oct 2019 23:00:07 -0700 (PDT)
Date:   Mon, 28 Oct 2019 12:59:57 +0700
From:   Didik Setiawan <ds@didiksetiawan.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/119] 4.14.151-stable review
Message-ID: <20191028055957.GA20979@notebook>
References: <20191027203259.948006506@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-ZohoMailClient: External
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 27, 2019 at 09:59:37PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.151 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.151-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Compiled, booted, and no regressions found on my x86_64 system.

Thanks,
Didik Setiawan

