Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6BB0677104
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 18:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjAVRO7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 12:14:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbjAVRO6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 12:14:58 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBECC19680
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 09:14:56 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id lp10so6303593pjb.4
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 09:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zK6KvEN+1gT/KGFB3z1cZhF8Epu1VNsht108LnGbIdg=;
        b=GCCYC6KxOzkTy+2KNXfUq/dHW3we8Tn9qdo+pCCiiQA1oG1A36mAhnwyuHkRmlVxln
         tP5/z0ObwOIPkM9DSL/4cfj24Nx05jIBhBnO+UDUbd1UMpwca+ziuBKuDkjzjfeaN0eP
         nsRISjFQjW7RguzjMI6jMJ8q7ivtsEqX9x+fNLawlH64oHLDkQyZ9iG9jiizdLmilrpD
         QnGqCp23VyAbYyp0+teuGRoWxt3kFmkFmyYQDPpivsfhhhIMOcE9xa0cvucN0dPofZDh
         KT4TvvnSy8YP3FSYIwBNmsQYLSLjpIqE5BqUXNP9vZc71EPeQ2MnzNfAAe4UzG2yJOEE
         arYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zK6KvEN+1gT/KGFB3z1cZhF8Epu1VNsht108LnGbIdg=;
        b=oazwx3FO5X0EVCc0MMFGJgCUxyCb0g6Z70ErcU4ChXaKA29YBF9hVUpU0tFZUFBLa5
         td8/o0ZhQkuOAIjMq3In/uRhut2pYeOSO6k7FV33jO6T4X4+4Copg96NXeMEnsLhiBam
         QI1ec/mpTOAEvrJwj4sQf0jToad9CPwPo2DI0sQBhq8Ke1uJChUkolXImXKKSpEBhQxr
         FZoUbgWtLHwxc6DPkJ3NfN+0cM4Q3Lc7LzB5fSL9gPJn53ZSW2GoOQ0UgWxGzJyHLlDD
         Y2aAkU0iznllDP2OBkzyvel6Zvd0KmVq1xQq9Ls2mzH37AHYRzXCYPITLZxLthowqxFV
         /4vg==
X-Gm-Message-State: AFqh2kpn5VhTFHmKy+MlCv2hcOJiPts+AwPXLhDEFYiBjEcaneZ4N1CP
        Z4rYXkAPVYVkYGGjlk3cGHO1nR7qajXzhGJ1
X-Google-Smtp-Source: AMrXdXsI9vI0vftLOQoDRIn1rE1WBuHQDWHUEQfzfUuJFzoq4wKUXlIAd1n9rHtjsOZd4ae1ipg37A==
X-Received: by 2002:a05:6a20:5492:b0:b7:9612:cd31 with SMTP id i18-20020a056a20549200b000b79612cd31mr6105853pzk.0.1674407696288;
        Sun, 22 Jan 2023 09:14:56 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p23-20020a170902a41700b00192a8b35fa3sm1691913plq.122.2023.01.22.09.14.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Jan 2023 09:14:55 -0800 (PST)
Message-ID: <7b770cdf-960f-b423-dc4e-300d66a044ca@kernel.dk>
Date:   Sun, 22 Jan 2023 10:14:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: FAILED: patch "[PATCH] io_uring: clear TIF_NOTIFY_SIGNAL if set
 and task_work not" failed to apply to 5.15-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
References: <1674398936111119@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1674398936111119@kroah.com>
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
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

This isn't needed, as the 5.15 base is still using tracehooks for this.

-- 
Jens Axboe


