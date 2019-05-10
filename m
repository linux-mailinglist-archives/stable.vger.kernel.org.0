Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0650C19E4F
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 15:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfEJNgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 09:36:46 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43750 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727258AbfEJNgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 May 2019 09:36:45 -0400
Received: by mail-pl1-f196.google.com with SMTP id n8so2859265plp.10;
        Fri, 10 May 2019 06:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Kt9FPFDpjFPjc6XHDzkaEMg/CJSFoG6/sggF3HB6EQQ=;
        b=OHyIZElzc6hUOnDTCKmPJOBRGsinYylt9gw5Jy1a/G1St7BjMOEsv+/Om7kCCZ7fQT
         oTecW84/Xr+JI1oUbkq451vNSYlAQVaNj76WQkYJPrM5WHOt5jC6gLTL9umKZoIQ9GOe
         /CSbvFDkp1LElYjggSsGijAs8RrMchndBRInZKwsArSGI06gs8CtUxXQFiy0Mg1YsyDY
         HX05IVooz+jxnjf+L2ohVwr474vbrswBA/pAfDe1o08joXWEzC9y/5AHyE+EfXncxLPq
         ublGQ/e3GU1+238TXbYMnQgxmwOsSmCkxFGdTuwXqElf7B3auSknPjxevKWAZncXspxA
         gu5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Kt9FPFDpjFPjc6XHDzkaEMg/CJSFoG6/sggF3HB6EQQ=;
        b=gjyBjSWRnyjIvDVDjkatLN9vbCfAg2co+9eD1kGUPtUWnqH7YiSMGbc6g4sC0v9SAk
         yIknC1KUtblih9SostMIvBrGWH5Uj+kPVfXEqRwDhBEqsqPXbmhNfKON68VKkwJ8OPF/
         6xuXUWWcl9iXYOJlxXgUi5AW86pyz1eFQy7hAU99aJTR7xnOqNyPGfEKmnOoAiG8i/aq
         sRL3A6IUTPCMU3gw/SLkqgkNROOIVciYkJbd/sGySa3fvz/hK7gijQ5kYjHTw0oUzEy1
         BUohYp81PcPp7N06ADYR9JaQz+L79U9fColAjISh+17Z1HkVd0bELAVUPwI2Qhe7sf+b
         Uvgg==
X-Gm-Message-State: APjAAAVwj44EHELScp/Wn1vJymLlZ3zbukvzpZPPyl5CkdvH4y5TNHdL
        JO29L9UsoAPoNcRyc1bigC9akJ35
X-Google-Smtp-Source: APXvYqwUWds51Bswk4inzGav4X7yQsA9fbIM68QAgKcLhKIUc4a9NAzPW/4r8WsoCtKp8VmqzIhAlg==
X-Received: by 2002:a17:902:76c5:: with SMTP id j5mr13115742plt.337.1557495405069;
        Fri, 10 May 2019 06:36:45 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s85sm8897102pfa.23.2019.05.10.06.36.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 06:36:44 -0700 (PDT)
Subject: Re: [PATCH 5.0 00/95] 5.0.15-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190509181309.180685671@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <411e19b0-7f02-a1e3-e1b6-1ff9ca4e1145@roeck-us.net>
Date:   Fri, 10 May 2019 06:36:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/9/19 11:41 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.0.15 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 11 May 2019 06:11:22 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 349 pass: 349 fail: 0

Guenter
