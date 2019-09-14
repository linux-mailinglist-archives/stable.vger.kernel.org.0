Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8207AB2A74
	for <lists+stable@lfdr.de>; Sat, 14 Sep 2019 10:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfINI2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Sep 2019 04:28:45 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36758 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfINI2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Sep 2019 04:28:45 -0400
Received: by mail-pl1-f194.google.com with SMTP id f19so14304673plr.3;
        Sat, 14 Sep 2019 01:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k8DwSuSw4PZ5u1BoETB+A5nJXF70f6Ln/Z/2oBSSQG8=;
        b=okd52fF8G/dus+Lt5HkEuHkK0FY+aBZ24EJeu871sWIF3EnJGoSeD0KxaxZcRczWvk
         aGsXeBGhhTiFbOS53xFCezPay42B2IkdyG28xVHlEvLFCAj7cA/ed8GGTE9+boEUpidZ
         XCNoDGvV/MgeAwNKgl9m2fz2uuvmyedsi0xs+iLhvNcpAXiQcdIWm3IBui9fGU9yFCUS
         PJWH5BWAi4jR2MW+ID1K6iP8tWTLowMutrHRu3MOackrkxPrLec48Uk6QwZhx2yAbtGU
         Al1bYNT4V4TNVEzSNcyjjPXGepy76RV68vsL8A4dypB6r6BuPBM9QoxAKJ2mM03w/gnO
         u/pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k8DwSuSw4PZ5u1BoETB+A5nJXF70f6Ln/Z/2oBSSQG8=;
        b=UiDtAmwVMLtuQtVDO+y87x904DBQPivjX++HJBS0LO4RAZLKDwEspLUbAZsOhY9wib
         kEAkV57R1W2t6oyIMEFzOWxi+e2jjmHUZL5qUsrbalp5wSBYkHOxdaWlQeeKPHJWYMFj
         KjnZs77UXyfeMZcAB6sbstsd5vsCH5qLkmojRDHPPEc5P1Bpdp7UANjfwrUoMlVF5SXZ
         uNJnjlOdTVqpYDAYH8+iHzhMuCL6eKhM9Z2QfRKREW/HhIENyx2HC2RWh0e1TFGCibo5
         VxTcqJavGrFn1MHMBW/OINc56K/v5GRvGphXtg4qtJJcX2ly28h/nTk65scSbOV3HHyr
         DGSw==
X-Gm-Message-State: APjAAAXcKhj9pbcLTsGiJdDb8sKxSy536UV9fGbQ7Azm9WWJad2eYov/
        vqPuSF+eRdPgTpeaFH2xHJM=
X-Google-Smtp-Source: APXvYqwiJDzT6fZQcyJAVPob89UznRSdZS1SQxseHEiuZ6g690ZysylOyaAlYr6ZurhDNIH8DGGr7g==
X-Received: by 2002:a17:902:bd05:: with SMTP id p5mr51403769pls.339.1568449723010;
        Sat, 14 Sep 2019 01:28:43 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a1sm26298891pgh.61.2019.09.14.01.28.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 Sep 2019 01:28:41 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/14] 4.9.193-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
References: <20190913130440.264749443@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <aefa6832-073e-493c-8576-5b2f06e714fb@roeck-us.net>
Date:   Sat, 14 Sep 2019 01:28:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190913130440.264749443@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/13/19 6:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.193 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 15 Sep 2019 01:03:32 PM UTC.
> Anything received after that time might be too late.
> 

Is it really only me seeing this ?

drivers/vhost/vhost.c: In function 'translate_desc':
include/linux/compiler.h:549:38: error: call to '__compiletime_assert_1879' declared with attribute error: BUILD_BUG_ON failed: sizeof(_s) > sizeof(long)

i386:allyesconfig, mips:allmodconfig and others, everywhere including
mainline. Culprit is commit a89db445fbd7f1 ("vhost: block speculation
of translated descriptors").

Guenter
