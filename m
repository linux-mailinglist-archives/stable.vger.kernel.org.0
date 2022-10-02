Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4310F5F21E2
	for <lists+stable@lfdr.de>; Sun,  2 Oct 2022 10:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiJBIKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 04:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiJBIKP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 04:10:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321AF2657B
        for <stable@vger.kernel.org>; Sun,  2 Oct 2022 01:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664698212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oMlcvX2/A0O+zg5EuALUNbmxlJ1/iWj6K/LwEPDTTS4=;
        b=FGl6pkGQcGH3Y4XWP4FBtrFE3Mp82N2y7miLlPgSlFW0PjfNE+9FldYjmjuRzfqB53e9fO
        BI+75bqFjcdMHk2NzUzTe3tXFDL37YnQPutTFAItBVI46pK8hmhat3ilZFKICn3w/hGaG3
        sCuNRJCOLgB2esOJz529GN+aS2EpFss=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-255-n2iEhq6kNAaUM9azudXaFA-1; Sun, 02 Oct 2022 04:10:10 -0400
X-MC-Unique: n2iEhq6kNAaUM9azudXaFA-1
Received: by mail-ed1-f69.google.com with SMTP id c6-20020a05640227c600b004521382116dso6821822ede.22
        for <stable@vger.kernel.org>; Sun, 02 Oct 2022 01:10:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=oMlcvX2/A0O+zg5EuALUNbmxlJ1/iWj6K/LwEPDTTS4=;
        b=1XAJHuePjqE4AuTR+HWwMuuEZ57YLmNydDU0s3fc9QQzFEGS7+N6XgHLbNHpDZJhrR
         PoAeBlm6XwpG69FVqDdHYgY1TMQfUtawFqYFTrOfklodVM558qqGE7wAZq9sKQI+VfCC
         4E2ufDGtZiA/sssZP8AqoBfnCyKdTsDPV4aoFB0L+d3Fc8ABQLv7NipXfKhnyEkWuq9Y
         qvVOl+fjQ/AyeiJaq8yTR66WiW5NC1HYv3TTNDtEwRKxuU64uBfW7co+N1KtvLSK5h8B
         Gh2gAejdf3gm0Eq/zAjux0oNi2Yh5OLcP/HxtjZGFfMqLA5xmNiKjBX5h9iBVtx3lMp1
         uCSQ==
X-Gm-Message-State: ACrzQf2nNtAdbOiOq2M03gdNqCF9GP+s0tFFT+X402qxPhimNEkvWnWg
        uns4qiQUfVTIPd/F236s4jcjWqQUn1iwbVvy3DE2y/w+FxIob4ry0p5nzhoWRC1pOeDMJ9N6oum
        kUwFhiQ7tua7FMF8t
X-Received: by 2002:a17:906:8442:b0:77c:6b3d:bec2 with SMTP id e2-20020a170906844200b0077c6b3dbec2mr11632749ejy.224.1664698209679;
        Sun, 02 Oct 2022 01:10:09 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4M28inQ9RrMapseebL+yuWnAQUerNjawWOYfMJxsyYp3xCGMhsvO+EV4UOY6216bjmSjv3YQ==
X-Received: by 2002:a17:906:8442:b0:77c:6b3d:bec2 with SMTP id e2-20020a170906844200b0077c6b3dbec2mr11632738ejy.224.1664698209515;
        Sun, 02 Oct 2022 01:10:09 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id 6-20020a170906318600b0078116c361d9sm3777659ejy.10.2022.10.02.01.10.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Oct 2022 01:10:08 -0700 (PDT)
Message-ID: <15c6e18f-16d8-685a-5dac-c35b39c9b51e@redhat.com>
Date:   Sun, 2 Oct 2022 10:10:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] i2c: designware: Fix handling of real but unexpected
 device interrupts
Content-Language: en-US, nl
To:     Wolfram Sang <wsa@kernel.org>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-i2c@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jan Dabros <jsd@semihalf.com>,
        Samuel Clark <slc2015@gmail.com>, stable@vger.kernel.org
References: <20220927135644.1656369-1-jarkko.nikula@linux.intel.com>
 <YzMKHf+aNKiGVkyn@smile.fi.intel.com>
 <31477388-b57b-5383-9c6a-18905c28253e@linux.intel.com>
 <5b8a4060-b800-6701-e0c9-cc8dfa0e6b67@redhat.com> <YzjB2WSQfL7i4Teo@shikoro>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <YzjB2WSQfL7i4Teo@shikoro>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 10/2/22 00:40, Wolfram Sang wrote:
> 
>> I will let you know if I hit any issues, if you don't hear anything from
>> me then you can assume I have not hit any issues :)
> 
> Ehrm, how long should I wait before applying the patch?

Just go for it, I don't expect any problems.

Also I'm doing some work on a Bay Trail device with a shared PMIC bus
today. So if there are any obvious problems then I should hit them today.

Regards,

Hans

