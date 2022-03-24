Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C663B4E68F0
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 19:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345941AbiCXS6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 14:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243939AbiCXS6c (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 14:58:32 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D511BB8217
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 11:56:59 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id e5so5714830pls.4
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 11:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=pcxhySIcOWCHsAiNVpYn/RRJbFdor6RwsPDjnucTHxk=;
        b=nrbDe1Ml+4V2uUxIoe4f8BFic4zt8RNcyHuM3oLeZGAjV8ZZ/eHnaMJXWri6n+tLor
         xKQalaC35/fg1pcz7wosiZfHD0U0lGfLwxfa1OjkGbtl+slmc85QxZjBUHizlQkzhj9z
         dLQzpebqoKIi49LvMPIgccQ3DWc2sia+0w1we+QVtD/LFeWP7+L4fUFv3XfGY6biXYap
         Ch0htHz9l6rnidqOM5elCWBn43lK7GSUXT6EkWfGBWaU5P2BPFBV1tgXLgi/0BOnpgUO
         YyrelQ8zZy8sZ8GCpp4KxaLLoEnQsPIzQsa5K3fQUXDYBxFsrodBBm5h+JUmme3H6bKg
         kTEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pcxhySIcOWCHsAiNVpYn/RRJbFdor6RwsPDjnucTHxk=;
        b=4quBUTsaqbn/2NHRgKWcrsVKv5rqNMu0I/3wjPlOy8SGurt//jzfmw1Be7o5CkEHXr
         0XqmvkvYwXXPoN7EWawJjoLSSC5ks2uxHf0LvPPmdT/fin8ZJq/4TUKIF3EODCbayPLl
         3+hSi92k3vc9hvqdLnSlrs34+B35ialYeYGtfeXoBeJhdVIBKGmmlGculwcB82dJ4D6H
         /ltgNBDpBk2vaKPABmVrGEwnP4B6qk11WIS20xs3+PCcMzfOfkNuzV7V53wZHYw20P6x
         WgnShpasP/RBimd4AHp7//gzK8SS7HPLKv5ulKPeYmMRaXiqbYHISpNMuJYW3BoiTiUm
         CsQQ==
X-Gm-Message-State: AOAM532d4iFJIgl6Tzwwb69UZYNC6tEZ0pt+bCxcF9bL5obGhscE/s5e
        BmenEEdqWDi7s/7aX61qnc97xA==
X-Google-Smtp-Source: ABdhPJyX80s+lS710dJwMcJQfySzYbRnAuXhxxi/OtmqVi0IMtT4JwbMbzfi3m8CANc1KC/lXf8sXw==
X-Received: by 2002:a17:903:1ce:b0:150:2117:16b3 with SMTP id e14-20020a17090301ce00b00150211716b3mr7305034plh.26.1648148219320;
        Thu, 24 Mar 2022 11:56:59 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id p128-20020a622986000000b004e1366dd88esm4008274pfp.160.2022.03.24.11.56.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Mar 2022 11:56:58 -0700 (PDT)
Message-ID: <23a2f6ae-42bb-fe05-9f3a-649de9f52a39@linaro.org>
Date:   Thu, 24 Mar 2022 11:56:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Apply "tpm: Fix error handling in async work" to stable
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <e7d8a669-b2ba-a7c3-9bcb-24af77a51d7d@linaro.org>
 <Yjyk6Eek06iJlWs4@kroah.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <Yjyk6Eek06iJlWs4@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/24/22 10:05, Greg KH wrote:
> On Thu, Mar 24, 2022 at 07:55:00AM -0700, Tadeusz Struk wrote:
>> Please apply upstream commit
>> 2e8e4c8f6673 ("tpm: Fix error handling in async work")
>> to stable 5.4, 5.10, 5.15, 5.16, 5.17
>> Link:https://lore.kernel.org/all/20220116012627.2031-1-tstruk@gmail.com/
> Now queued up, thanks.

Thanks, but I can see it queued up for 5.17 only.
What about 5.4, 5.10, 5.15, 5.16?

-- 
Thanks,
Tadeusz
