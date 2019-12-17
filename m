Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A68BF12218E
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 02:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfLQBcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 20:32:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726016AbfLQBcI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 20:32:08 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB4A120CC7;
        Tue, 17 Dec 2019 01:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576546327;
        bh=SfSH52QMrn2wkEA/8SYXmONPZSZmO7J+FDuIHq3JUA0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=tiZPj5j10+W9Zx+3PXYitH1VhaC+ShULa9m/X0gvw25mPd76MlPUBtCLIYOyE694e
         jK0oEpSq3c2FgNWhORBwVZfjtXt2ARRiIsGTFDDFLyelEu5FPD5LsWx5Q1KlCZ6VSQ
         lY4DbnTmdMzzZVcvm3lwhj7MsXr4UK7Y1K434MMw=
Subject: Re: [PATCH 4.14 000/267] 4.14.159-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191216174848.701533383@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <8939f7f3-1931-7b31-a092-7c3e36d33d97@kernel.org>
Date:   Mon, 16 Dec 2019 18:32:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/16/19 10:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.159 release.
> There are 267 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Dec 2019 17:41:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.159-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

