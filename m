Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 595307FF70
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 19:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404616AbfHBRVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 13:21:09 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:46058 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404613AbfHBRVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 13:21:09 -0400
Received: by mail-ed1-f65.google.com with SMTP id x19so67172126eda.12;
        Fri, 02 Aug 2019 10:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=inMByTwvV8O4aabJajJH9w/5ZouKzmsoSvqmiPR9bto=;
        b=idHhUTWIvhb6xC0k3eGhLumLIWXZcJacR+GTy4dO2/RxcQnK4OQ4TVgiVK4dpThYVa
         nimZ2Oe8fB7G0Q15o0ZO+79NrKFM4JUZ8sYuOYnwdW5nm8dQ5bdZ+8NAMDLBmIx1/jh1
         ykI5m4tlNe8OHRJRT+Zb7hsvKdQdUePMU9sXfLseAn33FXrrnLSLrjeDQiN8FI35j1Ze
         yjTB6z3E9LxTMkGoS5TPvFNNC9tGuK1VMKAfk8QsEivV0mfxbbJ1ucWq/QEnqadDoXAP
         c+LGvyH+YV+S2YHyd9U0JCCu92GB2etjfOI629OS2CYQgcuWIsE7lKt69yPONfsIZuN6
         r77Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=inMByTwvV8O4aabJajJH9w/5ZouKzmsoSvqmiPR9bto=;
        b=slQrmnHpMRabBEx08U7ZNVI5T5XCP7pcODal9jBYIZLmLalxg/1O2aRl9Po+FpeEcQ
         8sertUxU34ICsjHntgQxHheItTT8ESrsHxniWk+5jTfEGWZb9T73cg/baOGjupwaGYnb
         Ae22+Q7oXm5Jym+ipQAD2eSMe7VSvxbuaOboJ6xYwUcs+b0mbFBaNQC45ZdyUR1rYtzB
         Dqy7Icrdy2CHsPB15aMIUMOvgsEXXKK63ffGG2UinkrvtHJJ+DVL76uqbMjlrK3UWCFd
         Sro8VD2EIXOFSFaNnUmVA5EYWhazPq3+k8/YO3EK3KiKcexezOutxa8wzwsx79Pri9K1
         lLsg==
X-Gm-Message-State: APjAAAWPUpBQc1TBGPPKGNMaEDRqix1rtXLRpY4d6fpTIK5CzUK1ER3D
        qLQLeRbzNZbqsOFWzcozy0p7WfuV
X-Google-Smtp-Source: APXvYqzK0cRQJ9YE8mPvzGB/kRTFoDxdjvW7Ao0/m6JOrKkORGqKhTT5m8yLDw5oOs3R2ZhyUBjHFQ==
X-Received: by 2002:a50:ba19:: with SMTP id g25mr120278535edc.123.1564766467179;
        Fri, 02 Aug 2019 10:21:07 -0700 (PDT)
Received: from localhost (pD9E51890.dip0.t-ipconnect.de. [217.229.24.144])
        by smtp.gmail.com with ESMTPSA id y12sm13205321ejq.40.2019.08.02.10.21.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 10:21:06 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.2 00/20] 5.2.6-stable review
Date:   Fri,  2 Aug 2019 19:21:05 +0200
Message-Id: <20190802172105.18999-1-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092055.131876977@linuxfoundation.org>
References: <20190802092055.131876977@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

On Fri, 02 Aug 2019 11:39:54 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.6 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 04 Aug 2019 09:19:34 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.2:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	5.2.6-rc1-gbe893953fcc2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Thierry

