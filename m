Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D48B4E65D4
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 16:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351231AbiCXPLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 11:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351222AbiCXPLp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 11:11:45 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFB85DE60
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 08:10:13 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id gb19so4982227pjb.1
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 08:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=NnO431goVfTKN35sIuI6/MlmyFGMTyhi78maIsdFXTM=;
        b=hLXd/rWi8ellM1iVU2Y9LtqIDGMjq44CWxZiSjmpPW8qgGWwOrosADdY9F9REv37l9
         WLi7+ZyXe3IN6b2AgCNRHvPmDD9+ouhNCPVuiyGxTCBG513x1J/pHm9rHsWiamUUM8MO
         1mXru01wfXH4x7RHm1ukxXhf3zxOB97u4XWN/8VLg8AkJ0bdPrmCHzGwlVe26v8Tzyhv
         fdOtTtfp12dJEPh7Md87252gm/bQ2m3+a0rP+GHaDXyR3soxPj9z/Z/yyRq6cF96m0k/
         IIV9q4RBR5kU3lHNm6ASrur1McoobRm6VvB6eMHl5YJrK5E/NciLkmHPPvbLlVnhm2Ad
         lU+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NnO431goVfTKN35sIuI6/MlmyFGMTyhi78maIsdFXTM=;
        b=FteTuuoXfeFZH++XWz2s6A2Gk7Ox4yzvWULz8I9DJpmdOt24XIijbvu56cR4d8DeyR
         G0lqSeBLJk1L02ByQAr39ysdtRloMTALm20xWoh02390ufaBzSno+Pawuxq1FO7sASVq
         ilGe9RFrYhR7It6vbQxGsnkqNzMmwr6XvZ5SSU+nQ8ZLiwt0fFBygSDtGW2tQ8pJrvk/
         k6lCFSm9uDR4h5qhIZhDmtoptENOjPYToyyIym85Xq63ogAgkWe3QeoI013gL+bkWw4L
         Jhke6LS2e+WAaHMUEBgFV1qON1QS/+D6SDOPmZbVc4zTHND7iLoafyC4s740GuZW785h
         XJIw==
X-Gm-Message-State: AOAM531Xb5hcC+rr8fEmOJV5OAt/vh0x25q9vNfohhwBD0RCmdlnci8h
        gZ6OmLrZ3o6jvhiMekwjdY/RDRemp6A=
X-Google-Smtp-Source: ABdhPJzyK6KKaO1C+73ZnGLOBXD8t+XBElj7mlXvLXjKfSODWSBKSjmJGgqrILoC2jAHZ/nLwTsZww==
X-Received: by 2002:a17:90b:4c92:b0:1c7:a9a3:6274 with SMTP id my18-20020a17090b4c9200b001c7a9a36274mr7588475pjb.148.1648134613240;
        Thu, 24 Mar 2022 08:10:13 -0700 (PDT)
Received: from [192.168.1.26] (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id n3-20020a056a0007c300b004fa3e9f59cdsm3627849pfu.39.2022.03.24.08.10.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Mar 2022 08:10:12 -0700 (PDT)
Message-ID: <b859985d-e5db-1b70-2127-048abe59e363@gmail.com>
Date:   Thu, 24 Mar 2022 08:10:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Backport Request: scsi: lpfc: Fix DMA virtual address ptr
 assignment in bsg
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>
References: <6aab7d93-7791-fd8b-b0ed-6a0a2ee52472@gmail.com>
 <fd794879-48d6-463a-fe0f-184df7cc66d2@gmail.com> <Yjxp+RWNiRtNC919@kroah.com>
From:   James Smart <jsmart2021@gmail.com>
In-Reply-To: <Yjxp+RWNiRtNC919@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/24/2022 5:54 AM, Greg KH wrote:
> On Mon, Mar 21, 2022 at 02:45:53PM -0700, James Smart wrote:
>> Please backport the following patch to the 5.10 stable kernel. It is was
>> upstream'd as of the 5.12 kernel.
>>
>> scsi: lpfc: Fix DMA virtual address ptr assignment in bsg
>> commit    83adbba746d1
>>
>> The error causes diagnostic loopback tests to fail.
>>
>> Note: problem was introduced in 5.10 by:
>>    scsi: lpfc: Reject CT request for MIB commands
>>    commit b67b59443282
> 
> It does not apply.  How did you test that this works?
> 
> Please send a working backport and we will be glad to queue it up.
> 
> thanks,
> 
> greg k-h

I didn't. I apologize. Won't happen again. I had perused commit lists 
and obviously got that wrong. It was so simplistic I didn't give it the 
attention it should have had.

Please drop this request.

-- james
