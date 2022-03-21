Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611264E2DD2
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 17:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350249AbiCUQYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 12:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351041AbiCUQYg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 12:24:36 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EE531532
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 09:23:09 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id z16so15907053pfh.3
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 09:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=t3ReJ4PvBw3Gfo7mC/8g2N3DvGlY7pEgK2TBJHx457M=;
        b=hob5J1LXhdMy91RjtxIm5UulDUmru2i3utdeV8mTdOyTWxXFZRzDzndIRlpodF9mZX
         8upMZGZ5ABizUacX4OV2YplwO7FCyG7DW5cXgVBvMS6D9f2/+UH7p4/9zusxWYuK9R2C
         gQCKeBi+8YbIZYFCn1APAKDOlm7H5DqxU835i5JVWLj3X8WUAs2aFJjKfHm+7GuNukLN
         qBwRvUFIgo7wjdG/dRU5Yvxmt1L9ZqAC+bjpSAm9c81AAtbfUKrjuQutoSBHASbsXIqw
         VsFSbWFEIfPY4QYSsfiIvnRQW6EctnA3tnyGdXgcMiUh2wrphxetZb4QcgyZeRUhBtCk
         jqdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=t3ReJ4PvBw3Gfo7mC/8g2N3DvGlY7pEgK2TBJHx457M=;
        b=2xC56PZYBJyWdGZqOvHj6F6RLbrwJwNCz7Y3bzVL44/h7cdZNvCtScf6hAuoxhaCnh
         Mavj4/Wy/wwHQzuZINYzZ0Bn77MzeHHFZ+cAZoM624nt26+jICpqQ6dDVQ0GlWqkpRLD
         Zd57dkiYDn5f7BsjfKq3S5Un6B50Qkcc3gdmsCd9S9C4TE5Hi6OG6Q5kro3YIovEAxBN
         8Psfa3t6FilVOtQwnhjhDaiaBsmk4LvpZOWYaPomyKdm5k1XXc89uKvMumzt1/DQ/eKV
         i3tYaZuuEmycushWRcRZwYYLXZWHb3ukOG9LT61uaxaKL/2nIn7K2bdUCLrDeQZ3Klt8
         TCiQ==
X-Gm-Message-State: AOAM531NvNkZo8VMGHYjEzhNjztV2Z3u48Y7o83vMgfG0phYU00QZXFy
        vu4wNGkwo+P2q4nuLWSuAXU9IvvM8cstNQ==
X-Google-Smtp-Source: ABdhPJxoSzQpJ4eZG0papdjbUhdPotfeHoAE3ZwuthY1ZuDXHN2beWqDbC/a4N7FcltHsA4yFiJ28g==
X-Received: by 2002:a05:6a00:198c:b0:4f7:7e0f:bfc2 with SMTP id d12-20020a056a00198c00b004f77e0fbfc2mr23953395pfl.44.1647879788626;
        Mon, 21 Mar 2022 09:23:08 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id r1-20020a63b101000000b00380989bcb1bsm15654624pgf.5.2022.03.21.09.23.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 09:23:08 -0700 (PDT)
Message-ID: <3943117e-b490-14e5-c72c-3a7db3cac061@linaro.org>
Date:   Mon, 21 Mar 2022 09:23:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Chen Li <chenli@uniontech.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Apply "exfat: avoid incorrectly releasing for root inode" to stable
 5.10
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
Please apply 839a534f1e85 ("exfat: avoid incorrectly releasing for root inode")
to stable 5.10.y
Syzbot can still trigger a BUG:
https://syzkaller.appspot.com/bug?id=0896bca762e93f26a3922dc0822313a7be65a3c1
It is already applied to all versions above 5.10.

-- 
Thanks,
Tadeusz
