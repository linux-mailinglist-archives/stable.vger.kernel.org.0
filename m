Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 243DC4F2E1
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 02:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbfFVAqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 20:46:01 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33633 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbfFVAqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 20:46:01 -0400
Received: by mail-pf1-f194.google.com with SMTP id x15so4415679pfq.0;
        Fri, 21 Jun 2019 17:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1ud+6EuEn6wqRszAM8QE3ouYKP8d63mnARG0PmI1Im4=;
        b=oBj8snfnq6d4fl33O1dFRlYy87lZDW0uLGinOphOCbTKe6xz7EvtYLq9LHFzgBO4WN
         GokQaS4EJ6n2EMTGUhcoG1ARfoLibwHgUWy/2yO60hjo8ltTsM4CCUNXAIh+0g6lO4te
         QA7tqqW3hwhiP1Tx3pe/QCwnRluiuDWIFc9ILhc3IP57J3Za7l/EexGgjCDUuTC+f/h6
         L7I9Yszs9AQBU+yD5YaR2jg2O4cFyT9kcrHaIgbzGs3+gTaOsapnTJmfMIQACY0F+IVe
         HwYGe/vztRir5+YCwgn1TigDcDFWM9bUh5iZT3zXJ2zjCrDfkkQUKxGzZ5sVUAJYbjEP
         5XUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1ud+6EuEn6wqRszAM8QE3ouYKP8d63mnARG0PmI1Im4=;
        b=PatJwI6JIJPjMTeEfh96yr/744Mvp0MKQ8MqVK1j7w5g0vjPkMsWTAHTog6YSGk0V/
         sGEXf2nfzJOoqiMB0wetu2jZ0QAeQvBBuPyx9rpTbugpIMEGOsBP96O6qYqcuoy/bA7j
         Sn4v9dcKzgV/hXEs1lpjiPBKlD8k/7UqOSgPYx9jwzciq8AYBiFrAzpq7+Z/vVoMLxyu
         mZr0jUTVF440BbGy4ymRrjilcLpbI3jNomm+U/36m7MBnwtyyTp+6J2ewlPKq565aPjU
         SjoYYKGhDSM1x9ER+K8wrP97SANgdQLlo4wSllsns6gdbirBZfv+OXN4YphnUN795J6c
         R6lQ==
X-Gm-Message-State: APjAAAXkLGRvUzjhp7YnpVHCSJy5TV8HPZGYVBA6A5XvKYyrtHDeV3ex
        y8UJ0Ee5Ro/XxxP3GpdpRMk6SSv+
X-Google-Smtp-Source: APXvYqzGnPjyAfCAMByl1Fn8kRQ7uMlZ+3ojtPht6IaQcUtRF5zplTaaCiqtwFl/ogx0euU8xdzMsA==
X-Received: by 2002:a63:e250:: with SMTP id y16mr20581285pgj.392.1561164360117;
        Fri, 21 Jun 2019 17:46:00 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a3sm4157626pfo.49.2019.06.21.17.45.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:45:59 -0700 (PDT)
Subject: Re: [PATCH 5.1 00/98] 5.1.13-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190620174349.443386789@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <4efcd858-1b66-097a-1d8a-1a4e0efe7a42@roeck-us.net>
Date:   Fri, 21 Jun 2019 17:45:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/20/19 10:56 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.13 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 22 Jun 2019 05:42:15 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 364 pass: 364 fail: 0

Guenter
