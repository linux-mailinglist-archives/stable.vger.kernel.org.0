Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F238913FD
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 03:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbfHRBpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Aug 2019 21:45:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726198AbfHRBpF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Aug 2019 21:45:05 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A0A52086C;
        Sun, 18 Aug 2019 01:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566092704;
        bh=05qEJrtFlGILarYMvf+y1hptYPVnJsI2/VS5AtD0c6U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xTckV9iRCyXupa+icWp0PH7ukrjNo0Xr9lOZbat7Z+N7Ct7fgY2YLIDcoICmbwZnJ
         dEY+sFhrR9pd3vlIGDiXdPmpymLOvcPz8W/TO82SA45g58hDlPSptKF5IEeJhIiks7
         tKf1AOj9ljfdvOwPhCva7lwYtkak4M15t+ITIais=
Date:   Sat, 17 Aug 2019 21:45:03 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Max Filippov <jcmvbkbc@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        "open list:TENSILICA XTENSA PORT (xtensa)" 
        <linux-xtensa@linux-xtensa.org>
Subject: Re: [PATCH AUTOSEL 5.2 07/59] xtensa: fix build for cores with
 coprocessors
Message-ID: <20190818014503.GC1318@sasha-vm>
References: <20190806213319.19203-1-sashal@kernel.org>
 <20190806213319.19203-7-sashal@kernel.org>
 <CAMo8BfJZ1aQoyjpfUE-WT=OpW7EvNC+vu878BPqON0u7E5Ujiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAMo8BfJZ1aQoyjpfUE-WT=OpW7EvNC+vu878BPqON0u7E5Ujiw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 06, 2019 at 02:55:29PM -0700, Max Filippov wrote:
>Hello,
>
>On Tue, Aug 6, 2019 at 2:33 PM Sasha Levin <sashal@kernel.org> wrote:
>> From: Max Filippov <jcmvbkbc@gmail.com>
>>
>> [ Upstream commit e3cacb73e626d885b8cf24103fed0ae26518e3c4 ]
>>
>> Assembly entry/return abstraction change didn't add asmmacro.h include
>> statement to coprocessor.S, resulting in references to undefined macros
>> abi_entry and abi_ret on cores that define XTENSA_HAVE_COPROCESSORS.
>> Fix that by including asm/asmmacro.h from the coprocessor.S.
>>
>> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  arch/xtensa/kernel/coprocessor.S | 1 +
>>  1 file changed, 1 insertion(+)
>
>This fix is only relevant to 5.3, as it fixes a bug introduced in 5.3-rc1.

Now dropped, thank you.

--
Thanks,
Sasha
