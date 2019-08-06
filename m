Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B38F6835A1
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 17:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733134AbfHFPtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 11:49:17 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45806 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728189AbfHFPtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 11:49:17 -0400
Received: by mail-pg1-f195.google.com with SMTP id o13so41789656pgp.12;
        Tue, 06 Aug 2019 08:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fnKXs8RtaZz30JgCOfacYKUB5o412PzsJWOzMYFLHCo=;
        b=OH03zW+N5t9GB1S5rzX5O5MR/F4SIAMXgrtmWlXEaLyDB6D926Kdhf+44G3C1aZlZi
         9MhqowbxW0UYhkjQHsBAwaLSIkwZr81/6DQR38qE8D/TALI3GZh8q/5TxIXzd5zVOzTS
         mAzz87JqR835AJ9Tw7j+Sjji58Lt68B6UkQVkfd9OJhHvXfcoy1ZytjhJPVK5+LUTnS7
         +RdnOAccmy6mRKk86kBxfKCYcf/4IVZWkYR6/sOdAKc8rFWnGreNkR+3SwkG6I5gKPPR
         s74zLoFrQj04u00UxM7kwdG8PlRUlqFvF0rhGVGL+kXV1QT95QAMYgBlgUlfARAtrDSW
         h78w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=fnKXs8RtaZz30JgCOfacYKUB5o412PzsJWOzMYFLHCo=;
        b=GDlLEGU9YOnOqdd4jlb+1Yp6bUAoglcTTjRwigZLOX1/qi7jA3VfUakK2vX7LmTzT0
         eo9mywIrrOcMH+yBwNStOK5Ga1IZpn7WZHDWgCgUOtXziz+uTtcP4Su/7vGudw2p6qza
         S5J72m6zg3GCCdTVewUqFJhOapSUHCQ9I2IFNTINUBsmvk6MsIMQEMcUg9191beKd3uO
         HaN6eBq8g+rD4tUp0nM1GSts2t+dAlzbm71LVe4K33cPeF4g3J94Ces8rkXIXURsJI5Y
         wRLO0iz1cmk0TfMeE4a7TaGjHMaKetKeb/0aP9B8lvlPGskyNI0zLbbbO1IDAFApPXpK
         DOtw==
X-Gm-Message-State: APjAAAVl8GmZsZIa8+nbZmc1SxAVS/lg46Ax6m0h1At75LF6sFntZxin
        IRjljLYJu3ZxWaKWhOaSu1c=
X-Google-Smtp-Source: APXvYqy227dPRRf3Sp4cpQBB/VaU+/NwNhhuxZEy8eRV/HnzzeFtmzoFCD7/gi4uN566IoKBAQPlnA==
X-Received: by 2002:a63:724b:: with SMTP id c11mr3741988pgn.30.1565106557027;
        Tue, 06 Aug 2019 08:49:17 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x22sm94773578pff.5.2019.08.06.08.49.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 08:49:16 -0700 (PDT)
Date:   Tue, 6 Aug 2019 08:49:15 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/42] 4.9.188-stable review
Message-ID: <20190806154915.GB12156@roeck-us.net>
References: <20190805124924.788666484@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805124924.788666484@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 03:02:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.188 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 07 Aug 2019 12:47:58 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 333 pass: 333 fail: 0

Guenter
