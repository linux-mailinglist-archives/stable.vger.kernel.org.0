Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04EDB4F2D8
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 02:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbfFVAor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 20:44:47 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39141 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbfFVAoq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 20:44:46 -0400
Received: by mail-pf1-f194.google.com with SMTP id j2so4397796pfe.6;
        Fri, 21 Jun 2019 17:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Tu6HqIGrZwsHUX7/oBmz8RVDGi2XzIjjBnxuFYYblKk=;
        b=FbcfjKsRsgaHqZ56lgXNkEoMS7MmL7aosHhlw3z5kMdMp6P9HlZgbVyCoSsJsFkchq
         NQw8d8SoieeQjuvzr3oWp/h69YzCGjGIefANY4Yuh7w7W0aeHbnXoJa9R14tgFBFhl2V
         ClZRGN53QDK84BtcyU9pbT6LUDaq2Dk1N0nAM0PaP8+7UBWYK1swbBkI1eNc1N5ObOY5
         LwU1E93FQBU/plk10cqbOTwZ/OB3YqrvQGNjb01uKFb3iMMdlezDw55XTp+3KbZk5dVH
         q34sjZrHDhREZCC2Xk1hQndVj7EVtRWRNwSLSTTRCpCG8aO++YtisauY3mXRZaUH7Bnk
         Lxxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Tu6HqIGrZwsHUX7/oBmz8RVDGi2XzIjjBnxuFYYblKk=;
        b=T/g0yqbdU65AcaSQvUv/iggIv1nmVEtQa7riTOl5rsSot1+qoi99Lwwu2wDw+gEyYP
         Z5eqZzVjcKTWa5NmNXWqvL0ykbVh9cqTGjr525qvaQ5dQUKfsxaZNRoZo9S7yrKIbO9d
         mkubwNl9JGKDxV2YM5QhbDXtG3RdiMnFMrJxdpytnK3p8RIlintcTQyef5GZElG+1WwN
         XgKNO8Bi2/Zm+VUlAFlmn2IxKivMdMGU3Oro2JLk0lEFqPqMGuk0H5xBl+FjXO0fubSh
         nFoUr70cR2SmWTw/8Fo7CRLHt1aG4qkz2PoTCMZTF2GqtFys8g7UT0se64DBsYn0Reo0
         DC0A==
X-Gm-Message-State: APjAAAVcGn48orWynIHpjmBljtMR+iHJ37xP3h+xAXoSwV/h94trgaP7
        aRbEM8/5FxU9Ft7oDnAPZj67dnEw
X-Google-Smtp-Source: APXvYqyOr3jMvQFGFq75912J9OGNP3Zr7v5uroth3LvFx1AYkxJHIBe8EhKRJ7Obw2wlRSRLE9Bukw==
X-Received: by 2002:a17:90a:2430:: with SMTP id h45mr10463497pje.14.1561164286003;
        Fri, 21 Jun 2019 17:44:46 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d4sm3281180pju.19.2019.06.21.17.44.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:44:45 -0700 (PDT)
Subject: Re: [PATCH 4.14 00/45] 4.14.129-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190620174328.608036501@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <1ec62c27-e449-06c6-40d8-6104a1e203f4@roeck-us.net>
Date:   Fri, 21 Jun 2019 17:44:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190620174328.608036501@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/20/19 10:57 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.129 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 22 Jun 2019 05:42:15 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 346 pass: 346 fail: 0

Guenter
