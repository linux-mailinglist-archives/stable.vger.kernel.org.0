Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B227FDF68
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 14:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbfKONzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 08:55:45 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45033 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727496AbfKONzo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 08:55:44 -0500
Received: by mail-pl1-f196.google.com with SMTP id az9so4710173plb.11;
        Fri, 15 Nov 2019 05:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n1fqLNzThkpou5xsZlJyghefoBsjgqzEyV05NKr6H6U=;
        b=n1NFbqbanS718NMzvx0SmdaCzu9jDkzbceNCxrGmAqLD75WM3CjeMgVDCAZV4BgugG
         MyUayMb8kms9JdXSKJH5t9azgwmQ8CYdUhw/uOi1QOJHCkPym0/ovZ0RmntCu5+KQett
         lqecjAk1ftQbBhb4QsV+xAB07c5iFgomcfwj0ocSzVAgHgt8sBZQCrjLfwgkSFCTruTY
         AkFVMg4VUJT0C8UX5DTLefdCt/s+5luJCAgmELO5Xt724B5uN0MnAqx44iNuLNDfMsLs
         ExJPaSDT1I2YjPt9cQoIQjDlkTBtUHx/QowsfGwxOL+w+tB9zNrupw6BxmKWh8jJpQc4
         xrfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n1fqLNzThkpou5xsZlJyghefoBsjgqzEyV05NKr6H6U=;
        b=VCiuodrS5yhWKUuTJN5AzHujVIQl3Dy2e6wvxUzYIDaWxnAWYHEjjjKyslNP2qRHxm
         +c3QmiSn765lU0W2bV3ZIVNXcb2C1GDzzWklaa5ATxV3MO46xq371Ucy1DGlNjBgGlKO
         Ufq3uQ3lgaQiIca0GmOpJhGZxz9pbdmDyXfmJ9v/YxrDO9x3y1UqFcj+azx+Dfi6xC9/
         C4CvES9QOr6wm1u5Eh4byZBoi9p3HqdUIYx/73GcMQLLeXbnZ6SH7Y4KINSqdzOOdNUU
         tOLxGfhS+8aoOm4Xpkhtdkx1iLiAVapmvM2v05zymi20Rf1XBvompmsrkysJ0EpF9WD6
         jQ+Q==
X-Gm-Message-State: APjAAAV+YxC+ZqPbvpXBokT33w46Iar7u7sZ9sBlaKeUKbn7BjvJ4/jF
        m0fHkb9NasVcJ/hASDDcVf4H13kB
X-Google-Smtp-Source: APXvYqy9MIWaJU8Qz6+oah/tghadCTAPPSRJsVVqe4ncNzgHRlSzT+vWAeV9Ev29DBs6W5IaV/P5PQ==
X-Received: by 2002:a17:902:d917:: with SMTP id c23mr15177030plz.199.1573826143893;
        Fri, 15 Nov 2019 05:55:43 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a34sm10792143pgl.56.2019.11.15.05.55.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Nov 2019 05:55:42 -0800 (PST)
Subject: Re: [PATCH 4.4 00/20] 4.4.202-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191115062006.854443935@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <61528559-4d1a-a3be-4e69-b7bf1bf8bea9@roeck-us.net>
Date:   Fri, 15 Nov 2019 05:55:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191115062006.854443935@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/14/19 10:20 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.202 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Nov 2019 06:18:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 324 pass: 324 fail: 0

Guenter
