Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4EC600FFC
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 15:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbiJQNMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 09:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiJQNME (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 09:12:04 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1702BD4
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 06:11:56 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id s30so15990554eds.1
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 06:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4fQ3Q/lNjEMM/7vPfFc10TtgUuRl15Pk7cTbLoHr+pk=;
        b=WxIqDhVgkGOLsJhkI8GNrkWhFreLMHeGcyHs3RQmNIxV8A0t4D6FPmQlrZRluxAQlw
         8Btt+aXhLL5yWUw1NKiXOKJ+JyCY0qf6FMKdGXKHhzpFi268+gUrtWnxuI5L3XuMH7kd
         y14zxarSbjLuOR/uecWn4AY7iBH7khchW2KztMzgKJdYeq7WHcedZ5AdHJQXRurPxFJB
         tY8F3Ez1Qjra29EKoclCJYMFLTKs5YwMRhBBOrRo/lbfUxP/7XFmDCvebHOSc0kzrZPs
         jenaqFxfQ+mXX4nW1PB94xoDECWgblRkS9dSZ6lJDkoisZjuPqC2JsQS8cpuwOlAfq8m
         FmHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4fQ3Q/lNjEMM/7vPfFc10TtgUuRl15Pk7cTbLoHr+pk=;
        b=H7hezJ7FOompQfcQpPoI96wbGavWZszCZ32r3FdC4hppvFsYF3+Cog/k6/G744uiwZ
         4dqo/ipBwqDHuEEwE31euOSrMdl8WxP14BVlK9fEp7hnrPpxKxkXmivV+CNQpKAbAHH2
         pz1yY+EzafW7fsZXt4MkrbjmqpClpPNhRZf/UeNbh9FzuM3jjf9futPByI5facfAih3n
         FHuG9EZj045/bBYdvWJjP5KDq+/uJTOdVKDF8QxX8rfOgGOb3tQb92z3fpZZTHscB9/7
         qD0qMI4AwTTpO92DC5e3RCoGuW6+fzYoung6TWHVZpRWXFpxz+XnQtO/z1s3bSDxnNSq
         bhPA==
X-Gm-Message-State: ACrzQf3/AhqBSTb0xqwaRh7iekzeozoH/J7KYIyxLxRioKpi3A76tjrk
        +hOxRXc/o6d/J5zqeV9RaRI=
X-Google-Smtp-Source: AMsMyM4egPePxTxRcKZS/zzBZM8DD/QQVb7vT63dWPOqKh1EgLowRoKJBj8KPFfEAyHWn9b+YuWHfA==
X-Received: by 2002:a05:6402:c45:b0:442:c549:8e6b with SMTP id cs5-20020a0564020c4500b00442c5498e6bmr10235479edb.123.1666012311238;
        Mon, 17 Oct 2022 06:11:51 -0700 (PDT)
Received: from [192.168.8.100] (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id k10-20020a1709062a4a00b007838e332d78sm6105480eje.128.2022.10.17.06.11.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 06:11:50 -0700 (PDT)
Message-ID: <3b067018-3b79-9be4-455d-e48ae91afee8@gmail.com>
Date:   Mon, 17 Oct 2022 14:08:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH stable-5.15 0/5] io_uring backports
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
References: <cover.1665954636.git.asml.silence@gmail.com>
 <Y00iTiwiIGaIoGhm@kroah.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Y00iTiwiIGaIoGhm@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/17/22 10:37, Greg KH wrote:
> On Sun, Oct 16, 2022 at 10:42:53PM +0100, Pavel Begunkov wrote:
>> io_uring backports for stable 5.15
> 
> How about 5.19?

Looks there were no conflicts for 5.19 and you applied them
yesterday.

And thanks for queuing all backports!

> If you wait a week or so, 5.19 will be end-of-life, so maybe we can just
> not worry about it :)

-- 
Pavel Begunkov
