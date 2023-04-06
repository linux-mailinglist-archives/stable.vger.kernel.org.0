Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10FD6D8C19
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 02:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjDFAoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 20:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjDFAoJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 20:44:09 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA8C1993
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 17:44:08 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id r16so27914782oij.5
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 17:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680741848; x=1683333848;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=67K+de3mao0/Lnp/JFUaVgWP4zMne5Ah1yDfkby8fn8=;
        b=nx/AYkv7CEOZ3408n02ETiVYOD9Q8YNY4+QF2nmAjQZ98tpiXR9pQmmvXSeanS8Wft
         tHwCfnPL+27H/cOdUMC2iqt+3VOja7Zf3PXib+nFjLzBu4kzYWOTtk+q+QhvsLvwDxNc
         ITt7UYEWBmh8sxVpUS2AJmyK3VwPpR+AUVHerA1CKxBKsWvDvIXfQY7Hrx/LdfhyPoLV
         PVJ2/uzGVeyVYZrvXKYe/+zQrdWoPIxv6AmeOhC70xF7Ccl/l71IIVHsmiuCpBJ4nWpz
         sf+INcsn+Ap3BbTn4THDfpciSY52UTHeg2uUttrvjhgbgVw0aqHoL4CvbZX7//5+5sZL
         Sdsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680741848; x=1683333848;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=67K+de3mao0/Lnp/JFUaVgWP4zMne5Ah1yDfkby8fn8=;
        b=lp2n5Juoq7QilKqEJATFui8UDU3TjJelDc4Z5IpvrZyO7TW2hvsuhxQ4r0J9YbloBh
         VU+qEdGEugfYGJ/n1h6UIGCR2LW7kEU1kiSgP9biLUg6ZNSkingKTAIrgUokzZ1QiLj7
         CABL+aBzb9Z0/cSNkJTxOm+VIWGFRLmRcqWV2i/0Bvjg9zo0HeB6JJzJNqcDdOoExr4O
         RSazKWqDViwsjYQ5s1dxqkQSUBInOJ8xSzCsoNlxubUD7AavdTe+qB9A5zS/xmIveIRq
         njD1jwlKGxoypIiIlNkWG+FwE1AFBjEzVSENPBDjvfmd+cO+Awxyc2IKbGcpKu5gGusp
         oX8A==
X-Gm-Message-State: AAQBX9cI+poPO15o0LsXGgMU1TeARoqG2hU3JTTIwGWfuWDRkeqmRoD8
        AXE2X1A1/182XysQVdddmWA8O+vQV5nq0yRqSYQx3g==
X-Google-Smtp-Source: AKy350b8BmAT+p2shjCbWnOCKFS11d0DHa+ch0OS1JKdTIuUwWRx91NagXjRlTfZlnyd7JdcRr2AKQ==
X-Received: by 2002:aca:674a:0:b0:37f:b1d6:9f3c with SMTP id b10-20020aca674a000000b0037fb1d69f3cmr3077677oiy.46.1680741847707;
        Wed, 05 Apr 2023 17:44:07 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.75.19])
        by smtp.gmail.com with ESMTPSA id f1-20020a4ab001000000b0051aa196ac82sm7336187oon.14.2023.04.05.17.44.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 17:44:07 -0700 (PDT)
Message-ID: <ce3fab46-1ce6-888d-33ae-0e317b9bba2a@linaro.org>
Date:   Wed, 5 Apr 2023 18:44:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 5.4 084/357] treewide: Replace DECLARE_TASKLET() with
 DECLARE_TASKLET_OLD()
Content-Language: en-US
To:     Tom Saeger <tom.saeger@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
References: <20230310133733.973883071@linuxfoundation.org>
 <20230310133737.692796889@linuxfoundation.org>
 <20230317182806.owvwdor6qpzp6tve@oracle.com> <ZBhek48t2C6QBUrp@kroah.com>
 <20230320164800.mtiol2cbrtr4jfsy@oracle.com>
 <20230320172710.mx7hsqs6tgmcpxjd@oracle.com>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20230320172710.mx7hsqs6tgmcpxjd@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 20/03/23 11:27, Tom Saeger wrote:
> On Mon, Mar 20, 2023 at 11:48:02AM -0500, Tom Saeger wrote:
>> On Mon, Mar 20, 2023 at 02:24:35PM +0100, Greg Kroah-Hartman wrote:
>>> On Fri, Mar 17, 2023 at 12:28:06PM -0600, Tom Saeger wrote:
>>>> On Fri, Mar 10, 2023 at 02:36:13PM +0100, Greg Kroah-Hartman wrote:
>>>>> From: Kees Cook <keescook@chromium.org>
>>>>>
>>>>> [ Upstream commit b13fecb1c3a603c4b8e99b306fecf4f668c11b32 ]
>>>>>
>>>>> This converts all the existing DECLARE_TASKLET() (and ...DISABLED)
>>>>> macros with DECLARE_TASKLET_OLD() in preparation for refactoring the
>>>>> tasklet callback type. All existing DECLARE_TASKLET() users had a "0"
>>>>> data argument, it has been removed here as well.
>>>>>
>>>>> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>>> Acked-by: Thomas Gleixner <tglx@linutronix.de>
>>>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>>>> Stable-dep-of: 1fdeb8b9f29d ("wifi: iwl3945: Add missing check for create_singlethread_workqueue")
>>>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>>>> ---
>>>>
>>>> I noticed kernelci.org bot (5.4) reports:
>>>>
>>>>      Build Failures Detected:
>>>>
>>>>      mips:
>>>>          ip27_defconfig: (gcc-10) FAIL
>>>>          ip28_defconfig: (gcc-10) FAIL
>>>>          lasat_defconfig: (gcc-10) FAIL
>>>>
>>>>      Errors summary:
>>>>
>>>>      1    arch/mips/lasat/picvue_proc.c:87:20: error: ‘pvc_display_tasklet’ undeclared (first use in this function)
>>>>      1    arch/mips/lasat/picvue_proc.c:42:44: error: expected ‘)’ before ‘&’ token
>>>>      1    arch/mips/lasat/picvue_proc.c:33:13: error: ‘pvc_display’ defined but not used [-Werror=unused-function]
>>>>
>>>> Link: https://lore.kernel.org/stable/64041dda.170a0220.8cc25.79c9@mx.google.com/
>>>>
>>>> Here's what I found...
>>>> this backport to 5.4.y of:
>>>> b13fecb1c3a6 ("treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD()")
>>>> changed all locations of DECLARE_TASKLET with DECLARE_TASKLET_OLD,
>>>> except one, in arch/mips/lasat/pcivue_proc.c.
>>>>
>>>> This is due to:
>>>> 10760dde9be3 ("MIPS: Remove support for LASAT") preceeding
>>>> b13fecb1c3a6 ("treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD()")
>>>> upstream and the former not being present in 5.4.y.
>>>>
>>>> I rolled a revert/re-apply with fixes in the attached mbox,
>>>> however maybe just a revert makes more sense?  Up to you.
>>>>
>>>> I have yet to try building this on mips, just did this by inspection.
>>>
>>> I've taken your patches, let's see how that works...
>>>
>>
>> Ugh, It didn't go well.  I now see a problem.  The change to DECLARE_TASKLET_OLD also
>> removed the last parameter.  I missed that.  I'll spin-up a mips build.
>>
> 
> I've now confirmed locally with gcc-10 mips build of lasat_defconfig
> 
> 
> fixup patch should be:
> 
> 
> diff --git a/arch/mips/lasat/picvue_proc.c b/arch/mips/lasat/picvue_proc.c
> index 8126f15b8e09..6b019915b0c8 100644
> --- a/arch/mips/lasat/picvue_proc.c
> +++ b/arch/mips/lasat/picvue_proc.c
> @@ -39,7 +39,7 @@ static void pvc_display(unsigned long data)
>   		pvc_write_string(pvc_lines[i], 0, i);
>   }
>   
> -static DECLARE_TASKLET(pvc_display_tasklet, &pvc_display, 0);
> +static DECLARE_TASKLET_OLD(pvc_display_tasklet, &pvc_display);
>   
>   static int pvc_line_proc_show(struct seq_file *m, void *v)
>   {
> 
> 
> Attached is a reflow of these two patches.

We don't generally build lasat_defconfig but can reproduce the problem on the most recent 5.4.y RC (5.4.240-rc1). Bisection led to "treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD()" (5de7a4254eb2) (as expected), and reverting it also made the build pass (as expected, I guess).

With those two patches applied on top of 5.4.240-rc1, MIPS' lasat_defconfig builds with GCC-12 for us.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

