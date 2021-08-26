Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2323F87F0
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 14:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241651AbhHZMu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 08:50:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:59110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232506AbhHZMuZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Aug 2021 08:50:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FB45610A1;
        Thu, 26 Aug 2021 12:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629982178;
        bh=wY9kAL/A/x13IuXAWhbR5A9aRXYch28Z15UjfZ5JJR0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=askPaqQq6PWsFoX7g4k1iJZ+zBZwjD9C9/8FjWLfVfQX1t4qNn8t16v5Y1giSd5dC
         ChIToesQJ/GIb/eoRXbr1Mep+cKSVM2vb1i/O/eNhkxlJql2lwC3R5A6oQSdLtUCCv
         72ojMS51aD37MjZ4BRhQRmHMsmcRc598yDNBw3Bqj76Wva3AzkxEuKnufQpzF8EYH1
         75GCdJBvaajJVDoQfCHBmLtFNDjwngynrnAC0O94AxG41Bkn+G6IPI8lFcnMrJyQNu
         zl7SMAf55cdV56EMmScwbmSIomV4Dm4PgFqa9031yamqaLTiOdryza0LKhJkOoGHjp
         KSAIiRDM2Co2w==
Date:   Thu, 26 Aug 2021 08:49:37 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.13 000/127] 5.13.13-rc1 review
Message-ID: <YSeN4bQ0FXSuQR6m@sashalap>
References: <20210824165607.709387-1-sashal@kernel.org>
 <b4bef2f4-0c5b-527d-4f24-788d3265f5bf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b4bef2f4-0c5b-527d-4f24-788d3265f5bf@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 25, 2021 at 11:21:37AM -0500, Daniel Díaz wrote:
>Hello!
>
>On 8/24/21 11:54 AM, Sasha Levin wrote:
>>This is the start of the stable review cycle for the 5.13.13 release.
>>There are 127 patches in this series, all will be posted as a response
>>to this one.  If anyone has any issues with these being applied, please
>>let me know.
>>
>>Responses should be made by Thu 26 Aug 2021 04:55:18 PM UTC.
>>Anything received after that time might be too late.
>>
>>The whole patch series can be found in one patch at:
>>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.13.y&id2=v5.13.12
>>or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
>>and the diffstat can be found below.
>>
>>Thanks,
>>Sasha
>
>Results from Linaro’s test farm.
>No regressions on arm64, arm, x86_64, and i386.
>
>Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks for testing Daniel!

-- 
Thanks,
Sasha
