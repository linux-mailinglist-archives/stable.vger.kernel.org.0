Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153F235D3F0
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 01:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238267AbhDLX2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 19:28:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237531AbhDLX2E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 19:28:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9382861220;
        Mon, 12 Apr 2021 23:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618270065;
        bh=0sZxfQBEFBOBpSqDM7OrQysaIiYWGT29rKZEbmfKaiY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=npWEryw49Ee/MWFBVmOEABzr3S3dwkY+UYKU4kDqKwAOqpvpcfkYDpLs97qGVDVIQ
         txu30Fc6FpYcwg5Hl1eBLl84UuP0sZnHtClhs5WOAZRLkeA6XwEnfN2rA7qgioSIf2
         oDV+R4uxQObg1TS1QloP6KxII/RzXhafQvS6/E+zql2WgwH8dcKvN8uIj9OuPja8CN
         y8911AxiiPQj/dbWPB0j8XCGLIHkgdS/Cxx0McrmBcVQIsyfGk/KljC/Lo2NwcTUJG
         IOGFHV1FG3lB/hzSn8GotXjfuRSXWTa59XO3h+iIFH4uugV1ZjNlcOh+x6Sbn/SO2w
         w6KXlTOmNMPkw==
Date:   Mon, 12 Apr 2021 19:27:44 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Newer stable-tools
Message-ID: <YHTXcK3mXRUKTAAf@sashalap>
References: <f6ad8f77-6dd7-647e-5d4a-983754ba8442@canonical.com>
 <YHRzlIXXLUzfV0WT@sashalap>
 <5e5195b3-a2e9-471e-cbdd-0951f13ecbb0@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <5e5195b3-a2e9-471e-cbdd-0951f13ecbb0@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 12, 2021 at 06:50:00PM +0200, Krzysztof Kozlowski wrote:
>On 12/04/2021 18:21, Sasha Levin wrote:
>> Hey Krzysztof!
>>
>> On Mon, Apr 12, 2021 at 12:58:16PM +0200, Krzysztof Kozlowski wrote:
>>> Hi Greg, Sasha and everyone,
>>>
>>> I am looking at stable-tools from Sasha [1] in hope in re-using it. The
>>> problem I want to solve is to find easier commits in the distro tree,
>>> which were fixed or reverted upstream. Something like steal-commits from
>>> the stable-tools [1].
>>
>> You're probably looking for stable-has-fixes :)
>>
>>> However the tools themself were not updated since some time and have
>>> several issues, so the questions are:
>>> 1. Do you have somewhere updated version which you would like to share?
>>
>> So I've cleaned up and pushed the few patches I had locally to that
>> repo. It's not that it's abandoned, but rather it was working just fine
>> for me for the past few years so there wasn't anything too big done on
>> that front.
>>
>>> 2. Do you have other stable-toolset which you could share?
>>
>> FWIW, Greg has his own set of scripts: https://github.com/gregkh/gregkh-linux/tree/master/scripts
>
>Thanks, I'll try your changes and take a look at Greg's scripts.

Let me know if something doesn't seem to work out, I'd be happy to help
out here.

-- 
Thanks,
Sasha
