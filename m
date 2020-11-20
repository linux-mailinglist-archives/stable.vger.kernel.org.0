Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD8B2BA1A2
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 06:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbgKTFEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 00:04:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36520 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgKTFEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 00:04:39 -0500
Received: from mail-pg1-f199.google.com ([209.85.215.199])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <nivedita.singhvi@canonical.com>)
        id 1kfyb7-0007mQ-9D
        for stable@vger.kernel.org; Fri, 20 Nov 2020 05:04:37 +0000
Received: by mail-pg1-f199.google.com with SMTP id g3so5206723pgj.20
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 21:04:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=M0KPpXDTjYHJYCqQSeJz8XhZtoZ6mUyoFKmi0pfZlwc=;
        b=Il4nBKWvt2TUBfOvyvLq0jHpsCBh3Cs2yz8/3a2wr7cJjesTEVkPHpi7BURD89OIS8
         9aeBq6f6n0LlF8LIM56RtAflfRHUIUbWUXEteHpoCd/NoddMxnxfQ6bJuqkg3yx20uKG
         UFhwItg1fVodj7UOlx4nFy7gdamXwiTwgUDU0LHdyJMiNVDYguDBwJPuz09pEPVp1/3b
         JnegKt0cqv4dF1XJmZjX3RMpYIzELTW2KrA8rWZmhqb8U1ge1cibauaw8xArDpi7Pk5h
         m3JvAUuWwUtNvAuzq0HOCU92lxtBIGz7Qq4qiwoXPaojqHfACvsWSUjFqOF3zOUYOoEx
         vCkA==
X-Gm-Message-State: AOAM533westzPtJUvrX8D2tnjh5DCg20OBqKKjLSF73SkQXjDrVVdtFT
        vK8RChb/5dwK54SLSFkOcVNuX5OZH40SwTlQBFwuofG+RhJ/pH1pQxROk7qN+Ea12DfTfknaadc
        laaprNNgh3p5eEq20gDWMI6YKqSTbW3ypSg==
X-Received: by 2002:a17:90a:b881:: with SMTP id o1mr7389233pjr.43.1605848675842;
        Thu, 19 Nov 2020 21:04:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzlE5G5AMhdW6T4ncJChOafQ9uTGpy7QgA1LKb9By3opSamRrvt5joqFbI/9+u/cc4FBi0mEA==
X-Received: by 2002:a17:90a:b881:: with SMTP id o1mr7389205pjr.43.1605848675595;
        Thu, 19 Nov 2020 21:04:35 -0800 (PST)
Received: from ?IPv6:2409:4042:4e99:772b:3970:d9ad:c43e:294b? ([2409:4042:4e99:772b:3970:d9ad:c43e:294b])
        by smtp.gmail.com with ESMTPSA id l62sm1601763pga.63.2020.11.19.21.04.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 21:04:34 -0800 (PST)
Subject: Re: FAILED: patch "[PATCH] sched/fair: Fix unthrottle_cfs_rq() for
 leaf_cfs_rq list" failed to apply to 5.4-stable tree
To:     Sasha Levin <sashal@kernel.org>,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc:     peterz@infradead.org, Vincent Guittot <vincent.guittot@linaro.org>,
        bsegall@google.com, gregkh@linuxfoundation.org, pauld@redhat.com,
        zohooouoto@zoho.com.cn, stable@vger.kernel.org,
        Gavin Guo <gavin.guo@canonical.com>, halves@canonical.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>
References: <d3188913-ddb8-7198-8483-47d3031b01fe@canonical.com>
 <20201119185709.GD643756@sasha-vm>
From:   Nivedita Singhvi <nivedita.singhvi@canonical.com>
Message-ID: <97860226-715a-4191-e503-8d22df6962ab@canonical.com>
Date:   Fri, 20 Nov 2020 10:34:25 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201119185709.GD643756@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/20/20 12:27 AM, Sasha Levin wrote:
> On Thu, Nov 19, 2020 at 11:56:01AM -0300, Guilherme G. Piccoli wrote:
>> Hi Sasha / Peter, is there anything blocking this backport from Vincent
>> to get merged in 5.4.y?
>
> An ack from Peter...
>

Hey Peter,

Any concerns with this patch getting merged?  We are seeing
it in production, looks like, so would be good to get it into stable.


Nivedita

