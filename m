Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF43D3A149
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 20:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbfFHSuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 14:50:32 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39933 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727250AbfFHSuc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jun 2019 14:50:32 -0400
Received: by mail-pg1-f196.google.com with SMTP id 196so2861394pgc.6;
        Sat, 08 Jun 2019 11:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TrV/2uYCZ6ydfGT3DdFOmkj/97VfePPMT+jceKHRLyw=;
        b=kWBwFAP/k0IEMdE/kF+HYpQ2o971frVA/2l8IpSqzB/pSrlDUcf71qFFj6/YJhLFfn
         Yzkh5zBhpFB25AGrrnsNx/Va92ZZKDOEl4DRZ2jQQfEFqcAIdxBXke+x+hbV+jwOhALT
         tdnPEC5/NyX5L7+sKtg27h8DgXH2OtTxK6ixg8E/xXoaxJf8jP7Lbu0D1baOxD3+Eogd
         bJFoQc9KQusPEmrRhtTJGY0QChDVTNudbSC6HWwn7NMLRGnDCip/ffzXAgqjIn6Auyz/
         PbjjgFDU8RN8Wl04FRNQGdzOuz1ok/zPJ/lyzEKFgxk6kQ9tsoy+5cpMgMl4G3y7vQW5
         vNfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TrV/2uYCZ6ydfGT3DdFOmkj/97VfePPMT+jceKHRLyw=;
        b=jBM+phaFcp9TlY8zyV0bDrqYltn+WEwC0Bry96EZp3au86YdWjS2eFlqiB5nU6Pw8A
         KZJZK2Pe41StDT+IE6TPkSoMZlovQwUuyxzhTYikP1JZiJ1Ocx3h06RgsHec0Fx/iTap
         VVqBaXBQ+zTmp5fKphm5K6XOUO2IsEU+G6nl4I1T824GomrGb6rmyvnkmBNwejUtm4hx
         dw/TamGQoDjUyiekJd2O1dsUCnBL2aXkEYLd2ABtjITOKVBt+RNa/957S1XIQSaYbDL2
         Ht9iDqHzoveqXEwb6Pb1pLFerYgfsMwDvdbJjNAxBkDAqwe/dJx6yHBBVu8d3UnPA3t/
         auRQ==
X-Gm-Message-State: APjAAAX/alyzJFHXF5zUtWtXQgfuM7fEEcbzVjCPmk0IBd3QaYTK9/HV
        uaRI9rj1f6qagIvUYBuFfqb+jvZi
X-Google-Smtp-Source: APXvYqylXy38/B08zzc44IS/3AsYuvndcnt8xxWjv4/UbLLckg5WEmbPPMbqe8EN0vpmTayAyVVkFg==
X-Received: by 2002:a65:62c7:: with SMTP id m7mr8565363pgv.223.1560019831695;
        Sat, 08 Jun 2019 11:50:31 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c6sm11211606pfm.163.2019.06.08.11.50.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 11:50:31 -0700 (PDT)
Subject: Re: [PATCH 5.1 00/85] 5.1.8-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190607153849.101321647@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <1e5e5424-c888-bb1a-8e70-cc23847ed87b@roeck-us.net>
Date:   Sat, 8 Jun 2019 11:50:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/7/19 8:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.8 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 09 Jun 2019 03:37:09 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 351 pass: 351 fail: 0

Guenter
