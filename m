Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B3A456638
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 00:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhKRXLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 18:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbhKRXLI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 18:11:08 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0F5C06173E
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 15:08:07 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso9557410pji.0
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 15:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:cc:from:to
         :subject:content-transfer-encoding;
        bh=uHe0nHBoQnusXD7sqpDSgV4n0Un05qLazUUcsOwBApU=;
        b=olu2tKe8WwBsUhb1pyzkmIse+j1hlmXgWE7qkgXCkJzwhLLOQQMvt2AsenAjDZdSp8
         5AXASJxnSJ205uUovwHSH2kAsHvpVFNEh/xjuYmlPhEUZqq2N4LFU6wffRkCsH5M0tq4
         9OsTtReKwjYaXPz1b1YFNxg+uKX4VykN4Qk3eyHVxaFHBZBETPsZTKlmA+mAhlnx27up
         ruFpZr48NZZwtcZlY8Yy2BkgbLLpmbdOGOhoXlFjenMLzxHJ7xBvmHRMoLidVRRJTtEe
         Q7ebH9oN6+3EiMsZ+aykmk9Ew3QS0XZ7HgBn+ov69HLF9kRNKqFpOtrfOjoHMRFboMQv
         rzXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:cc:from:to:subject:content-transfer-encoding;
        bh=uHe0nHBoQnusXD7sqpDSgV4n0Un05qLazUUcsOwBApU=;
        b=QHwCJ6I5V4xkvmP/OS7JC7SkeV+WJkuZ43FaZ/IvuzJZALI8a9bxcX3gZZeGDWawA0
         keh+ov8sCK+EijUnNvpoQmhU3IPPBldnw98Yk4PHyZQduT/8hqltZPfb51BMDX02Y3Qe
         NG1eHZHTg95foMNRmZOh7B1L1HfZXipXiaOeagKqOSzMa4zf45eiMKX7lafDF2WFYcG8
         Q+sRbxgEeuE0+2T/JW56fINe9rnC8cnysUwOTDzKgEaB/eVUyKBJfcU3Dv0akYOVCpzT
         MPt/8IxQrMNYoEfD3L2LWh/DA0y2RWwxNH7+JLSlZsXfbQ7eMgAIs/23D6b4065UbF/d
         f22A==
X-Gm-Message-State: AOAM533wgc52eROTmVi+x246HZzBAShAmC2f7Zy8ZRAcar2wPOyP1yk+
        67sngemKWaQbvppoqrCTxUH6IBSz9zE6VQ==
X-Google-Smtp-Source: ABdhPJyE+ku5KctC4fuaG3TdvAXqJjhHDTpWzWxaypNRYbu2MbOuIG2qnmKp0Orrxvj1FSgblsFOGg==
X-Received: by 2002:a17:902:7d8b:b0:144:e29b:4f2b with SMTP id a11-20020a1709027d8b00b00144e29b4f2bmr3501542plm.57.1637276887254;
        Thu, 18 Nov 2021 15:08:07 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id k3sm640442pff.211.2021.11.18.15.08.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 15:08:07 -0800 (PST)
Message-ID: <7e6c4c23-f071-f33b-7bd4-da11980d34c6@linaro.org>
Date:   Thu, 18 Nov 2021 15:08:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: en-US
Cc:     syzbot+662448179365dddc1880@syzkaller.appspotmail.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        xieyongji@bytedance.com, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     stable@vger.kernel.org
Subject: general protection fault in bdev_read_page
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
This has triggered in 5.10.77 yesterday [1], and I was able to
reproduce it on 5.10.80 using the C repro from android-54 [2].
What happens is that the function do_mpage_readpage() calls
bdev_read_page() [3] passing in bdev == NULL, and bdev_read_page()
crashes here [4]. This happens in 5.15 down to 5.10, but it is fixed
in 5.16-rc1. I bisected it to the first good commit, which is:

af3c570fb0df ("loop: Use blk_validate_block_size() to validate block size")

The root cause seems to be loss of precision in loop_configure(),
when it calls loop_validate_block_size() in [5]. The config->block_size
is an uint32 and the bsize param passed to loop_validate_block_size() is
unsigned short. The reproducer sets up a loop device with the block size
equal to 0x20000400, which is bigger than USHRT_MAX.
The loop_validate_block_size() returns 0, but uses the invalid size
to setup the device. The new helper changes the bsize param type to uint,
and the issue goes away.

To fix this for the older kernels can we please have the two commits:

570b1cac4776 ("block: Add a helper to validate the block size")
af3c570fb0df ("loop: Use blk_validate_block_size() to validate block size")

applied to 5.15, 5.14, and 5.10.
The first one needs to be back ported, but the second applies cleanly.
I will follow up back ports for each version in few minutes.

-- 
Thanks,
Tadeusz

[1] https://syzkaller.appspot.com/bug?id=2a34ab9dad714959a3d2b60533acbd99094a5c5a
[2] https://syzkaller.appspot.com/x/repro.c?x=13420a05900000
[3] https://elixir.bootlin.com/linux/v5.15/source/fs/mpage.c#L302
[4] https://elixir.bootlin.com/linux/v5.15/source/block/bdev.c#L323
[5] https://elixir.bootlin.com/linux/v5.15/source/drivers/block/loop.c#L1239

