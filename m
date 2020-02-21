Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1362E1684DD
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 18:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgBUR0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 12:26:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:39290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725957AbgBUR0A (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 12:26:00 -0500
Received: from localhost (unknown [73.61.17.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A8A4208E4;
        Fri, 21 Feb 2020 17:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582305959;
        bh=SJV8c+G/5TuxkNzuPLOXMidkuUBv+7ik1hxVWH+M1gw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qGdHGsRnp4+y1SbvHTUPtMR2vd0sYPc3TGY+RNYAzwlTL1QCS/2ufgytYKvtmXyDm
         0gr4D6ygwacuSiL71gTFEL5KNKgTl/yB28e2Tnoy/DCU5UI3Wkh+IkUfe7Wb1CoQol
         GMcPvLha3TppHyj59VAXIODTBBQ8i6uT2Cd0tt+U=
Date:   Fri, 21 Feb 2020 12:25:57 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkft-triage@lists.linaro.org
Subject: Re: Build failures in v4.9.y, v4.14.y stable queues
Message-ID: <20200221172557.GA1449@sasha-vm>
References: <adb8b3ba-16c4-49f9-0160-3522681b49f8@roeck-us.net>
 <CA+G9fYtCZpVYmSDLO75UJZpF9oz=UVWeENz-6x9vj=urqt+0oQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+G9fYtCZpVYmSDLO75UJZpF9oz=UVWeENz-6x9vj=urqt+0oQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 21, 2020 at 09:02:47PM +0530, Naresh Kamboju wrote:
>On Fri, 21 Feb 2020 at 20:03, Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> Building arm:allmodconfig ... failed
>> --------------
>> Error log:
>> arch/arm/boot/dts/sun8i-h3-orangepi-lite.dtb: ERROR (phandle_references): Reference to non-existent node or label "cpu0"
>>
>> Affects both v4.9.y (v4.9.214-119-gb651de82f0d1) and v4.14.y (v4.14.171-173-g611d08c2bab0).
>
>We do see this build problems.

I've fixed it up, thank you for the report.

-- 
Thanks,
Sasha
