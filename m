Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCD0A210DEA
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 16:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731538AbgGAOlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 10:41:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730264AbgGAOlf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 10:41:35 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F468206BE;
        Wed,  1 Jul 2020 14:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593614495;
        bh=nvSH9+2UcI96e3EjDMa5kVK8In3TIpQBLCm5N8cVFi0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eORGEak+Owgx+ynvZGvWQlOfu+Ht2UxINJv+97tD9Y6h72mcvJMvLK103WUonhgKe
         W1l9ho/ij7oUlMoQQTeoPKbw+j7W4ofbFiaKfvgpR9f1AfRE7hhc5Ght8kzbj+MVnj
         sBvUuYwuHN6vWjDnFXg53jQW+gDs+z/cCI/b7s8U=
Date:   Wed, 1 Jul 2020 10:41:34 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.7 000/265] 5.7.7-rc1 review
Message-ID: <20200701144134.GD2687961@sasha-vm>
References: <20200629151818.2493727-1-sashal@kernel.org>
 <CA+G9fYu0Vq2KbqonYwp-mm+STOg5yKDjqHvSeFQ_u-VbaLjgUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYu0Vq2KbqonYwp-mm+STOg5yKDjqHvSeFQ_u-VbaLjgUA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 30, 2020 at 10:44:12AM +0530, Naresh Kamboju wrote:
>On Mon, 29 Jun 2020 at 20:48, Sasha Levin <sashal@kernel.org> wrote:
>>
>>
>> This is the start of the stable review cycle for the 5.7.7 release.
>> There are 265 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed 01 Jul 2020 03:14:48 PM UTC.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.7.y&id2=v5.7.6
>>
>> or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
>> and the diffstat can be found below.
>>
>> --
>> Thanks,
>> Sasha
>
>Results from Linaro’s test farm.
>No regressions on arm64, arm, x86_64, and i386.

Thanks for testing!

-- 
Thanks,
Sasha
