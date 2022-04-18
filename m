Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4365A505A5A
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 16:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243852AbiDRO5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 10:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345051AbiDRO5X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 10:57:23 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4FF22282
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 06:45:26 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id k29so18931884pgm.12
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 06:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=GcQWdCaoNg9E/cWyeWkPW9R/RpZZOj//1t2DCLFab7c=;
        b=Y6U0SG112JZkYtVVt3uLWajnJJ2JrGdhR6f9JefNrW1qCH5oBJmcYf+Yery6hpyfb/
         EQYGa/2ZWZ5iws+1fRqbZ7nId1dYdRGNjkBNfgvqmRtGRCT4Ue1Vs/PBZ9oR+1g4rwt8
         jsgBbecFr2J/jgHoE3PXTJI46+dl6f/E81Kc685ejqZmO6mKSO/lXhY6jifAqBCX0mKz
         AGJVL99IunB5n3LRXSuc3E1UOprOQYjfU0gXjIykuNg5VqLd/5czDwcHZbMXyAs/7q3N
         yRvgrGx3S8NyFWxEpNl1+L/V2DAYgnQJMo9FDzJPplGl7OQvpvqsaZe5XiI510Y6qDnj
         EReQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GcQWdCaoNg9E/cWyeWkPW9R/RpZZOj//1t2DCLFab7c=;
        b=yj5g8YAO3mw62xnmbLhdougxKxpP1oUAfogNaaEr5VyMmelE47wPSsKZJzKG9RDanl
         /TQZ1oZ9+CcR474qNW4pDFKh7cCanNTl8D/tY0fxozJVrKKpaFFVjQGFBUwyZhe5PSFU
         qm7JefA+AxkLKgWPk0gdntERHRIUS9Nxffe6iwrquJqH/hZh454eN3WK2cyTw7bambIU
         xTo9FynAh9zPebXBcDpZuXBosf0boHgaM4ArY3rBAZq5SfHAd2qRBaN4WR3YDglOgFR/
         cUXwF1dlh3tVE6FfNHILjF80xkr+ryGmTCuL/NCjirLr8p4mtYs2u3Am1I89HSbZE/nR
         sW8Q==
X-Gm-Message-State: AOAM532duRAaRJzrswbxnE9IyHflGc6ttOySdmWQcboWNubitkaOujZg
        Dm0t88+Sp8CrhAQZn1XYYMZoeg==
X-Google-Smtp-Source: ABdhPJzu/EueoF6a2kZYKj/aC4p5rNhgKKJw9KFxXemTlJZH65onNAg/RMhpKQmj26nb4QJPBDW3jg==
X-Received: by 2002:a05:6a00:162f:b0:50a:4909:2691 with SMTP id e15-20020a056a00162f00b0050a49092691mr12577935pfc.64.1650289521539;
        Mon, 18 Apr 2022 06:45:21 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s4-20020a056a00194400b004fb358ffe84sm12672428pfk.104.2022.04.18.06.45.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 06:45:20 -0700 (PDT)
Message-ID: <9b45635a-852e-2298-77f4-8d93cc1577c6@kernel.dk>
Date:   Mon, 18 Apr 2022 07:45:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: FAILED: patch "[PATCH] io_uring: use right issue_flags for
 splice/tee" failed to apply to 5.17-stable tree
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     asml.silence@gmail.com, stable@vger.kernel.org
References: <1650275686134226@kroah.com>
 <6bb25dbf-a25b-b35a-d6dd-bb5845084649@kernel.dk> <Yl1iS7/yaWKLDktm@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Yl1iS7/yaWKLDktm@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/18/22 7:06 AM, Greg KH wrote:
> On Mon, Apr 18, 2022 at 06:43:13AM -0600, Jens Axboe wrote:
>> On 4/18/22 3:54 AM, gregkh@linuxfoundation.org wrote:
>>>
>>> The patch below does not apply to the 5.17-stable tree.
>>> If someone wants it applied there, or to any other stable or longterm
>>> tree, then please email the backport, including the original git commit
>>> id to <stable@vger.kernel.org>.
>>
>> Here's this one, and the two others that failed to apply for
>> 5.17-stable.
> 
> Thanks for these, now queued up.

Thanks Greg.

-- 
Jens Axboe

