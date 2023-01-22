Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337D8677100
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 18:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjAVROd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 12:14:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjAVROc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 12:14:32 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5684C26
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 09:14:31 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id jm10so9328695plb.13
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 09:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xm9uV0gUHl1kkLS+ud6UIV6PQCifQLs0A7WwwaMHoRg=;
        b=XDyqmBiX63vDFFMHNBd8bwRWLViJ7LBejtcPd90aw+3OZIV6jJpELQBw5QDqRsgy7P
         p101A7vSR+jk6zpO9WPEO3KU5GL6BuLeo+ljqHCIPc6dLbvN08LNUzvygsM+y2TFrkIY
         sstUhxThTdjJF5rjS4fJF03eOUo9ZKTpPh/9Gf2TaqJ869tDc7WPlTdIjN0QtLvsMGEf
         PKJqzMN4vpSS0joy+6FgH/AaDs17b6jq09Vnv9Mq5AiHazkR8weEcRfDabUcgJBFCOjS
         TdX28Vi/bRLV1qOnPfE2o+tXLa9Rf2GrnHsvwUo9Pf6sdpTH3WF8fMTtG+DbAhqf1sgc
         lzAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xm9uV0gUHl1kkLS+ud6UIV6PQCifQLs0A7WwwaMHoRg=;
        b=Eh90NX6pUQa4fkPJtBlbvdHJ5M9II1mzzA0efk0EDgp2RIiAzJNIL4HyNEtfqpsqqm
         evZ2uGnN1B62rnZmCDtBlgh+DAPtjtrC3WI2kHzCJecVJGS9mkrM6vHT05MEHI4drLpQ
         EqmjmubYwf0CoWcTDm4ljpdD6PBOWw6Zw0Wf6mRgke9/r1fC9ibC8YA8pTkSDtp+YF0B
         f+w6Dx74tTMWEkiBCSaTwcn2GYDUNZk8S9/cwzmLa7ntRrMQdxvicS2A3gxXo6SKGsfO
         +0RfBkp3TFyCFp8kT9S8c6OC4QVIJ2e6GEGPzeXr1iwIh/Q0sZ+CzG/1yjBJnc2ybYL3
         h4sw==
X-Gm-Message-State: AFqh2kpEzSMBzxLJTmg9tC74iMnAMP79/I1NxSyOLeLj/4OiLrDRPdW+
        ZvB8RhPCqf4oAcZMEFWuC97MJt+BKW31Ww/j
X-Google-Smtp-Source: AMrXdXsoItVEuM3lmDXBksU5DCtlxQ3BVD3flYKQLo0Y4wtvBrlPzj1mi1DpNXRmXXq92nwKyqoITQ==
X-Received: by 2002:a17:90a:a513:b0:227:18b6:501c with SMTP id a19-20020a17090aa51300b0022718b6501cmr5143745pjq.1.1674407671090;
        Sun, 22 Jan 2023 09:14:31 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ft12-20020a17090b0f8c00b0020b2082e0acsm5160063pjb.0.2023.01.22.09.14.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Jan 2023 09:14:30 -0800 (PST)
Message-ID: <690a39e5-bd87-bfaf-53a1-64d8e4c63c49@kernel.dk>
Date:   Sun, 22 Jan 2023 10:14:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: FAILED: patch "[PATCH] io_uring: clear TIF_NOTIFY_SIGNAL if set
 and task_work not" failed to apply to 5.10-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
References: <167439893545192@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <167439893545192@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/22/23 7:48 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

This isn't needed, as the 5.10 base is still using tracehooks for this.

-- 
Jens Axboe


