Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE9D4DB56A
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 20:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438029AbfJQSDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 14:03:20 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42822 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438028AbfJQSDT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 14:03:19 -0400
Received: by mail-pl1-f194.google.com with SMTP id g9so176633plj.9;
        Thu, 17 Oct 2019 11:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9oCmTVnAEa32nAb5BJZQ/i4PUlAhvohf94rvuYIrx2g=;
        b=NUVNIEv/vBTToTobEZUT+Up2ImRUo3WbNnWudxlqRnZg8/Rz7kuU2do0p4DnqwGP+8
         l2K9y1GOX2sy5jvuyb/BO1TYSHbEiOBRxlUM3PGNXOj1MLMpFIao0V05BzbWGsKxf95/
         MlKIUj7bViGKM6AF0jyfgvlQLgxCpjXERdJjyphs5HEWlW0Mw4vNVL8xNbpY67yQ9xcU
         u4Kzk/YVWytel/M+jDTirfTeo5qeQteYKVVmKHLBTGFIr0zZJDJTHOZFlWlId/HB4MSg
         PEjCcsCtaFBezs1qxLmRVFD3twH509vw0RJW8uBx78dolhb6EtSw8I95I4B8ezsicoD6
         NZvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=9oCmTVnAEa32nAb5BJZQ/i4PUlAhvohf94rvuYIrx2g=;
        b=LyUbW/PK/Yi9BZ4l4Pr2MMGLYO9fhr7wMcEti8srraQNLXJOoalZ8KsvC3CzHyp4uy
         b66F5q1oRA5lx3CZNreoADuSx/UNyCyWjiyjAGJCEd61+59cQ3ZQjRRB9vm1VwwirqYX
         dVnqEnhfVf0PDurWiRKew5zcL1FzlW9qwnRcSdUumxaaXksbHYTYrgTChH/3BXJn8EDq
         E/w06dK7+XoLQe3IitOl25uh3HrXcXRJSZIl5jf1FXsrnrDXohcFLO/pHKlZn+TOjdLs
         rD0miULTeaBLeJMPi9SQ2vo9E4GuIEF1DcvctAg26w/9o2y4mmkn6AIO5UTSohgpkdpC
         AyZA==
X-Gm-Message-State: APjAAAUyknB4+t0+CGvFcG6mmmrsIxPVauomo2HzA+tzSH5KYrNkvT/H
        9DEcvFuDmxlXMMoyQoYuZzQ=
X-Google-Smtp-Source: APXvYqw8etUNVn8kVOfD8cH7NLuy7T1NE4l5lDQl4N7hYJO1CH46vHNr8pz1dmU7+pIcqgJRn6anLg==
X-Received: by 2002:a17:902:9a92:: with SMTP id w18mr5260334plp.223.1571335397608;
        Thu, 17 Oct 2019 11:03:17 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g4sm3514798pfo.33.2019.10.17.11.03.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 17 Oct 2019 11:03:17 -0700 (PDT)
Date:   Thu, 17 Oct 2019 11:03:15 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/92] 4.9.197-stable review
Message-ID: <20191017180315.GB29239@roeck-us.net>
References: <20191016214759.600329427@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016214759.600329427@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 16, 2019 at 02:49:33PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.197 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 18 Oct 2019 09:43:41 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 356 pass: 356 fail: 0

Guenter
