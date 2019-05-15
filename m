Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EABB21F9C8
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 20:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfEOSRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 14:17:09 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36792 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726517AbfEOSRI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 14:17:08 -0400
Received: by mail-pf1-f195.google.com with SMTP id v80so388909pfa.3;
        Wed, 15 May 2019 11:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QkhiS+F3Fk+QJc7JQzvxbKez26eA97mP/ZMNMBbdaG4=;
        b=B776ekfp0SJNQZ7PpIgpA1nGElXrlrbZvZtaDPVbjrTICuN7W3GaH9dUXUhuOm/YKV
         zcHhQokyEkkM84r00XvQXZIL7CUboG9mS/jo9AOwtkoVM8LTYjXcudZ0lODeMNEH+VdX
         JK5UoAUAqzsrcRSL3jhaoWzvs6qguUDNymHy92r+Cz1D5JXTqlv2Wj6z0EateWPu9c44
         wDBsoWS4sRDIVGLxSVZ498LzKMMowTosZbmIpKNcA5UeD7ZUZUcXosbUjg/0gz+gL/Vq
         Pccz5GQE+8w19tAJ50hLtR2VBOqbPnd0XdSofZ3KSI1MU7vWhWUghoUPNMoLKdw7LjHj
         hG8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=QkhiS+F3Fk+QJc7JQzvxbKez26eA97mP/ZMNMBbdaG4=;
        b=jWPsto+Zam/MVxs8/B8DmbMGbPX0obzERxJSWyAbMyiUZ+VWL8ynuFyxNb9/KYqa7N
         /0RxbDNtNJNT0u2D6N6rXtnqUG5IB+2wYg92ce4z7k8O93yBGor97gVETcHlrWH4n+j5
         2nabgFUxh/FCUSh5YlK2S4T9idojRTwRtEJQ5YVe0nZb3c9sHmWTlh3Y6myGmq0CMzD2
         z6TeWNjEsivywDRAAEJ310cKRBlrPpjelLWnd+addnl4NJrX094IP35wZk73AjFJWmQp
         HdMEIU2HWbeSHPkk1Sg/OrPLGMtR5e2KJUcXAZyX6PRFEesv60ZotYWHMWNMV8q5rmth
         1IoA==
X-Gm-Message-State: APjAAAUKvuHJ5MMxUh2+s1mbwRnalFE9nGI3xUoZYeUKFITToDSSl/CT
        DtIdizqvJGFT9ddhc5v78Mo=
X-Google-Smtp-Source: APXvYqy553HrFBeJkKPjGVuBI+myrEKoThnRS6cssy5WHJ1ycwDlU2GWdn9//qM8SbaaXh5Q6oAVbQ==
X-Received: by 2002:a63:3d0b:: with SMTP id k11mr44850491pga.349.1557944227410;
        Wed, 15 May 2019 11:17:07 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 132sm3489677pga.79.2019.05.15.11.17.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 11:17:06 -0700 (PDT)
Date:   Wed, 15 May 2019 11:17:05 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/115] 4.14.120-stable review
Message-ID: <20190515181705.GB16742@roeck-us.net>
References: <20190515090659.123121100@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 15, 2019 at 12:54:40PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.120 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 17 May 2019 09:04:39 AM UTC.
> Anything received after that time might be too late.
> 

mips:malta_defconfig, parisc:defconfig with
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=n:

In file included from crypto/testmgr.c:54:0:
crypto/testmgr.h:16081:4: error:
	'const struct cipher_testvec' has no member named 'ptext'
crypto/testmgr.h:16089:4: error:
	'const struct cipher_testvec' has no member named 'ctext'

and several more. Commit c97feceb948b6 ("crypto: testmgr - add AES-CFB tests")
[upstream commit 7da66670775d201f633577f5b15a4bbeebaaa2b0] is the culprit -
aplying it to v4.14.y would require a backport.

Guenter
