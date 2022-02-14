Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8764B59FC
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 19:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357502AbiBNSe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 13:34:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357499AbiBNSey (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 13:34:54 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF156543B
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 10:34:46 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id c10so5118493pfv.8
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 10:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=iVTc80VDgAX6ffBkAdZDFZFBuKvS8UKxrL8hYZmwMtw=;
        b=J2EAjIE2pDV5MoeTSydLeYvlBMJ8UOu4jfyTx+yFEIsDOW3jDtt88nXLQq6kZ2K54N
         CO+JlAM2uQdfpuqmoKVokH3licFATuPfJRguuDupvHbBMCK+STs56tXm+dnMv7wUZrzt
         u3Ypj/O7eMiBiSq/P4FUQkDTBNl38ZEnCYSVXC2Xro4L32wCE4Zsd7jSu8YMhTnRePAk
         hMS+GT7nCX9L+GFCGGJvuMYz1ECZ54u2rFqXCLCwOH90N/WebQP7iKVpNZV60wTrkK9U
         TyNS1n7RmQVOtXAA8Xpp7+3V9RF+X4XoYey8Ad4sKxK7lxWw78UBd/whkdzxqOngvQh/
         hY6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iVTc80VDgAX6ffBkAdZDFZFBuKvS8UKxrL8hYZmwMtw=;
        b=T6kjXjh1bCmyqm7JEpTbVQIAD+7OmV5OUDGyQT9nOptre5+2pslQSthjHRtNFk8mFW
         ZhdHmKOfspIWLF+2+kNVrAEgzZbLtAVxd76XZ/S1mMjlMiX9Hfv85un4/eK34VfgEIBk
         hJ0pu+VLMbjcAENkEgYC0WqGg9vDEGNKodhLfgQN9Xg51OFzvGYi5huH1B3lTlkI+Ep+
         NijoV5LWAiH5ES36YQTdiOjceVj23p1tkL84VkPid13iWMtCPn9LZDA1kl2o62IjHU40
         aWmwTjVDl6epShPz95tbl0ReaJWx/qgRdVOERbbCPVVgfLoS4rqa49Gj3ABmXf+8ZPYH
         RtGg==
X-Gm-Message-State: AOAM530Rfi3NFgs/shxQIFRpMTE6UFR22/VIxBlbOCxwnxnESRy82gR3
        cb4kyAviB8fMcdUZKgXKNJ1cijMeKqM=
X-Google-Smtp-Source: ABdhPJyBLIj6gN/mjUcwyuOykNO0XvIDlaEAsDKagwy+9gNfn9bwY9FgEyI7ob2S7LZExKRjD7cAjQ==
X-Received: by 2002:a63:87c6:: with SMTP id i189mr304614pge.314.1644863686129;
        Mon, 14 Feb 2022 10:34:46 -0800 (PST)
Received: from [10.69.44.239] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h9sm38259733pfi.124.2022.02.14.10.34.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 10:34:45 -0800 (PST)
Message-ID: <f0873dd7-d32d-d851-51bc-51d86f7bd0f0@gmail.com>
Date:   Mon, 14 Feb 2022 10:34:45 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: backport of lpfc patches: NVME_FC disabled and Reducing Log msgs
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>
References: <9d661b63-5640-fe88-b938-1f4d1767908c@gmail.com>
 <YgoAuFRKWOIfY8ai@kroah.com>
From:   James Smart <jsmart2021@gmail.com>
In-Reply-To: <YgoAuFRKWOIfY8ai@kroah.com>
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

On 2/13/2022 11:11 PM, Greg KH wrote:
> On Sun, Feb 13, 2022 at 09:26:16AM -0800, James Smart wrote:
>> I'd like to request the 2 patches below to be backported to the 5.6 and 5.12
> 
> 5.6 and 5.12 are long end-of-life, see the front page of kernel.org for
> the active kernel trees please.
> 
>> kernels. Other stable kernels are fine. The fixes were recently merged into
>> linus's tree:
>>
>> scsi: lpfc: Remove NVMe support if kernel has NVME_FC disabled
>> This can cause device connectivity failure.
>> commit c80b27cfd93b
> 
> This one applied to 5.4, 5.10, 5.15, and 5.16 ok.
> 
>> scsi: lpfc: Reduce log messages seen after firmware download
>> This was causing overruns and headaches on consoles that were very slow.
>> commit 5852ed2a6a39
> 
> This only could be applied to 5.10 and newer stable kernels.  If you
> want any of these applied to older kernel trees, please provide working
> backports.
> 
> thanks,
> 
> greg k-h

I'm good with 5.10 and newer stable kernels, and 5.4 with the 1st patch.

Thank you.

-- james
