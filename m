Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A24B315D19E
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 06:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbgBNF0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 00:26:48 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33503 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgBNF0s (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 00:26:48 -0500
Received: by mail-pf1-f194.google.com with SMTP id n7so4307764pfn.0;
        Thu, 13 Feb 2020 21:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nlp5waVzcNqVmbhY3uqpWox8ceXJtdpgXZBCxdPtD3Y=;
        b=ckUnS8JfeCfcff3wl1yfEbei/+gqR7s+QvtJd5cbUYdzIhWBlAiSuec21rq3qTrbX8
         KWX4fNNsy6RTs/8sj2v3cjan6vRqp163+QLJm58s/4UPvi1ln4WnU0tDtbHOls64j5G7
         t/DsOvN0ZwSVf7vB5CR/8KX7xWKQutei0zBiWzCG5mAwQLKbeJQnor7xQS8hViQD7jpy
         utpkaz5y1BjWOt2+ffCZcqPU9PoaSp1XwZf2+cRxH309ciZTFTh8OfjjTp0BFOElGdzr
         dJuqPX30Uw5Q8eoTQVo+qm77EukhiUn95ZLPWWkZluEb1dpQTUxwlcv0sFMY1zEiv+RR
         aw3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nlp5waVzcNqVmbhY3uqpWox8ceXJtdpgXZBCxdPtD3Y=;
        b=obbWecY5Sd4krqja21enPiNWwN2GFW8EIRkzUK8jVpoAjG+HcFFkjUuTO2Bg4y95Mr
         BHm4zhk5nSapjkaWN6S/Q0FSAqGvfOnEZNcu83lQrYr+VEFti5AhoglhDzWSBn6uvEd4
         CAeeJrtDdgrCqbl/s3RF1NNC1WGbmu7H8kC4D9ExeMt99cxwAwfZ79wd2Tsd3z2X5S8d
         qekZ/8kZU4aaFDS9t8U2IuISE37Jgihhh5cwqSK48exrMvwMteMGlltcnb0ssbGNWvV/
         rNFlT7PVpfZkNPT0x7KygAXtAbFAX7o9Atpq1xm6PZCDm6wXYRWcp/oiMYonWNpgzaEH
         MsNQ==
X-Gm-Message-State: APjAAAWTquodHIIT4U0ohqsCeraAnFT7fDJrQY99F86ALNBGXXy0Hk7O
        vc6goaho4coeylXBr3riwof4hf69
X-Google-Smtp-Source: APXvYqz1OcuwgZQ//KX2wD+tM9kp20keH1XAAQ7JsZr6KN/edZeqdzecVTFloJKIRTgDcrtsCYdKqA==
X-Received: by 2002:a62:1d1:: with SMTP id 200mr1688046pfb.184.1581658007200;
        Thu, 13 Feb 2020 21:26:47 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i68sm5234741pfe.173.2020.02.13.21.26.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 21:26:46 -0800 (PST)
Subject: Re: [PATCH 4.9 000/116] 4.9.214-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200213151842.259660170@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <02282730-586c-5572-68f3-daaed78c8b9a@roeck-us.net>
Date:   Thu, 13 Feb 2020 21:26:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200213151842.259660170@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/13/20 7:19 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.214 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Feb 2020 15:16:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 360 pass: 360 fail: 0

Guenter
