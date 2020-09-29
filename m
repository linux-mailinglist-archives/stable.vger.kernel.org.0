Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450AA27D9C0
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 23:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbgI2VIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 17:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727347AbgI2VIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 17:08:11 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9A0C061755;
        Tue, 29 Sep 2020 14:08:11 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id 95so5847984ota.13;
        Tue, 29 Sep 2020 14:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=PlmNXw7ZpFTwSV3L+F5jDFoW1vvdajkclsGk3mMsf4k=;
        b=mXmdQXAsrxqScrzTvmHDTNHXXq/PBtM6GvG22NOOWp8K5sqChjRxJYFMi9JfMCiW1A
         yGXoIzQK60jUF06Zrxpj8jn0nAxuHiwim01gSOKBFSA9eL+SZPjsPvxXkTahWnAx5OTx
         jRJ9LZIVMquVE8YzPGNaW/i5qW+FtqJ5DrA2XNr1konCcDZr/d+LzQ3N/hSRkEx4xOA6
         cbiW3TMHroFVDHbYwEqkv7txMjv2vIZZh04wiEOvHaWE3NeB472Iq/ji133B5BzFcLoc
         XPND7vGkt2msl4r0/fDWKgTFePxHgneXH3OUUBg4gknHY18jBmDBXcU/9ysdChS9eMkD
         AW4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=PlmNXw7ZpFTwSV3L+F5jDFoW1vvdajkclsGk3mMsf4k=;
        b=U6symX+C+lrobPdUP+3qg847HPmGH5UuaI4+ItRJAia4vbg9uDE4XA08Wx2VCYmnGt
         yPi1eDvHMAADLR2ZDeYS1i7xvKVhv62GfgQnPspmlVcqLtG2obhxcgAEDPybDfMmsV4P
         mj9t6qAiloD43PMNZRneOQte9q2XibS4MKphE3SpPvUfBF8SVOj1eYNrOnAG93K07I9G
         HsvBmMAveQpyKtqfXakRoUeq9N2/28fvASjLvV1F7sAAGZNKARV6VGy/wS+3zQbnhGTb
         oqBkWM1OBkQf+VO066BXORSjTQcDje+LcqgZ+eD9Qm8iolhkQ+2ivI1MoOoUheNFhfvu
         kw6Q==
X-Gm-Message-State: AOAM532RRCaE6C0S7ndGyLKwVfHZT01CEfNYgbs+rlrPXTSw0s5D5/Xm
        e1XVZgLORqv+K7bSF90GGSA=
X-Google-Smtp-Source: ABdhPJxPrDKCJz+3VJEX/ZpKrEq+OWZrCRe2f53nK42EpGgT86sw4rpedKOYdAnMc+C8WB8Ls5li/Q==
X-Received: by 2002:a9d:4cd:: with SMTP id 71mr3891833otm.276.1601413690631;
        Tue, 29 Sep 2020 14:08:10 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m12sm1283417otq.8.2020.09.29.14.08.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Sep 2020 14:08:10 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 29 Sep 2020 14:08:09 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/244] 4.19.149-rc2 review
Message-ID: <20200929210809.GA154271@roeck-us.net>
References: <20200929142826.951084251@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200929142826.951084251@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 04:29:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.149 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Oct 2020 14:27:43 +0000.
> Anything received after that time might be too late.
> 

For v4.19.148-245-g78ef55b:

Build results:
	total: 155 pass: 153 fail: 2
Failed builds:
	i386:tools/perf
	x86_64:tools/perf
Qemu test results:
	total: 421 pass: 421 fail: 0

perf build error:

util/evsel.c: In function ‘perf_evsel__exit’:
util/util.h:25:28: error: passing argument 1 of ‘free’ discards ‘const’ qualifier from pointer target type

Guenter
