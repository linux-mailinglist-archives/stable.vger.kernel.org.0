Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008DA6313C0
	for <lists+stable@lfdr.de>; Sun, 20 Nov 2022 12:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiKTLuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Nov 2022 06:50:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiKTLuw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Nov 2022 06:50:52 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511A232BA0;
        Sun, 20 Nov 2022 03:50:50 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id k5so8199892pjo.5;
        Sun, 20 Nov 2022 03:50:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w+40jj36T96DtJh5DmGZMsh8qwcyv1b5eoW/IqfAE8M=;
        b=Ln6v20dGZDl/B17fLeuofYj7zGcP8E/JFma7aYnYn69HdA1TIO1MP+7b5j4BxlDvMB
         nujdVr6mwRYNvhqRaBzYBoTWQCIAAf48yMcw31vcziHTF+HoSQ9dBH8mA3/oGUo2WQb7
         X9es13xRChMYoko/zPrt3CISH0Br3wAr91jcPlyEZbEBisTXBc1uzAzYHVTIBSxkl97O
         sp0mClXHrt0M2YrZfdmXe6DTexoIEtqG2/sKxobByv6n2bw/11BSCLW5z35hRVIsOsAJ
         SsOv43cYSnPejzuWfVPY4oPS9Yd5fTMwqbyYoEowTB+e9UTapi/bLe/zVDbbJS2HzAXi
         2qpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w+40jj36T96DtJh5DmGZMsh8qwcyv1b5eoW/IqfAE8M=;
        b=WC5LEUo4wnqtl2Be9G7SShfDCoDGztgiknWd0Q6kp42HfCDhDN05n/pbplMKqJpWt4
         8ZLoL1ADDmXeGaS5oZEAVesooWv2z4FcAlQidRWnoxlMd03euhzirNPB8BYJSYSQs/xy
         22tEzWPue3G0Op7ViwV3x/ZKJH8Fz+B3v9gPlRxr4xFQf695Cqp+BkjLzBr8XmUHokQq
         zOdefKb8Gbc5cNjZaWUrFeVTVlH/5N7Sby23QwZ4Jzx+1fcOAcMDC//c2uCdaj41g8ub
         +a2s1CMvsxZIKITRhpAWpVNBiR6/rhNqShMeMDcYMaWM+ocQ31C36JTJeQyT598PUTIk
         26tw==
X-Gm-Message-State: ANoB5pmEPMGcSuVIU7AzkM8aH+mIVMOlEDpzgpk2r6+vrA6cu/dZB/rC
        bnhI2mJeJx7Rc1d1SUEfXLA=
X-Google-Smtp-Source: AA0mqf5wuyjQuzy0tygjF5lFeT9bCDUKiC/2Om9GQQ85mimyAYcdgNszdQYs4AVn4uFnbitUsOQwHQ==
X-Received: by 2002:a17:90a:3d41:b0:213:d34:a80b with SMTP id o1-20020a17090a3d4100b002130d34a80bmr16090030pjf.74.1668945049692;
        Sun, 20 Nov 2022 03:50:49 -0800 (PST)
Received: from [172.30.1.1] ([14.32.163.5])
        by smtp.gmail.com with ESMTPSA id t5-20020a625f05000000b00562f6df42f1sm6483214pfb.152.2022.11.20.03.50.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Nov 2022 03:50:48 -0800 (PST)
Message-ID: <400b9db5-e831-1c60-f47c-905173dd1537@gmail.com>
Date:   Sun, 20 Nov 2022 20:50:44 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v4] PM/devfreq: governor: Add a private governor_data for
 governor
To:     Kant Fan <kant@allwinnertech.com>, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        mturquette@ti.com, rjw@rjwysocki.net, khilman@ti.com
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20221025072109.64025-1-kant@allwinnertech.com>
From:   Chanwoo Choi <cwchoi00@gmail.com>
Content-Language: en-US
In-Reply-To: <20221025072109.64025-1-kant@allwinnertech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22. 10. 25. 16:21, Kant Fan wrote:
> The member void *data in the structure devfreq can be overwrite
> by governor_userspace. For example:
> 1. The device driver assigned the devfreq governor to simple_ondemand
> by the function devfreq_add_device() and init the devfreq member
> void *data to a pointer of a static structure devfreq_simple_ondemand_data
> by the function devfreq_add_device().
> 2. The user changed the devfreq governor to userspace by the command
> "echo userspace > /sys/class/devfreq/.../governor".
> 3. The governor userspace alloced a dynamic memory for the struct
> userspace_data and assigend the member void *data of devfreq to
> this memory by the function userspace_init().
> 4. The user changed the devfreq governor back to simple_ondemand
> by the command "echo simple_ondemand > /sys/class/devfreq/.../governor".
> 5. The governor userspace exited and assigned the member void *data
> in the structure devfreq to NULL by the function userspace_exit().
> 6. The governor simple_ondemand fetched the static information of
> devfreq_simple_ondemand_data in the function
> devfreq_simple_ondemand_func() but the member void *data of devfreq was
> assigned to NULL by the function userspace_exit().
> 7. The information of upthreshold and downdifferential is lost
> and the governor simple_ondemand can't work correctly.
> 
> The member void *data in the structure devfreq is designed for
> a static pointer used in a governor and inited by the function
> devfreq_add_device(). This patch add an element named governor_data
> in the devfreq structure which can be used by a governor(E.g userspace)
> who want to assign a private data to do some private things.
> 
> Fixes: ce26c5bb9569 ("PM / devfreq: Add basic governors")
> Cc: stable@vger.kernel.org # 5.10+
> Reviewed-by: Chanwoo Choi <cwchoi00@gmail.com>
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kant Fan <kant@allwinnertech.com>
> ---
>  drivers/devfreq/devfreq.c            |  6 ++----
>  drivers/devfreq/governor_userspace.c | 12 ++++++------
>  include/linux/devfreq.h              |  7 ++++---
>  3 files changed, 12 insertions(+), 13 deletions(-)
> 


(snip)

Applied it. Thanks.

-- 
Best Regards,
Samsung Electronics
Chanwoo Choi

