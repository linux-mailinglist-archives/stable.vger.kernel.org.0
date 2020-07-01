Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35809210DEF
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 16:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730264AbgGAOmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 10:42:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbgGAOmL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 10:42:11 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33E45206BE;
        Wed,  1 Jul 2020 14:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593614531;
        bh=ACxp76ucG1qgQ74F8LybWvPXdvjNU6q7QRASsTci1iU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VsPSXOOwqo+ovj6QMd90CKjzA3856mNrd2yg1mPylVnDyhnItstWe/j9ddDwZRAUk
         CkNKJ6ArTftLId+VOjlRXzF3ZFLJoQlp318oh10HIQCsgYVwLVvuWGbuqQsEu+9oN3
         OYbQq9tqYaytkkth4RcWGkrEVJHBMyZQVCVj569Q=
Date:   Wed, 1 Jul 2020 10:42:10 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.7 000/265] 5.7.7-rc1 review
Message-ID: <20200701144210.GF2687961@sasha-vm>
References: <20200629151818.2493727-1-sashal@kernel.org>
 <20200630172251.GF629@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200630172251.GF629@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 30, 2020 at 10:22:51AM -0700, Guenter Roeck wrote:
>On Mon, Jun 29, 2020 at 11:13:53AM -0400, Sasha Levin wrote:
>>
>> This is the start of the stable review cycle for the 5.7.7 release.
>> There are 265 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed 01 Jul 2020 03:14:48 PM UTC.
>> Anything received after that time might be too late.
>>
>
>Build results:
>	total: 155 pass: 155 fail: 0
>Qemu test results:
>	total: 430 pass: 430 fail: 0

Thanks Guenter!

-- 
Thanks,
Sasha
