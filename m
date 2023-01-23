Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2512B677FDD
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 16:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbjAWPeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 10:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbjAWPeW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 10:34:22 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526192A172
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 07:34:14 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id d14so7496937wrr.9
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 07:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bd/aSNKmgCiEgahXrJvC7Y3jhRFF5zV0QaXnmmOoHlI=;
        b=TYtcizlZTGQ+IZVdYuBFT+OKelRWncs+u9b4CBoSh3lv87AR+ZdSVkooAdS2i6qr0j
         UE7itcXextumS0Tie3vn8j4HZgLsgM0R+0Mqwl+cSpUidfAUtEEonXtxVHvV/FkT3PAJ
         zrqUsREtbJ7A+GAbYjzvUbhX3ImNKTqTf3EIXPcZsnTflUbujoOVm9DCcmjM+j7YkRzP
         QyM2p7M6rj4KLTN7of/z1JOSxty+KMXYlYeoLWK9aTFoVTJnAjGvR7z1zERsZNg0ZnTV
         B1ekJw0Ml5boXBY5Zec0yJWT/o1MDlRVYjemJDgMZvBONY9gcPw8ICOn/EAiVHeXYZef
         ILkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bd/aSNKmgCiEgahXrJvC7Y3jhRFF5zV0QaXnmmOoHlI=;
        b=aR2KDcetG3Ln2GEaV2RL2mMYEc7ZTgzvSUCa6B6RGnm6ypEF66wgtSOKil14Zll+fB
         8/HGQhuc/jNR5aLRN/PntOZ1gyrtjDqTO0b5DBbz9FOPXUjh4Gh1EgIFHHVBwVpPACn9
         aNh3ENOb14Fe3HESSEdjjQ5pgAtFjPdmqmQ3K+L/SLmxIS1k07mCzJnIekUdHZDy6TfF
         9RxCJXiI984A1LPWHBI7TuLrO1ksAj9/znY7JxJHCtbTBC2XFsxjfqHSJpPrH0b0AsRJ
         glGJIdfGaSNz9t0rwHkFdGq4yR2XHp1i//dOnDmVmrhLmzJty3qK+KDutajq771FZD5V
         VHWw==
X-Gm-Message-State: AO0yUKWj6GqqxZyNL55oKZCtyljbJ6Nh52HIIRTclfMilmCFH83Ly29l
        NVPH9pTvSqgDTaoy0g33szjS5hCUyPU=
X-Google-Smtp-Source: AK7set8GJaKh4JWEPbjb138fxXCCAkml5AHRgSOcbPVopX40HwfWTIyzbfumPmaOLGBNq5jfWY0+mA==
X-Received: by 2002:a5d:6804:0:b0:2bf:ad43:8f08 with SMTP id w4-20020a5d6804000000b002bfad438f08mr179713wru.14.1674488052850;
        Mon, 23 Jan 2023 07:34:12 -0800 (PST)
Received: from [192.168.8.100] (92.41.36.86.threembb.co.uk. [92.41.36.86])
        by smtp.gmail.com with ESMTPSA id e36-20020a5d5964000000b002be0b1e556esm18006795wri.59.2023.01.23.07.34.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 07:34:12 -0800 (PST)
Message-ID: <8f5f017b-ba8c-b47c-3812-f61c4ed4151a@gmail.com>
Date:   Mon, 23 Jan 2023 15:29:25 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH stable-6.1 1/1] io_uring/msg_ring: fix remote queue to
 disabled ring
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
References: <7912d2195155239ddcc77fa9ec22cf0f503ddf68.1674486170.git.asml.silence@gmail.com>
 <Y86mheG5a2noWIW3@kroah.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Y86mheG5a2noWIW3@kroah.com>
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

On 1/23/23 15:23, Greg KH wrote:
> On Mon, Jan 23, 2023 at 03:03:24PM +0000, Pavel Begunkov wrote:
>> [ upstream commit 8579538c89e33ce78be2feb41e07489c8cbf8f31 ]
>>
>> IORING_SETUP_R_DISABLED rings don't have the submitter task set, so
>> it's not always safe to use ->submitter_task. Disallow posting msg_ring
>> messaged to disabled rings. Also add task NULL check for loosy sync
>> around testing for IORING_SETUP_R_DISABLED.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 6d043ee1164ca ("io_uring: do msg_ring in target task via tw")
> 
> This commit is only in 6.2-rc1, so is it really relevant for this commit
> to go to 6.1?
In short, yes.


The upstream commit fixes a bug in 6.2, that's the Fixes tag, but
it also adjusts behaviour of the feature, which came in earlier
kernels. My bad I didn't split the patch in two.

I also thought Jens added a second Fixes tag but it's not there.

Fixes: 4f57f06ce2186 ("io_uring: add support for IORING_OP_MSG_RING command")

-- 
Pavel Begunkov
