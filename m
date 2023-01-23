Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10857677ED3
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 16:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbjAWPMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 10:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjAWPMB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 10:12:01 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21367976F
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 07:12:00 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id f12-20020a7bc8cc000000b003daf6b2f9b9so10829079wml.3
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 07:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NRhNDNoSonwGDoBRr5ThavzB/iQ7bT0q+/z6Q+f3Jsc=;
        b=VPf1QE9jPKLo2Q+rVbl22eRmHDLLCl5fJVG+JHvKZbHe+l5cdkQ40NIUkiCWxncwa1
         NFCEEqAEPXMg2bMkuww7+lx8fuMd5fWmv2hKC/Y28VrCvCosjD5cJ7sHq1fzkwFyzhOK
         /UbR5Zf4M1Fgs6YYXCA6hPh4Sh695d3bOBo5n3luzxmqw+uy/uKYjl8Lo/RE5oDsLE7P
         Av9cgIrOME9J7uObxPMJUtpiVjro2jd8N7T7v77i9aN1XyX6Bvc+J0FccvgQNQuFOTM9
         fUflvpccUt9vbiZMUwQH7y1rWc5EZRsqQlmhYyzcxQyaJrZYAGuQcSEQtEW6gSRM3te7
         0gbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NRhNDNoSonwGDoBRr5ThavzB/iQ7bT0q+/z6Q+f3Jsc=;
        b=UeygFI3oe02OHHuJKIVUfXl3ZUjuB3zCiA5w5ShMjsU8c4SWkOpDz+vGLRoBRlUbSr
         KOYG/NeW8d0KnEL8Z8xNsxdOiYDMDhZVDTbXFKQqbjg+B+Q12S17da3cD8TxhpHotrZe
         WY/6VsXvaAl5IfsPEi7SiZdfDS2FjefcKPnmf2WaSsxmEjwhadaVPMJxo5jmDiLvLRtC
         19P2W3iXARU/sVv8Mic5AVtCYi9oBzUbLQ8NFliRZEaG5BbBH9qmeShIIv5y+RIn3F1L
         lZCuDXi4wx1858mCdkEpG4AGx47GaqVAeBmkUFerZJe/Z+nQywN7LVoyfTCusaQXlKsv
         42JA==
X-Gm-Message-State: AFqh2kosmrZM3WB9CX3kXOk8qZa34OJRvBSSa+3CkzG24BZfayfPYNRb
        8BI5hHT6Dz+qzFdLP0UlHkQobepyGjo=
X-Google-Smtp-Source: AMrXdXvmJcMynfEAQ6GFLSU3IAMgGr7bn/MUo1sOGtPtBgssVEdd61VviL78NFlbuHYRBbZnBBFdxQ==
X-Received: by 2002:a1c:7417:0:b0:3da:fcd:7dfe with SMTP id p23-20020a1c7417000000b003da0fcd7dfemr32226193wmc.10.1674486718686;
        Mon, 23 Jan 2023 07:11:58 -0800 (PST)
Received: from [192.168.8.100] (188.30.84.186.threembb.co.uk. [188.30.84.186])
        by smtp.gmail.com with ESMTPSA id j25-20020a05600c1c1900b003c71358a42dsm15165547wms.18.2023.01.23.07.11.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 07:11:58 -0800 (PST)
Message-ID: <8228d88c-4490-9286-95ae-c143e3e27fba@gmail.com>
Date:   Mon, 23 Jan 2023 15:07:13 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: FAILED: patch "[PATCH] io_uring/msg_ring: fix flagging remote
 execution" failed to apply to 6.1-stable tree
To:     gregkh@linuxfoundation.org, axboe@kernel.dk
Cc:     stable@vger.kernel.org
References: <16743931882234@kroah.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <16743931882234@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/22/23 13:13, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 6.1-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Apparently, it's not needed in stable

[...]
> ------------------ original commit in Linus's tree ------------------
> 
>  From 56d8e3180c065c9b78ed77afcd0cf99677a4e22f Mon Sep 17 00:00:00 2001
> From: Pavel Begunkov <asml.silence@gmail.com>
> Date: Fri, 20 Jan 2023 16:38:05 +0000
> Subject: [PATCH] io_uring/msg_ring: fix flagging remote execution
> 
> There is a couple of problems with queueing a tw in io_msg_ring_data()
> for remote execution. First, once we queue it the target ring can
> go away and so setting IORING_SQ_TASKRUN there is not safe. Secondly,
> the userspace might not expect IORING_SQ_TASKRUN.
> 
> Extract a helper and uniformly use TWA_SIGNAL without TWA_SIGNAL_NO_IPI
> tricks for now, just as it was done in the original patch.
> 
> Cc: stable@vger.kernel.org
> Fixes: 6d043ee1164ca ("io_uring: do msg_ring in target task via tw")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 

-- 
Pavel Begunkov
