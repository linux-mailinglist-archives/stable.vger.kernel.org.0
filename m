Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCBD2077C5
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 17:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404511AbgFXPlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 11:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404508AbgFXPlL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 11:41:11 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6EAC061573;
        Wed, 24 Jun 2020 08:41:11 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id x8so301476plm.10;
        Wed, 24 Jun 2020 08:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ly1TDzAEx8vRao/mqsmJUAAYy7jcqmMxO/HEea7Av6A=;
        b=pT1lDwxeGf1ZL1WDYZhRIsulBFmJl83sDoFHdazqASaBZVOm1HCyGs373KF9U3FGXw
         8fiCa8hrNCfHQ60kR2Q908SL1kmBPgtXUw6JMgrx7BNSLzLaxPPsVMgiEP37Q6Ep/3KV
         mQ7Ir5vwQ0gaVOZE6eSFfzzGumTrBoMz7auwUvj/jn+4uKTHZyc4e5M1eleZ3bKID314
         5ikyJrd1Gwr7UpJd6zFty4Q5JAKUPbOGOa8zvMd0lMB47YxgOzhNPoBO3eSGlM3L/scs
         itSyAEkl1QeSXf3Sq3qBpArKgTXTYysF35McTTMhqptBVFkL5c7bcysm+PZSneppZ6xX
         cXSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ly1TDzAEx8vRao/mqsmJUAAYy7jcqmMxO/HEea7Av6A=;
        b=IJKSTqm4CJyiC+d6V8hZiKK6bKz7THoHwDxp4NqnRvV1PN93Cu/zrdnqXn5Qxh/jNK
         uM5H/bBc7M+f0RYw3NqguoqXe7ecuyeWxreJ94PUKoZ1wjb8KyAi+MulMvRJOxcbpGJc
         nhAtAnjYr6AxhOy/rpldkdSmcBAd9jApC9SbPbNa7YC5apsaXLltl7qwyr3xdivt0BL5
         PyC0LvckDsKFbbOm8+niX/ONv7pN/42IJnQRW+srB88MYc4kNXcidyAvn/WjcV92gHyU
         DPVkPzZsvA/dJ5V7/aMVlro2eatrNrlbTC0qhKzZpS+p37b4S4RAq1GILHwmPHca4L5Q
         Uyrw==
X-Gm-Message-State: AOAM53355PJlnfQh2Rx4iIYwR/UlUBo0XYRK6VcczCWxm/xGU7ewaQaw
        kvzJAGHi9HP07PN3WYl7O/UGwmMP
X-Google-Smtp-Source: ABdhPJwjJvWss3nf1yZq/iKmUT8dWFX2W1k4dETLwsNyvHC7n3w0ua0Pqn3ngFYp/kPAu7UiQLIkXQ==
X-Received: by 2002:a17:902:8c89:: with SMTP id t9mr18616817plo.306.1593013270406;
        Wed, 24 Jun 2020 08:41:10 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id m20sm21981737pfk.52.2020.06.24.08.41.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2020 08:41:09 -0700 (PDT)
Subject: Re: [PATCH stable 4.9 00/21] Unbreak 32-bit DVB applications on
 64-bit kernels
To:     Greg KH <greg@kroah.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shuah Khan <shuah@kernel.org>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        "open list:MEDIA INPUT INFRASTRUCTURE (V4L/DVB)" 
        <linux-media@vger.kernel.org>,
        "open list:FILESYSTEMS (VFS and infrastructure)" 
        <linux-fsdevel@vger.kernel.org>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
 <20200623191334.GA279616@kroah.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <99a35736-6539-4a83-b0f0-74a8cf28d85d@gmail.com>
Date:   Wed, 24 Jun 2020 08:41:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200623191334.GA279616@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/23/2020 12:13 PM, Greg KH wrote:
> On Fri, Jun 05, 2020 at 09:24:57AM -0700, Florian Fainelli wrote:
>> Hi all,
>>
>> This long patch series was motivated by backporting Jaedon's changes
>> which add a proper ioctl compatibility layer for 32-bit applications
>> running on 64-bit kernels. We have a number of Android TV-based products
>> currently running on the 4.9 kernel and this was broken for them.
>>
>> Thanks to Robert McConnell for identifying and providing the patches in
>> their initial format.
>>
>> In order for Jaedon's patches to apply cleanly a number of changes were
>> applied to support those changes. If you deem the patch series too big
>> please let me know.
> 
> Now queued up,t hanks.

Thanks a lot, I did not get an email about "[PATCH stable 4.9 02/21]
media: dvb_frontend: initialize variable s with FE_NONE instead of 0"
being applied, not that it is a very important change,

> 
> greg k-h
> 

-- 
Florian
