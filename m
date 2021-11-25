Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2312C45DE17
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 16:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234553AbhKYP6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 10:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356227AbhKYP4l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 10:56:41 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CBC0C0619E4;
        Thu, 25 Nov 2021 07:45:26 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id r10-20020a056830080a00b0055c8fd2cebdso9974574ots.6;
        Thu, 25 Nov 2021 07:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=No0vuIKUUWd8wCmisiET3NNJ4gz4w6NOLgT4BfCkyhQ=;
        b=jFsUn1dd3c6xci8NNHvjO1NLzKQxSjRYmOdTGtw3HXOXGzNxt/6Vy/Ife8xFV3RLEL
         RKLaUJQTp0FPoHz6E793lWkYECK++MO/K8uRD2dh2xfGvpksSn4cQAs3kA+THFqDxXdB
         y19EYZyQIjJd4ogPs4+UX+YpS/+PiEUBWqUlCwNaufI5dtUGfgUYFdTisHiHMwIyuBZg
         /WHJrtQU3SKmbDAxfc38Pz6O31w8n2FmpYHn5IlBteWSQkcTLTkZ+MZHOrSNhdn2dolG
         qy49cB/GkR62W+5AES53CbeoNsVXnaowxSE+0T9iPkDS24ASEpnk3VQcpd+MLm9bKUzG
         Kzlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=No0vuIKUUWd8wCmisiET3NNJ4gz4w6NOLgT4BfCkyhQ=;
        b=ta98ac10sPjuKymtzCwR3aHdkON5Kr1YaYaXPPPmCdzTaw0W7o5vv3yLf7IbG4AG2S
         gU5qqgde9TZIbOOjN0y5VRKo29+FCXk6CWbr4G0oQ2SvVfQ197SEvcQGbNeYTinAxPsp
         9PZjQRo6vxhgLxL3Xbdh2GAFZeExNm6fpWtukSl20g/4EJHkblTNwGtNdRGjlm5AJ3L4
         8c3SPAvJ8EJT8nnLFpqUNCwYj8DlR+JkOwWDlC2BkFS+1j5N2nJn0qFLbUjbVNrOLL+H
         YL/L8zrossVgslRnx6m+f12on3MIp4IItvLdkpze/gD0G4mBov6McNdL0StA1immvTQK
         s07g==
X-Gm-Message-State: AOAM531Fe5gWAmM4m9fj+Plx6rocF5mG8ZOIMVoeysqrqDMJMfbKAtuj
        Ix0Y8fvv9FpZBAdoqcL91wY8ul+TOz0=
X-Google-Smtp-Source: ABdhPJzOl0Cte2Vm0yiVOC/CDVQJAxTxpFcgmanw1wd4Ourf3qSyG12kDlh3mFr59BIhCW1hOS0Pfw==
X-Received: by 2002:a9d:7586:: with SMTP id s6mr22272301otk.158.1637855125481;
        Thu, 25 Nov 2021 07:45:25 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z2sm562257oto.38.2021.11.25.07.45.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 07:45:24 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20211125125641.226524689@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 4.9 000/206] 4.9.291-rc2 review
Message-ID: <dd620210-af02-189c-f972-e31bd21008b4@roeck-us.net>
Date:   Thu, 25 Nov 2021 07:45:22 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211125125641.226524689@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/25/21 4:57 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.291 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Nov 2021 12:56:08 +0000.
> Anything received after that time might be too late.
> 

In file included from arch/sh/mm/init.c:25:
arch/sh/include/asm/tlb.h:118:15: error: return type defaults to 'int' [-Werror=return-type]
   118 | static inline tlb_flush_pmd_range(struct mmu_gather *tlb, unsigned long address,

The problem affects v4.9.y, v4.14.y, and v4.19.y.

Commit aca917cb287ba99c5 ("hugetlbfs: flush TLBs correctly after huge_pmd_unshare")
doesn't really match the upstream commit and obviously was not even build tested
on sh (and I would suspect it was not tested on other architectures either).
It seems to me that it may do more harm than good.

Guenter
