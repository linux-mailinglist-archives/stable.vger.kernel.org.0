Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D375451423
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349060AbhKOUBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:01:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344280AbhKOTYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 14:24:23 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C899C04A18F
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 10:32:41 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id x64so15817063pfd.6
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 10:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5PG6sJZZOAhklRWq8XWd5solPtqMOwcN4ocpP/2rOgo=;
        b=c0ugunSMVvj/7NWkNPRmlZauTvMBW5Ew04+LO78zKp5Wf/vWGVmU9Ead+SlqLCKzh7
         MafHouCZR65vh9x2jl+joX95OYkKC/f2bvBH4ciHBC2hmlKL71bgQqN2gcAQNLHOsoXs
         QRJyRJJZmhT4bbR/kcigHVYOKlgKCJj5O6sy3McyMSV1XIAFcXOPqNHP970te1q0H8td
         lYmSWtO/BB/lo4r/4PRubwvMc8EhmCOCmEEkV1deJW+aC680/4mdfF5oYwF5v1RPt5Ei
         +/bcRcf3apsLhpT53bzIzT00mN/lG8+R9s6MDBW0kFdZaNC+I3TshFwuQ8s+dl4Ppdql
         gmBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5PG6sJZZOAhklRWq8XWd5solPtqMOwcN4ocpP/2rOgo=;
        b=jLG3fuS/OAoBzyO05fzlTusO/NvAj81P6wAa8jwI1yoIQjuDd0Z0g4+6Iz1Ith0m46
         4+xhm3vQqVwSMK+WBVb3CxsrT1YK+cZrIiksmoqWWoZWynUDWUAQ4gpcHXGbhv2QmRHJ
         1IHkxwFVicrUQspE3sv+v2LK5DpazXyR6XWqwRUwr1Mt2qxVGXDiUkYOWA160PVtijAu
         wSzzr3cDw5JS/GqoYIHPaQAy/aMr40k4P0sRmM/rIjUAbRNSyh68njD3SLKxKxoglW0s
         N5VyWnWGT+7IMAhtmu4o074G0ZB9xeD71VJfvlyUffRj1wiUqEHQUWpNi1UdTlByn6Vn
         Np+g==
X-Gm-Message-State: AOAM530YDmdNQwzKferzMsSMKnZoc2sbhk3+lMMrGagXYeTd5jZi37rc
        yt43IPdI/QyrMM4EcpmSsnOTLQ==
X-Google-Smtp-Source: ABdhPJy2IaPVOSbtMr7GPsVcsLYjo+Qs6gh3P/TfN9wxgzx8aAoH98fxe4o84CeDNxN1VA9qVYJ1sA==
X-Received: by 2002:a63:1d21:: with SMTP id d33mr632920pgd.101.1637001161172;
        Mon, 15 Nov 2021 10:32:41 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id f5sm69667pju.15.2021.11.15.10.32.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 10:32:40 -0800 (PST)
Message-ID: <1563f090-2217-959e-cc80-30a7a804c567@linaro.org>
Date:   Mon, 15 Nov 2021 10:32:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 5.10 011/575] scsi: core: Remove command size deduction
 from scsi_setup_scsi_cmnd()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        syzbot+5516b30f5401d4dcbcae@syzkaller.appspotmail.com
References: <20211115165343.579890274@linuxfoundation.org>
 <20211115165343.996963128@linuxfoundation.org>
 <7ed36c27-a150-39a6-d8e3-483c76bbedc5@acm.org>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <7ed36c27-a150-39a6-d8e3-483c76bbedc5@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/15/21 09:58, Bart Van Assche wrote:
> Hi Greg,
> 
> Thanks for having queued this patch for the 5.10 stable branch.
> 
> Do you plan to also include commit 20aaef52eb08 ("scsi: scsi_ioctl: Validate 
> command size")? That patch prevents that the bug in the commit mentioned above 
> can be triggered.
> 
> Thanks,

Hi Brad,
The "scsi_ioctl: Validate command size" patch is not needed for either 5.10 nor
5.14 as the it is set directly from COMMAND_SIZE(opcode). See:

https://elixir.bootlin.com/linux/v5.14.18/source/block/scsi_ioctl.c#L445
https://elixir.bootlin.com/linux/v5.10.79/source/block/scsi_ioctl.c#L447

-- 
Thanks,
Tadeusz
