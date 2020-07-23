Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20D1B22B694
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 21:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgGWTNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 15:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgGWTNo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 15:13:44 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0A0C0619DC
        for <stable@vger.kernel.org>; Thu, 23 Jul 2020 12:13:44 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id o22so3555228pjw.2
        for <stable@vger.kernel.org>; Thu, 23 Jul 2020 12:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3pjQoyubxLl1kb07cNN0S12gALs8/SDD70YszB3Dfh0=;
        b=AQPyplN5KFDvggnIWXh+MaOXHbLLmNWvULtoTuHWuiaW9ChvGDpmkUKnfyAM731pXa
         8S+aDLgQvnOqfLsWX7JYbd22SWhaU61gf7T4i4u2GkEnMlb2HZH2BMW2SzHnOJARTcn/
         /aIc7OEjA3Qt82s/wFV9dWEnOnRVLT0HoNUfT7Lkyu1TxcE9HbLV3Z+I8zH6VJ/Gr+ud
         RukVkRq0GBJlGJT+Sa/+VMoMpaW2oa6ib82YJjFUjWlwW0PlD9EqYu82pbXkGlmH3zqT
         rxIOmKqOEUBtnf63q9u7VRLrdU/vuSEkMFemRbyYklKT0yCA+AcAdbI4EqjW6hxnMVyT
         ULow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=3pjQoyubxLl1kb07cNN0S12gALs8/SDD70YszB3Dfh0=;
        b=qFdsHcOccgETt5zofEwyj1I9GLOuy/AMCIRcQvU+/pId76gYUc7ArDi94A0A5+Dgmc
         Xvj0KCLzc0TEkalnoxAdfHxxV0jbwfz/lb1XWpvfqek7pxXsPoKEPf0qhwNK9r0F94rY
         oD4A3KMa6lg6m0yflLmcPhWOZLZTv0TALva/bT71SONWCpkrcgTi1LDv2kCYZcEJQlf0
         gBO/OSa+Gao/DsicrHKIUXwV38j+xxEyY1NnZJ9Z1QUGP+j0nWg3QlXlMKNa1zw+JRfM
         AA4CLeEWdjJfDBz+avtqrsVWb1zrr/45S6JtXE/QbFIeuUIRaf4nIgtqRMFzN5DSg2Mp
         /Iqg==
X-Gm-Message-State: AOAM531S9z7c1/CIZfzEGayYHNgX+a//IEY2YbB1eqku8j9cJ+Jx4mE+
        sGaOGNJrIAjQKqO2AxRg21ulhf9B
X-Google-Smtp-Source: ABdhPJxq5Az1O8uhTnqdJXHOFT0IX7+OG86LiVtyOWuwpVfrj2r6elhIIttCaXJwK63rkRGUtlbW2Q==
X-Received: by 2002:a17:90a:8d06:: with SMTP id c6mr1792442pjo.137.1595531623808;
        Thu, 23 Jul 2020 12:13:43 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p12sm3328468pjz.44.2020.07.23.12.13.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2020 12:13:42 -0700 (PDT)
Subject: Re: Patches to apply to stable releases [7/23/2020]
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
References: <20200723155708.5233-1-linux@roeck-us.net>
 <20200723182402.GB2960332@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <caa531e7-6a77-0fc8-330f-9478058ab854@roeck-us.net>
Date:   Thu, 23 Jul 2020 12:13:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200723182402.GB2960332@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/23/20 11:24 AM, Greg Kroah-Hartman wrote:
> On Thu, Jul 23, 2020 at 08:57:08AM -0700, Guenter Roeck wrote:
>> Hi,
>>
>> Please consider applying the following patches to the listed stable
>> releases.
>>
>> The following patches were found to be missing in stable releases by the
>> Chrome OS missing patch robot. The patches meet the following criteria.
>> - The patch includes a Fixes: tag
>>   Note that the Fixes: tag does not always point to the correct upstream
>>   SHA. In that case the correct upstream SHA is listed below.
>> - The patch referenced in the Fixes: tag has been applied to the listed
>>   stable release
>> - The patch has not been applied to that stable release
>>
>> All patches have been applied to the listed stable releases and to at least
>> one Chrome OS branch. Resulting images have been build- and runtime-tested
>> (where applicable) on real hardware and with virtual hardware on
>> kerneltests.org.
>>
>> Thanks,
>> Guenter
>>
>> ---
>> Upstream commit 2aeb18835476 ("perf/core: Fix locking for children siblings group read")
>>   upstream: v4.13-rc2
>>     Fixes: ba5213ae6b88 ("perf/core: Correct event creation with PERF_FORMAT_GROUP")
>>       in linux-4.4.y: a8dd3dfefcf5
>>       in linux-4.9.y: 50fe37e83e14
>>       upstream: v4.13-rc1
>>     Affected branches:
>>       linux-4.4.y
>>       linux-4.9.y (already applied)
>>
>> Upstream commit d41f36a6464a ("spi: spi-fsl-dspi: Exit the ISR with IRQ_NONE when it's not ours")
>>   upstream: v5.4-rc1
>>     Fixes: 13aed2392741 ("spi: spi-fsl-dspi: use IRQF_SHARED mode to request IRQ")
>>       in linux-4.14.y: c75e886e1270
>>       in linux-4.19.y: eb336b9003b1
>>       upstream: v5.0-rc1
>>     Affected branches:
>>       linux-4.14.y
>>       linux-4.19.y
> 
> All now queued up, thanks!
> 

Excellent. That concludes the applicable backlog. Everything else the robot
has found was either cosmetic or resulted in conflicts, and I did not try
to create a backport for a variety of reasons (minor, irrelevant for us,
too complex, too risky, untestable, ...).

Our robot keeps finding more patches to apply from top-of-tree, but it looks
like your and Sasha's workflow identifies those reliably nowadays, and they
are usually applied to stable releases within a week or two. I may send more
requests in the future, but only if a fix is urgent or if it looks like
a patch got lost.

Thanks,
Guenter
