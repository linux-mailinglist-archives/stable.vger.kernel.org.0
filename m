Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54E951825BE
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 00:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731465AbgCKXWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 19:22:38 -0400
Received: from mx1.yrkesakademin.fi ([85.134.45.194]:10052 "EHLO
        mx1.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgCKXWi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 19:22:38 -0400
Subject: Re: [PATCH 5.4 000/169] 5.4.25-rc4 review
To:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <shuah@kernel.org>,
        <patches@kernelci.org>, <ben.hutchings@codethink.co.uk>,
        <lkft-triage@lists.linaro.org>, <stable@vger.kernel.org>
References: <20200311204002.240698596@linuxfoundation.org>
 <20200311230653.GA25697@roeck-us.net>
From:   Thomas Backlund <tmb@mageia.org>
Message-ID: <fb6f1f17-456b-86ec-f7d7-e9e6e8c28ba1@mageia.org>
Date:   Thu, 12 Mar 2020 01:22:34 +0200
MIME-Version: 1.0
In-Reply-To: <20200311230653.GA25697@roeck-us.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Den 12-03-2020 kl. 01:06, skrev Guenter Roeck:
> On Wed, Mar 11, 2020 at 09:41:16PM +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.4.25 release.
>> There are 169 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 13 Mar 2020 20:39:27 +0000.
>> Anything received after that time might be too late.
>>
> 
> Build results:
> 	total: 158 pass: 146 fail: 12
> Failed builds:
> 	alpha:allmodconfig
> 	arm:allmodconfig
> 	arm64:allmodconfig
> 	m68k:allmodconfig
> 	mips:allmodconfig
> 	nds32:allmodconfig
> 	parisc:allmodconfig
> 	powerpc:allmodconfig
> 	riscv:defconfig
> 	s390:allmodconfig
> 	sparc64:allmodconfig
> 	xtensa:allmodconfig
> Qemu test results:
> 	total: 422 pass: 405 fail: 17
> Failed tests:
> 	<all riscv>
> 
> As already reported, the failure is:
> 
> drivers/gpu/drm/virtio/virtgpu_object.c:31:67: error: expected ')' before 'int'
>     31 | module_param_named(virglhack, virtio_gpu_virglrenderer_workaround, int, 0400);
> 
> Guenter
> 

I guess you need:
commit b0138364da17617db052c4a738b58bf45e42f500
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Wed Aug 28 18:55:16 2019 +1000

     drm/virtio: module_param_named() requires linux/moduleparam.h


--
Thomas
