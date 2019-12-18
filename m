Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44C9E124A10
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 15:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfLROrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 09:47:43 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33431 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726921AbfLROrm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 09:47:42 -0500
Received: by mail-pg1-f195.google.com with SMTP id 6so1417723pgk.0;
        Wed, 18 Dec 2019 06:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=guFwf+wCa12JSxYCT/+nf881wz06mcBiWToUaJNXU+I=;
        b=fQMdv/vhVoW4o4bNtXzhG4yJUPXzUyaCEdzXdPxDo8S1IHbrFubu1HtXnUstlkNwjN
         sAsNoFaemGt9CFgffOHZLOhCP5ihIJzIXIB7y73SVcDTTpWeoNPyC1F1eys+lLkqSeYy
         gKrXjN/t5Al7GahcB8pusfDRaMAAP4nLlxEoXieWtFVaj+Y2TaFpicX7e5Y0MPaQ0v8C
         V3EVlxom5lkK02ZIKKMky/TES8fuyrfKj37ewYlMKeQg7sjZEhr72nO3ERheRY4lZY1q
         36taH3Hqjb9bDk7dNv2QHE4bBDXAfmw3kX5xUAO4GaFeNV2XLnksTwJegKDK5+A4Tq9D
         ii3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=guFwf+wCa12JSxYCT/+nf881wz06mcBiWToUaJNXU+I=;
        b=KTDt6FNoDbCiM1BRM28lQY8YNilDe6zbzpI+QvhlnVTW0NFBWDMDnSHSSlyoEkSZ/2
         KX3cuCEgj1D6aM3ab3AL8F8OAGNu4D4ZKCySNBc2/ROFkFJ2/ixfY6KbSmbxJz5e9KUx
         +PcWZxc8P1KRZFNZJjWfzorxAH0jRzpabsETyvDYyVNTBfMwCg6v+6ahP6V3AubFcawg
         gY9ywFcso0/jBTgO3+3yIJ/WUE9UQpkPRSfMqmIyNELsynDojjsw2mSraZugHnG9XmsA
         FJxP79D4Xs8BVzmQqMpXYf/BoDsURw3IcpdRZAZSrhSppgq2quAmtkjPQtBgHmb7o4gV
         iuqw==
X-Gm-Message-State: APjAAAW6aGK8T5ZAnb/IvYAvMXFUw1Rz88VCGAb92h+3UJ7dwk7gAEnN
        VpybCc5ZuFppDuQ1FOl/imY=
X-Google-Smtp-Source: APXvYqyM9FqA1ARCYVXS0NxiH0ecdtuCZqFkvEMg+feJh4WBiJZ4U68zBxyrj7d6NSrqilRo+FzblQ==
X-Received: by 2002:a63:504f:: with SMTP id q15mr3486434pgl.8.1576680462221;
        Wed, 18 Dec 2019 06:47:42 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w38sm3731258pgk.45.2019.12.18.06.47.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 18 Dec 2019 06:47:40 -0800 (PST)
Date:   Wed, 18 Dec 2019 06:47:39 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.3 00/25] 5.3.18-stable review
Message-ID: <20191218144739.GA19358@roeck-us.net>
References: <20191217200903.179327435@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217200903.179327435@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 17, 2019 at 09:15:59PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.18 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Note, this is the LAST 5.3.y kernel to be released, after this one, it
> will be end-of-life.  You should have moved to the 5.4.y series already
> by now.
> 
Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 384 pass: 384 fail: 0

Guenter
