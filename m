Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780EB61265B
	for <lists+stable@lfdr.de>; Sun, 30 Oct 2022 01:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiJ2XKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Oct 2022 19:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ2XKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Oct 2022 19:10:51 -0400
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4110286F4;
        Sat, 29 Oct 2022 16:10:50 -0700 (PDT)
Received: by mail-pg1-f181.google.com with SMTP id g129so7774541pgc.7;
        Sat, 29 Oct 2022 16:10:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RKuufKUacq98coDfbHylwf70NDNDwuBrz/1iKBZ4tBg=;
        b=jyP03bu0TOomk862KxbPtI6eGbaGJ3lIOrXdX+bAo98vJR99S7Otl3YHwyfZ+OSfAf
         sNRc2ntxjg9IoEFIuHoXGCI5dbcafS2LhrzWyuWq78jPXm58pdeLQ2AYr5D+aUK+XM3K
         +y9yYbiPfljDsNY0kBOGOCQdwa3zJx80zbXci2HKNCzAUkzRioqIyciFiE0vJe21DPQT
         E3LfnrN88JM+Y1HLj7T45AvSC28uiJ/5zdtCErdo9NwX89DdUqiUusOQNUv2/iN/bpK5
         tiamL3Y/Z770WQVFeZ+D+5TlGhXUt/G69fymAD6Lfofrv8OgbwCGMGAFPM/P3gRhvClA
         Ec0Q==
X-Gm-Message-State: ACrzQf3YNM+hq2+wh/WLKI1yKJAawkpSvCztEOvT2xKkxZKR7F/0lL/x
        4+KcEKpWfic0MdXkSfJIigk=
X-Google-Smtp-Source: AMsMyM4BQlI8gWRRmy8uCysPtCtYvOyKN/QDcSsbqVJRiZrhNYIRDCdx7rdt+cLeWGvS52yER9LZXg==
X-Received: by 2002:a63:e218:0:b0:448:5163:478f with SMTP id q24-20020a63e218000000b004485163478fmr5846451pgh.415.1667085050358;
        Sat, 29 Oct 2022 16:10:50 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id n4-20020a170903110400b0017534ffd491sm1781654plh.163.2022.10.29.16.10.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Oct 2022 16:10:49 -0700 (PDT)
Message-ID: <fb98be99-58e9-9f09-7179-cef70b45a8dc@acm.org>
Date:   Sat, 29 Oct 2022 16:10:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 5.10/5.15] scsi: sd: Revert "scsi: sd: Remove a local
 variable"
Content-Language: en-US
To:     Yu Kuai <yukuai1@huaweicloud.com>, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, hare@suse.com
Cc:     linux-scsi@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com
References: <20221029025837.1258377-1-yukuai1@huaweicloud.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221029025837.1258377-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/28/22 19:58, Yu Kuai wrote:
> This reverts commit 84f7a9de0602704bbec774a6c7f7c8c4994bee9c.
> 
> Because it introduces a problem that rq->__data_len is set to the wrong
> value.
> 
> before this patch:
> 1) nr_bytes = rq->__data_len
> 2) rq->__data_len = sdp->sector_size
> 3) scsi_init_io()
> 4) rq->__data_len = nr_bytes
> 
> after this patch:
> 1) rq->__data_len = sdp->sector_size
> 2) scsi_init_io()
> 3) rq->__data_len = rq->__data_len -> __data_len is wrong
> 
> It will cause that io can only complete one segment each time, and the io
> will requeue in scsi_io_completion_action(), which will cause severe
> performance degradation.

It's probably worth mentioning that the code affected by this patch has 
been removed from the master branch and hence that this patch is only 
needed for stable kernels. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
