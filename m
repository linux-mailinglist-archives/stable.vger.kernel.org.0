Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC2863607B
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 14:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237270AbiKWNwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 08:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238473AbiKWNwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 08:52:09 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B22BE3B
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 05:44:06 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id a22-20020a17090a6d9600b0021896eb5554so2063287pjk.1
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 05:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lbeQKfnL1JVfpAPQSNTjPMiQNcrNzohQvamTKcbh7Tw=;
        b=V/XM2iU5sNodsDsjcWS8GKBX137HaeUdN4/FLT6cKIsxy+fM6YWCIZdWMeubqWZqqG
         VtgAHJTgsmi+7SbmsEtEyAeEeicQeGDv/2RtcMYndF+hSOPSIvz7t5cfD/zSNMSKaBxD
         JZ17HiHRvbYgGBfztFds8ULjxmP+fAxR3cB1yoy0tGgt13jfnWwpN9N0xLnWSCOiZyCl
         qHZNvyRKS7N3wB5NkB5beQEzCYQLvo0L5qMvKhuHEj43bcpvME1ePgq3ffk/Zwsrm0oW
         NcaJxr6ljCcjdvxei9/BmaZw3JCFP1xJEXiQuSD/RDnZaDKxR5Im0TELpDIVXk5twPbI
         OtLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lbeQKfnL1JVfpAPQSNTjPMiQNcrNzohQvamTKcbh7Tw=;
        b=UzL84Bd+WCNDjAulKLGFMAsZYAuFM2yW0+puZfQqd8zKDXJswLvQng6WXOpLNLGbgu
         BpRSZUnfeoL56W+F153rsJvuN+X6Kv4cjqRwCX8PAy73nCyNNUdmfZGnFV3tnK5wF1wj
         mf2/0gDApmGCwyuWsDQwor6iHksymY8CXb0E19lo1BS0GVYtxYZEWQNL1S/tQ7x1SVmQ
         GwVEETJcvBcX2Efpbd6a8PGE+PylNGx6uuMpSZ3/QcXozkiPucSNnBFUpMgb+WO/QsrV
         Ch9hvcSZsIL7dLHL3kb0TBjV4aUQZBvn61J5J5tktEA0S6M/7+Ci044Q2m69Kgyq14hI
         yc9A==
X-Gm-Message-State: ANoB5pmWpi86thtuemB6eVs6s1SR84w7IkeVWC5vmamLNR65AxP9aH+7
        LHmbtxJ5i4j0v49ARE/2reqO+Q==
X-Google-Smtp-Source: AA0mqf6049m2SP2gSyJsyhrIKBHIkOlqY6v7feMQBw0RrDiC6nGnPLgDnPwzGqIwTYXI8IW0B3QX8Q==
X-Received: by 2002:a17:902:7c0e:b0:186:7395:e36a with SMTP id x14-20020a1709027c0e00b001867395e36amr21580729pll.83.1669211045783;
        Wed, 23 Nov 2022 05:44:05 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b8-20020aa78ec8000000b0056b8b17f914sm12609513pfr.216.2022.11.23.05.44.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Nov 2022 05:44:04 -0800 (PST)
Message-ID: <27f3a493-4684-7eee-b3af-fa1c70b492e0@kernel.dk>
Date:   Wed, 23 Nov 2022 06:44:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH AUTOSEL 5.15 23/31] block: make blk_set_default_limits()
 private
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
        linux-block@vger.kernel.org
References: <20221123124234.265396-1-sashal@kernel.org>
 <20221123124234.265396-23-sashal@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221123124234.265396-23-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/23/22 5:42 AM, Sasha Levin wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> [ Upstream commit b3228254bb6e91e57f920227f72a1a7d81925d81 ]
> 
> There are no external users of this function.

Please drop the 5.15 and earlier backports of this series, it's
not needed.

-- 
Jens Axboe


