Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C513169B26
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 01:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgBXARt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Feb 2020 19:17:49 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45022 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgBXARt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Feb 2020 19:17:49 -0500
Received: by mail-pf1-f196.google.com with SMTP id y5so4406383pfb.11;
        Sun, 23 Feb 2020 16:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H6q7nfEV4MDtglth++K8H942rxEUO2n9ZdDpRmR3CaA=;
        b=qv9sP1+2rCe5A5ByzXj7U3d42Sq5tlW/gJUmlG8P5dE9sgDfAnfEYaqiOn/8yns1qt
         cB/W4fPT09JsAssTLveLv3OzfQPBYFnf0qaO94nJAbUOZU7u4TPSOFqu+Wq6iYTUVTrZ
         nKFJBLcDwjbnexi8TRXXeRyyKnqsci1l/Du8k7Rna/gRvG+63O/GFikQlF1tyFlPXIel
         K9Trx5qplViS+b3NxpcPoAxFm1A9K6o1g8ckRLyH9dT7s+iEkyJSykMTp/1tvgfU47Bk
         XKr7VxuZzFtDO3CXZwE+2UoTcDiiXEx7X2cf6RpfxiO3lLOwsZYeP8wE/BDavkohqdzA
         e/oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H6q7nfEV4MDtglth++K8H942rxEUO2n9ZdDpRmR3CaA=;
        b=joVmjcpyAXyNztEBSzyczwFVmgtmg1hZORvkbNhcs6q5M/fU/XUsbxqSqZ0Ef7xweq
         qEMcCKJztsJXDt36Qkne3wUQ+G6OBdxa+QRYJ3Pd0PUY1jRv7Seo3SBdxkXN2X4ZZD0N
         7X388gVB/FIGhhFDxui1NL+mgrzmcahrioQYYUaK2Ac6HL/UI7hGHnNZqZZ8LG/lgiUg
         hhUyVMObPEuE4EYSnOu2TDjJRcKziikZQcsLXLiTbC4QPLSUqf4BPiIIsoupL0tpGNa/
         O1DWMouYs39tqjdGGAHhXNEr0JN9+s3mJhhHrGe1lS9QQWCyXbwjUbD6U3hbZYRsb3fr
         J4IA==
X-Gm-Message-State: APjAAAWSyxLRDvaHKzQFxsNPw1xvnFnnEG9Yo+9PxaPfJMYWH1SVvoZb
        MJr9PMLC0DV7ltuP3XbASBXMaZ+c
X-Google-Smtp-Source: APXvYqxItSynldxNjs+x2zPko9C0F3Uij0BrGNxNiPT3DuaA8vr/eIvgEgeQcRL6MjtP/7as7arhoA==
X-Received: by 2002:a63:340c:: with SMTP id b12mr45413623pga.180.1582503467147;
        Sun, 23 Feb 2020 16:17:47 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p21sm10144764pfn.103.2020.02.23.16.17.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2020 16:17:46 -0800 (PST)
Subject: Re: [PATCH 5.4 000/344] 5.4.22-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200221072349.335551332@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <2cc32a95-b781-41aa-b343-af153cd3fc8b@roeck-us.net>
Date:   Sun, 23 Feb 2020 16:17:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/20/20 11:36 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.22 release.
> There are 344 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Feb 2020 07:19:49 +0000.
> Anything received after that time might be too late.
> 

For v5.4.21-338-g3b5dde2478ad:

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 411 pass: 411 fail: 0

Guenter
