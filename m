Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBBACC620
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 00:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfJDW4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 18:56:39 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41685 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJDW4j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 18:56:39 -0400
Received: by mail-pg1-f195.google.com with SMTP id s1so4553410pgv.8;
        Fri, 04 Oct 2019 15:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=l7g8HamlQol0aU/CF9o1oFr9XvSIJ+TGgCyCmeFxI7Y=;
        b=I838sTIZM1SoGJg10Zp+Xq6WtMUsGydzE3yrdiHMeTujYGRpnUXIZYTVtL7ARv5tkk
         9JfGLybrZxV4ZFSK894jiTgZIqsqU5kH2XuKeeZ4ge7k/pSc44RUp8rFskwbnD0XWKXy
         dJfm6izMyVei9+12lzp8qwaVNBmDY+YPjuyscViMqssRh433S6yUifDy3m/ZHO/iTsG0
         ynW6lNsZ0J8hWygcGJVBjCNRIYjdgOUjVVT8I3ZHP3arS6dv53Ct2kFr0TshhUhCP/Q+
         aVe3DTjt1dwg/t3Qr3MKymXoVwGAdWS4hMx/nvxyZBQx0pt/Fkp+X3dGsgyohaRylkqM
         gURA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=l7g8HamlQol0aU/CF9o1oFr9XvSIJ+TGgCyCmeFxI7Y=;
        b=KwMDRTR/IL8R6Lw0H+piWHks7/J6N3oQH/mz5fj/fUwt7vXp69jGFT2GNKyVN5DDqn
         o6gVy/imxs3/NbztN8/+QRBXTbBQnvtNIUe0h848ciVcBpJH0Zsf3lUCaXuPYt8K7nv/
         dbSFocIH1N9ieqLvWQT2j0LH9rJXHFfSH7KnCbCyap4gyx/loDork5CJ5DfpF3zjhBkl
         AdgW/RHa7cZc0eALY3Kje49UH4xxpcPIsscqtsXa/YkOTbBLLXV4FrrhMUZY+IzIZJS7
         EeTb+6cqXBRSjS3BRZE17l7FbGBNI/oLVev1AvhNmaI2cFc3tEkIupGeOSCL5C+vCP7Z
         D4rw==
X-Gm-Message-State: APjAAAVHq/hMl66aTZdnHmHAqkFmqgmdaISY4xJ7qxheJ5QcdR78p88Q
        YbZdc3QIqIHA1T1yT+WsHr8=
X-Google-Smtp-Source: APXvYqxH0O2PU8d7DI8HgBLCDC1lv/KwthcLkLBvAj5NCxXDy96lhU9B0AJPc7KbLi+eP/PdAVtzpA==
X-Received: by 2002:a63:7d10:: with SMTP id y16mr17890820pgc.368.1570229798364;
        Fri, 04 Oct 2019 15:56:38 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g7sm12462219pfm.176.2019.10.04.15.56.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 04 Oct 2019 15:56:37 -0700 (PDT)
Date:   Fri, 4 Oct 2019 15:56:36 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/129] 4.9.195-stable review
Message-ID: <20191004225636.GB14687@roeck-us.net>
References: <20191003154318.081116689@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003154318.081116689@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 05:52:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.195 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 05 Oct 2019 03:37:47 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 356 pass: 356 fail: 0

Guenter
