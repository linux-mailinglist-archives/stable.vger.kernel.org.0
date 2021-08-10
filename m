Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 782CB3E566B
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 11:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbhHJJK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 05:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbhHJJK6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 05:10:58 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D49C0613D3
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 02:10:36 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id u13so27970511lje.5
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 02:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/m7bVhb4g1gYLvZhyCGYx5mtcIVS8oF1F7i/QNR69P4=;
        b=OCiPuKoovycAm8zxYJHHfp811gHGgq1thnz0olAtDjoG644uUm3MdxxtKnE/RvEuq4
         Dn0Xc265/Xdp5+VJiytOL+6/hcrKZUBrrSb0BhYN4l6vqSRmjsIz1+NoF7CWFm+kqQP7
         ZcenMssUfB/oR/HcQxzmH3WNxz6DntwLB2IOgIcUOCYUT3zJm/8AvAbkfyAI/DgAeVcP
         5POWN9li/7Z7W/FrBMjVG2CcC2sNlwIf2hrg0l2nnYCD0IyqnnJd2ZkxeWemGaC+axJB
         q6MXG8GTfkxJleSEUy7OepMdRNUogkJg1UCtsE9daY7dD2t9Z7WDBIzhYy3mneo5tkpy
         IiNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/m7bVhb4g1gYLvZhyCGYx5mtcIVS8oF1F7i/QNR69P4=;
        b=mcc+itHR7oZ5wmFZ/hsN+yUTZ6eT0FoiIx3px4xsL1mkyfyKu4AYBowJhCNaxSjre/
         OzFPC79qd7O7j7cXMgZEW3tQH3zGDfcVGjh9ILijgkG+tCslQ7590vkhJLQ/dPg95Q41
         RfpDwvVI/gQ5Gz2L3z6EqiI7ZKYpQ7RXH8iSNnoemgEqwsjoHb0Z00RjS6UOVFZSvUY3
         LZ7hvoY2wtZ2ka8r+hyZarnI9EHfvbTtnLRmrdJUCVY2Jg9wdZyugdLtvDrP3305tkrf
         K+jH2Zt0rM0ifgOezCJDNtxCRqAn9Whpl58jVQ2lCcpGn7+peFZGR/U+aCuxytEpjn4A
         //KQ==
X-Gm-Message-State: AOAM531vb0qPhgzi6NDQ3dgiltSdfvzlFB1KoapzWFWQ8XuUBPwq3UUm
        Wost0vpOs6kQs6qUrRPSz1qQrDLi1CLS5w==
X-Google-Smtp-Source: ABdhPJy2LSZjwFL2f2ioej8WJ9WxeLPJBIm2g8/qIGgP7eT+JNdUrRar20SAWwnfKX8ViBE5z+FxBQ==
X-Received: by 2002:a05:651c:1181:: with SMTP id w1mr18905287ljo.466.1628586634633;
        Tue, 10 Aug 2021 02:10:34 -0700 (PDT)
Received: from localhost.localdomain ([46.61.204.60])
        by smtp.gmail.com with ESMTPSA id b8sm315871lfs.71.2021.08.10.02.10.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 02:10:34 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] staging: rtl8712: error handling
 refactoring" failed to apply to 5.4-stable tree
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
References: <162850253410956@kroah.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <77187907-8eb3-8c19-5cd2-0e31a4bc6c71@gmail.com>
Date:   Tue, 10 Aug 2021 12:10:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <162850253410956@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/9/21 12:48 PM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 

Hi, Greg!

Should I rewrote this patch to make it applicable to 5.4-stable? I 
believe, that following patch "staging: rtl8712: get rid of 
flush_scheduled_work" makes no sense without this one.



With regards,
Pavel Skripkin
