Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A874ADF8B
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 21:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405744AbfIITj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 15:39:28 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42156 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405742AbfIITj2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 15:39:28 -0400
Received: by mail-pf1-f196.google.com with SMTP id w22so9854365pfi.9;
        Mon, 09 Sep 2019 12:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vTBJpu0XjQ8sfwEZz8qBZMfA0LRuklcy0qqVv8kCRaw=;
        b=VYcOB8p0Tq48PWKkXGGnQsu4OD0YIZH1qcHDegEOnF3Mowdf1c8XAGOSrlBWcy5vOv
         ZtFvf2EiKYOdwVBe0SNuGknvVSf5HzVoXiOx1ruiLUDvfLLS/p/1AFuSy8h4T/zb4+eB
         TNQmmpJtfiAM+RhIM4iHad5hvig9dFTQroUbonK9bnPO5HPinPnjq/7bVmdSymUFEvPj
         DAaUXeea4fvEfRoMz1Vo2ttIHWaKyWcnf0q1I/LrQkpo/T59T7pMt0VqLci+HpruoEWM
         R+vYV+W9fMurq3lxtXrtNYtBlWAn8M93OxvpEwNASoZQoDPiMTCI8pE2KHlZfGwQ4Mll
         Y3AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=vTBJpu0XjQ8sfwEZz8qBZMfA0LRuklcy0qqVv8kCRaw=;
        b=KvKhAVWEzG9PLwLZ9GwLoSiVsKzHGMfxJPPLYL+MqqtM1mWGtD1Mqsq5wo173U7Jp2
         rxzxydo2UxHvykxI3rz/X3g7t5cMBIyjY2PqS24r9qZqLYlN/kkcvn4ax/NWNtwspOC0
         BUlOQP9RiSvLGypkdPgC0A4kX7laSZ9iIV2TTfFnmAvHB0W69pXWqtBC/Waw5Iwr3zps
         W7Lg9EsEXRW0hI75olB5U5j010qxhg78fxrO8AKW9irYJKpfdrjHVLY5E1ETDg2xDfXi
         VamesiKa8FbmAq16ya+iTr4Z8QPWKNSl/oyHZrHIwS709qQ7T0k8nl5tYD2cXjkWwTtW
         zWGQ==
X-Gm-Message-State: APjAAAXvzKxSurFkNTQF6DYDvNn2RiqkQcOLPdiOBZuoaY3h3SQQxQJv
        djDs/IwWJOrFS0ZeVp8UZMY=
X-Google-Smtp-Source: APXvYqwfz2PH9bmFtlIvnP/56LiKC6u2KHS8NcDd6L9Ac8lcV0+G8/Wq0OH3cSdAueFfKs2a1Vg8EA==
X-Received: by 2002:a05:6a00:8c:: with SMTP id c12mr28822236pfj.200.1568057966210;
        Mon, 09 Sep 2019 12:39:26 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t125sm21464819pfc.80.2019.09.09.12.39.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 12:39:25 -0700 (PDT)
Date:   Mon, 9 Sep 2019 12:39:24 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/40] 4.14.143-stable review
Message-ID: <20190909193924.GB22633@roeck-us.net>
References: <20190908121114.260662089@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190908121114.260662089@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 08, 2019 at 01:41:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.143 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 10 Sep 2019 12:09:36 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 372 pass: 372 fail: 0

Guenter
