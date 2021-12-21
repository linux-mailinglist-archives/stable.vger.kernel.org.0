Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D73147C31E
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 16:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239630AbhLUPhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 10:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239651AbhLUPgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 10:36:46 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96B0C0617A2
        for <stable@vger.kernel.org>; Tue, 21 Dec 2021 07:36:34 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id x15so10472166ilc.5
        for <stable@vger.kernel.org>; Tue, 21 Dec 2021 07:36:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D6U5n1tpzp8Gl3D3iIJXPOKJi/MwcEuN5g8chsyJzdI=;
        b=o58nCgcawpLnL4E0qEwWzxPc5FwGIeLp5F7sfcMwAKLzGjVWAvi/kAtR3tsbRthOjv
         4nr7dGsh78i4yE4QJeYLyVdPMfSLnt0ea6Mryt+obR+2NMGMIw9s5/UXinON38Zm8GfJ
         1X2o+eZ+AGdF//UW5uSJ6B38D49LdTZtwulN4yZ0anLhqZ/f4rm1K5v7P6Z45lwvAqpT
         fQ8OCbKnWHjdCGR1/U4AOBO1lkwTkeEovP79sqCMmD/RfRV8YaWcD69eWfbZEQILRAE/
         PAg8p9pCM97gjP3WbRkFRw8isVlrd4SM9UP6/oaoVZadmp+y0BDCDAmFTv0j5pyVLJNP
         iECg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D6U5n1tpzp8Gl3D3iIJXPOKJi/MwcEuN5g8chsyJzdI=;
        b=bDzUtfwL2uIvSd/DR8zEMwGHHdFgExcgv1MUa3gYkYMuhO7wJxTnPPw5kDvZ8+82Hd
         RuUSvNzHDcFv4yh2XTO7eV+pHmImyu8wcUl61aSGJOzoM78XpOAANXqalfSYto5zXB0u
         u5/Pxu4wV1imNzcdbXYtIwksiHIftncu00kohziUT6fdU0d8/QMRJENyO/aHDX28Hr7+
         h5MtZ0gKUz153RcnEOwYwACxv6EbY1Rb5qU3GO1Ulv8xS/fcfGLFTvg8SCG5EeYwo0Gr
         6DwkfI6iQzfFvVTtkWMF0AM84jmhkHfv8dkcPsQ3dVxxXUBaIq7E5xWQdZc4iFrWHVDu
         chUA==
X-Gm-Message-State: AOAM533dNY9fJjc4IaVO0/9rQuFccEhMOD4rjgu8TT/QhuAhaEAWo0aB
        hngXlS+wJzQD7V3+LS63OvTXGQ==
X-Google-Smtp-Source: ABdhPJxSttCDfaRZ22MnO3/Ib9Pc2GN0BwXtg2JhUPaWirS+54tVsp6LzgtxxA1XHNUzncbZaQOYrw==
X-Received: by 2002:a05:6e02:148c:: with SMTP id n12mr1914426ilk.89.1640100994116;
        Tue, 21 Dec 2021 07:36:34 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id m7sm7739249ild.25.2021.12.21.07.36.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 07:36:33 -0800 (PST)
Subject: Re: [PATCH AUTOSEL 5.15 20/29] block: reduce
 kblockd_mod_delayed_work_on() CPU consumption
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     Dexuan Cui <decui@microsoft.com>, Ming Lei <ming.lei@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20211221015751.116328-1-sashal@kernel.org>
 <20211221015751.116328-20-sashal@kernel.org>
 <MWHPR21MB1593141494C76CF5A0BDDB11D77C9@MWHPR21MB1593.namprd21.prod.outlook.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ad76826e-73b2-b2f0-3cd4-8481645a6568@kernel.dk>
Date:   Tue, 21 Dec 2021 08:36:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <MWHPR21MB1593141494C76CF5A0BDDB11D77C9@MWHPR21MB1593.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/21/21 8:35 AM, Michael Kelley (LINUX) wrote:
> From: Sasha Levin <sashal@kernel.org> Sent: Monday, December 20, 2021 5:58 PM
>>
>> From: Jens Axboe <axboe@kernel.dk>
>>
>> [ Upstream commit cb2ac2912a9ca7d3d26291c511939a41361d2d83 ]
>>
>> Dexuan reports that he's seeing spikes of very heavy CPU utilization when
>> running 24 disks and using the 'none' scheduler. This happens off the
>> sched restart path, because SCSI requires the queue to be restarted async,
>> and hence we're hammering on mod_delayed_work_on() to ensure that the work
>> item gets run appropriately.
>>
>> Avoid hammering on the timer and just use queue_work_on() if no delay
>> has been specified.
>>
>> Reported-and-tested-by: Dexuan Cui <decui@microsoft.com>
>> Link: https://lore.kernel.org/linux-block/BYAPR21MB1270C598ED214C0490F47400BF719@BYAPR21MB1270.namprd21.prod.outlook.com/
>> Reviewed-by: Ming Lei <ming.lei@redhat.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  block/blk-core.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index c2d912d0c976c..a728434fcff87 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -1625,6 +1625,8 @@ EXPORT_SYMBOL(kblockd_schedule_work);
>>  int kblockd_mod_delayed_work_on(int cpu, struct delayed_work *dwork,
>>  				unsigned long delay)
>>  {
>> +	if (!delay)
>> +		return queue_work_on(cpu, kblockd_workqueue, &dwork->work);
>>  	return mod_delayed_work_on(cpu, kblockd_workqueue, dwork, delay);
>>  }
>>  EXPORT_SYMBOL(kblockd_mod_delayed_work_on);
>> --
>> 2.34.1
> 
> Sasha -- there are reports of this patch causing performance problems.
> See
> https://lore.kernel.org/lkml/1639853092.524jxfaem2.none@localhost/. I
> would suggest *not* backporting it to any of the stable branches until
> the issues are fully sorted out.

Both this and the revert were backported. Which arguably doesn't make a
lot of sense, but at least it's consistent and won't cause any issues...

-- 
Jens Axboe

