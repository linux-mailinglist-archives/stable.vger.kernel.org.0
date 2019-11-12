Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB3C6F9872
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 19:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfKLSTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 13:19:30 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40372 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbfKLST3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 13:19:29 -0500
Received: by mail-pl1-f196.google.com with SMTP id e3so9742029plt.7;
        Tue, 12 Nov 2019 10:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fRQ/2Z96ykIEjO0iCjzfY7isnGb6IL9GY2koKZerK1U=;
        b=fazxCNQTX8AIib9gHeejW+z5liRU1/x5blgkMHOLUJauoUCxeQAys0h5R5LJHPhFlS
         97vrkvJWuVcuGLUmdhkyzOA054tVOIgPBtOHmCIRJTBD2zbHWc+2VvfhJ6IA3LcTW8Wo
         Hr+4cczgObvOoiEoWiTeF4dHZqJXQ+SxLpzs04RiLkRnN5kXycF5YWpnro9qqIbHvLAF
         NvD7ts/WCRkGWelGz6WEfooHeKKxqCcVuegfYqPgbaqTxwrpQy2OVEtDfTdhgN6hUnQg
         3+ixb5nUM1j+3eEQP84J5hlGpVnpaOEmmEqyWZvw8J8yYH2+EW0ZzRgNeAYVXtRmIUKh
         /rQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=fRQ/2Z96ykIEjO0iCjzfY7isnGb6IL9GY2koKZerK1U=;
        b=gAOpBBLWgAEJ9dz2EeIBPSdsnfZGiuSnxBvTT7wKD++ssKyGQ2bupOfttFr1X9dWfT
         O3Uxijf2XgmHiZb2c4ZkBgt4ZRo04bYBSNzTh7VeUvzUJthajwNspyPQFDLXptSp0h6Q
         UON0fe8orQofe1sl2DjtyOmZW/86/YCBFzAbd3uXuPjQBk0sdWFcbFD2lolizLZCSNj2
         zAwuJ9h/vHZIe1flTf3ClThyXs67+8FGgZ/dhBJFUiIj2nfhsLuct2+ofjgLhh3Hr6H5
         aXCiQhZHZvhI7+hVxrJc4qcUyqCxGUjAKEeKJPI9Y7uhXsBsQNK0QfBrm54/9xDKa9/0
         5JuQ==
X-Gm-Message-State: APjAAAUPkQLUEXuiVwspmiHGMp6zJKJjPe/1LJ+uMZusJxjI57ovH3mz
        /aM7boHgoi/JsbnWlQhxPbc=
X-Google-Smtp-Source: APXvYqxYqLsvtSaq/zpzhSJqLznoKiKiEGiXlqbh8fgMuHj/oy+/56wCzbudagpMlk/I9nu0ZIzA7w==
X-Received: by 2002:a17:902:74c5:: with SMTP id f5mr10761544plt.310.1573582767531;
        Tue, 12 Nov 2019 10:19:27 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i32sm14951017pgl.73.2019.11.12.10.19.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Nov 2019 10:19:27 -0800 (PST)
Date:   Tue, 12 Nov 2019 10:19:26 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/65] 4.9.201-stable review
Message-ID: <20191112181926.GC30127@roeck-us.net>
References: <20191111181331.917659011@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111181331.917659011@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 07:28:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.201 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Nov 2019 18:08:44 +0000.
> Anything received after that time might be too late.
> 

For -rc2:

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 356 pass: 356 fail: 0

Guenter
