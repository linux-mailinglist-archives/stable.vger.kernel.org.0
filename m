Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF0C21365F
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 10:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725779AbgGCI2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 04:28:23 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44890 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725648AbgGCI2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jul 2020 04:28:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593764901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kcuCW971MtT9fDm0+vC/HbFyI8kTsXqRTn3WmXdz9Pc=;
        b=DJdl31mR/1INaw7VLtfRK89cUAImIENHCLvULd6hvncN17YYNfWYaI+dnLAmeXs/1dIRnJ
        h2e1Yfs3HbJXZuIT0WUIeM+MsME51RdkkdPnP0Q/7EMilLxeUUXPVDtHf3FfVMZ6BUdoGK
        wBH/20j+6WF7B76TMb6eUXny6KH9BF4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-9w3pzun2NjCrlWOKgl5k-A-1; Fri, 03 Jul 2020 04:28:19 -0400
X-MC-Unique: 9w3pzun2NjCrlWOKgl5k-A-1
Received: by mail-ed1-f70.google.com with SMTP id w19so33938078edx.0
        for <stable@vger.kernel.org>; Fri, 03 Jul 2020 01:28:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kcuCW971MtT9fDm0+vC/HbFyI8kTsXqRTn3WmXdz9Pc=;
        b=MIUFpM8OPqV1NnEOl+VfSk2qICtl+Tacu9wbZeovib4mPcR4CTaNpgwRTwGsz8BeYf
         V1TFccfzfdQ011v0i7xv3gU8jciBTA3zSVRNMNGLF6y0dNOdP9i8/572TENsMk1TEEgC
         sLcdr9lgChn5LSI+iozwJqDCVZrftk+ezrd2tFn8twBV8MvBl0+7Wk2ZthdOETeWRPBj
         6GJO2dvVkjhOVgdu44ifDKKqBat6bBoEArjFUCtIOFW+6nOrZWhayHQ6QtZzUeTYj1fL
         u+GDpzUwSHWE24yu4jKRNMWCUIlh4jGm7c4jikXpkMl2KtRRMp3k3T98I9z1xQ9E4XZb
         cjTA==
X-Gm-Message-State: AOAM531qF6uTFm75gIfdwhU89yHKKr2NHPQEEN6uEbWNBeQE2rOP+U7t
        evQaVFeTtGgu9qQ4rrjMF7hTN4HSSXf3jHiQMxtDstrGvPTZmXypriAoludatO+VtahWyJVCNQ9
        XVO1HrDBaAljZWcf3
X-Received: by 2002:a17:907:1050:: with SMTP id oy16mr32546074ejb.353.1593764898395;
        Fri, 03 Jul 2020 01:28:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy5F25xNxrjdxmltQqMgp5D7YcIJS+ItkF/2SWSVv0IqXEEONzaxbYjkXzEpAG6b+ZhoOEjkg==
X-Received: by 2002:a17:907:1050:: with SMTP id oy16mr32546063ejb.353.1593764898226;
        Fri, 03 Jul 2020 01:28:18 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id d26sm11356201edz.93.2020.07.03.01.28.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 01:28:17 -0700 (PDT)
Subject: Re: [PATCH 1/6] ASoC: Intel: cht_bsw_rt5672: Change bus format to I2S
 2 channel
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Cezary Rojewski <cezary.rojewski@intel.com>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
References: <20200628155231.71089-2-hdegoede@redhat.com>
 <20200701193320.C948B20870@mail.kernel.org>
 <869046c6-030c-9243-784d-ecabdb774fa7@linux.intel.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <24708afa-bf28-3c5b-84ef-a6e7fb455bf0@redhat.com>
Date:   Fri, 3 Jul 2020 10:28:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <869046c6-030c-9243-784d-ecabdb774fa7@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 7/1/20 9:46 PM, Pierre-Louis Bossart wrote:
> 
> 
> On 7/1/20 2:33 PM, Sasha Levin wrote:
>> Hi
>>
>> [This is an automated email]
>>
>> This commit has been processed because it contains a -stable tag.
>> The stable tag indicates that it's relevant for the following trees: all
>>
>> The bot has tested the following trees: v5.7.6, v5.4.49, v4.19.130, v4.14.186, v4.9.228, v4.4.228.
>>
>> v5.7.6: Build OK!
>> v5.4.49: Failed to apply! Possible dependencies:
>>      0d1571c197a92 ("ASoC: intel: use asoc_rtd_to_cpu() / asoc_rtd_to_codec() macro for DAI pointer")
> 
> This patch is probably the missing dependency, but it's quite large and invasive.
> 
> if we wanted to apply this patch to stable versions < 5.7, we should replace all occurrences of
> 
> asoc_rtd_to_cpu(rtd, 0) by rtd->cpu_dai
> 
> and
> 
> asoc_rtd_to_codec(rtd, 0) by rtd->codec_dai

This fix affects only 1 model tablet, so I think it is fine to just add it to 5.7
and skip it for older kernels.

Regards,

Hans

