Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C577A2BC63
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 01:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfE0Xly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 19:41:54 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35952 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbfE0Xlx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 May 2019 19:41:53 -0400
Received: by mail-pg1-f196.google.com with SMTP id a3so9794284pgb.3
        for <stable@vger.kernel.org>; Mon, 27 May 2019 16:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:from:to:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1+HkNg93mJQ38uQbeJtA0ojvONF3YKeoTnZWRzUfY18=;
        b=Xgy5CjuArd7xtFJgyNgvF4HkC5GpHaX0V9CHF/rVrZl7MmLVOEHfiYwGFUCtTCrXt/
         SOQUIkDXiTodJ4jX5u0CN4vKPQoFpRJYsLlkyfL4qeKb1yn6HhLYQ+SsryETBBi0Wx1f
         0DMnAXrN0330MZkAqAqR9n4ShxmKDhJb04i3jslN/kL4VX3wUM9WBXmvgYXgVKOvU+sk
         HwDXMsC5ypB+Kg8MnMtbPtTlEmdpjoZ4kY8891jftDWA+ANlNLvwhS0btnULt/XN2ZSx
         OHrUIqzxdjILbYAMDJWRXNCpChOrt5cXV6/2ow0FqMvHswIB+dc88hnTdYrmBA0VI/sa
         pGwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:from:to:references:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1+HkNg93mJQ38uQbeJtA0ojvONF3YKeoTnZWRzUfY18=;
        b=Abhd7HApvDFBb1UB6NEAP3V7X0dpkP6gzqpmJL42z9PIySPxjPPDggYpM5eO/69XBW
         F7P/E0s0qK7pBLE+XrMn25C26NSwQ029j9hObTKmD7zrpwSyKrKepLvFzFodvibHf0zM
         lAJzZW0q+ue51a2+zPzUAvuz1vyN7SFKO8ojHjTT/n11zGY2eM8jlV0M3NbX57iIAm//
         XFhlecHU2yd5Mo/cZ6ibNxDWtycoOsz2xj5wNzjrL55Owy9eSRPUj8kQ74lbF7w2xg7b
         tTcXMjwAs8lqIzg7T8B8VxlSFzYU0VGfGFXu8gSsObXfNOyD1/l2hHKE6oq5DB4w44lU
         9Z5Q==
X-Gm-Message-State: APjAAAWQ9Bn4Fi8b7TVaEmidIuuvCxBuhJUqvPeaG2WpuHReqcJHzFYe
        cuktHErBkWOE5uqsZp9kKMVyuXhV
X-Google-Smtp-Source: APXvYqw5O5b/GnqeRniLonFy6dgM5yzMQbQ6SmJebeHTNZrduEfGhPr8JAqLHjNLhpW+we1QHtjfDg==
X-Received: by 2002:a17:90a:80c7:: with SMTP id k7mr1535617pjw.90.1559000513227;
        Mon, 27 May 2019 16:41:53 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h123sm12993752pfe.80.2019.05.27.16.41.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 16:41:52 -0700 (PDT)
Subject: Re: Build failures in v4.14.y, v4.19.y, v5.0.y, v5.1.y
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <14854627-178c-ed40-d8cf-913035167df8@roeck-us.net>
Message-ID: <b68aabcb-eb5a-561d-225c-6ebcf84870d7@roeck-us.net>
Date:   Mon, 27 May 2019 16:41:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <14854627-178c-ed40-d8cf-913035167df8@roeck-us.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/27/19 4:39 PM, Guenter Roeck wrote:
> The following build failure affects all stable releases starting with v4.14.y.
> v4.9.y and earlier are not affected.
> 
Additional information: v4.14.121, v4.19.45, v5.0.18, and v5.1.4 are not affected.

Guenter

> Guenter
> 
> ---
> Build reference: v4.14.122
> gcc version: x86_64-linux-gcc.br_real (Buildroot 2017.02) 6.3.0
> 
> Building um:defconfig ... failed
> --------------
> Error log:
> In file included from /opt/buildbot/slave/stable-queue-4.14/build/arch/x86/um/../kernel/module.c:34:0:
> /opt/buildbot/slave/stable-queue-4.14/build/arch/x86/include/asm/text-patching.h: In function ‘int3_emulate_jmp’:
> /opt/buildbot/slave/stable-queue-4.14/build/arch/x86/include/asm/text-patching.h:43:6: error: ‘struct pt_regs’ has no member named ‘ip’
>    regs->ip = ip;
>        ^~
> /opt/buildbot/slave/stable-queue-4.14/build/arch/x86/include/asm/text-patching.h: In function ‘int3_emulate_push’:
> /opt/buildbot/slave/stable-queue-4.14/build/arch/x86/include/asm/text-patching.h:58:6: error: ‘struct pt_regs’ has no member named ‘sp’
>    regs->sp -= sizeof(unsigned long);
>        ^~
> /opt/buildbot/slave/stable-queue-4.14/build/arch/x86/include/asm/text-patching.h:59:24: error: ‘struct pt_regs’ has no member named ‘sp’
>    *(unsigned long *)regs->sp = val;
>                          ^~
> /opt/buildbot/slave/stable-queue-4.14/build/arch/x86/include/asm/text-patching.h: In function ‘int3_emulate_call’:
> /opt/buildbot/slave/stable-queue-4.14/build/arch/x86/include/asm/text-patching.h:64:30: error: ‘struct pt_regs’ has no member named ‘ip’
>    int3_emulate_push(regs, regs->ip - INT3_INSN_SIZE + CALL_INSN_SIZE);
>                                ^~
> make[2]: *** [arch/x86/um/../kernel/module.o] Error 1

