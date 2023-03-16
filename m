Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C03B96BD870
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 19:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjCPS6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 14:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjCPS6v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 14:58:51 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AA8EFBC
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 11:58:49 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id v10so1239322iol.9
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 11:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678993128; x=1681585128;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=beuZlOYlsGzrMlG2T+NH12KmnMkS0LRayDtZbfmxOCM=;
        b=YHNcLeTN/TdKtnITj02u1Dj0NXIHsb7iM4JVFgpxlSmdKIrLsTn/lf1H4q17titWS5
         0jLJhX+RJKAh+ybCHy7TR71/RwA6C5OUzPsWBkAUUQLD+akdJZy7IvRhHbd9l35Rps8Y
         A2o0FtExI/rvjWzIliySutETJRfmXcntUfVWf4oQNMhpAMXjNYsiZcA0dWRdcKjaVsCN
         5fhHiQTaz7g6HreC/6DboYmGcJHzjvBTKSmxbBzFe452qH4Rzan6fG7cdAsXXgem5ImN
         FbcjdQd6cFGVwhhsgSjDqjo9PhjsiaU+OvnB8qV6QKWHQIR7Jz57Tp8F4zrcsp7XpwcM
         DGYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678993128; x=1681585128;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=beuZlOYlsGzrMlG2T+NH12KmnMkS0LRayDtZbfmxOCM=;
        b=moWVSgOyHpxJ94Aot0mF4DrjODKebHAlh5eEItqaDxLIgVp+zgUfR0vyH44dtEd97G
         lY9e/qnoOZeIo2+99zJcQrdvxh0E1x8kruGN7XWk6+AFVeHUVR9n7NRvDvvGhT/dBb+h
         s354lGYzHRmiI9+c+oP8g0mFdsb6OmEY4HtusJS6OszIw+dZfT8FC1b1y8R0sEczgo8D
         wzChmMiClW5RgkxlC0iAORO6RUpkP/ETn2I8gsUaR6QLxkgaHio3xFh9ikgqhxfEfx3L
         tKT4NzG4R7HHXUcL40hhv15UnnmCLE2IoGHDt+tYYrOxW1dNmL5QkRPHLgzVvE7VSaDn
         laxQ==
X-Gm-Message-State: AO0yUKXTpQ97YHCVLbFr+bfvK3YtdZx6Enpl4mcYUyXKmnKHRTWhlJ1E
        rFD2Td2AxBaj47xvabirliG1jcwGqtNXUsX4YrAW7Q==
X-Google-Smtp-Source: AK7set/HbVF/sI5C5fpqS0RJ/ZYcJLU41RZTQBCp5bQc0lst6zGd3Kd6qtUMUKfyxVuu57wrWVOsdg==
X-Received: by 2002:a6b:c38f:0:b0:752:f9b6:386b with SMTP id t137-20020a6bc38f000000b00752f9b6386bmr2123784iof.0.1678993128361;
        Thu, 16 Mar 2023 11:58:48 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ck16-20020a0566383f1000b003cfd7393382sm12225jab.93.2023.03.16.11.58.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 11:58:47 -0700 (PDT)
Message-ID: <23aa947b-43b6-d1d3-f8b4-4518cf4dcabb@kernel.dk>
Date:   Thu, 16 Mar 2023 12:58:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.10/5.15] io_uring: avoid null-ptr-deref in
 io_arm_poll_handler
Content-Language: en-US
To:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
References: <20230316185616.271024-1-pchelkin@ispras.ru>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230316185616.271024-1-pchelkin@ispras.ru>
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

On 3/16/23 12:56 PM, Fedor Pchelkin wrote:
> No upstream commit exists for this commit.
> 
> The issue was introduced with backporting upstream commit c16bda37594f
> ("io_uring/poll: allow some retries for poll triggering spuriously").
> 
> Memory allocation can possibly fail causing invalid pointer be
> dereferenced just before comparing it to NULL value.
> 
> Move the pointer check in proper place (upstream has the similar location
> of the check). In case the request has REQ_F_POLLED flag up, apoll can't
> be NULL so no need to check there.
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Ah thanks, yes that's a mistake. Looks good to me!

-- 
Jens Axboe


