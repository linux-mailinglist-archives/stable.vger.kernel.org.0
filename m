Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633184F5DA0
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 14:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbiDFMSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 08:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbiDFMRi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 08:17:38 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2213ADAD7;
        Tue,  5 Apr 2022 20:49:14 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-e1dcc0a327so1668464fac.1;
        Tue, 05 Apr 2022 20:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=o4I0NyHKaAd4B37pBgJToRxsKvsclvd6Qiz2ePpuduI=;
        b=Wq7XF5SlpgXg/tTj+nVW6gxMbioQyEfGboik+g6QViTdIqpyXgqKa7Iulf59PPi40P
         d0Vbaw8bK7n32NfVYsClDrCadpW74EkareXUkj7UOY4+Nz8dLkFoLlM770DMfYJOENWW
         5kXoIFP5UsMDGTJaUfM9H928vkJzdQvYoN+r21tXDwV0Jb+mBhunvVAw/sI9ce9yI7eD
         eISRjQ3kFxDujorgEsk7Ap9ELQV0xP27MRxFPWYnKjEph35TysaeXVAJ10aeZGzXTk2y
         nVpUpcYRbA0DDYcHcWyatS7aYSDyvQC4ZFHRQVU/EXeBEEFmH0CcN27BLJFUDWldJHMx
         /k4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=o4I0NyHKaAd4B37pBgJToRxsKvsclvd6Qiz2ePpuduI=;
        b=7Kx1Vj3Ox1EOyTN0hoetDfNgHQpkAe551JZQ2n4NxfVjrHk/Iy4z7lXA2hS5o+w+qS
         Aj+zbREOLQoLI7Dvy0rkaGExqppqmRkHDKYGrgEbmyuOgMLX1AmVO2q7NeusOXc8KZff
         USq/rBVnTMt2EF52XAkSn00zCluAZ4OjOUEIeJk2XR39ltO0RJojCir4DZCtnk1wfOHG
         HUyVWpU7gWrh4HxuUTckFyjlSz6G5pC6tdt8oGzsBPn79Zq2kA6Wu9VcrHx2WY+OyoWt
         YZGwsjDssOA3dPvC+ZNlPUz6V1wlxR4Q8fHNONiXSWYJGECJDbaXkpx5c6E3AEe1GIrm
         4ajA==
X-Gm-Message-State: AOAM53048z3Sv/SJ2J6RyCPvu7sNREvV3GJeumphupBZ6FoLo3UbyhFN
        l9NeGlQ6W+jxU9eaekzPgj4=
X-Google-Smtp-Source: ABdhPJyioCRdGIPf85NBOXUoM5addAJhjyEhFcGvAdB7LkJwnN8H1CuOkGkyqCH6NvPOXIFEq2RIQw==
X-Received: by 2002:a05:6870:17a5:b0:d4:164a:a1b0 with SMTP id r37-20020a05687017a500b000d4164aa1b0mr3161904oae.74.1649216953968;
        Tue, 05 Apr 2022 20:49:13 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 8-20020a056870130800b000dea2399c5esm6117040oab.45.2022.04.05.20.49.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 20:49:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <70b550a0-3d8a-528e-4e1f-10cfbaa874ef@roeck-us.net>
Date:   Tue, 5 Apr 2022 20:49:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.10 000/599] 5.10.110-rc1 review
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220405070258.802373272@linuxfoundation.org>
 <20220406010749.GA1133386@roeck-us.net>
 <20220406023025.GA1926389@roeck-us.net>
 <20220405225212.061852f9@gandalf.local.home>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220405225212.061852f9@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/5/22 19:52, Steven Rostedt wrote:
> On Tue, 5 Apr 2022 19:30:25 -0700
> Guenter Roeck <linux@roeck-us.net> wrote:
> 
>>> s390 tests crashed. Other failed qemu tests did not compile.
>>
>> Bisect points to commit 93fe2389e6fd ("tracing: Have TRACE_DEFINE_ENUM
>> affect trace event types as well"). Bisect log attached. Reverting the
>> offending patch fixes the problem. Copying Steven for comments/input.
> 
> Do you have this commit?
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=795301d3c2899
> 

No, It applies, but doesn't compile.

kernel/trace/trace_events.c: In function 'update_event_fields':
kernel/trace/trace_events.c:2459:40: error: 'TRACE_EVENT_FL_DYNAMIC' undeclared

TRACE_EVENT_FL_DYNAMIC is not defined in v5.10.y.

Guenter
