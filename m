Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99716565743
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 15:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234683AbiGDNcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 09:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234530AbiGDNb5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 09:31:57 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B71411A
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 06:28:20 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so13756622pjl.5
        for <stable@vger.kernel.org>; Mon, 04 Jul 2022 06:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=JHEVI+d7tEPJB9AOP+MWDP4fsBFl54YyhWPmaDUtkVY=;
        b=RLbZG1v6jlKwBM7hwhuLA9k4dcKjZDYAJvM6ZDAyuq7AmNhZBFPeWF7U3BSo7NOB//
         mbDNXl6CkaNbbQMETUVYc4VShgrOKJgKDPFYYauRgE/e+PVLH1L5HvpSAq+4hSr4ugWn
         znb0C9G8Ig1m4pE5h4a9PMWJ0LjyqlK9W+dTwYh63zVIekBXJYxGpYrWr04aOxhfBenS
         4Lwbax5BhUFUDI8T+39vAD8SMhWhyzz5cOI+4u0Kxh/50E32/ace06SgeT0i4eGyfXHG
         6DEepZHG8ltcfaFUXwVWY3tHg/a9x58aHGY0hSY3lhcXs9WMEvJyTruGsybY7bTUaNlH
         UUqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=JHEVI+d7tEPJB9AOP+MWDP4fsBFl54YyhWPmaDUtkVY=;
        b=EJxgYFmzIV+YF/n9pGih7Y+LroTV1p/GDz/k/MqB2FAjs9XqEQRl8jh3djZwPPY/dH
         oLFcllWK0tARC3F/lh3hrA2UgBtL/YuDA21s3xSsjQfRC+GU0wGJdmvzd0NcnBlPmAzv
         +eoIdmbweVGJbhsWRptDYIOGUh+fx1X7JGjH37I8RYQZufkF//29QXi6CO5IWn6ICEi+
         ae43ZGOa616NVWanRfv8otkapOa8F/z+gz46gm1YNUy25whYXl9WhvymCTd/pdsB33PF
         fOglQCdVi36+m1Ctw8y9A29rOCmHXkulLFwh2XcHBHOMSR5TcoeyCWd6Jl5I2QDEG5fZ
         vFsQ==
X-Gm-Message-State: AJIora/ahU81K8yScWxfkoPGycmVDzfAB/AaDyUuAEyeg2T7ngdcsxs4
        r7ntKp1rHXE1nlKYJjNQHifD1g==
X-Google-Smtp-Source: AGRyM1s+DJ8VT777wrHIRgbunEmu6zRBg5ENqnob/1nRBQjOaxtqg/L1o1ysy/a4/1My7QwgfwQ5Wg==
X-Received: by 2002:a17:90b:1807:b0:1ef:8aa5:1158 with SMTP id lw7-20020a17090b180700b001ef8aa51158mr4908409pjb.163.1656941299927;
        Mon, 04 Jul 2022 06:28:19 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id w66-20020a627b45000000b005286697ec68sm2205577pfc.133.2022.07.04.06.28.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jul 2022 06:28:19 -0700 (PDT)
Message-ID: <e61ff267-4c75-2fd8-d7f6-bd5e059602bd@kernel.dk>
Date:   Mon, 4 Jul 2022 07:28:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: 5.18/15/10 backport
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
References: <36e6d08d-89c0-99e3-a248-1ce79315de03@kernel.dk>
 <4d63639d-f285-5585-4b6c-14e0bf7cdb17@kernel.dk>
In-Reply-To: <4d63639d-f285-5585-4b6c-14e0bf7cdb17@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/4/22 7:26 AM, Jens Axboe wrote:
> On 6/30/22 2:45 PM, Jens Axboe wrote:
>> Hi,
>>
>> Can you apply these three patches, one for each of the 5.10, 5.15, and
>> 5.18 stable tree? Doesn't fix any issues of concern, just ensures that
>> we -EINVAL when invalid fields are set in the sqe for these opcodes.
>> This brings it up to par with 5.19 and newer.
> 
> Just a reminder on this one, thanks!

Disregard, mid-air collision on emails. Thanks for queueing them up.

-- 
Jens Axboe

