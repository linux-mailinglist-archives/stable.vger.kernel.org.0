Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB94E2BC60
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 01:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfE0Xjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 19:39:55 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42218 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbfE0Xjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 May 2019 19:39:54 -0400
Received: by mail-pf1-f193.google.com with SMTP id r22so7398604pfh.9
        for <stable@vger.kernel.org>; Mon, 27 May 2019 16:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=H0wSQSM7TgFEVj84DSzD2Y0P0tPJ1SfL2fDgtAF01Do=;
        b=OAfYXSWq3vZrgK9YHO0rtorVg+7r2KG6gmtQF4o3rN/rloy7P/nF0lCrYkRApLzm67
         qNrIqZFq5G3lmSnf29K9Ci5+KOUJlg4p4YVF/b7meSgYFnaWJhNg6xjNzekQ+jWNJSoo
         JHbkSoZl/TcqtOJPmFEDWOvC3y0re+lgiZqh1Tkeua+Pp3Ehx/u7ZctriYIkukac7V9N
         5s+40fZDCCra0emkghBU4p49s9WeVYMAY/b+SQ+fhQW3UXG+rac4HfMumIdCtPscLLiI
         POqptxHNRE8xXU1nr5hdFO/ce2AouMorn08ZJtS6p+wgSglxSjo1T410hhoG+Yzrexgm
         ZFgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=H0wSQSM7TgFEVj84DSzD2Y0P0tPJ1SfL2fDgtAF01Do=;
        b=UtJoStga8AFcEuleauptdzmtifkaw+MgRuXdP2k7yPCTUe9VeiOT92m0BQDnBQhac1
         inIAVoXDgMxDg7PlZkNe2Vq981gq208/OWKskTXRyLiEag+MDDOiK1JPhx9/bnwSFEmi
         EA4TnZBBwAVuPLJafPR9efwkfg3eMWblvZd8Anwv3QiB5G8AlWQMpuRFdayn3iBiHe++
         mq+AdYGVcgSoD+eq8by7QnLzJjelotuwO4gbHtwz48qpgbGsOfbZt+WFQEcrRgP9hyv3
         121uH/ZxqPbvZVtuaMmbpqUNhwxBpvMF1lQA3DVPGqKRv4RTmxiWCmI/sOU2SLyVlK9m
         w/tg==
X-Gm-Message-State: APjAAAWQ/2TNVKpj6te72Rl8ffVAqh7uYtsYf7KCzxCuRAT92mYZK5Cb
        GpBgMppsNIHwjoyVLgwe+JE=
X-Google-Smtp-Source: APXvYqxC//ooIAHHH26skI9havPGP5X8oJlZ936iCic4f8lYeN7oasyiP5zTJgF8UOmwDqame9tjlg==
X-Received: by 2002:a17:90a:a10f:: with SMTP id s15mr1580030pjp.30.1559000393984;
        Mon, 27 May 2019 16:39:53 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d14sm537249pjc.29.2019.05.27.16.39.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 16:39:53 -0700 (PDT)
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Build failures in v4.14.y, v4.19.y, v5.0.y, v5.1.y
Message-ID: <14854627-178c-ed40-d8cf-913035167df8@roeck-us.net>
Date:   Mon, 27 May 2019 16:39:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following build failure affects all stable releases starting with v4.14.y.
v4.9.y and earlier are not affected.

Guenter

---
Build reference: v4.14.122
gcc version: x86_64-linux-gcc.br_real (Buildroot 2017.02) 6.3.0

Building um:defconfig ... failed
--------------
Error log:
In file included from /opt/buildbot/slave/stable-queue-4.14/build/arch/x86/um/../kernel/module.c:34:0:
/opt/buildbot/slave/stable-queue-4.14/build/arch/x86/include/asm/text-patching.h: In function ‘int3_emulate_jmp’:
/opt/buildbot/slave/stable-queue-4.14/build/arch/x86/include/asm/text-patching.h:43:6: error: ‘struct pt_regs’ has no member named ‘ip’
   regs->ip = ip;
       ^~
/opt/buildbot/slave/stable-queue-4.14/build/arch/x86/include/asm/text-patching.h: In function ‘int3_emulate_push’:
/opt/buildbot/slave/stable-queue-4.14/build/arch/x86/include/asm/text-patching.h:58:6: error: ‘struct pt_regs’ has no member named ‘sp’
   regs->sp -= sizeof(unsigned long);
       ^~
/opt/buildbot/slave/stable-queue-4.14/build/arch/x86/include/asm/text-patching.h:59:24: error: ‘struct pt_regs’ has no member named ‘sp’
   *(unsigned long *)regs->sp = val;
                         ^~
/opt/buildbot/slave/stable-queue-4.14/build/arch/x86/include/asm/text-patching.h: In function ‘int3_emulate_call’:
/opt/buildbot/slave/stable-queue-4.14/build/arch/x86/include/asm/text-patching.h:64:30: error: ‘struct pt_regs’ has no member named ‘ip’
   int3_emulate_push(regs, regs->ip - INT3_INSN_SIZE + CALL_INSN_SIZE);
                               ^~
make[2]: *** [arch/x86/um/../kernel/module.o] Error 1
