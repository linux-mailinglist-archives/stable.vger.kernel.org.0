Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAE49CB27A
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 01:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728781AbfJCXtc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 19:49:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbfJCXtb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 19:49:31 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96EB020842;
        Thu,  3 Oct 2019 23:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570146571;
        bh=OdfgtGrDBM7pGIYwyOOcwlg8c8wA73NyLyNDkmSozc0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=QFyvodNv2Cp3zytjOLGhK/0/JQcDO4SmqAVciw0nTrQx/H3/4fQ7W0UsPcbpbjelC
         qn9O867IbY23kRAz06e6mD2F4I4LjMj65QtqwHHCiEq++NLFgAJED0rtjzLw9Q58wI
         XcQZsK2dIPXFdY3Frab1ACeiZlXkMfinwCsyTX8A=
Subject: Re: [PATCH 5.3 000/344] 5.3.4-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191003154540.062170222@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <65695fdf-e399-4b0d-51bc-4243943820e9@kernel.org>
Date:   Thu, 3 Oct 2019 17:49:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/3/19 9:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.4 release.
> There are 344 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 05 Oct 2019 03:37:47 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

