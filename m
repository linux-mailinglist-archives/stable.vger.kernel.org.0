Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06EC4362A85
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 23:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237911AbhDPVou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 17:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235540AbhDPVot (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 17:44:49 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED68BC061574
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 14:44:23 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id z5so7265937ioc.13
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 14:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F20hX6SAKymA+4kbgsxrCEm2iaV484qElSPM86dpe9g=;
        b=UgSiU8aMue8nsFzOnUf10ow3xB1uA/Fcml4nKQY3vvz5QLtYC0fRhZhCcE8RrrG9th
         2YyWv0fE/hMa5UQMbnZzuD3birlJaiqcZn9ctrm0IvMfJeRbFi9TwADx8aDO/mj3RotJ
         eNV9cu2ocRcP4aq/I7T4RUG1JtBuFWAhDY6YA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F20hX6SAKymA+4kbgsxrCEm2iaV484qElSPM86dpe9g=;
        b=biRyxm8Ri6z+m31m6NHTU4X3lEb8muh0p3PoHhkAbpegsROReWQ/U/SlWT3O1lxzpg
         PvnGlPbAO4ZWW86Civh8+Fi5TNvn0zJJRUXa8G0BNurHhg9RmpXrmq4mDs86/kD38wq5
         BTh1VvZrmCFT28zyUvPnU//LHvzltRDBiBpui/0uICvEHWM0g3v7CgevuYYEWSGMD8lu
         mcMTqb9V11kXttRo1vyYnqSpvl776sINIcSP5D5iogKuFQgOyzIQDlj6zzNjPJL9vEdg
         cXyE3sSJ0BjNH8hJSEOVtQajsOLv2jwHjtlE2Xd9m/Ahby+o/152a0stlSFJQS1GdMDp
         2Nkg==
X-Gm-Message-State: AOAM530TkQnUXlWIJRIfnRQSJ3edbv0nqSYNxnAlKC0tnc63lHeaOasC
        eRdBH3VuCdLwPNI/lNPtENIKQQ==
X-Google-Smtp-Source: ABdhPJxMTF3HBSS30SbvypoR0QP6DbzKGBS+kTzwx45DNq/wpYPfnfkmG9bLUDcoiGknPR4gino6Gg==
X-Received: by 2002:a5e:d907:: with SMTP id n7mr5395570iop.177.1618609463384;
        Fri, 16 Apr 2021 14:44:23 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id h12sm3378051ilj.41.2021.04.16.14.44.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 14:44:23 -0700 (PDT)
Subject: Re: [PATCH 2/4] usbip: stub-dev synchronize sysfs code paths
To:     Tom Seewald <tseewald@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210416205319.14075-1-tseewald@gmail.com>
 <20210416205319.14075-2-tseewald@gmail.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c93d209c-a5ad-3bec-0724-99ab308b3d25@linuxfoundation.org>
Date:   Fri, 16 Apr 2021 15:44:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210416205319.14075-2-tseewald@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/16/21 2:53 PM, Tom Seewald wrote:
> From: Shuah Khan <skhan@linuxfoundation.org>
> 
> commit 9dbf34a834563dada91366c2ac266f32ff34641a upstream.
> 
> Fuzzing uncovered race condition between sysfs code paths in usbip
> drivers. Device connect/disconnect code paths initiated through
> sysfs interface are prone to races if disconnect happens during
> connect and vice versa.
> 
> Use sysfs_lock to protect sysfs paths in stub-dev.
> 
> Cc: stable@vger.kernel.org # 4.9.x
> Reported-and-tested-by: syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> Link: https://lore.kernel.org/r/2b182f3561b4a065bf3bf6dce3b0e9944ba17b3f.1616807117.git.skhan@linuxfoundation.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Tom Seewald <tseewald@gmail.com>
> ---


Thank you for the backport.

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

Greg, please pick this up for 4.9.x

thanks,
-- Shuah
