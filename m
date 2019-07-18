Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA9E66D565
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 21:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391695AbfGRTs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 15:48:26 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34598 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391352AbfGRTs0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 15:48:26 -0400
Received: by mail-pf1-f194.google.com with SMTP id b13so13092771pfo.1;
        Thu, 18 Jul 2019 12:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HHDHbWT0uj8R9ZN9JYE1sUsynffwgt75FkHn6hTWOdI=;
        b=IMEN7y1EoITwAkBJgzNXTOk792GSiisbtZrwR5c7FxEEB1IcYJUWC2r8SqTInMIcJQ
         Iot+DaBSIi69HjeCyd1cDoU+4CMabHVwK/X48MDCCjVpDQcJeVMrkKyg7vW0y3Yb/HVn
         DwjTpbEMPU8jcTBVsEkehRZcqMaaqt8hSLYWsjvR/kqhczL1NzJS8LWcDUouCIVteLUp
         NzShdoTUZavI9snofJcuP1OxI1PvsuhTPk7IZ47gupu4NHPMaztZSoCz/Z5afj1yXU1i
         lKXPEg4oPO9VBXf2YtAxew0ydOA1WZfTwVJrhDuPddxgFBR0/c6MW9iYEaVpuOoo3u74
         fKgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=HHDHbWT0uj8R9ZN9JYE1sUsynffwgt75FkHn6hTWOdI=;
        b=oOs2HqAjl2Gd5Xzk5cF1pTxBY5oRz+8omSQSQ9WjhQzvyo5tG5bMWfSRGBd/gSL3La
         IKVjVa7Haw6kPVpPUWddToFdHhn2L97RNldNrr2L9GtngWDNCwi8IKnq13V7paKQNrxU
         mkRvubGHcJSk4x5UPdr2x/ZWc7awaok+6kEA3JereEuwtzAL25N/W1ktGzxT7jQ8r4Zh
         EYn1t6AF+abSAaVKaZBgacjzVg+22gYh6a5zCSxlaaJUtySzw8725MQraAfTlzsCxc5F
         +iH3lfkU6HlVI4z1DnTXFJZx0LzyQi4UZmnHH+0QUKRpWBDcw40e7nhizBoW7DMxJYob
         Tn5g==
X-Gm-Message-State: APjAAAU9uHgYDYa6Pe0S3zfVpfrX275VUSHam3ISkTU9e57XtuOCBUQd
        CcK9myo7hidlrBCVTwoPBz0=
X-Google-Smtp-Source: APXvYqxslvo6fwgYsnUNxIfehMHLKKeXWKOsCFJiCl+xQmRlXFAMSvtkGAT3gstYm/1ZnHz3eztJJA==
X-Received: by 2002:a17:90a:9dca:: with SMTP id x10mr53361419pjv.100.1563479305544;
        Thu, 18 Jul 2019 12:48:25 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u1sm27615603pgi.28.2019.07.18.12.48.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 12:48:25 -0700 (PDT)
Date:   Thu, 18 Jul 2019 12:48:24 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/47] 4.19.60-stable review
Message-ID: <20190718194824.GD24320@roeck-us.net>
References: <20190718030045.780672747@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718030045.780672747@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 12:01:14PM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.60 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 20 Jul 2019 02:59:27 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 364 pass: 364 fail: 0

Guenter
