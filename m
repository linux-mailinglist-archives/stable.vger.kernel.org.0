Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEBB2C9EB6
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 11:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbgLAKFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 05:05:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54184 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729633AbgLAKFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 05:05:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606817023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tbNblql/bgu1kTrPaVv4ukfAe+ESYoXim3MXcwQHQFg=;
        b=Qj3wop95wujwVPr6qigDJxxrfZ5nQ5lReWwbYziDkevXXT8nNUubZM7Fi7GcKH98cxTHbc
        5DCB4iU4veSip2aSSgRXpaUFWaZ9u7UNYAi6VF6JPKEd6uy1sX0Rmr7yv11a6qiE5OSFeJ
        bhNldqKFm46m0bVD/tmzbpik7gkP/nI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-7fGXtA3yP4-lTzyqzseyxg-1; Tue, 01 Dec 2020 05:03:39 -0500
X-MC-Unique: 7fGXtA3yP4-lTzyqzseyxg-1
Received: by mail-ej1-f71.google.com with SMTP id t17so927001ejd.12
        for <stable@vger.kernel.org>; Tue, 01 Dec 2020 02:03:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tbNblql/bgu1kTrPaVv4ukfAe+ESYoXim3MXcwQHQFg=;
        b=Kw3mFBsNBDbrvMvo8SI9nzTdKSsJQcN2LbanoTwVSbDhZeCkEugjYLmtJZ3m61sLWJ
         lw5SFn06uP2HxUGevq42aF0iM4DKmqyjDDlHr8ovTUwQnHz6PmXXYSfWNcLHcVFX0RLW
         K7b8jg+UhvWsN/0AwzYfrkxf71bVKw3KVOSzD2PoY14KNv1qsF+C0eZ8WF+1GAm1JWoH
         /d8fVxvWnX5CKMziAlRxliT9NMcV6NrHcEZ/Dq4T1B4WBr2AjnAHX4fAXwymi/g0g+0Y
         mUO7TX1xNnc7PKtHgGrGlhG88r9uUN7q31Vd+8G3VMbfGsn3Wm+ZXWgT6jb4zhGskADU
         cJ9Q==
X-Gm-Message-State: AOAM532QguP1xK1Laoyook18LcPP5gq7e6ntwNzBHpRcerAHZ9mnvwYb
        i2CZnH8Fe1UY2m5edzfMllSv8coAs8RH58hDbTsZ85H8QGs9xGzjBLeQN8BgcIQjv6zvYOf/3Ix
        QyYtO2mAXdsgRZ1Nj
X-Received: by 2002:aa7:c2d6:: with SMTP id m22mr2200295edp.368.1606817018386;
        Tue, 01 Dec 2020 02:03:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJycOxYx/Nex1usEn7X2wa0s1d7yHUQ7OMBrOZX+9So4+nOCjgyrvd5+f7dSybH3Ipu+EinTrw==
X-Received: by 2002:aa7:c2d6:: with SMTP id m22mr2200273edp.368.1606817018220;
        Tue, 01 Dec 2020 02:03:38 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j22sm578718ejy.106.2020.12.01.02.03.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Dec 2020 02:03:37 -0800 (PST)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Woodhouse <dwmw@amazon.co.uk>,
        Nikos Tsironis <ntsironis@arrikto.com>
References: <20201201084647.751612010@linuxfoundation.org>
 <20201201084648.690944071@linuxfoundation.org>
 <d29c4b25-33f6-8d99-7a45-8f4e06f5ade6@redhat.com>
 <X8YThgeaonYhB6zi@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 4.19 08/57] KVM: x86: Fix split-irqchip vs interrupt
 injection window request
Message-ID: <fe3fa32b-fc84-9e81-80e0-cb19889fc042@redhat.com>
Date:   Tue, 1 Dec 2020 11:03:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <X8YThgeaonYhB6zi@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/12/20 10:57, Greg Kroah-Hartman wrote:
>> Since you did not apply "KVM: x86: handle !lapic_in_kernel case in
>> kvm_cpu_*_extint" to 4.19 or earlier, please leave this one out as well.
> Isn't it patch 07 of this series?

Yes, it arrived a few minutes after I hit send for whatever reason. 
Though it still applies to 4.14 and earlier:

` [PATCH 4.14 04/50] wireless: Use linux/stddef.h instead of stddef.h
` [PATCH 4.14 07/50] btrfs: adjust return values of btrfs_inode_by_name
` [PATCH 4.14 08/50] btrfs: inode: Verify inode mode to avoid NULL 
pointer dereference
` [PATCH 4.14 09/50] KVM: x86: Fix split-irqchip vs interrupt injection 
window request

` [PATCH 4.9 05/42] btrfs: tree-checker: Enhance chunk checker to 
validate chunk profile
` [PATCH 4.9 06/42] btrfs: inode: Verify inode mode to avoid NULL 
pointer dereference
` [PATCH 4.9 07/42] KVM: x86: Fix split-irqchip vs interrupt injection 
window request

` [PATCH 4.4 01/24] btrfs: tree-checker: Enhance chunk checker to 
validate chunk profile
` [PATCH 4.4 02/24] btrfs: inode: Verify inode mode to avoid NULL 
pointer dereference
` [PATCH 4.4 03/24] KVM: x86: Fix split-irqchip vs interrupt injection 
window request

Paolo

