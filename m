Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6CA36D569
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 21:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390937AbfGRTtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 15:49:09 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46240 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727687AbfGRTtJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 15:49:09 -0400
Received: by mail-pl1-f195.google.com with SMTP id c2so14367538plz.13;
        Thu, 18 Jul 2019 12:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=y1jbfwmGOLbCH3+K0FgAzpdU40mHgSAs55s79iVNAAA=;
        b=g7OtIpiLmV64npMcC4dqcJ6pHztipkVsipTnuJFXxdjUk5+zqvZx7caWmFvti5VjCd
         WdZ4pB5I/P7xWndLaC2UrqwzQHwcp/r2kpPuT5bu4zyoTHUwQF3awBtKgZo+srX83rar
         we/6rfhxeuC413gJlC//Jz6p755THB1bmQVmlowDuVObfglI/j86M4issOeYaV9l8FB6
         xHnYvrIgIYrx+zF9Pkiiii4ZXdvH4UT60TakhxtDndirGmyzcAEHE5qARC1C7zOsLM8+
         MpD2nK/z5Ej5WgFMPsyf3ymVjnxi2U/jLaQ8v8OX870QM8Xl9qROralmgP8mulmeCnXB
         nC9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=y1jbfwmGOLbCH3+K0FgAzpdU40mHgSAs55s79iVNAAA=;
        b=XzWYWX8EzlatvlGqVRXXxSh/MJd1EZ6JQvfb/1zPZPQ9DHr8UOSck4VNxVgDN4lIpW
         Iwat4QoQEmSTYGsNoZxVejZrQUXS5qTu9RBi+hKa6UfiYx4GZl4IXhQEeyGfrtqsDI6J
         qkBRLm5MOHubfh5mAVFsTaDi735d+24hnt423pLkyGu3+nAM0x+PNGz61hDH9JaqXGEv
         cg3IlJ7HXDBTprZoqh4/at1G2rEb655dj8VSegwdpGcNnL09Xe1PNAJYTUgG3iEBwjUs
         isK+VEiwonsKNlxQPseh1vHM+jR3nWP3Hl080dxV9CDqkXsQ39dSJdgNDOy50D2MX60B
         fmMg==
X-Gm-Message-State: APjAAAVjJ9mAEIigRjaLdlVkUWM7PKO5xMk7rBne9p7n6yMYoimCoPpl
        h4dZ3pDW1jYU3OIaJYXtuqI=
X-Google-Smtp-Source: APXvYqxH6WXlOB9GIUryyHbnNYn5g4LiXy7CnVNk7QjiPg30NciIvNg3iatxuuCYUgtOb8s4b8Mj0w==
X-Received: by 2002:a17:902:b186:: with SMTP id s6mr51850666plr.343.1563479348966;
        Thu, 18 Jul 2019 12:49:08 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o14sm26301527pjp.29.2019.07.18.12.49.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 12:49:08 -0700 (PDT)
Date:   Thu, 18 Jul 2019 12:49:07 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 00/21] 5.2.2-stable review
Message-ID: <20190718194907.GF24320@roeck-us.net>
References: <20190718030030.456918453@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718030030.456918453@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 12:01:18PM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.2 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 20 Jul 2019 02:59:27 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 364 pass: 364 fail: 0

Guenter
