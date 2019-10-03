Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8E96CAF0C
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 21:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbfJCTSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 15:18:07 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38610 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728610AbfJCTSH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 15:18:07 -0400
Received: by mail-ed1-f66.google.com with SMTP id l21so3639245edr.5
        for <stable@vger.kernel.org>; Thu, 03 Oct 2019 12:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=O3JmB4BdXGl28zMMr0T0pMzRCDjIhAyxIK59E3bU/HY=;
        b=Ajn5ocgwHlPa8vs6tJ8Dr+wEkW2JICbiovNlxrH8WgCGWYAxq2e9jCvOV+yVNU4oyj
         qyWlvZlW+St+A9GU8lMIK7JyT1sDH7yR7EMxnYQ6rK5qVqSlXRc+QAIciEq5aJvEHXHi
         xCTjDmUSv+aw+RpgE1kKucCLljc3mEORGNQXD/7KpQjVfRojtUxgbRY3Qo25AyQlDDzO
         TxOaGG0ePNWdmQ+72fDl4CiVLEKRAfui6SxOSNhwhQebU/POYYUig2MbH8JE8iw5hKvz
         s6BSOkALtBC4YBstYdXFaVC0SyTilOVSafhZsxCA2nQEAwuz39fgpRM5ShV0dL75oHZd
         ErVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=O3JmB4BdXGl28zMMr0T0pMzRCDjIhAyxIK59E3bU/HY=;
        b=Et2OMJdNGgwTuli5u+zHY0ydJ7PaqDF/9w4Ul3pc2rzWS04tVVrnjnex+bbUUAKr9u
         aLjqu5iN0EpkcHdskdcP2IQP2bAUl+Q9K+6xjBfVYY9mPjKGacTsW2NEHQy5lzJlFvG9
         wY4sBFkOK2z9PLtZQyM9N3nsJrSOGpmlBUSd8cdbg4T04iKfXGpL0eyCqBJFhLwrhiAO
         HXSwIsAyKAUlqtN4io78old8xj4IsG8CherPYIwl4ZF7x4w4/BN97kNc2SG2zdXR8L/G
         qooyV+3ovVrpw6kr+zdjPbzoDjavawxQ8XMJSCflbRChgDwV8ImFp7P70fk8/UeK97hs
         IB8w==
X-Gm-Message-State: APjAAAW/ouH0ohr0Jqg1M3ELRNzCqlvBLP2AsbVwD/hWtK6UrgBhy0bB
        GVPARhTJej87mWjfXYFgtsms28bbD2+ftQ==
X-Google-Smtp-Source: APXvYqwEVPlf/CHRXkfUOetXmf4BLjLrD/2h08OfDojhNm8YNaN9bWYBdBVD4dN2vC12GzfUSl6RqA==
X-Received: by 2002:a17:906:5644:: with SMTP id v4mr9030922ejr.52.1570130285591;
        Thu, 03 Oct 2019 12:18:05 -0700 (PDT)
Received: from [192.168.1.2] (host-109-89-151-97.dynamic.voo.be. [109.89.151.97])
        by smtp.gmail.com with ESMTPSA id w21sm644354eda.90.2019.10.03.12.18.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2019 12:18:04 -0700 (PDT)
Subject: Re: [PATCH 4.19 000/211] 4.19.77-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20191003154447.010950442@linuxfoundation.org>
 <ea824819-1047-e74b-2e71-814c3c2756e9@gmail.com>
 <20191003191016.GB3585751@kroah.com>
From:   =?UTF-8?Q?Fran=c3=a7ois_Valenduc?= <francoisvalenduc@gmail.com>
Message-ID: <00f259ab-2bcf-21b3-e705-f3d2a2e707f4@gmail.com>
Date:   Thu, 3 Oct 2019 21:18:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191003191016.GB3585751@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: fr-moderne
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Le 3/10/19 à 21:10, Greg Kroah-Hartman a écrit :
> On Thu, Oct 03, 2019 at 09:02:23PM +0200, François Valenduc wrote:
>> This does not compile. I get this error:
>>
>>   CC      drivers/ras/debugfs.o
>> drivers/ras/debugfs.c:9:5: error: redefinition of 'ras_userspace_consumers'
>>  int ras_userspace_consumers(void)
>>      ^~~~~~~~~~~~~~~~~~~~~~~
>> In file included from drivers/ras/debugfs.c:2:
>> ./include/linux/ras.h:14:19: note: previous definition of
>> 'ras_userspace_consumers' was here
>>  static inline int ras_userspace_consumers(void) { return 0; }
>>                    ^~~~~~~~~~~~~~~~~~~~~~~
>> drivers/ras/debugfs.c:39:12: error: redefinition of 'ras_add_daemon_trace'
>>  int __init ras_add_daemon_trace(void)
>>             ^~~~~~~~~~~~~~~~~~~~
>> In file included from drivers/ras/debugfs.c:2:
>> ./include/linux/ras.h:16:19: note: previous definition of
>> 'ras_add_daemon_trace' was here
>>  static inline int ras_add_daemon_trace(void) { return 0; }
>>                    ^~~~~~~~~~~~~~~~~~~~
>> drivers/ras/debugfs.c:55:13: error: redefinition of 'ras_debugfs_init'
>>  void __init ras_debugfs_init(void)
>>              ^~~~~~~~~~~~~~~~
>> In file included from drivers/ras/debugfs.c:2:
>> ./include/linux/ras.h:15:20: note: previous definition of
>> 'ras_debugfs_init' was here
>>  static inline void ras_debugfs_init(void) { }
>>                     ^~~~~~~~~~~~~~~~
>> make[2]: *** [scripts/Makefile.build:304: drivers/ras/debugfs.o] Error 1
>> make[1]: *** [scripts/Makefile.build:544: drivers/ras] Error 2
>> make: *** [Makefile:1046: drivers] Error 2
>> zsh: exit 2     LANG="C" make
>>
>>
>> Does somebody have an idea about this ?
> If you add b6ff24f7b510 ("RAS: Build debugfs.o only when enabled in
> Kconfig") to your tree, does that solve the issue?
>
> This should not be a new thing right?
>
> And is this riscv?
>
> thanks,
>
> greg k-h

This indeed works with a trivially modified version of the patch. The
original one doesn't apply because apparently of the SPDX identiers.
This one works:

diff --git a/drivers/ras/Makefile b/drivers/ras/Makefile
index 7b26dd3aa5d0..6a2a7da37e61 100644
--- a/drivers/ras/Makefile
+++ b/drivers/ras/Makefile
@@ -1,2 +1,3 @@
-obj-$(CONFIG_RAS)      += ras.o debugfs.o
+obj-$(CONFIG_RAS)      += ras.o
+obj-$(CONFIG_DEBUG_FS) += debugfs.o
 obj-$(CONFIG_RAS_CEC)  += cec.o

And this is on x86.

François Valenduc

