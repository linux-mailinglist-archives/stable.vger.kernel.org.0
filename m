Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7947F6D567
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 21:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391319AbfGRTss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 15:48:48 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39599 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391147AbfGRTss (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 15:48:48 -0400
Received: by mail-pf1-f194.google.com with SMTP id f17so9098869pfn.6;
        Thu, 18 Jul 2019 12:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wkYP7/hFWkapKmQaM5m8pBsTjgNylcDN4V4Eo47NHgE=;
        b=ZYyJpREo/vVEMtCI/uAptmUakeQca3SNUDsz9vh/9ZgUSh73dpHwSRSmxb2kLw2oWV
         ECAMbHefSLI5ho/imEOsNRyEBesIaXgP3VNGDdho5QjugC0/4dxvwQOE4SBFnh3vkSZY
         kxhgFsHE3uhRKTX1NQ4z6Qsaac2iiwq4Fct6L0HPE7OGxH30RmV4TFRy6W6rYw/eWpwo
         FzBFsmBwUzkf7nupShhifckaZJpCsX/M7dll/IwsHl2EeWKl3sBu+22Ti9cBofXt7yPi
         6jCyhpEdyJ7ENMlHUWO82Z0JhnL5DrL094O3pAnrIWy+6+Ez0+lGes/smNLweLRe6clU
         WPxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=wkYP7/hFWkapKmQaM5m8pBsTjgNylcDN4V4Eo47NHgE=;
        b=fNvNamy6K8GmOp6Zek8XrxeboVGFcta3sDz9YfKott3Ov935TBEMp9MZ8pchy2P6OS
         bnLzOEyKZc5Zq0gE3nxsuj+J63yqSPJYoYTePWV/FSVPb74w0Q309PZSuxGAQmiZ1fGl
         Xh5bhusEqJd4t90Peo0pdv2lFG84MK4IEfnCmzhMzD8Doy45vWaTeK0/gSGBpIKeAkXR
         3P3/uyMALJwwYeg3SCqJnIM4w1Huw9QQBxcNC/khzFCADStSn6evPz+R7KCHbJDc7Q7i
         mSpF+b9PZYQ4h0QTjbh7UBhFIKGUJpk4OSz3/zFekIqF4LCsKB4AqwxnbxpF2RzbDNgO
         0cxg==
X-Gm-Message-State: APjAAAUlnNfU0RDunj+Z9qWlNM4vHVm3G1oh2ocl7p8ca0DAGZ93LHVo
        fklrsp2oBdfIaJyMOA5RAbw=
X-Google-Smtp-Source: APXvYqz1C6o2eKtwXzV2HZhqbAyDijrC9SDmtaOMXUyr3HDKjKj3seRa+Bb12OPZyefP1Vd1HZWLjA==
X-Received: by 2002:a17:90a:ab0d:: with SMTP id m13mr50554936pjq.84.1563479327337;
        Thu, 18 Jul 2019 12:48:47 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r27sm33554680pgn.25.2019.07.18.12.48.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 12:48:46 -0700 (PDT)
Date:   Thu, 18 Jul 2019 12:48:46 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/54] 5.1.19-stable review
Message-ID: <20190718194845.GE24320@roeck-us.net>
References: <20190718030053.287374640@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718030053.287374640@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 12:00:55PM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.19 release.
> There are 54 patches in this series, all will be posted as a response
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
