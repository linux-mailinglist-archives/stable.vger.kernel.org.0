Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A48C6C3BEA
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 21:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjCUUhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 16:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCUUhv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 16:37:51 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A802B2BE
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 13:37:49 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id ew6so1705072edb.7
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 13:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679431068;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ooxoPpxJcWn1cgnJus+6MsxiU12bkVeiWLUik+bBjDA=;
        b=ZprA1MamKgGc7rmrBpQsdZ5sv7Cc/PJpEh5pIzz6RTRi7VLK8meSSCcF2pyowEJ9hW
         seDUd9iPVLl//3VjyrnZq0hXDvi3hGwuc8BxYtbG4x9hCoiBQbueXAklDIMfCIYRkWKD
         B6e1Su3ESPObIK0EXcg54kum2cmR0gGon80xAsVenGfMnJv0SlQUJAN72lkSb+gVTh9u
         p9Hd3f5/xGdWCjNNYIMYWlxLR3VEy23eE3aZELswljVHAL40YTcdUNSyKyB1FEIjNUhL
         H5IHcyBI7bBkPsvFuMbIcOuSQ/IL1X1A0Q/NKBn3XewDftHB0P2ABCxXMFJMACPYpcU1
         RzxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679431068;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ooxoPpxJcWn1cgnJus+6MsxiU12bkVeiWLUik+bBjDA=;
        b=hoCVhdo9gPfnH5Wzk4Jc4leMjPZv65AV0odrKSBV4p7ZlKuV2evSXJzPfTK7FoEVPC
         9R3DXd8+8cF6mswtRurHOaEdXOI1MObgN6kudlyUaHB7Oixzsq190GRpnsu7NG7JxVTV
         BNrZBHn+2xuGzWXH6fRd9yGAIZ42HtwDWbhCgk9bNGz5q/l1VkG/WA/BJXwjlnZRVpx+
         nAMrOdw8yshTA9KVbR4IRPaWywb5YyXjH8Qv41XCNqAc4Llv4dzpY/tuH8tc8Kve0iAF
         U69hBPlgj+3FipR1mOrqauUxvsg4D+WcTyqEAbGflWUaOdFtywWkRGMfR7UqYb30Y2TX
         XqCg==
X-Gm-Message-State: AO0yUKWncZYKXXmN5hFAPpbFwWqnS0YlZ23JTvzEfO3AeF1I4usr/5cB
        VwqzKGbEZ1h14n8Da+h9gERz7blg1vSh+sFly1A=
X-Google-Smtp-Source: AK7set84TzV6DjBlgek9nqUxmjcU4q//bjtT1QVmmi8hOZGyEQgDS5fsrBa5cQdiZQx/P81frRcYMw==
X-Received: by 2002:a17:906:b0d7:b0:933:3cd8:a16f with SMTP id bk23-20020a170906b0d700b009333cd8a16fmr4286405ejb.75.1679431068049;
        Tue, 21 Mar 2023 13:37:48 -0700 (PDT)
Received: from [192.168.1.195] ([5.133.47.210])
        by smtp.googlemail.com with ESMTPSA id k8-20020a17090627c800b008d1693c212csm6167681ejc.8.2023.03.21.13.37.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 13:37:47 -0700 (PDT)
Message-ID: <5ac68553-4e05-732b-2058-35590f6adbcb@linaro.org>
Date:   Tue, 21 Mar 2023 20:37:46 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH for-6.1.y] Revert "ASoC: codecs: lpass: register mclk
 after runtime pm"
Content-Language: en-US
To:     Amit Pundir <amit.pundir@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Stable <stable@vger.kernel.org>
References: <20230315181900.2107200-1-amit.pundir@linaro.org>
 <ZBINX5qbdmY5CQOD@kroah.com>
 <CAMi1Hd1VaEGcN6Z2v0_V4Msj+BddNLtfPggZpc2u1yKHRHueiQ@mail.gmail.com>
 <ZBLSg0BI28Bq31EU@kroah.com>
 <CAMi1Hd3v7sXwR5h0Zgn32vjN49OdJYQ7RH9NCO9yj9x9QTae0A@mail.gmail.com>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
In-Reply-To: <CAMi1Hd3v7sXwR5h0Zgn32vjN49OdJYQ7RH9NCO9yj9x9QTae0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Amit,

sorry for late reply.

On 16/03/2023 11:29, Amit Pundir wrote:
> On Thu, 16 Mar 2023 at 13:55, Greg KH <gregkh@linuxfoundation.org> wrote:
>>
>> On Thu, Mar 16, 2023 at 12:13:40AM +0530, Amit Pundir wrote:
>>> On Wed, 15 Mar 2023 at 23:54, Greg KH <gregkh@linuxfoundation.org> wrote:
>>>>
>>>> On Wed, Mar 15, 2023 at 11:49:00PM +0530, Amit Pundir wrote:
>>>>> This reverts commit 7b642273438cf500d36cffde145b9739fa525c1d which is
>>>>> commit 1dc3459009c33e335f0d62b84dd39a6bbd7fd5d2 upstream.
>>>>>
>>>>> This patch broke RB5 (Qualcomm SM8250) devboard. The device
>>>>> reboots into USB crash dump mode after following error:
>>>>>
>>>>>      qcom_q6v5_pas 17300000.remoteproc: fatal error received: \
>>>>>      ABT_dal.c:278:ABTimeout: AHB Bus hang is detected, \
>>>>>      Number of bus hang detected := 2 , addr0 = 0x3370000 , addr1 = 0x0!!!
>>>>>
>>>>> Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
>>>>> ---
>>>>>   sound/soc/codecs/lpass-rx-macro.c  |  8 ++++----
>>>>>   sound/soc/codecs/lpass-tx-macro.c  |  8 ++++----
>>>>>   sound/soc/codecs/lpass-va-macro.c  | 20 ++++++++++----------
>>>>>   sound/soc/codecs/lpass-wsa-macro.c |  9 +++++----
>>>>>   4 files changed, 23 insertions(+), 22 deletions(-)
>>>>
>>>> Is this also reverted in Linus's tree?  If not, why not?
>>>
>>> I couldn't reproduce this crash on Linus's tree. It was first reported
>>> on android14-6.1 and then I could reproduce it on v6.1.19 as well,
>>> hence this revert.
>>>
>>> A quick search points out that this patch is a part of a 8 patch
>>> series https://lore.kernel.org/lkml/20230209122806.18923-1-srinivas.kandagatla@linaro.org/
>>> while only 5 of them landed on v6.1.y. May be we need the remaining
>>> fixes on v6.1.y as well? I can give the remaining patches a quick shot
>>> tomorrow if that helps.
>>
>> Yes please, we would much rather take whatever is in Linus's tree than a
>> special revert as that will keep the trees in sync better.  If you can
>> provide the missing git ids, I can just queue them up if you have tested
>> them.
>>
> 
> Cherry-picking the rest of the relevant fixes from the
> https://lore.kernel.org/lkml/20230209122806.18923-1-srinivas.kandagatla@linaro.org/
> series didn't help.
> 
> Srini, does this patch series has a dependency on other upstream fixes
> as well? With the above patch series on v6.1.y, I see the following
> crash on RB5:
> 
This looks like uncovered an issue with 
drivers/clk/qcom/lpass-gfm-sm8250.c driver which seems to not do runtime 
pm correctly in some case.
This driver seems to get lucky with clocks.

I already sent a fix for this 
https://lore.kernel.org/lkml/c5273d67493cbb008f13d7538837828a.sboyd@kernel.org/T/

That should fix the reported issue.

--srini
> qcom-q6afe aprsvc:apr-service:4:4: cmd = 0x100f6 returned error = 0x1
> q6asm-dai 17300000.remoteproc:glink-edge:apr:apr-service@7:dais:
> Adding to iommu group 25
> qcom-q6afe aprsvc:apr-service:4:4: Unknown cmd 0x100f6
> qcom,apr 17300000.remoteproc:glink-edge.apr_audio_svc.-1.-1: Adding
> APR/GPR dev: aprsvc:apr-service:4:8
> qcom-q6afe aprsvc:apr-service:4:4: cmd = 0x100f6 returned error = 0x1
> qcom-q6afe aprsvc:apr-service:4:4: Unknown cmd 0x100f6
> qcom-q6afe aprsvc:apr-service:4:4: cmd = 0x100f6 returned error = 0x1
> qcom-q6afe aprsvc:apr-service:4:4: Unknown cmd 0x100f6
> wsa881x-codec sdw:0:0217:2110:00:4: nonexclusive access to GPIO for powerdown
> qcom-soundwire 3250000.soundwire-controller: Qualcomm Soundwire
> controller v1.5.1 Registered
> qcom_q6v5_pas 17300000.remoteproc: fatal error received:
> ABT_dal.c:278:ABTimeout: AHB Bus hang is detected, Number of bus hang
> detected := 2 , addr0 = 0x3370000 , addr1 = 0x0!!!
> remoteproc remoteproc1: crash detected in 17300000.remoteproc: type fatal error
> remoteproc remoteproc1: handling crash #1 in 17300000.remoteproc
> remoteproc remoteproc1: recovering 17300000.remoteproc
> platform 17300000.remoteproc:glink-edge:fastrpc:compute-cb@5: Removing
> from iommu group 23
> platform 17300000.remoteproc:glink-edge:fastrpc:compute-cb@4: Removing
> from iommu group 22
> platform 17300000.remoteproc:glink-edge:fastrpc:compute-cb@3: Removing
> from iommu group 21
> qcom-q6afe aprsvc:apr-service:4:4: AFE set params failed -110
> clk_unregister: unregistering prepared clock: LPASS_HW_DCODEC
> clk_unregister: unregistering prepared clock: LPASS_HW_MACRO
> platform 17300000.remoteproc:glink-edge:apr:apr-service@7:dais:
> Removing from iommu group 25
> remoteproc remoteproc1: stopped remote processor 17300000.remoteproc
> remoteproc remoteproc1: remote processor 17300000.remoteproc is now up
> qcom,fastrpc-cb 17300000.remoteproc:glink-edge:fastrpc:compute-cb@3:
> Adding to iommu group 21
> qcom,fastrpc-cb 17300000.remoteproc:glink-edge:fastrpc:compute-cb@4:
> Adding to iommu group 22
> qcom,fastrpc-cb 17300000.remoteproc:glink-edge:fastrpc:compute-cb@5:
> Adding to iommu group 23
> qcom,apr 17300000.remoteproc:glink-edge.apr_audio_svc.-1.-1: Adding
> APR/GPR dev: aprsvc:apr-service:4:3
> qcom,apr 17300000.remoteproc:glink-edge.apr_audio_svc.-1.-1: Adding
> APR/GPR dev: aprsvc:apr-service:4:4
> SError Interrupt on CPU6, code 0x00000000be000411 -- SError
> <RB5 reboots into crash mode here..>
> 
> 
> Regards,
> Amit Pundir
> 
>> thanks,
>>
>> greg k-h
