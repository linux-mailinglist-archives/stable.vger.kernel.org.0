Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84C88F9877
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 19:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfKLSUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 13:20:20 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35695 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbfKLSUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 13:20:20 -0500
Received: by mail-pg1-f194.google.com with SMTP id q22so12409250pgk.2;
        Tue, 12 Nov 2019 10:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fZ+fG8ppVexF4LjsLNnoTQsOX7BLCAq55QXOv1gfMPk=;
        b=LvWssALG4HnY3vyOBcqSMNWyUy+AEhLyhxY1QCrDOjI7uxGE9xNQHmtmZktPQ0t+Zq
         VmnbXR0jY2GShjS8mp4/N1gAMdiYGf4TJksyXamiK4KaaGb8UeMx4AS4PgGAi1AFEDv1
         meSMH/SRVvD/VEvOlxE3AwD/LAi4EjNkILUS8oJPAhQyRXFKHRaR7RF5BftNzLDgz9i6
         2Zq2JEjCmyEQWhcRzX0F2FwMWOk0P9goxoPX1ij+nDcyzRaBQe/auDvkzqhRl4s59ICP
         1c3fwC4hPc/0JMOgYvZt9MTmO8SuHVmx9bSuR208ORA+UR5YiyPrXJmLnIF3f2HLYoNo
         KjNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=fZ+fG8ppVexF4LjsLNnoTQsOX7BLCAq55QXOv1gfMPk=;
        b=DGLDZJDP384lmO2EPGsGVtQhRsY3rCrrVsWtZuCYtNCsUUTTwlimbVnejcTu8shA8F
         Vq3gVi97AdqHdof4L0s9eq2Bjql1PGHQRhUJq9l2dgiUToiiFPcKmfdFQR6HHCP1Dnj4
         6BlehEDar3/OTJ3kLscAIyuw76CDmVpA7bgbhLxPyj3Ae93Ka2mcKH5DjmFfafMpDon2
         gaHKFSm0MgBB8k93xWVu5MT2+ocVy1hHw99h9+jsDyI/faR7BD4uFfOqX04oH6UTFe+I
         mXkOFJk2znGco5fj4+PG8Yd2XKYdezCTH/2PJ+WVTnar4k4tAxwrbApNvLuJ2GddNs0V
         HhLA==
X-Gm-Message-State: APjAAAVeN5y+9CUJUqiEm4CQykTIAiqmr9CTDnYZBDkjHE53sYAyfJ5J
        5pJ8xHtj/ShZD9sHGHKQdKA=
X-Google-Smtp-Source: APXvYqzoonJh2zHBT6wOUC52VewKHnteA3t80KkPSPRrBQL0dIdSXN0bC26uB7o/EmVsrJk1bqg7CQ==
X-Received: by 2002:a17:90a:d102:: with SMTP id l2mr8584829pju.132.1573582818294;
        Tue, 12 Nov 2019 10:20:18 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 136sm12912475pfb.49.2019.11.12.10.20.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Nov 2019 10:20:17 -0800 (PST)
Date:   Tue, 12 Nov 2019 10:20:17 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/125] 4.19.84-stable review
Message-ID: <20191112182016.GE30127@roeck-us.net>
References: <20191111181438.945353076@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 07:27:19PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.84 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Nov 2019 18:08:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
