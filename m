Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C484B62D2D
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 02:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbfGIAw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 20:52:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725857AbfGIAw7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 20:52:59 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B5BA2166E;
        Tue,  9 Jul 2019 00:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562633578;
        bh=nKoGB+nVJSu0UoX2opJoIi5rsWLPVtXAFvSsjMgBddk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=N18ClQ/lVWxCs5Fb37g8fZgzNNDPGqia4wyoFlhsLTtbdtZXwNPuwKmwNDt0GnJfm
         2a8L4qHWSiNTH1eXNcfSF9uI6bGRKRsprtmQgJpDSyn94EboO3cvgOJmxIDVblbu39
         rDbwF7w3MSll8dgKUa7sr9Qa92bLObfkAWPjtl5g=
Subject: Re: [PATCH 5.1 00/96] 5.1.17-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190708150526.234572443@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <d6a655e7-c303-98cd-e007-c1ed24469c07@kernel.org>
Date:   Mon, 8 Jul 2019 18:52:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/8/19 9:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.17 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
