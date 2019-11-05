Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E11EEFFAA
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 15:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730985AbfKEO0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 09:26:32 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43669 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727849AbfKEO0c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 09:26:32 -0500
Received: by mail-pf1-f195.google.com with SMTP id 3so15537097pfb.10;
        Tue, 05 Nov 2019 06:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PK+HHV1/IFV7ZYeQjogsIwGVKZHVoLQkuXcsiphZtd0=;
        b=CXZwYak3xedQX4/e63TeUH/7kgSArHLOR7ucp/4vFiEmrRCb7V2w7ARdXLwpX0s7AQ
         PkvB0OsaNGBZw/zkyOT643saTTZntuEd1ArgZ8sGfJU4A2GPmbnGHeXBiD2rVJtn7eEt
         gHPxN229cxG/lnhIOFe+FtKqJux80nNkFegC60BFXaRGFBA3ILYrMvIsuVJrYCVWrbWC
         ffGCK76W1LQpxGcHzQJ6n3cN316IV5aFX6bYdnh4spVioIpvScPRJ0/0JLNX7FwQsEC9
         uM9ffN/ChNC04sTtl49rBgQtmBbprwXKEQtR6e6J2kZDBfGcpLWywXrD8ovFtIiKLbZ0
         Py+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PK+HHV1/IFV7ZYeQjogsIwGVKZHVoLQkuXcsiphZtd0=;
        b=BQ2dyqdP3vi5rJ8zsNLleHbt/DYtbKBog044S5NXgH4l9DOIXPSSRxbFN6kwllkti7
         E8689Q51zFS5PV15SWtUXkikxfwrhOXlM3X9Gkh8HARQeZCN4B6nV2YOPoiZ85ZUv5NZ
         Bk5CJJknLxJpuITlD7NeKmiHRcpuekXr6YJaK5yf60rIwir5YTf9MqpcS5qE1TCp5zzU
         F3zO7Etelwcd2eQSqMru9tygTfm3r3Asq+E+dS9hACnHPuZIKUrj4Zblf94e1s0nRxVR
         Sl8PQXI4/OehrBQAJTWbiCvZSZ1wgBMeAkuldkJtSClHZazVMx7XvEW88TFoNxUi0QfZ
         R8Cw==
X-Gm-Message-State: APjAAAXrEdK7aapKyKwNA/l02ZiDkShM4Yy4mwCkwcbB3kkgWpH8lITd
        nIGizcUKHBq8uH1d6dDmWwbSwD4a
X-Google-Smtp-Source: APXvYqz+Xn38K1Eq5zudDxVnCfJqlKsIjiOv0HrcDmOm8N2jm5wZ2EXSrv//ssjLwTnHHfLGgw6r6w==
X-Received: by 2002:aa7:9ad0:: with SMTP id x16mr38531421pfp.51.1572963989837;
        Tue, 05 Nov 2019 06:26:29 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a21sm17528858pjq.1.2019.11.05.06.26.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 06:26:29 -0800 (PST)
Subject: Re: [PATCH 5.3 000/163] 5.3.9-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191104212140.046021995@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <22e9066f-b2e9-552e-70d8-b6aaf3a01cd4@roeck-us.net>
Date:   Tue, 5 Nov 2019 06:26:27 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/4/19 1:43 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.9 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 06 Nov 2019 09:14:04 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 391 pass: 391 fail: 0

Guenter
