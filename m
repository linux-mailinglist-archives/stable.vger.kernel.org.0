Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C365699987
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 17:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjBPQMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 11:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjBPQML (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 11:12:11 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795C54D622
        for <stable@vger.kernel.org>; Thu, 16 Feb 2023 08:12:10 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id t7so926607ilq.2
        for <stable@vger.kernel.org>; Thu, 16 Feb 2023 08:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1676563930;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LhUvfX7glNpvwW+Gq+n9YyxZjZuFRnl1TRab5y1A6q0=;
        b=MobkfvtZCT2QgFZn1pSA306z+wFkYTtKB/fmy7W52ysQRpqpc7wtqSHydbE0fF9rXZ
         0Bzx9JA5EtMT4faVU/a0hsPFjKVZ93N2S2XKf4sjngSJWN5qJQMqpkC5LdbM+ejCKxva
         /OgMktweFCc2MeIpeLlgJyy4OuAdPWs5PyeHRF+FAhIH/xYVr8/6AUGnyOv+GhlO3o+D
         HZ9rFlwQiqyDGvclgFzitksXZtnpsttHgiMxyYNV7TtQI1+dxuWPwc8O9+OlioQtITaK
         1NHLuZ4pv6pABl0Lf88KtjFqdvfQVHuX0JluZJL7jMGcWY9MR5lByG2Xxn3qk+V9tCS8
         MLQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676563930;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LhUvfX7glNpvwW+Gq+n9YyxZjZuFRnl1TRab5y1A6q0=;
        b=MMd2TzlMN266/UPTCmOqBWRwgFWcgKglNvycRlQX49Qqh34L6ZfUSQ7yx+2TVIcjJ7
         FCW1LvvjlH3kat0klwyu1APbr/mqX0iDXLzQowuyUSBsxyRmkcg4eYP98X8g03dKK01t
         rWrKeoNz/yy6yOkJ7H3aiL32TbPswJMpNfITOg4e3JV4CeGGJCVMmAQNpMT1CLU2cFyo
         TU+ud7gBhCAKUOmNdPKfRqvKZFlU2/5S62p1I5ZQelp4LvS8RoK3Cxs8CJ+S3/iRrqPN
         rEJgyDL/nSy9hM3Ckbiv5gzquLsAkISR7/ebzCqSiQVNM3GsdrR71S16O1qJmZETk3gT
         OfGQ==
X-Gm-Message-State: AO0yUKW1Pv6Pa7eLCpVJkxurm0EK3Kw7+jqk7fKzA7QewB7qCBUW1oCN
        iBIr+oClsdEnezekxaAaXgy8oA==
X-Google-Smtp-Source: AK7set8jKBn8uw9Gbj3EMqpPGpgqez+WDk7CYhGa9AEMpgWcWzob86nzcF8Lf9q4jnkznT6dDLoxoA==
X-Received: by 2002:a92:c80b:0:b0:314:11c9:955b with SMTP id v11-20020a92c80b000000b0031411c9955bmr3763885iln.1.1676563929734;
        Thu, 16 Feb 2023 08:12:09 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l18-20020a056638221200b003c46345b48bsm665416jas.89.2023.02.16.08.12.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 08:12:09 -0800 (PST)
Message-ID: <108b6dbe-15a4-9e4a-c89f-0efb5859736f@kernel.dk>
Date:   Thu, 16 Feb 2023 09:12:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 3/4] brd: only preload radix tree if we're using a
 blocking gfp mask
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, stable@vger.kernel.org
References: <20230216151918.319585-1-axboe@kernel.dk>
 <20230216151918.319585-4-axboe@kernel.dk> <Y+5Uqc2FxZT8W8mF@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y+5Uqc2FxZT8W8mF@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/16/23 9:07 AM, Christoph Hellwig wrote:
> This should probably go into the previous patch, as that's the
> one creating the warning.

Agree, but it also can't happen before patch 4. But I can fold
the two, only did the split because it's nice to have the error
handling separate.

-- 
Jens Axboe


