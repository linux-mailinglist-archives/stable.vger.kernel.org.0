Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08CB9675F38
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 22:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjATVAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 16:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjATVAp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 16:00:45 -0500
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4468BA9F
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 13:00:44 -0800 (PST)
Received: by mail-oo1-xc2d.google.com with SMTP id d16-20020a4a5210000000b004f23d1aea58so1213417oob.3
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 13:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CDDzVfb3PboGUZ1ek82m5PLa0K8UtUGpbjnyxxvLkcI=;
        b=byii7Hj+8+LKxY69s+XuNvu6mpQvxsu7DtCFHAIen3WyhQhMAJAhm8joJwO2qVZqIv
         FcyaJyFJIWeLm04YUTU8SbTNDg+k83ogniWSoNAj6l/TDlRO815cSI/GQ7d7xbx7Kdxo
         IegEC6IpE1NOhx1xEN+sur71tSQMTXXSypwz922VlbXOXoBnnwePaCAy37SJ6YpJPbx0
         N5Ygtd6rnpDdhT5opZuD7czRTPM6oeywjm9NUpBG6yxgZfUQBv01H7cyC3FswEH1NOjs
         d51aiAfTOwwufO+5n00boGQd00mjshUba9xivbU2eR9k+8FuJJinAwk3PVfcShYJ8l0m
         omiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CDDzVfb3PboGUZ1ek82m5PLa0K8UtUGpbjnyxxvLkcI=;
        b=EbizaNzDYufOhf1ewN1o6PE7rIwtYSIK+PGhEBMRTf1pPZkoUMLfmoTCH0pBbaJfnT
         tXwkBv9eNSxL7CNYGdwf9MRGlFEw1aR6KnYi2JaER46Uyifafuo2GbDSIqhDp1nxDaKX
         wYb1BBRmhB7/DPXiwlU7a+qVpl7B4qKDoyADaJynfyRgQv6FAWx2mNAuSNh5a/V5fOm/
         REDE01sc2PfwHzgetfNK7JvQxIR6CAr74Ge7uo9Dd5zMUXsCeCJWQbd6I3rlRgPYTUma
         SUTxh2oQMIbUNFQLR9jlhxi7gtjCFb1wUSAIQiuU5rCrp9QPtld1tJJXO2i6npZy8Bj2
         Lb0g==
X-Gm-Message-State: AFqh2kqwr94xZqxlPd6D+fHwG5kwEGT0Ln/SJYl9j2amjjy6/01PHAvr
        mLRANQtbWznPvMiTQi83cpN68TxdMEc=
X-Google-Smtp-Source: AMrXdXux2SadVMxuQYTh+X9u46rTjIh0ZWTNszXZy2RR0PyWcpRHbLUCf0qTMXzi+38BJtTTclMrug==
X-Received: by 2002:a4a:acc4:0:b0:4f2:a1c1:4dfc with SMTP id c4-20020a4aacc4000000b004f2a1c14dfcmr7510500oon.6.1674248443947;
        Fri, 20 Jan 2023 13:00:43 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m22-20020a4ac696000000b0049bfbf7c5a8sm19766449ooq.38.2023.01.20.13.00.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 13:00:42 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <9927d839-4abc-0daf-36cd-e547beb7c87d@roeck-us.net>
Date:   Fri, 20 Jan 2023 13:00:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "Lin, Wayne" <Wayne.Lin@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "stanislav.lisovskiy@intel.com" <stanislav.lisovskiy@intel.com>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "bskeggs@redhat.com" <bskeggs@redhat.com>
References: <20230112085044.1706379-1-Wayne.Lin@amd.com>
 <20230120174634.GA889896@roeck-us.net>
 <a9deecb3-5955-ee4e-c76f-2654ee9f1a92@amd.com>
 <20230120181806.GA890663@roeck-us.net>
 <MN0PR12MB6101FE67D355FF2A47470C37E2C59@MN0PR12MB6101.namprd12.prod.outlook.com>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] Revert "drm/display/dp_mst: Move all payload info into
 the atomic state"
In-Reply-To: <MN0PR12MB6101FE67D355FF2A47470C37E2C59@MN0PR12MB6101.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/20/23 10:39, Limonciello, Mario wrote:
[ ... ]
>>>
>>> Wayne is OOO for CNY, but let me update you.
>>>
>>> Harry has sent out this series which is a collection of proper fixes.
>>> https://patchwork.freedesktop.org/series/113125/
>>>
>>> Once that's reviewed and accepted, 4 of them are applicable for 6.1.
>>
>> Thanks a lot for the update. There is talk about abandoning v6.1.y as
>> LTS candidate, in large part due to this problem, so it would be great
>> to get the problem fixed before that happens.
> 
> Any idea how soon that decision is happening?  It seems that we have line
> of sight to a solution including back to 6.1.y pending that review.  So perhaps
> we can put off the decision until those are landed.

I honestly don't know. All I know is that Greg is concerned about
the number of regressions in v6.1.y, and this problem was one
he specifically mentioned to me as potential reason to not designate
6.1.y as LTS kernel. The extensive discussion at [1] may be an
indication that there is a problem, though that mostly refers to
[lack of] test coverage and does not point to specific regressions.

Guenter

---
[1] https://lore.kernel.org/lkml/CAPDLWs-Z8pYkwQ13dEgHXqSCjiq4xVnjuAXTy26H3=8NZCpV_g@mail.gmail.com/

