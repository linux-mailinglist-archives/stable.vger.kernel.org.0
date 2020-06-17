Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDD31FC54C
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 06:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgFQEjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 00:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgFQEjr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jun 2020 00:39:47 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C592BC061573;
        Tue, 16 Jun 2020 21:39:46 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id j1so521442pfe.4;
        Tue, 16 Jun 2020 21:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wjIS6quU1lqmjDVhNjwaJnXFCnUiOtUwKImzRhZ2bgc=;
        b=A2sl74xLMtbifaX9arP7WG0Nvc0k8r6ElGrJK5gpjailYwkH8k29L17jpK6Qj1uITQ
         +KqzQcaecorBYwYZ4EAIB3lA//jZbV5lku/OtcchMNgPpXtQZBazVCieXXjeM1ntE0bJ
         Q2/4JdFFhPmH9xBIkqaoTWBOpg7tlcgb3VtbVEGK8kdQP6DHUrAdM/dky/cUkoswsq+0
         q3WMWxslAVdfSs23NjjJpmIcNEhokrOfWTdIIekQu5/J61hxsk2eSusBEFGPBFcKzKtJ
         8kMNZgjfTI9MX1v8+t8DmAh3u/CmDJIhevxgjBGGoY5HEcN4VFJ55dV+lNoX8wJfDxqQ
         oyqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wjIS6quU1lqmjDVhNjwaJnXFCnUiOtUwKImzRhZ2bgc=;
        b=hc9OyI9D4Jrf+UsJCUdl/s6M96UMd5g+zasluHym1XkIv6xEJrJcsvPpIQTpkwwYsg
         VKwiQqtv/eV0IND3J+NUNGS4RHR7OH+t+RRC3aEHEVACmATjBz6pbXu1TkA40Lya25Kg
         2Jen53h9Zv4Q/UxuHu3+1nOBxbriaK8X7gL+TdvGG1zeIn+E/Fbn/uN3yyMXDbEMe8JM
         QfIWGjomgY2199A3GyRro1B1ULKv5jgPx1398x2TQynrSVzNV9UFJ0LINICWTzY0j7Hp
         x3EiPZx75/uZ1Y9mPbwZMDYqwmSbvfOw54LF2wlszdM5FCcuCg1qjIOOro3NLNomQ6V8
         /a6A==
X-Gm-Message-State: AOAM532KKSlKB1MLgtM168gcbAH1F8+KmmfyPB+Qrr8g+5Oub6qiVlV1
        H288pXOfBvGKyXbl4yQEfSnhIFX0
X-Google-Smtp-Source: ABdhPJzhXvMS9kSx+ExP9yrbN6n3d+LE44zdO2gChfNiINIH7YwdBgj2hmb0sOL0xUBhT3aW4iN32A==
X-Received: by 2002:a63:4b44:: with SMTP id k4mr4924320pgl.305.1592368785092;
        Tue, 16 Jun 2020 21:39:45 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 12sm19545757pfb.3.2020.06.16.21.39.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2020 21:39:44 -0700 (PDT)
Subject: Re: [PATCH stable 4.9 00/21] Unbreak 32-bit DVB applications on
 64-bit kernels
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        "open list:MEDIA INPUT INFRASTRUCTURE (V4L/DVB)" 
        <linux-media@vger.kernel.org>,
        "open list:FILESYSTEMS (VFS and infrastructure)" 
        <linux-fsdevel@vger.kernel.org>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
 <6b1f0668-572e-ae52-27e6-c897bab4204c@gmail.com>
Message-ID: <0c0ba84e-4b2d-53ac-5092-40312ecba13b@gmail.com>
Date:   Tue, 16 Jun 2020 21:39:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <6b1f0668-572e-ae52-27e6-c897bab4204c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/11/2020 9:45 PM, Florian Fainelli wrote:
> 
> 
> On 6/5/2020 9:24 AM, Florian Fainelli wrote:
>> Hi all,
>>
>> This long patch series was motivated by backporting Jaedon's changes
>> which add a proper ioctl compatibility layer for 32-bit applications
>> running on 64-bit kernels. We have a number of Android TV-based products
>> currently running on the 4.9 kernel and this was broken for them.
>>
>> Thanks to Robert McConnell for identifying and providing the patches in
>> their initial format.
>>
>> In order for Jaedon's patches to apply cleanly a number of changes were
>> applied to support those changes. If you deem the patch series too big
>> please let me know.
> 
> Mauro, can you review this? I would prefer not to maintain those patches
> in our downstream 4.9 kernel as there are quite a few of them, and this
> is likely beneficial to other people.

Hello? Anybody here?
-- 
Florian
