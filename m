Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAA91CD383
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 10:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgEKIIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 04:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgEKIIH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 May 2020 04:08:07 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E01C061A0C;
        Mon, 11 May 2020 01:08:05 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t9so7495667pjw.0;
        Mon, 11 May 2020 01:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k2G71kN8Haoompxo3U0sCkik6jn//FKFL8AWmWCpJvI=;
        b=XNbWWqVKHyKLF7jd1B3sI+3YjTL+cq3MvXdnNWXuqOmEQRFeObEcdBASNHmooe9oRb
         biqNyWZNDEHxpVT1FGOIX+umumlhX0lGY+e4c8lCsiUtUav2Xi7KYTQossE5xNcIF6fV
         e8WgOsr4Z+FUt184K3RDDRAPJcjI2X2kMAg0JYUkWYogOd5n2y4ntUNIt6GeSVT6KquY
         0IsYVWHi0OOYINJ+hcHRxiutKQMCG9Kv7iwmZ95SznSYSZLP7Q9NNExGZHibbQaB/b+2
         DaTmklNT83XQCaQaJJFsbH+mNleZLtnirI/WoDUIHIzGn01hXuqQB0M0rA+2D03+ZsY9
         Xnfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k2G71kN8Haoompxo3U0sCkik6jn//FKFL8AWmWCpJvI=;
        b=NXwyx9cUoBZVlgxAhaYKYtr8WHxleqnmmdxoY84uBIkjQ3Ltf1c2GMnyfqFIbnK9ue
         jVFhBFbmyxhUCmD5oVQyIsQMC+qa256j9mPg8R03/JTyPTpKMDJb31QzKcFWUO91A9XU
         AlR6hcW98tgHXlAz/nVLzgxi2+zliMeLANPcband88XOCww9js6pSJlBJve98zX/EA3b
         KPCvPQ+r0f8Y6Rnh/133PhTy2mucdgS/imzMJzkDSeHDjTNV09oiqw5myR8ltNxeQm0b
         vVX4thjWV8Lm/VXEffWbedQqqDEoov3Jx+gmGkhwd31FCmGwsgXuV9jxN4shbkW263xy
         C17w==
X-Gm-Message-State: AGi0PuZkGOss7a0BXfZpwnz9KqVqwVDau1tZpyOGMydfk/gUYtsIZ6Ky
        LUBP9yT6FlW8acmzSEYwRMg=
X-Google-Smtp-Source: APiQypIdWF58ZixPlbFx3vC8hS2e/98FkERnQkNxs7PIcrmTySLB6s3ePNW1kPAA93QLqelKNcAESw==
X-Received: by 2002:a17:902:7c05:: with SMTP id x5mr7216740pll.278.1589184484383;
        Mon, 11 May 2020 01:08:04 -0700 (PDT)
Received: from localhost.localdomain ([124.123.80.46])
        by smtp.gmail.com with ESMTPSA id 73sm4143046pge.15.2020.05.11.01.08.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 01:08:03 -0700 (PDT)
Subject: Re: [PATCH] ext4: Don't set dioread_nolock by default for blocksize <
 pagesize
To:     stable@vger.kernel.org
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.cz>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
References: <87pndagw7s.fsf@linux.ibm.com>
 <20200327200744.12473-1-riteshh@linux.ibm.com>
 <20200329021728.GI53396@mit.edu>
From:   Ritesh Harjani <ritesh.list@gmail.com>
Message-ID: <e61fe76d-687f-3e34-6091-c501071b8a9a@gmail.com>
Date:   Mon, 11 May 2020 13:37:59 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200329021728.GI53396@mit.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello stable-list,

I think this subjected patch [1] missed the below fixes tag.
I guess the subjected patch is only picked for 5.7. And
AFAIU, this patch will be needed for 5.6 as well.

Could you please do the needful.

Fixes: 244adf6426ee31a (ext4: make dioread_nolock the default)

[1]: 
https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/commit/?h=dev&id=626b035b816b61a7a7b4d2205a6807e2f11a18c1


-ritesh

On 3/29/20 7:47 AM, Theodore Y. Ts'o wrote:
> On Sat, Mar 28, 2020 at 01:37:44AM +0530, Ritesh Harjani wrote:
>> Currently on calling echo 3 > drop_caches on host machine, we see
>> FS corruption in the guest. This happens on Power machine where
>> blocksize < pagesize.
>>
>> So as a temporary workaound don't enable dioread_nolock by default
>> for blocksize < pagesize until we identify the root cause.
>>
>> Also emit a warning msg in case if this mount option is manually
>> enabled for blocksize < pagesize.
>>
>> Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
>> Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
> 
> Thanks, applied.
> 
> 					- Ted
> 
