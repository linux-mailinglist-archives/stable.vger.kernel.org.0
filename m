Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3782534919B
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 13:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhCYMJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 08:09:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230057AbhCYMJK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 08:09:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FE40619AB;
        Thu, 25 Mar 2021 12:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616674150;
        bh=uK1guUZ8GR5sGME2dMgTuaLhqRnxTlcdjS8GVb3pdE0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1a7Izp+SVL+FEaRYTqNdfs4gMX1ZE7CAFubz090Gvb8NMSb2D3gfhNYaGr+9QnoW6
         nowcBWYHF0sJyleowh2g7L+0DsfGLKveaUDp9SBqnrGahgQjR0i1UE2Ah2XdMzIFEi
         Jk0ccOMatnRKthQpPHnO88/7LAINX8DL/jlYa8W4=
Date:   Thu, 25 Mar 2021 13:09:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Samuel Zou <zou_wei@huawei.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/150] 5.10.26-rc3 review
Message-ID: <YFx9Y75I6v/r/VZi@kroah.com>
References: <20210324093435.962321672@linuxfoundation.org>
 <6f9b4fa5-5970-e821-98f9-4d41f216ff69@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f9b4fa5-5970-e821-98f9-4d41f216ff69@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 25, 2021 at 09:01:55AM +0800, Samuel Zou wrote:
> 
> 
> On 2021/3/24 17:40, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.26 release.
> > There are 150 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 26 Mar 2021 09:33:54 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.26-rc3.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Tested on arm64 and x86 for 5.10.26-rc3,
> 
> Kernel repo:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> Branch: linux-5.10.y
> Version: 5.10.26-rc3
> Commit: f6bd595b6fdae1933a752242cfb77a1a0bc3117d
> Compiler: gcc version 7.3.0 (GCC)
> 
> arm64:
> --------------------------------------------------------------------
> Testcase Result Summary:
> total: 4720
> passed: 4720
> failed: 0
> timeout: 0
> --------------------------------------------------------------------
> 
> x86:
> --------------------------------------------------------------------
> Testcase Result Summary:
> total: 4720
> passed: 4720
> failed: 0
> timeout: 0
> --------------------------------------------------------------------
> 
> Tested-by: Hulk Robot <hulkrobot@huawei.com>
> 

thanks for testing.

