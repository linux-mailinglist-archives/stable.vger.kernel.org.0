Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7476552D2A1
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 14:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbiESMhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 08:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234115AbiESMhY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 08:37:24 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B53D366A4
        for <stable@vger.kernel.org>; Thu, 19 May 2022 05:37:23 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id ds11so5225585pjb.0
        for <stable@vger.kernel.org>; Thu, 19 May 2022 05:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/y6BVIWJFnRlCLbZyh+AFPzEBsmDxR4nuEPPRMcWq0E=;
        b=VFzCNrQRFSSwJWNARC3i6ZOH6adrc8XDY1OMceC2FIcGIA3DBDMxc1RL6AUaxREcfQ
         NN12xlMtOtu69JGtdMCmDru/QWw2iDuXj9YZYO3WrBgItrc12A+Q364XSwTuf8mtSMYS
         IVlZzPM4jOc6we4in25k2Vbz618yw4/BEDLeAdpfC68Am+9xgNlNA+IuXxlTl1wOW0wd
         roD1i6TxQimY9nlC7VXz+9bsr/2EMVhr1efhyNMOTvwCn3UhYz2QFqNUcHNUeE5v0eww
         PrkMmKwnXpJtjk6i0yPVMeN2DIXoJm5MTId9cy66XhXOZIZn3QYtY0iuxGJ96S7qPw03
         5HVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/y6BVIWJFnRlCLbZyh+AFPzEBsmDxR4nuEPPRMcWq0E=;
        b=FWvG+G2jkp91bQY2oKmMdUfu/5rjDnXixVreW2Oz3HDexRlv7LhFqz8dk9urfTtLZw
         90jkcvYu6YGoE+wHZkAc+YmUDEg+oMf+ciI36waTuWIh9RJ1kiK4OuxIDgDmpyVKeyEv
         TQ++2AMnPSFeATL20ys8LTvk1YrqU+pTnisp0+Xoa3io/OGszNmUFHWIB2fwDLqXBwTh
         gC+Al7Q4k4aBWuO81k7zA+iF3x6E5LneH+MKxf+TOMYVLJEJNfaH4sc2C+UTOUcc9SZY
         8HVeIh8kwAtZOetksQUtsVYlHqxRKoYBYmEhEaWIgNSC94/7nguex8k/n1OU0KW4mAKC
         I0HA==
X-Gm-Message-State: AOAM530TbJAw+nREo7C+tgSr5mqnvRjVEDoaLIq4LFB1lzDnFTYtFtZk
        27lxMCBs3LXkT2rUHQdWTeQtoA==
X-Google-Smtp-Source: ABdhPJyICpszGDJrostM9GG9EEm7DRvpAAR39N8hKUpjaJpi3yJjBYEwmrOf/quqpRhzsw/dQxS9qw==
X-Received: by 2002:a17:902:a614:b0:161:7a0d:c73e with SMTP id u20-20020a170902a61400b001617a0dc73emr4360630plq.110.1652963842902;
        Thu, 19 May 2022 05:37:22 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k11-20020aa788cb000000b0050dc76281c7sm4066320pff.161.2022.05.19.05.37.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 May 2022 05:37:22 -0700 (PDT)
Message-ID: <d9750f3b-f220-c1ca-d40a-2a3dc664d05c@kernel.dk>
Date:   Thu, 19 May 2022 06:37:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: Patch for 5.10-stable
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
References: <543c3909-a7b6-23ac-2c2e-ce10dd2433e8@kernel.dk>
 <YoY5tZ//ENRFzEiU@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YoY5tZ//ENRFzEiU@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/19/22 6:36 AM, Greg Kroah-Hartman wrote:
> On Thu, May 19, 2022 at 06:09:39AM -0600, Jens Axboe wrote:
>> Hi,
>>
>> Can we get this queued up for 5.10-stable? Thanks!
> 
> Now queued up, thanks.

Thanks Greg!

-- 
Jens Axboe

