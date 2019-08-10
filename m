Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 483DC88BF8
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 17:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfHJPpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 11:45:30 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45075 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbfHJPpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 11:45:30 -0400
Received: by mail-pl1-f196.google.com with SMTP id y8so4045016plr.12;
        Sat, 10 Aug 2019 08:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=g8EryOusqX/mFfSa4kBJXrjKexBE7DMaLxTAFZHSwh0=;
        b=hTzTVzq6wfwgn4jt3dReWCS/nTWpJWkqQrtotcq+Fxi1r2AfpMbWQZsv7gztQkFV2d
         7gQW1k1m2I7P/tHFROQjRavaA3kYGwqSILh88b+KEMMJwmrfswVAsHs4/Ix9Rooro3eA
         wg30rWESUC/ScvmVWsEoa5Ujv7uuL4UNzyvM2mQg9ze6Xr7vdOBIZAUvizdUaRprhtyG
         9Z4SZB+MBfCTsG5vRMguOFqo/6Kz9pQnr/zfcxtswzUsSU6Flq/S0qrAeBhac6yKI7x4
         1/BeezTtwhoBIveSGK5sXTePGLIIkUUjjJEPDyS68aPILUi5pi9xmK4RH9zzihLrT/OW
         s91A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=g8EryOusqX/mFfSa4kBJXrjKexBE7DMaLxTAFZHSwh0=;
        b=hR9DQiUr4WpP5q73t0jxGUC6Qlevxe48kUediZPH7ph6BlzTGxdE2pm1lRHLls0snT
         OvTUtg+ICR/v0QPqvKF+c1vqQMSz9L0l3xaCWvkrkhMi9JEyrDO8nHg4rB2YvQU5wl+w
         +fhMCYr6CuGYG6jG19lstk0C/MdxqlMMBOfQV23PBygJtlS1jznszFoUJu99LosueBIw
         KYFemroIqeH7S/DO9P8EkRMfNcBTVhSELUsWO3XSSpirLhGkgINnRc/UOJ/P/nWXDKf4
         dXpWZsfgMYHjw/1Jds8ultRpvRjHOvuKJhdEmMdiBbqBSkuzypRRx7FxmuasNOH/pdkI
         s0pg==
X-Gm-Message-State: APjAAAVVHdTSObSvLxDVEpQZudvuafOIgIoPkcjaQQSjdGKjLCC1iS/P
        i2aMFwdv3L3RyZ4VwI+lsCM=
X-Google-Smtp-Source: APXvYqw6d8N9ayb1YObIvxMPmMRDFKablVAPi/LHX6THrFMeG6J+gfSvKoskgkzIbwZxqCugMsoAFA==
X-Received: by 2002:a17:902:82c4:: with SMTP id u4mr24797136plz.196.1565451929651;
        Sat, 10 Aug 2019 08:45:29 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m9sm156631605pgr.24.2019.08.10.08.45.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 10 Aug 2019 08:45:29 -0700 (PDT)
Date:   Sat, 10 Aug 2019 08:45:28 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/32] 4.9.189-stable review
Message-ID: <20190810154528.GB11992@roeck-us.net>
References: <20190809133922.945349906@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809133922.945349906@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 09, 2019 at 03:45:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.189 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 11 Aug 2019 01:38:45 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 356 pass: 356 fail: 0

Guenter
