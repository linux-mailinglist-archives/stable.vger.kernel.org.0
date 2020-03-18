Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE25189786
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 10:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbgCRJCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 05:02:10 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:39599 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727324AbgCRJCK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Mar 2020 05:02:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584522129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NuaZbz5N2+w2+fsWF+Tlug+T6O+oQm2ursJ2AfBoRfo=;
        b=KwC1XAdHEU+3X9VHhn34CkGUmZg+A3j5rrjcBSct91TEtc5N/4BZdR6RmnuSUekJac8wo3
        x/U50pwrzEZhfLcb3zOiZXP/ZQiN64sZi692y2mDH/gh60HuadeSBUu5pgoI1vEkhmLgnp
        iP77cEzXCxWgSlr4ohR9/8gVeAVVM48=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-rzZyKMRMNSG924h5IfaOSA-1; Wed, 18 Mar 2020 05:02:08 -0400
X-MC-Unique: rzZyKMRMNSG924h5IfaOSA-1
Received: by mail-wr1-f71.google.com with SMTP id c6so4187527wro.7
        for <stable@vger.kernel.org>; Wed, 18 Mar 2020 02:02:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NuaZbz5N2+w2+fsWF+Tlug+T6O+oQm2ursJ2AfBoRfo=;
        b=lSaa2eCDbAGox4O19ityycoCqzM5dByhNKhwmpxA5WIQyb9eRJD0FwuPDEntJJzJkF
         914E0i9h/aINnE4W3EqRD28+LuqAaHR41AjzwNQsqRLNTM5CPaNsXkx0LpuRpV8zJ2gT
         w65+VEojwBLBvpKa8HMujKis7E4rDmwOf+nFdJdsrQvs7zUFfpkvdbkUTLycYZiKmzC5
         RTB3X00vacNTWcDEgYLY68FJBZtR3/EtxFK7QefvtvErlg/Dc9edbqwewj9/yCdSrEIS
         b4BzRUmUTWCEM6KSNsSCP2+/uxf70fOxeCd5VV0dUfd4G+rByBboeFV9eYk4nYsVkQqv
         hn0g==
X-Gm-Message-State: ANhLgQ1bXqu37aVPuAx3K9pxpdvJxDAN/2SSuh+FkOAR/T1O6xAetA9p
        aN9bekN8teVcE9QxX4jJP8ILDEDkKjlFnTonHgHFnUJLEXri4aWcbD6eKWXDt0QgyHcn76Ndqan
        1FHnrN4ifocyvOxzg
X-Received: by 2002:adf:fc08:: with SMTP id i8mr4204995wrr.378.1584522126929;
        Wed, 18 Mar 2020 02:02:06 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vufT3OBEBb+u59Fkp6uNpNRU/gaf0uc9IcRRIbD+tsusVvID03cxB5FshCG91aQiJ+Db+1G3g==
X-Received: by 2002:adf:fc08:: with SMTP id i8mr4204964wrr.378.1584522126617;
        Wed, 18 Mar 2020 02:02:06 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-fc7e-fd47-85c1-1ab3.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:fc7e:fd47:85c1:1ab3])
        by smtp.gmail.com with ESMTPSA id c26sm2887419wmb.8.2020.03.18.02.02.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 02:02:05 -0700 (PDT)
Subject: Re: [tip: x86/timers] x86/tsc_msr: Use named struct initializers
To:     Sasha Levin <sashal@kernel.org>, linux-tip-commits@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <158396431730.28353.16602854182721546383.tip-bot2@tip-bot2>
 <20200317223027.3623120409@mail.kernel.org>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <b9de4d4f-2bcc-9751-54a0-4fb6b030c9f3@redhat.com>
Date:   Wed, 18 Mar 2020 10:01:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200317223027.3623120409@mail.kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 3/17/20 11:30 PM, Sasha Levin wrote:
> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.5.9, v5.4.25, v4.19.109, v4.14.173, v4.9.216, v4.4.216.
> 
> v5.5.9: Build OK!
> v5.4.25: Build OK!
> v4.19.109: Failed to apply! Possible dependencies:
>      0cc5359d8fd4 ("x86/cpu: Update init data for new Airmont CPU model")
>      bba10c5cab4d ("x86/cpu: Use constant definitions for CPU models")
> 
> v4.14.173: Failed to apply! Possible dependencies:
>      0cc5359d8fd4 ("x86/cpu: Update init data for new Airmont CPU model")
>      397d3ad18dc4 ("x86/tsc: Convert to use x86_match_cpu() and INTEL_CPU_FAM6()")
>      bba10c5cab4d ("x86/cpu: Use constant definitions for CPU models")
> 
> v4.9.216: Failed to apply! Possible dependencies:
>      0cc5359d8fd4 ("x86/cpu: Update init data for new Airmont CPU model")
>      397d3ad18dc4 ("x86/tsc: Convert to use x86_match_cpu() and INTEL_CPU_FAM6()")
>      bba10c5cab4d ("x86/cpu: Use constant definitions for CPU models")
> 
> v4.4.216: Failed to apply! Possible dependencies:
>      05680e7fa8a4 ("x86/tsc_msr: Correct Silvermont reference clock values")
>      0cc5359d8fd4 ("x86/cpu: Update init data for new Airmont CPU model")
>      397d3ad18dc4 ("x86/tsc: Convert to use x86_match_cpu() and INTEL_CPU_FAM6()")
>      6fcb41cdaee5 ("x86/tsc_msr: Add Airmont reference clock values")
>      9e0cae9f6227 ("x86/tsc_msr: Update comments, expand definitions")
>      ba8268330dc1 ("x86/tsc_msr: Identify Intel-specific code")
>      bba10c5cab4d ("x86/cpu: Use constant definitions for CPU models")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

Just adding it to 5.4 / 5.5 is fine. It is not really a high prio fix.

Regards,

Hans

