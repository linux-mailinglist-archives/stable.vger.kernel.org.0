Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3747C1FE32
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 05:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfEPDfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 23:35:19 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41210 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfEPDfT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 23:35:19 -0400
Received: by mail-pl1-f195.google.com with SMTP id f12so868815plt.8;
        Wed, 15 May 2019 20:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RPMH081ErAZuXU51Qe7vnlcf5u8SRg2bVoDCOxr9GnA=;
        b=dp1r/rIbve4gVBvWhyqPeIEVZ1QXyvIduwQOFkCwsHgdJMYr7KZecZCIfr8W2g16z8
         raLFuxeDyS8xzUyb+vru0BthRKnoYmekVaKy5aYqRhAgZV8OetCOi7V9LmJSStbupr8H
         nCcCuP3UYW7i1d5Khk2XYfOzIoAq+a0x1Gp5mh0jh1izvvT0bPVkqv+CyAHP+bZ/V5pv
         GBPXRMF5bRUoqMeLmdkAXUHJpTBMlnOleObOu29fig4Tofm6GrhUI+8FQY7UsM0+rHe2
         irGikArRyzhMn13htI9QWFnfsAg5oF5P4rn9MRZhQXrNbiqpUnwFWNFw5zuSTaDCr7e6
         Gxvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RPMH081ErAZuXU51Qe7vnlcf5u8SRg2bVoDCOxr9GnA=;
        b=dcWduihkmGyBKdRDv+rri/bvnUP9qyAYhYdM6V27OJPBjgHrOrdLStIjfqXgOUEgQP
         lANveyX1fXX+2H2o/9yyy5MFTfr9d7ynqvt30gnofiCB9NjjjhiLpFHqMgTtOnxuIrjE
         BIZ2hcBSN+XKlIk1z+JDxaYbZ4DYQlzZCHg6QB7PZnqs3+m/h4VEGkxKRI4u0q6DJ5IW
         1WhBMqYGUVriIdI3mNDFMwwhv97aEc+U+PsKtaqrWvYeOgbtRdAUwCkHJSBLbJgkWhx5
         i/dwpp8MVVCp7tuJA6FRhoMdTk+1mFg4vaCt/37vKzl+vNHBfXhcUqNbNTWWQ2s6jODg
         jFSQ==
X-Gm-Message-State: APjAAAXzrlMImaDuu/tP8t4wMw2/UyWSRP85Fkpwv4OzTqdsI3NGtDYF
        OuA03cNjdmdV9RzrDEqQb2ugkNSp
X-Google-Smtp-Source: APXvYqyN++5g5Tlw6WyMpCCr9nJ9Dad8+iHeAwKh1vSLxlMn2VePHgP6k+O5SUXXTvtr0NYx1O6rmg==
X-Received: by 2002:a17:902:a614:: with SMTP id u20mr47808881plq.117.1557977718371;
        Wed, 15 May 2019 20:35:18 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p16sm9889608pfq.153.2019.05.15.20.35.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 20:35:17 -0700 (PDT)
Subject: Re: [PATCH 4.14 000/115] 4.14.120-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190515090659.123121100@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <c6bc58b0-e83a-ef8c-e549-fe1cab6badc7@roeck-us.net>
Date:   Wed, 15 May 2019 20:35:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/15/19 3:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.120 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 17 May 2019 09:04:39 AM UTC.
> Anything received after that time might be too late.
> 

For v4.14.119-115-g76f2977:

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 333 pass: 333 fail: 0

Guenter
