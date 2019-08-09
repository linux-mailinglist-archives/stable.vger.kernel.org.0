Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69EC886EDE
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 02:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404866AbfHIAhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 20:37:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404805AbfHIAhw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 20:37:52 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A870208C4;
        Fri,  9 Aug 2019 00:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565311071;
        bh=VW1PhqI2dz8XoDJj/JFKjs0UJohC/xrTnYExRLHrtvw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=VxTM/MLAnh9Ce49BfMQcEKFh8hBTNEngV7DgYBdRSMyfuiMKO1E93DMAg6OTYlyeF
         BT8UESnd26vm6IgGsn593ZmqNAMkjSS8AaxbJapgCxSyrWzFNNKQv/p9ktiswHuADr
         zhnYLo/6psd6vdcQRab73+1K/mwt/mRICJ6kyi6o=
Subject: Re: [PATCH 4.19 00/45] 4.19.66-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190808190453.827571908@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <dd227668-a985-27b8-b013-7634b479b949@kernel.org>
Date:   Thu, 8 Aug 2019 18:37:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190808190453.827571908@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/8/19 1:04 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.66 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 10 Aug 2019 07:03:19 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.66-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

