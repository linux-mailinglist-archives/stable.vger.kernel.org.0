Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEB8108017
	for <lists+stable@lfdr.de>; Sat, 23 Nov 2019 20:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfKWTJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Nov 2019 14:09:11 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39392 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfKWTJL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Nov 2019 14:09:11 -0500
Received: by mail-qk1-f193.google.com with SMTP id z65so4493162qka.6
        for <stable@vger.kernel.org>; Sat, 23 Nov 2019 11:09:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=0r5YajQAWOT3rHYZDkRDr/sf0OvZvmqsBf7K8bxjHdk=;
        b=bd/bHdM2OdMmo3x2iEsM2VXYUPuFO4FmSGmhGSWMQXHPrLVA/UI1CreiaGa0TLuwTr
         +qb8teNgwQCd2+jNn49jJ9X7bpOPYXvDJhSN52Lplqic4kZB6McIWdkQ8gv1Zexb1fw+
         jKZ5/LPha6w8SxZ+krdUKrvLEOLBc/tgjEaoppSrjIzD8bSlID9Js0Sg0DJBq7X2Mrxh
         KN4O/eIoMRSbRzohwmfmi1FL4sVB9hZZPixBaK1NNI58O6rl897wg0R4oMXGwSBKTack
         yH2VNEYjd2Gr6xUCRXvCxMVUQHW4rKW0iiwK/llWX3fxc4WVvE71GLMRI7g5qrENVgQP
         wcKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=0r5YajQAWOT3rHYZDkRDr/sf0OvZvmqsBf7K8bxjHdk=;
        b=GxFi3eF6CmHkLu4tEYw/VVffTMgisnXHL/wt3S1UdNpaz/rW3GOhl2GO4KuMREQi+3
         T/u/mvFn8hCrxq4NRdNwDMMiPjr4/2ly7gVbc4bIkwLMJBDs68qbeiZF4+XGTnIVDjDF
         XvZ8qNKfOX0vXq8kcMdGCdN3rw3vMGlf4cuxv12fNnIKnFzJRMwPOIFDh2ldg75baVIc
         6x9fiqY2HnktlFh/7jr1s2IdOhK+enQcIg1ZIl8zTOL1ikYvzkpCzPfaK1e72P1HHv9B
         ffxxMyEzoQlzH/VcKTEjYIy9X1hSYl7lkJ+V63v9bFSAoXmxUrMv3seqh0JO1HtRbEJW
         BHhg==
X-Gm-Message-State: APjAAAVXLeDDnLW/ftn8cZ2av7UfTOIUysz5EvmLB125OeqSPDANInOk
        dru/DLcsradZNCK9ePGvtDCZvEekyBQ=
X-Google-Smtp-Source: APXvYqwGJdZzPMw4L5rKjy3hayd3vrqaTQllu66iAvaSIk7kP9QPZ+tzGA0+NfR77cq1pS2bK3gyLA==
X-Received: by 2002:a05:620a:208f:: with SMTP id e15mr9690935qka.351.1574536150477;
        Sat, 23 Nov 2019 11:09:10 -0800 (PST)
Received: from [192.168.1.101] ([104.246.133.66])
        by smtp.gmail.com with ESMTPSA id d6sm767333qkb.103.2019.11.23.11.09.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Nov 2019 11:09:10 -0800 (PST)
Subject: Re: Bug Report - Kernel Branch 4.4.y - asus-wmi.c
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     sashal@kernel.org, stable@vger.kernel.org
References: <33bfa93a-3853-85f5-47f9-8a69ed9c656e@gmail.com>
 <20191123092701.GA2129125@kroah.com>
From:   Bob Funk <bobfunk11@gmail.com>
Message-ID: <e452278c-4b5c-59fc-441c-94b41d817503@gmail.com>
Date:   Sat, 23 Nov 2019 13:08:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191123092701.GA2129125@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,
I have no personal issues against upgrading to a newer kernel myself. The
reason I am working with the 4.4 kernel is that it is the supported 
kernel from
my distro's stable release (slackware). Unfortunately slackware's stable 
release is
several years old and consequently based on the older 4.4 LTS kernel branch.

The result of the distro packaging this older kernel is multiple users 
reporting this
bug to the slackware community so I came to the kernel maintainers to 
see if this
can be fixed upstream. I could also advocate for the slackware 
maintainer to
apply the patch to his releases if you think that's a better route to take.

For the record, the patch that Willy offered does fix the issue on my 
affected
system. That might be a better choice than my request to revert as per the
original email.

Please let me know what you decide.

Thanks,

Bob Funk


On 11/23/19 3:27 AM, Greg KH wrote:
> On Fri, Nov 22, 2019 at 08:33:46PM -0600, Bob Funk wrote:
>> Hello,
>>
>> I am contacting the stable branch maintainers with a bug report concerning
>> the asus-wmi kernel driver in the 4.4 kernel branch. I had initially
>> contacted
>> maintainers for the specific driver and received a response stating that I
>> should contact the stable branch maintainers about the issue instead. Their
>> opinion was that the patch in question should be reverted rather than
>> debugged. I will append my initial report here and let you decide what to do
>> with the bug.
> Any reason you can not just use 5.3 or newer for this hardware?  Why are
> you stuck on 4.4?
>
> thanks,
>
> greg k-h
