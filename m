Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA86A1F88F
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 18:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfEOQ0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 12:26:43 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39648 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727210AbfEOQ0m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 12:26:42 -0400
Received: by mail-pf1-f196.google.com with SMTP id z26so232564pfg.6;
        Wed, 15 May 2019 09:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F0bn/v684zLzhOA5jqU4X2gfQAg+CBVsTZKM84TmUik=;
        b=pYGYr5l8QIibLVX6Ur8mbibQm/o+//ymxDRChD/nGfhBvSo7z/wW8VLq4N2t+aBkK6
         a61mJiMyB6nJzN2kRiL3LNcJE+D2zS5mJRzzXTP/efZV2QuHm78I6WK/oF0Y9O3IS81F
         +39Ec1HU/ojlwQUDoMlVL0bc5AiJyLzrmoWJFPQ2izhk9wy/LvhvwvdIbTnBVlC6Oy/v
         WjoFTvij2Xn2IhjoAPxRcnXWYN+eKTfxBaGRo8DU+Tglpgnkig7vj/vZZCavy8ljJnsW
         ix03WWBwFbEpy24li3PhtQ+FwMOmYDLlxnMUBjStoZ+DbAU/2AhlCtf7o4mU7R+m098X
         9c0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=F0bn/v684zLzhOA5jqU4X2gfQAg+CBVsTZKM84TmUik=;
        b=JrIB+VagbZE8TAwri1cTecZch/VPIK+cXz0p9u3Sax0gjabF7xrj2yFzkUDdJ5CZcP
         1tLEHmSF3n4g3VGOyhBByMB171bY7TZx0V6UC2HqkJyTcARkLNySZRqZozOkt8bSZFUp
         xrK/s+saGvMyOigJOILKA6AlUCY3KHl76945ZjcbpjeevJ050aonXal+sinEtk2p98PJ
         XIwZCKOtZjfbyLPUuGOVbW/VkbYoKj97ZLuX5jSltwWSkubn51L15Q34pDHLvg/gtTfp
         0s9KG/+C7sm4YgAqC0a3TQ8N+N1h6UqFIyL6HXbZ8607RUWoCBGX6uan0r2xjS9CAKA5
         8yHw==
X-Gm-Message-State: APjAAAWhkdysgjV3oamztdYzWvIXHYl0sTsohgGg6/toP4uroZCjBFAM
        oIdcGh1Qn8gVjiDCKmUvqXU=
X-Google-Smtp-Source: APXvYqx0qF2+Nm8DFCMcw0LmHJmMeggpzcW190TV9S0nsvCx01e8G7w2Lrh0z2xHoUOyWV4wMJbkzQ==
X-Received: by 2002:a63:61cf:: with SMTP id v198mr45198947pgb.29.1557937601240;
        Wed, 15 May 2019 09:26:41 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h18sm2881575pgv.38.2019.05.15.09.26.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 09:26:39 -0700 (PDT)
Date:   Wed, 15 May 2019 09:26:38 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/115] 4.14.120-stable review
Message-ID: <20190515162638.GA25612@roeck-us.net>
References: <20190515090659.123121100@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 15, 2019 at 12:54:40PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.120 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 17 May 2019 09:04:39 AM UTC.
> Anything received after that time might be too late.
> 

There is a build error with s390 builds.

arch/s390/kernel/nospec-branch.c: In function 'nospec_auto_detect':
arch/s390/kernel/nospec-branch.c:84:19: error:
	invalid storage class for function 'spectre_v2_setup_early'

arch/s390/kernel/nospec-branch.c:96:27: error:
	initializer element is not constant

and more. The file has merge damage in function nospec_auto_detect().
Culprit is commit 91788fcb21d0 ("s390/speculation: Support 'mitigations='
cmdline option"). That patch is in v4.14.119, so you'll have to patch
it up manually. Example patch (compile tested) below.

Guenter

---
From c4430ee29bf57cb1327d52b38acf3f616be9d7f5 Mon Sep 17 00:00:00 2001
From: Guenter Roeck <linux@roeck-us.net>
Date: Wed, 15 May 2019 09:22:31 -0700
Subject: [PATCH] s390/speculation: Fix build error caused by bad backport

The backport of commit 0336e04a6520 ("s390/speculation: Support
'mitigations=' cmdline option") introduces a build error. Fix it up.

Fixes: 91788fcb21d0 ("s390/speculation: Support 'mitigations=' cmdline option")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/s390/kernel/nospec-branch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/kernel/nospec-branch.c b/arch/s390/kernel/nospec-branch.c
index 83e597688562..6956902bba12 100644
--- a/arch/s390/kernel/nospec-branch.c
+++ b/arch/s390/kernel/nospec-branch.c
@@ -66,6 +66,7 @@ void __init nospec_auto_detect(void)
 		if (IS_ENABLED(CC_USING_EXPOLINE))
 			nospec_disable = 1;
 		__clear_facility(82, S390_lowcore.alt_stfle_fac_list);
+	}
 	if (IS_ENABLED(CC_USING_EXPOLINE)) {
 		/*
 		 * The kernel has been compiled with expolines.
-- 
2.7.4

