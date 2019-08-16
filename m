Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E06F3903E3
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 16:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfHPOUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 10:20:46 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41368 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727365AbfHPOUp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 10:20:45 -0400
Received: by mail-pl1-f194.google.com with SMTP id m9so2504590pls.8
        for <stable@vger.kernel.org>; Fri, 16 Aug 2019 07:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fu+P3/a+1rC8rZw3Gt8TiaXxYRTXamUs9fDcY+0m0HI=;
        b=In9xW0iFA6WQomqB28O3E74hynrni7Gz1trvj0bDzhPmgmkTmp1aCpOGRP7dCnTeOp
         AgPIaWtWncH0ufUpW7I1atzs15KEkwDc9NyyeuI+82ZjxEpUtV736clbGeP6rIVuq89C
         zuWlr0Gr7NYSTygP7ELUWufE7fgFS+IwHYkpUGXcxMJpZ49P5D98d8ThJce9R8Fn+k3v
         tmZ2tCfR0tNnC39tFdCJ9eQzGx0o1r7dXbtEVx7tnueZ38sPbhfGsNtNnWytqarcYf0l
         zg5L84Wk0E2iUOE5wTSLlczPHObOPHxZu2Dwz0218eo+0Ci8pS2vFEmDsdQECawCJ00N
         aysw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fu+P3/a+1rC8rZw3Gt8TiaXxYRTXamUs9fDcY+0m0HI=;
        b=PbxLp9+iHhLqFZhbBhPSkfhu8kM47rwiISso5treI1vtjH2ir970LnzChggma5snAH
         DycOSc9TmutYrHJvfD2w31E28l5H7Vyh7iDDpcF5MaYI4j/bNxOWwgE5GltI0D9wWgjR
         g7UcLSni6ztgHq8jtAvdPMLLwRxHZbEJkTxzrErHmgiydnk7z+nuSWdklwYgl+GmSJjb
         iEJMRmIrLhcBPmDHHciATvo2FK2OybXiuU0YuufklONc7wDUNe9zVG3y1h+hVYnGF5wo
         9uMecU699QELs5ssOm6kipbMbxkVIiJIrNZnq+ac1CLCfTNV6+lER7NTqFsz5rNJJ3DU
         4ArA==
X-Gm-Message-State: APjAAAW5yYyj312DY6om4inCyCXMytB7Gubc0NRlxipqPgdxgmSt2V4I
        l1TU4TCZbJINHrkPqHX9BSo+bQ==
X-Google-Smtp-Source: APXvYqwVoge3HO3eQudhtz14WRTcXikDJEruLSRjcdra21rftjb2fcmmOiACkbGPUEkw3CWjghfVlw==
X-Received: by 2002:a17:902:760c:: with SMTP id k12mr9115512pll.206.1565965245063;
        Fri, 16 Aug 2019 07:20:45 -0700 (PDT)
Received: from [192.168.1.188] (66.29.164.166.static.utbb.net. [66.29.164.166])
        by smtp.gmail.com with ESMTPSA id 143sm9039470pgc.6.2019.08.16.07.20.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 07:20:44 -0700 (PDT)
Subject: Re: [PATCH] blk-mq: remove blk_mq_hw_sysfs_cpus
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, stable@vger.kernel.org,
        Mark Ray <mark.ray@hpe.com>,
        Greg KH <gregkh@linuxfoundation.org>
References: <20190816074849.7197-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5baa0c28-6e12-5a61-0254-de0e49cf1596@kernel.dk>
Date:   Fri, 16 Aug 2019 08:20:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190816074849.7197-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/16/19 1:48 AM, Ming Lei wrote:
> It is reported that sysfs buffer overflow can be triggered in case
> of too many CPU cores(>841 on 4K PAGE_SIZE) when showing CPUs in
> blk_mq_hw_sysfs_cpus_show().
> 
> This info isn't useful, given users may retrieve the CPU list
> from sw queue entries under same kobject dir, so far not see
> any active users.
> 
> So remove the entry as suggested by Greg.

I think that's a bit frivolous, there could very well be scripts or
apps that use it. Let's just fix the overflow.

-- 
Jens Axboe

