Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38301C2068
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 00:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgEAWLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 18:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgEAWLy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 18:11:54 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B89C061A0C;
        Fri,  1 May 2020 15:11:53 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id l25so2804513pgc.5;
        Fri, 01 May 2020 15:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=G9cPNDRl11Z1ZRygMEdXWM8M1qjkV/0N8rVCPsP3QuE=;
        b=B0qQffUy1NpowQUWvDV1Ny+FZZunxuKytsmlPoFOhFKTaYY70Yd6AK0yjBY1qFZBld
         J6Cu0JqHTpRgmFAB0/m+haYu7dBvFjrxJVVdHMMfYvOR2VC8cHJ2sfwLQ4L3xBkrfA5J
         C0GLXVEdEVHDA9EiRSaful/L/YCAGMCSQfAAkYo5wqKEX2JIfN0xpIXJOoBF00y1fyQU
         D61edZvrtGAT4BPJMnaNOtnwMJR6pccpg7SYy7dblYpkWjZUlLCleFd0FHfP4DjnG2Vy
         mJaw1kKEa8KorXaOsvOxxj2YBbmLfiykCdDSL0G4/avUsH2gEs++9rOEVufqWwbPcX+h
         Fw/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=G9cPNDRl11Z1ZRygMEdXWM8M1qjkV/0N8rVCPsP3QuE=;
        b=ocDT3azffWJTqEu3RSkakBIiYlsrVQVAUhknqUXZm3776rwrCm2bH6O0NPp4MwxOR5
         uQAusEi27knmUCe3uOoehFgXmImnfNlhc6E0sJMJ3YiW47iwZVs6Gub2ygfGRY8d9PSX
         udnhTeIMU5EN3rDnvYp4Rnv2eWYbLc5exL338jgiF8UEey2EoM73hui+Odi7oGaPdcP8
         Glgda3zr0KqkLF7OBgm4U0JX1lvyMbi1Bvo+Wie4IXNhXcUpIvM9JO+8OVIlWfNgLPax
         Cvu7M9KFoLfIh3N7uED2pFZ0zjR7cAIA6bPJkueLkkx1RFKHkXhPyxKqvc9XXztH/nLD
         J3dA==
X-Gm-Message-State: AGi0PuZ9Q0FRi0ztkR8uHKLWVnRyCZ6K7gbOB1KwC3w9tEVNXPErzURM
        IScT8XZTwKO14Abh5wR6jc8=
X-Google-Smtp-Source: APiQypIjvJxz3rKYAcaWKyu5GOgStjMSsxYWjQ8LslxdLt8Tk7l16ARagz1BYuV7MNr7ja9KgluHhg==
X-Received: by 2002:aa7:81cf:: with SMTP id c15mr6212380pfn.211.1588371112817;
        Fri, 01 May 2020 15:11:52 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o21sm510174pjr.37.2020.05.01.15.11.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 May 2020 15:11:52 -0700 (PDT)
Date:   Fri, 1 May 2020 15:11:51 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/83] 5.4.37-rc1 review
Message-ID: <20200501221151.GE44185@roeck-us.net>
References: <20200501131524.004332640@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501131524.004332640@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 01, 2020 at 03:22:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.37 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 03 May 2020 13:12:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Guenter
