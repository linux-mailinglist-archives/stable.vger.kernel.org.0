Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4B41945FF
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 19:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgCZSEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 14:04:20 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:37806 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726163AbgCZSEU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 14:04:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585245859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c4LPjPNt5XitfnwhDrgfXuX6BJTSNYbmGi1BrggmJpM=;
        b=BTO73owCTSy/RNPj6iDpeXd8tH6TPMw5ty9n32QQUskWV9PVQr6aUqkedD60z2OW0iR76T
        LpmGPjseFVqikdc5qIGCYRnuzkDM8OHqA3T6UJuDzmWdm77Seb9xBI8C9ykjvd/OumTg8+
        o0TYiVM0A95IGoiDm6YLx8dS2JYdM6I=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-BQnAUHPSOumoLNEidUDq8A-1; Thu, 26 Mar 2020 14:04:17 -0400
X-MC-Unique: BQnAUHPSOumoLNEidUDq8A-1
Received: by mail-wr1-f69.google.com with SMTP id u16so474868wrp.14
        for <stable@vger.kernel.org>; Thu, 26 Mar 2020 11:04:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c4LPjPNt5XitfnwhDrgfXuX6BJTSNYbmGi1BrggmJpM=;
        b=jf+hnlIIMPryzyhYhY+JJLe8OJ5l7zyFHzDYaZ5H1248Q1Ni0V6pDvQG/0JUbBiSfm
         KfMb+meICDPuQtRLrKm+hx4sODzL4vK9H5PPI2LabqhgVRdcyPiD4fJVtLQtsYZ9VP0s
         DlAeOas4gFEty85hSYkejItE2Ju6lzZp2SFxDo1OeeVGcdRn3zbROredp43vpfIZpBKo
         9dgvCxdmVFPOg0gQpBXxLOAX3QsHq7BCCY2fp4YSaEGBwQilo07uQLm8NNfZyO79Ck+F
         KiHH9QCYe6qtxCjxjto0v+lPFOULBOYsQf4TQirbfiM8SGaR1ucxYJPSR4TTGAum4UQj
         Fisg==
X-Gm-Message-State: ANhLgQ3O/RKuS3ZeMs8Ww3zwO/Ss0xh8FaXYL06PWGdPeIvSH+C/z6vv
        dCfP+dwG4uP573fqFSBNAvAT8f2tDd2+xlyPFQNkGerzgMCsFGfPxAdNERg9yPWsaCh1gHBf0nw
        Be2nS3y5eEhfw4rFH
X-Received: by 2002:adf:dfce:: with SMTP id q14mr11115653wrn.326.1585245856239;
        Thu, 26 Mar 2020 11:04:16 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vumFTdcpO40a3mOwroVYrdB5elGElI1FDhD6zpr8AdXKtomHxfxFvjo6W4Do+Og0LtvgrSagA==
X-Received: by 2002:adf:dfce:: with SMTP id q14mr11115625wrn.326.1585245855956;
        Thu, 26 Mar 2020 11:04:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac:65bc:cc13:a014? ([2001:b07:6468:f312:ac:65bc:cc13:a014])
        by smtp.gmail.com with ESMTPSA id c23sm4736988wrb.79.2020.03.26.11.04.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2020 11:04:15 -0700 (PDT)
Subject: Re: proposing 7df003c85218b5f for v5.5.y, v5.4.y, 4.19.y, v4.14.y,
 v4.9.y
To:     Thomas Voegtle <tv@lio96.de>, stable@vger.kernel.org
Cc:     Zhuang Yanying <ann.zhuangyanying@huawei.com>,
        LinFeng <linfeng23@huawei.com>
References: <alpine.LSU.2.21.2003261831320.11753@er-systems.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8350b14e-f708-f2e3-19cd-4e85a4a3235c@redhat.com>
Date:   Thu, 26 Mar 2020 19:04:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.2003261831320.11753@er-systems.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26/03/20 18:43, Thomas Voegtle wrote:
> 
> Hello,
> 
> the following one line commit
> 
> commit 7df003c85218b5f5b10a7f6418208f31e813f38f
> Author: Zhuang Yanying <ann.zhuangyanying@huawei.com>
> Date:   Sat Oct 12 11:37:31 2019 +0800
> 
>     KVM: fix overflow of zero page refcount with ksm running
> 
> 
> applies cleanly to v5.5.y, v5.4.y, 4.19.y, v4.14.y and v4.9.y.
> 
> I actually ran into that bug on 4.9.y
> 
> Thanks in advance,
> 
>  Thomas
> 
> 
> 

Yes, indeed.  It's not a trivial backport though, so I prefer to do it
manually.  I can help with that, or with reviews if Yanying already has
patches ready.

Thanks,

Paolo

