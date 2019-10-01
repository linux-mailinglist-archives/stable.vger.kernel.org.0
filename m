Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E07E9C2B6F
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 02:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbfJAAxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 20:53:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:57584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbfJAAxh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Sep 2019 20:53:37 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90C0120815;
        Tue,  1 Oct 2019 00:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569891217;
        bh=77i6Dx2TQa6aIEbPIK9hT2kd3SmRZpilcJCRtAau8J0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=YuI2cEsPCcELvZ8fXzwgkiXAy6TkHMnp5080OTTs0EZ4+VadiipO8WdbcYRUw/Vr4
         qHGHcnlX0uFS4/ggTAnoit9Q15xR0BSCMryG38ETHCNb/HcTH78Mq5ArND3yaaoqeF
         UTM/luVh+EuhPakfXo719EV52kELLT+yotP1Yugc=
Subject: Re: [PATCH 5.2 00/45] 5.2.18-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190929135024.387033930@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <df4d31b8-907d-1c69-78c5-c40092cf4654@kernel.org>
Date:   Mon, 30 Sep 2019 18:53:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190929135024.387033930@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/29/19 7:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.18 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 01 Oct 2019 01:47:47 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

