Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFC06ACF0F
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 21:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjCFUUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 15:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjCFUUo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 15:20:44 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2079139BAA
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 12:20:41 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id a2so11793797plm.4
        for <stable@vger.kernel.org>; Mon, 06 Mar 2023 12:20:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678134040;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=epEDJHU54ATeMhb0uXnd0U2vO7djNerXC6SP2AYsBIo=;
        b=CcIO+ZjKkseOvHE021pLaDeJLTy0ZgrQN6NXyKIBt3zsbGpefx47mB4qnFDcesyGPf
         hqUjhg1u3Rs/cTkT7pQRrI9uvW8g0mlUV6L+XfjsbXUcQkZ9ei3ozHzHiZ2kZMfUCosN
         8KHT078yOG7nejG9/OoZK7/4/TFIUcRM1dTj6FTmo7ahSg1223AemmKOFurZVT/liwCj
         7kPisW5yGSLA6DVLrdXUv4ThodgK0HYZraMVcBOAPkLZB+7qKS8P+eYsJWYcBNPnH197
         KhzvswjG8NenA54XuyYVmi1F0NVhD4X0nyCAHLp7OmLMBn/aqbUD1Vhj9z2wt4QgJMaE
         i16g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678134040;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=epEDJHU54ATeMhb0uXnd0U2vO7djNerXC6SP2AYsBIo=;
        b=QgBz5D49BrNZ3DC2ABDeYoYDDsy5YZTHOG20A+mvt8EhA30gyVjypIFV7qBvgP5InB
         wlc3UiwT/4RAYpbm27gRggtfgEAkezX7dcGmtPoqvMvbUaoMAK3oA7szCq49YZSAGKUN
         NLArCZSGi0tyn/hMzfwm+lSrugPda8qgWkDCwDreHGMzIBNfpIZ/83p+w6FuXpLCgkDv
         zbG7QahxsPZkpr0EHy30AvhA1CFp4MwbaqBt1E5R/mEByv36gTESSKW1oYSBXiaZz0FD
         QmKZdnrgIOzgOFAQZ0w9aegIpvPqm+I6TqczcAclbPqbcEF8lU6rf3wafI9E4PwTZK/Z
         AQRw==
X-Gm-Message-State: AO0yUKXOYcE+vv9W21bR0YtMPfQU7dmFIFs3Ww9R91p8TgODE8ad7P/T
        Wpy6YbThFGU6hVrHasHF2gW1/jBQuv+TOhdg+fI=
X-Google-Smtp-Source: AK7set+iIeDc2dpWOnfyiI7YWh0++ezorZ7Q95uhAOvlnlU9N4VHqtDbizckWvMUyf5Xb4KmhIpIzw==
X-Received: by 2002:a17:902:ce92:b0:19e:21d2:ed2f with SMTP id f18-20020a170902ce9200b0019e21d2ed2fmr14845598plg.2.1678134040514;
        Mon, 06 Mar 2023 12:20:40 -0800 (PST)
Received: from [172.20.4.229] ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id kx7-20020a170902f94700b001990028c0c9sm7150367plb.68.2023.03.06.12.20.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 12:20:40 -0800 (PST)
Message-ID: <7576d4fb-ea4f-d886-b5a6-63ebe4fcd653@kernel.dk>
Date:   Mon, 6 Mar 2023 13:20:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: FAILED: patch "[PATCH] io_uring: add reschedule point to
 handle_tw_list()" failed to apply to 5.15-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
References: <1678099737150217@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1678099737150217@kroah.com>
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

On 3/6/23 3:48 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

This one can get dropped from the stable queue for 5.10/5.15.

-- 
Jens Axboe


