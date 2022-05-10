Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D80E8521FF8
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 17:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346657AbiEJPw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 11:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347195AbiEJPwE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 11:52:04 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4373128B68B
        for <stable@vger.kernel.org>; Tue, 10 May 2022 08:47:16 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id e194so18924652iof.11
        for <stable@vger.kernel.org>; Tue, 10 May 2022 08:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nVSRi5wIDVHYpu1ojocgQkPMvGst2Aq+pvqCJIj4u9U=;
        b=nFOSEcSgCpgBBmL0TyKyaBVjPh73Ju0Q2KaPb7KCGh6PN1pcC8PB/DGUjucpqWozeR
         +NbJvR0+4rtIpirPaTw/xPISfWRVjDmxo4LY4zFzO4BN6rYwhbuzjCUVA8b5nZtlqpMs
         UWBGIYR978FvUWmx8cGw2nKJvy+DwAby2lp3ZPd2JDpoPnHAbIOmC/DgIpWD7Ht1uVwb
         FvaqA9sSjqBZFCwMcXeNr/sKgc7NE8sUkII2gFBGHpoqh1ytOfl4mpLYDrfi2r1uhVsK
         ZwCYb2dHYoH3p/Kib8Lj3MfG9k0DUFedUrYo1oTIf2LhQNvQc0CSaW5GQK1IFfL0xOgc
         mVUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nVSRi5wIDVHYpu1ojocgQkPMvGst2Aq+pvqCJIj4u9U=;
        b=j7uwN8Tr3DIne1PEz4xm+NZGkiWqZMulKjTM/5OwgCg8GNbMTHUWME0u1j/BsQ/tQ3
         a7k+uijjqbis9mGsMh7pRJeCbGsLsWl/YQwS9g66Ov6qs6DMJG66vbsDc/8sNX3QGMua
         ZvCtZ5dAmJz30+7HI4re0ChvRIC4lDrDKJOTVKC1Zsu55vyCp2lB9bHNHoZjPcN3l4tJ
         pJiwt2YnfbJhjgqsP4BihgbQxIlDPFZ5DEov8CsgW1gi3walugqCO5gX41e2MiYOaU2Q
         oYXvfGOShB+Ez2eBiOwBekmrK47Vngcv1Q8RoL5nXHSng3NHkqv0QyPqPn7cPfutXjVz
         /zqA==
X-Gm-Message-State: AOAM532svpzL33exFtZu/y2Zx6ew3+weIjzXsFzG+oKkeEWv7dIqZibT
        wo/fWRQGp1Q0YNHsO5hwAGM1Jg==
X-Google-Smtp-Source: ABdhPJzJk2EhDRZC5gyjdHD0MJkfj4xYHJ2O8ogCT7cH9cIpmdxqbnx0pshNm6IQHgMhKlN5tXXIFA==
X-Received: by 2002:a05:6602:314c:b0:649:a265:72ee with SMTP id m12-20020a056602314c00b00649a26572eemr8750978ioy.100.1652197635312;
        Tue, 10 May 2022 08:47:15 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id m9-20020a056638224900b0032b3a78173csm4452139jas.0.2022.05.10.08.47.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 08:47:14 -0700 (PDT)
Message-ID: <6e611c42-fea2-defe-80d1-e1b427d6ccc0@kernel.dk>
Date:   Tue, 10 May 2022 09:47:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH AUTOSEL 5.15 09/19] io_uring: assign non-fixed early for
 async work
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     io-uring@vger.kernel.org
References: <20220510154429.153677-1-sashal@kernel.org>
 <20220510154429.153677-9-sashal@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220510154429.153677-9-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/10/22 9:44 AM, Sasha Levin wrote:
> From: Jens Axboe <axboe@kernel.dk>
> 
> [ Upstream commit a196c78b5443fc61af2c0490213b9d125482cbd1 ]
> 
> We defer file assignment to ensure that fixed files work with links
> between a direct accept/open and the links that follow it. But this has
> the side effect that normal file assignment is then not complete by the
> time that request submission has been done.
> 
> For deferred execution, if the file is a regular file, assign it when
> we do the async prep anyway.

This one should only go into 5.17-stable, not anything earlier.

-- 
Jens Axboe

