Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 858A867665
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 00:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfGLWGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 18:06:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727245AbfGLWGc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 18:06:32 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB63820989;
        Fri, 12 Jul 2019 22:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562969191;
        bh=eBk7dQSQWa06zkKl4XKERXEsTm34meKha8Khlxo8T/Q=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=es7jKlBXy44XM1QgZaQXY3crBT9+c27brLF8SNUyKTB5JkWtQ//CrRLqtgP4EGfAV
         IV6EgY3I6CvOpDj8LXsQiNteHL7BzKURRA9+gzO9yams4zXxtjIuY61apEehUtNbmy
         SFvpsJRx/T/pKaK8W8eFG8TCVQwKGVBxrazdWU78=
Subject: Re: [PATCH 4.19 00/91] 4.19.59-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190712121621.422224300@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <7b816e39-ccaf-ea79-cc84-bee9ecd9cb04@kernel.org>
Date:   Fri, 12 Jul 2019 16:06:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/12/19 6:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.59 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.59-rc1.gz
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

