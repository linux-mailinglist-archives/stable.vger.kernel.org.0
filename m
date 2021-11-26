Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB0D45E6E3
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 05:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358679AbhKZEfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 23:35:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351904AbhKZEdl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 23:33:41 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE972C061396;
        Thu, 25 Nov 2021 20:15:53 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id r10-20020a056830080a00b0055c8fd2cebdso12213931ots.6;
        Thu, 25 Nov 2021 20:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MfLRrldd9s+XqARInRincKPaf/YnAT6MhH9tGyReJSM=;
        b=AmQVLgB5HpE5rlzBO+F9sYIGbiq+/WAnJ9uvuHFJjW6gjPewKWsybRu7LPQuV65TEw
         eb2z9inAIhpZcPvI6UcIF3WPQo2ER7pWwVjMCUSevFKO2IfvFb6qIC+IWo83v2vt1Jxn
         L/jBixtCWjuh+LUmIUfVHL5HcJg5E77w5g5Vvzp+Lq+LsluPDZ3vFiNTc0joOC4SMJ4K
         ZXvg1gl9LiwvgIhign/TvMhNhb3jlUwg0VqD2DKoQPktx0bi/5E99t5du+evvzMdBhEa
         SbY1jY25tTw0DYDV7TA3ELsV4AoR6xVqkurWOxbq1lziFLNx+Y4dOAdO9X7vnI+V2O1M
         Is2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=MfLRrldd9s+XqARInRincKPaf/YnAT6MhH9tGyReJSM=;
        b=NlQsspioRCCDzFRDr5k9KJdlEltQ/I22lpsKXsgt/HdsUI+DXS3dKvYMGpCDVSLvND
         4YiXhBJJHf3Mc1XfGswVBcKh7DTNE0N5bHlql2ViZmrLvcv/0/OrQthGrpsZCNUkvqFk
         6uCtK7tfHs07xGqAlDg0OTchKxKn1U1sUKUrx19ikii2wARw5kXtNoWVcQlUEZQiW5UR
         MWdVBDtZCVSrwNihMIRqQdoVcDnAeGPjAIY50tLYp/jqYGDcEnON/uOie0aER7eyjytr
         b5/KjrkW+gEzsZF5rbE8piAACHmosN18EjZ7p5erpUIM2nxFFRez+qvAfiIWGvIK15sR
         o5Sw==
X-Gm-Message-State: AOAM532r0BD8u8xeGwgMICSJmEbwKbk2f5qfYPXMwdL2Xbmg516HnCkd
        3yXEWH/1X6dNPnyzjLWPic4N/97/2aE=
X-Google-Smtp-Source: ABdhPJyBOsCqwjPaIoWTNTBnySN+VG/l/D0jZcAKMS473ml3xyHc6+yWAA8YZivkCuJ3jjDqMVdKFw==
X-Received: by 2002:a9d:433:: with SMTP id 48mr14591333otc.360.1637900153413;
        Thu, 25 Nov 2021 20:15:53 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g61sm849183otg.43.2021.11.25.20.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 20:15:53 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 25 Nov 2021 20:15:51 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/153] 5.10.82-rc2 review
Message-ID: <20211126041551.GE1376219@roeck-us.net>
References: <20211125092029.973858485@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125092029.973858485@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 25, 2021 at 10:23:48AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.82 release.
> There are 153 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Nov 2021 09:20:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 474 pass: 474 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
