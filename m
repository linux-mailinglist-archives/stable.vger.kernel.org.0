Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 541BA113564
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 20:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbfLDTFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 14:05:07 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35354 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728114AbfLDTFH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 14:05:07 -0500
Received: by mail-pg1-f193.google.com with SMTP id l24so311095pgk.2;
        Wed, 04 Dec 2019 11:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pQ1mLyqjahNhLnTegXayzsOSqrUzeJV5uu9HLCvBzBg=;
        b=MRhMPt4knHXqTz1/88Nn3+a0gr1x/O4ryhvFqpbX0FKW5lo5P44oMU5VvymDguKprJ
         x3+nCJJ9cNWyNLPLj/h5VFfNoBWZVLdKZkcc+kAbI7TdbUGZ+i2hsuJ/xpWWxictJQ0W
         jWlxDKp0F3ej7mn6IbuPbZlRvZlUeXTgssmi4rIxQqcU1Bom9kPR5dVm3jy45hfw/zRL
         +omVs3wKUZlKAFoSooBHO8UGKFVJ0fG0nq7+B+gcuzlaHSNNLpUIIcPUbaWh7qk7FtXx
         3yfx4m0agPnx2z2IwqYVFB8RRCM44/GoNBwh1aUhbKBfMa9p31QrE4l6VQSCEUeF7yR5
         s43Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=pQ1mLyqjahNhLnTegXayzsOSqrUzeJV5uu9HLCvBzBg=;
        b=d/u1biuN3R7vDts627A/B8ltCqnUG5INSZ22C6kyetJTMUoJ6ioAzYjBBlMc7vcXJf
         6zlMzMgN3Ximav5gpBsjRRrIEl/ABwLEcDJ1OvKWmc10i5zwfDojGRFQnuVfiiurATxx
         FKrtzcas35EHgC+i0G2VsMdT9vEYH593/M5i0LsMH1P90M7RN1arwglGzwUwCzE8KLYF
         C8CqaoZNVWU5pYmr0AlsprffMkHhzzj80V08W7S/uYqy8csXqxkq0n8xmNu7JbV+Uzrk
         +YjcXoU/+befW+hzGETVvViU0SPF3gtesOJRfZud/LVUholfgji1+r32vHvfwmtm2/fC
         GOSA==
X-Gm-Message-State: APjAAAX/Q/Q674dWCmqp88IiQjlfRSp8X+s+6Y//TUL4XXM2ggDv1vTA
        v27jqRj8pu+eOp8euXc25GA=
X-Google-Smtp-Source: APXvYqxdb9XaF+w/s6bZIB0G9YdWXO+lvj0xGVfhM4aUqGRD4Ulot/aYTTy7mkEuBtk1MPrCMsyNeA==
X-Received: by 2002:a65:4cc9:: with SMTP id n9mr5330098pgt.426.1575486306588;
        Wed, 04 Dec 2019 11:05:06 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r6sm6722000pfh.91.2019.12.04.11.05.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 04 Dec 2019 11:05:05 -0800 (PST)
Date:   Wed, 4 Dec 2019 11:05:05 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.3 000/135] 5.3.15-stable review
Message-ID: <20191204190505.GC11419@roeck-us.net>
References: <20191203213005.828543156@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 03, 2019 at 11:34:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.15 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Dec 2019 21:20:36 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 391 pass: 391 fail: 0

Guenter
