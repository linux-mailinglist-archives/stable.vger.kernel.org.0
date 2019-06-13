Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24A7A44CCE
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 22:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfFMUCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 16:02:34 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35679 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbfFMUCe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 16:02:34 -0400
Received: by mail-pg1-f196.google.com with SMTP id s27so133207pgl.2;
        Thu, 13 Jun 2019 13:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pz+OMXKivSXeeb4ndq6AXO4LBvkk+BDJgun9rWkJPIs=;
        b=K02PF5QcbM/MkpPVmvzKRroA6/5thL3e1AhgbU2QG0bmky69RGiA09o1NcpS9HZsl3
         NShI438EjtZNcYTINxtJ7f9sUzSBOnRlnwvrWBtVI+WhcDmkH1ybuOSHZEEN75AJ/X2f
         safxRWjLXzzPu2bfupR4bFbirDis6UwoP5ZQAlFzsWXc/rT1zOV0CFbTboNFOTrF81oD
         HRPV3VzZtohSD+EUX7Bv/2ewCr0ZitGCCIRaBJ+coHoM/n1cBSymrdDwvbSQTEe0t+sR
         DtUWhjrbhIT5potNhyaBTBImRufh8VAm9eaBMFY1tROrfvvz5eSlqXpfKMOj0+KjTnWD
         y3Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pz+OMXKivSXeeb4ndq6AXO4LBvkk+BDJgun9rWkJPIs=;
        b=gGwsv35sD2/3l7kbHyQQGTOix69Z+i7VwlRAQAA/QFcwRliYoSXNyfKYNAgT6Svr0r
         RCc15nySLFDSGKTcx3h6rLFLJzcXLziSlRpF4YqkNeDaZxAb3dg6iqroe6G8PA8hON9G
         BgesoTIsVgUU44DCI31YUwsfOiEeIoE9205sd/sYvDnLCmlTQ2R4XbFXgBS2GO3cc/Ga
         wtfhw4FNt1pHaVp0cpORwD1MTQQbA6YUL4RpTO/wCNrtHaRkWygm2W1Gndis21T60LLe
         4Jy2eLHE37IquWGa4jJp2lHuxxax4WyZ5lsbDy+SsPIxfYtcNSM2KsUKSgvBCl6drUUS
         F69w==
X-Gm-Message-State: APjAAAXzIjtCnG4WnidVfe7Us0rM0RclzWI1nS6GwecIT5/rXy4Wf5NK
        aaFrQPqqTnUcE4GZ6Td2j9lo3bpP
X-Google-Smtp-Source: APXvYqz9o+RuuipAZjCz5X2jtJ2csI5PUhVN0/EvfDzaift8+IZ6q4XDcVIYKW/0MWLvqysMb+Q9JA==
X-Received: by 2002:a65:56c5:: with SMTP id w5mr31766184pgs.434.1560456153001;
        Thu, 13 Jun 2019 13:02:33 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 25sm502601pfp.76.2019.06.13.13.02.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 13:02:31 -0700 (PDT)
Subject: Re: [PATCH 4.19 000/118] 4.19.51-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190613075643.642092651@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <a5695d20-a2cb-6b19-41c7-ee922f57a22c@roeck-us.net>
Date:   Thu, 13 Jun 2019 13:02:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/13/19 1:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.51 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 15 Jun 2019 07:54:44 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 354 pass: 354 fail: 0

Guenter
