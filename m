Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02B0430307
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 21:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbfE3T4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 15:56:35 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36500 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfE3T4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 15:56:35 -0400
Received: by mail-pf1-f193.google.com with SMTP id u22so4628301pfm.3;
        Thu, 30 May 2019 12:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TFzQAu5rH7cJ/MaKQhlpsQb6OQzMLwGjWIzCKxfmP5k=;
        b=EQ3EwljAlMSXoMG0IIYouQ2aLfhOO7YuTENRCpF5zgqCK5sdgzAFozsLJvLGLaWYDq
         SG5lY9rl1/XzZChzAxJIqkrYSQIP1yH0o6cvOhvu8Pr4QaQAchd3BiiIiYcC/tmCdPFL
         oohQhVY2NTxG9K9Qzthjl6zP0JDjFMeiHY4aiJchJQugyA/6jrsB/bEOC24NnAmDULca
         3FyDk2VlzvIm/Enb64lYQfJVYGVP3DmhGFigxxEu1TCau3P5uU5RykjnYmeKyoEa7/HC
         /K0kgjrSJ1FcAXtw7VHnXvYKmMtYtWIMe6RhVoVmed+bAHN1IiPb9A3KS5xLXFJxo8nn
         u0Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=TFzQAu5rH7cJ/MaKQhlpsQb6OQzMLwGjWIzCKxfmP5k=;
        b=lWqsIHY2htEtAeJvfNDlXIWlCNfHdRyiYLh4XszIurvqTYh6Z9LwhtLzkJpl1xV09h
         jyGI07/O5GJgoB8ijIrtcqtpClWBF0ZELLyp+EmteApVYur26nWW6mmJZfSZAbstAuwC
         w4xRpJ/m0CPW8rGiDaU7AWxqxjONjiUZWugu45G5mealp1XNobyvdJ77dsmNXmmXtVLO
         ONrCJcF21lx8gOJ/SvpbfC5493gaIZkEpdZfbiXeSC8xvPvf3vEf0WIlMrtn15R+YpeQ
         cxKghRuqiAlHcmEtQT9igITLpgaQ7vj0SXTpqINh0xQuREpotgeWvfH0RAUcMV1xYtVb
         FlEQ==
X-Gm-Message-State: APjAAAW3Mb/26kn1khFj1IG4namrk+Gp7KsiWKSL///4zo9AsruJxO02
        i4ZzjD9YpullazXFL9Mr/5dywp4d
X-Google-Smtp-Source: APXvYqwRW+4Jp7iQQ0I+j5O9Bq7aY6RU5Dv6gDo10kL0rc75kx4WUJ0vYfTV2qctz2awU8NfFysFWg==
X-Received: by 2002:a63:1224:: with SMTP id h36mr5292499pgl.9.1559246194425;
        Thu, 30 May 2019 12:56:34 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y7sm9018321pja.26.2019.05.30.12.56.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 12:56:33 -0700 (PDT)
Date:   Thu, 30 May 2019 12:56:32 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/276] 4.19.47-stable review
Message-ID: <20190530195632.GB12310@roeck-us.net>
References: <20190530030523.133519668@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 29, 2019 at 08:02:38PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.47 release.
> There are 276 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 01 Jun 2019 03:02:08 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 349 pass: 349 fail: 0

Guenter
