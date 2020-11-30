Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAFC2C85F1
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 14:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgK3Nxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 08:53:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21404 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726283AbgK3Nxv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 08:53:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606744345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dd7YyZx6S0r/k7Jv+t4IouJbGqiia4Gb0CDXIGTscz0=;
        b=daGvEjxAH22SYd4ZZLBcgNXfrvKjiRiu/TnW6Zatx8Vv2cJRf0BlGL6f797mhaFsYdPEx2
        nJQPADRgyvSiOinK4ZoIjFQOzHRxclJTqC1pgwWXUCU7PtyWBrGKuQRRSLmMUx6sNwbJ0w
        FHRWZZEZyhLtiBG4CjnH2vQdBoJ21S4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-kH6FNoVDOkGEBDsEzkf6pg-1; Mon, 30 Nov 2020 08:52:14 -0500
X-MC-Unique: kH6FNoVDOkGEBDsEzkf6pg-1
Received: by mail-wr1-f70.google.com with SMTP id z6so6660380wrl.7
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 05:52:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dd7YyZx6S0r/k7Jv+t4IouJbGqiia4Gb0CDXIGTscz0=;
        b=G5lQn1TFLUvtQRyaa8/ZW4ZiDuRAwUEd3xSSXkaYBzUh8F0HrmtJ4++rDx2MlDiGyp
         GuUH5ca4sC13zU2ZtmQPfgR46ZVO8zccDAVO9C1jS5LX7RQuj3jE9OyIuK2lRKUponqg
         +1EsJGUqoAwYjSIjbVRo4MrXoHexXlYc6/84fdpkDZJg0BZAQzY0ZSuWUxYCKqwPk3dR
         qbr9zzVtEE3eOQBxCRLncme7/Vw4ahofSzBDkAuR1J612g2gk2mE0eOFgh3IDNB8BbHU
         wOWiOUqgu9GF5sxVvls/t5S/WJ+4QqUTavBLhvjSi8znAHSHIj3858gU1hZ8ZZciBIF7
         vpJQ==
X-Gm-Message-State: AOAM532sXCltwzGdY7nKipTQImqkpX7UOmVEp6s8YkzUazr4nVcz7i+W
        2EWJ5Mthek3hfUdvVk96KSIYnMoDHWq92gfds+MHNZEOwctFw1GYFNK9JpOLH/X2Tse+xDZTl6+
        oehxeQEZP5+n3+GSg
X-Received: by 2002:a7b:c308:: with SMTP id k8mr23439822wmj.76.1606744333519;
        Mon, 30 Nov 2020 05:52:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxDRWnK6zyQVzBKPkyfXvW5Lg7IYkytWYIR8qzu9foUcwM4XjEiPARUAO4ll+Mb92v/wZ91Gw==
X-Received: by 2002:a7b:c308:: with SMTP id k8mr23439788wmj.76.1606744333185;
        Mon, 30 Nov 2020 05:52:13 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i11sm29049398wro.85.2020.11.30.05.52.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 05:52:12 -0800 (PST)
Subject: Re: [PATCH AUTOSEL 5.9 22/33] vhost scsi: add lun parser helper
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20201125153550.810101-1-sashal@kernel.org>
 <20201125153550.810101-22-sashal@kernel.org>
 <25cd0d64-bffc-9506-c148-11583fed897c@redhat.com>
 <20201125180102.GL643756@sasha-vm>
 <9670064e-793f-561e-b032-75b1ab5c9096@redhat.com>
 <20201129041314.GO643756@sasha-vm>
 <7a4c3d84-8ff7-abd9-7340-3a6d7c65cfa7@redhat.com>
 <20201129210650.GP643756@sasha-vm>
 <e499986d-ade5-23bd-7a04-fa5eb3f15a56@redhat.com>
 <X8TzeoIlR3G5awC6@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <17481d8c-c19d-69e3-653d-63a9efec2591@redhat.com>
Date:   Mon, 30 Nov 2020 14:52:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <X8TzeoIlR3G5awC6@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30/11/20 14:28, Greg KH wrote:
>>> Lines of code is not everything. If you think that this needs additional
>>> testing then that's fine and we can drop it, but not picking up a fix
>>> just because it's 120 lines is not something we'd do.
>> Starting with the first two steps in stable-kernel-rules.rst:
>>
>> Rules on what kind of patches are accepted, and which ones are not, into the
>> "-stable" tree:
>>
>>   - It must be obviously correct and tested.
>>   - It cannot be bigger than 100 lines, with context.
> We do obviously take patches that are bigger than 100 lines, as there
> are always exceptions to the rules here.  Look at all of the
> spectre/meltdown patches as one such example.  Should we refuse a patch
> just because it fixes a real issue yet is 101 lines long?

Every patch should be "fixing a real issue"---even a new feature.  But 
the larger the patch, the more the submitters and maintainers should be 
trusted rather than a bot.  The line between feature and bugfix 
_sometimes_ is blurry, I would say that in this case it's not, and it 
makes me question how the bot decided that this patch would be 
acceptable for stable (which AFAIK is not something that can be answered).

Paolo

