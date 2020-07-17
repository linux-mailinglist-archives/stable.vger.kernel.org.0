Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDDB2242EC
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 20:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbgGQSKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 14:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgGQSKB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jul 2020 14:10:01 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4CEC0619D2
        for <stable@vger.kernel.org>; Fri, 17 Jul 2020 11:10:01 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id k27so7067241pgm.2
        for <stable@vger.kernel.org>; Fri, 17 Jul 2020 11:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=i04VIV5yBy5MktxhQ64pKyHDiBTIn39ShvbAT6u/y+8=;
        b=pXnbPZXGj542WQPXH1WNHe7FwbZqnK0mLnAwBWkD/0vMdH4xAUOk/8cS64zoAbmZ3C
         uvmuQDDn3m4GCsndzWvR/yQYE2YeGOaPVS6OI1/qoqvR79/T/IlQAu/YdgU4KhVmCD6z
         M4z8BJG/zD0XgdTmBdR6kSVqmnRO2c9AESADZd2VqTz6ecZQvQkCcmEscHkAZhGt1dZt
         XGQNcu3uiJTs9CI1iaXPwD+iobiz2DfXXqyDhmyRAlPJRjUIBISOcbD5lUZL7xN59LOs
         ZmAwJPyCdBIl5z0VuiEFkoS6Pk2mFVowQ9RlwH99VLocIcCWCUMvhuq/r/0R8xMrXUPL
         HKxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=i04VIV5yBy5MktxhQ64pKyHDiBTIn39ShvbAT6u/y+8=;
        b=ogFzYhX0PacRYciTjPXOyMr6X37IUJfnGeLzncMYxb1mlNQ/l8EuNtEQf+WUePuqNf
         JMpB7oe/D8DTIThv7WPajDmnPWuT9H9ih0j5Y1I3AnCRETSmRQ9T/RfCk3za1yKxYxjy
         WeaF7lmPZQhpJAo+TSaEK9Jl0Gyu2ATdJFdeDNDIzTxFAd/v1ntJ5eazmLHWzZSCIXRc
         Qc+jjDvqSjXNLDdT82InVDIi09QBQLMo9EN1e8xpGKOpneuxgqnkP2kF0RebSRxy3DFn
         X6BOAWZT3ntrMKZAayYypTgFl1ahLut71FYZkQzn4UttFPDdocxHAPc3Kq7Fh+vEBTcJ
         gD3g==
X-Gm-Message-State: AOAM531CaghhFKRcYIMtQTcpru6n57Up65d3tjDhWQTFhSuITd5kQr1m
        QpiAkHLAtbzedQn9gOlUZUi24kHCz/b2Uw==
X-Google-Smtp-Source: ABdhPJxemuSalONdbTUCWrotdGb8GpzT/30U+NKqqoioj/BnBwOX6f+y28yHMLoxrjUmdQg1I+ag8w==
X-Received: by 2002:a65:64c1:: with SMTP id t1mr9603127pgv.267.1595009400455;
        Fri, 17 Jul 2020 11:10:00 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id s10sm3506208pjl.41.2020.07.17.11.09.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2020 11:09:59 -0700 (PDT)
To:     stable@vger.kernel.org
From:   Jens Axboe <axboe@kernel.dk>
Subject: Stable inclusion request
Message-ID: <bd2a28c0-ee8c-3be9-58f1-a52cc935bb86@kernel.dk>
Date:   Fri, 17 Jul 2020 12:09:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I forgot to mark this one with stable, can you please cherry-pick it
for 5.7-stable? It picks cleanly. Thanks!

commit 681fda8d27a66f7e65ff7f2d200d7635e64a8d05
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Wed Jul 15 22:20:45 2020 +0300

    io_uring: fix recvmsg memory leak with buffer selection

-- 
Jens Axboe

