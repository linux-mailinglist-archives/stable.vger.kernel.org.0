Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66BC77C9EA
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 19:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbfGaRGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 13:06:15 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43777 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728955AbfGaRGP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 13:06:15 -0400
Received: by mail-wr1-f68.google.com with SMTP id p13so70479730wru.10
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 10:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NqYuAsCxZnbGTgaXr+3YhsOwAJv9zT0r5brKkzwq8xQ=;
        b=i+bybRXG3TBUtD9u8radmJFhL9V1SqHv7Hf1YDzeg8dR5Scv5AmIG4IhHNyP5xiup9
         YM8uVOWbN0avt9C2+QfMlHV/J5SogDzkUluww3JrZZcyb5dKHznzgZnvLzNiq9UvINED
         7ljcCoCJ1mw7f1KwlbJqWabuapSdsjghBvDkoHeAufSyKx4e9ksVeg1TbIwDjXBKmJMa
         Ar3Ib+ZVDFUWrNry4pMzYS0JsHkyksRUi5oBq/C7Rdnyqw668xkdbf/UHsTLWAChk0IJ
         7HYQ9F1NFsgFW6Xbw7PmKFHxWCgWcTMLRcTyeWAhGN8ljvlytlIirHjazjRwIRmWnNbI
         8/Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NqYuAsCxZnbGTgaXr+3YhsOwAJv9zT0r5brKkzwq8xQ=;
        b=BP+8L2cl0ksO31x0WtgnZhMo+6L2cUVPfUopMrYlQadsVh7mE6TcdMl8Xhi5vdWy6W
         TtCPzhmE4GM1DDmEIBVjqcE6a13ugEIfxOj2bBBCsGRW8h7xZUcitFLv93N82lIWeCdZ
         lzTy2B5cU1qRXeYBe2B/3oziKkCqVQcvP2dnqtNTvb0tWfCIHLPCMGMvwpd3Oz1ues2m
         hTQ9xLH1HaevepZCYMRdsxK/L/ALp9hq7tMyHmdUYh4Bfu/ZFpoIbHff7REXyIDN/KkA
         Pg8NoAtBipEWDfnLNwrOMeNm4B4NhLY9QhuAb4uxUS6lQfksPV00Lvm3OhR2VZsdjPsj
         XJKA==
X-Gm-Message-State: APjAAAUADNetcpNeaCrsKpRAW9khk2J+QCVbj+uf+aNNGnRMVfV957lZ
        B/0HsGV+l+TOiv7KB+YIHogfzERHuPZgC+2cJvz45JOHjXlXI+ckHeGVtIO4q9SHbJyQH3bfnLI
        cnmXspU/1I3qoBiBjcu/bF5IHMWRlBB0mHJZUctplh+yQ7Q9p0SF/B9g2DTG4YEs5jzcc4p4ncX
        GnEhHOOU7z8jAUqwtbdg==
X-Google-Smtp-Source: APXvYqziuO0u89HuMRTcTlrbmTgjMLvFjOA+gjyCdQuAQYX7L3aCovgO5ZZr5B7JjCaxYRnKZS7Y3g==
X-Received: by 2002:a5d:6284:: with SMTP id k4mr103268166wru.179.1564592773228;
        Wed, 31 Jul 2019 10:06:13 -0700 (PDT)
Received: from [10.83.36.153] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id i12sm81569400wrx.61.2019.07.31.10.06.12
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 10:06:12 -0700 (PDT)
Subject: Re: [PATCH-4.19-stable 2/2] iommu/iova: Fix compilation error with
 !CONFIG_IOMMU_IOVA
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, 0x7f454c46@gmail.com,
        Joerg Roedel <jroedel@suse.de>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
References: <20190731162220.24364-1-dima@arista.com>
 <20190731162220.24364-3-dima@arista.com> <20190731170411.GA22660@kroah.com>
From:   Dmitry Safonov <dima@arista.com>
Message-ID: <beb8ebff-aece-2f50-9779-2ab1d183ce03@arista.com>
Date:   Wed, 31 Jul 2019 18:06:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190731170411.GA22660@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CLOUD-SEC-AV-Info: arista,google_mail,monitor
X-CLOUD-SEC-AV-Sent: true
X-Gm-Spam: 0
X-Gm-Phishy: 0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/31/19 6:04 PM, Greg Kroah-Hartman wrote:
> On Wed, Jul 31, 2019 at 05:22:20PM +0100, Dmitry Safonov wrote:
>> From: Joerg Roedel <jroedel@suse.de>
>>
>> [ Upstream commit 201c1db90cd643282185a00770f12f95da330eca ]
>>
>> The stub function for !CONFIG_IOMMU_IOVA needs to be
>> 'static inline'.
>>
>> Fixes: effa467870c76 ('iommu/vt-d: Don't queue_iova() if there is no flush queue')
>> Signed-off-by: Joerg Roedel <jroedel@suse.de>
>> Signed-off-by: Dmitry Safonov <dima@arista.com>
>> [v4.14 backport]
> 
> 4.19?  :)
> 

Hehe, yes - copied SoB line from 4.14 backport *blush*

Thanks,
          Dmitry
