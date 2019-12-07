Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD1F4115D4F
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 16:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfLGPTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Dec 2019 10:19:23 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44314 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbfLGPTX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Dec 2019 10:19:23 -0500
Received: by mail-pf1-f193.google.com with SMTP id d199so4907311pfd.11
        for <stable@vger.kernel.org>; Sat, 07 Dec 2019 07:19:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=swvw28YyLbYtIP86iVqxeTEx6HYn+zV4iPqtMnRCKnE=;
        b=DSKqeP8urcZw+lyiu76jklIcCBSdOo7h9yM31epZHzu24LWOspyCHEfGR/T8fsR1vC
         X+aSBrow72sBYzIQ3M9Nr6bznmfYIQPmFX/CgKZTJLfQeY43V+SN2q8OCfsLr06J0DPv
         s3Yt2s87+0nfNI6l1xbgA/dTFPs1MaVpQej6iCamSSCa8PITWMwRui3usCWbN7PZsmBa
         JV8pB1gpQOoVs4g5YhpPfxMfWso7J4Js+SGg3qaHhzJMaKgaU0gX2qXklSmuMhupWPiF
         LMogg+kctY+p6WnIj0Kv8qXS8QpZapWpuqhB9ufsgE9cyfICfXgxdKC66e1wvzVv2029
         2UwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=swvw28YyLbYtIP86iVqxeTEx6HYn+zV4iPqtMnRCKnE=;
        b=lYqWdL/WSopzDviWYIKEGdJHvsSSzer8T0eK1mBFMIM48rYvEq68dHHiKp9vNTN4+B
         6ya1rOfKHm3gFUceMUSfS/mJj5qAYv0dF8XmqXXVb7dgVczBLY2DQuq0q6c5CDO0UrT5
         KICUEEbJcOlHxKZVWhwXLIszbzKmUn+10QwR71ysBEgYqXvPfy1XTTZxmNb+oCF6P2Kd
         wnp2CBd7PloytOPbdteM9dVVUoD3rI2ZDIQeTabNyGsEBzlCYTPkybnNfOPp3TKDMQKe
         WGswTXHYxPSM7jGk1/DsR/cSTaAIBXHNn5j158NH8Ndh7v3B3Ma5Oh3dqC5JrJvB2jI7
         qO3Q==
X-Gm-Message-State: APjAAAWwuOOtp0DcENYDZBhYc5CqB9EIj6m81Gc8QFXJc3SHZzrPfcQQ
        cAYiPzh58G1w12sf0RlsWNjIMBJthPc3Zw==
X-Google-Smtp-Source: APXvYqzWiK0wDXUlAS+ePxa8wf34cEIGCh8xDdClIr+U1X9MWHjiYYWWXM2epauUmNMa2e3ajsOefA==
X-Received: by 2002:a62:1b4b:: with SMTP id b72mr20290972pfb.96.1575731961649;
        Sat, 07 Dec 2019 07:19:21 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id y144sm21592026pfb.188.2019.12.07.07.19.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Dec 2019 07:19:20 -0800 (PST)
Subject: Re: io_uring stable addition
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <a33932d5-c5ff-ff4d-2bb4-3a1c3401a850@kernel.dk>
 <20191207120158.GC325082@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <eb01b23d-0e3a-ff36-47fc-e694618c4cb3@kernel.dk>
Date:   Sat, 7 Dec 2019 08:19:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191207120158.GC325082@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/7/19 5:01 AM, Greg KH wrote:
> On Wed, Dec 04, 2019 at 08:53:43AM -0700, Jens Axboe wrote:
>> Hi,
>>
>> We have an issue with drains not working due to missing copy of some
>> state, it's affecting 5.2/5.3/5.4. I'm attaching the patch for 5.4,
>> however the patch should apply to 5.2 and 5.3 as well by just removing
>> the last hunk. The last hunk is touching the linked code, which was
>> introduced with 5.4.
> 
> Does this match up with a patch in Linus's tree anywhere?  Why is this a
> stable-only thing?

Because it was fixed as part of a cleanup series in mainline, before
anyone realized we had this issue. That removed the separate states
of ->index vs ->submit.sqe. That series is not something I was
comfortable putting into stable, hence the much simpler addition.
Here's the patch in the series that fixes the same issue:

commit cf6fd4bd559ee61a4454b161863c8de6f30f8dca
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Mon Nov 25 23:14:39 2019 +0300

    io_uring: inline struct sqe_submit


-- 
Jens Axboe

