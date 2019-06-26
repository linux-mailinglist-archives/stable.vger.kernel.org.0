Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5D85709E
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 20:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfFZSdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 14:33:47 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44479 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFZSdr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 14:33:47 -0400
Received: by mail-pf1-f196.google.com with SMTP id t16so1784326pfe.11;
        Wed, 26 Jun 2019 11:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=G/okrWlpbMKEmp3rzs0iLQjcpEPOHFUgGczIwF8ZghY=;
        b=YmRAbXjDlVJyrHK59tUByDa86CYMuFUYhz6Wm7m/jYVbbmA1JaAit4OA0/XY6cyj7i
         T7TxWfvPYKVXoWVACGvZYPGxxSj0jxIarEGW4k2lJR0z/sBSOMPhRjHa64vkMneTuWaq
         n3pbE79zM8l3EvSbWTpS2oKpbU7pCKG3ANvZ0wC+KeXtyzOaNoZpWxFo2Q7NMLOpMejO
         7GMCuXsmFbSo6kd47qexEUZefixvRxPYl56agmOX2vz4NKsDXMZOV28Mp9cGpR+5swOS
         6rVKGE/jzDFARXFz2+x4o+Bm3qEnNFxd4ET/SBqJ5ybpjvKE3A0gRfQr78XcLKXmc614
         sVLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=G/okrWlpbMKEmp3rzs0iLQjcpEPOHFUgGczIwF8ZghY=;
        b=VRw8vlIEWl85ZGfvPxd4RKrEE6QskMdrgKp/xf6CffDo7AhLQXb9nJNMPbVW4Eizbc
         9XMZmIppnbZwVPTqxrl60FaPaD4sxAzWWH+Fd6ou+gSCtZjoRsa09j4x6KxN3QZOaCqB
         QXBonCW0OE6b1xpYTZxgS8CetdWqhuQsJAlblcZaVHmMhC5/3mt1aOAu6r7CTVbSYjE/
         xYw9NFbPPez2ktffocM5cAVAl32hvFqWYWvwNXXXsWeWCn3VYYgBoUZ4UCw+F4dzBKuH
         Sba37S3G5vUaQhBtTUE04+R3tsG3U/RldMeB/LE+nUxPW2NQmRf2rpPnJ7wPEpLaS+9f
         ArXg==
X-Gm-Message-State: APjAAAVQnYuG27M7AxqAs8D+KYuw/ZgEYuRc/0sSuYCgHil/NnkMNQZz
        mcs3da11np91GN928GKOXns=
X-Google-Smtp-Source: APXvYqx3ogaNpOnk+k8C+MXZ2L22BSAzq4sFDt7w5Vsy3aKeTBJRMb3VHyYHFDrii7JlLurHzwl5YA==
X-Received: by 2002:a63:c006:: with SMTP id h6mr4192258pgg.285.1561574026989;
        Wed, 26 Jun 2019 11:33:46 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g6sm18280745pgh.64.2019.06.26.11.33.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 11:33:45 -0700 (PDT)
Date:   Wed, 26 Jun 2019 11:33:44 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 0/1] 4.9.184-stable review
Message-ID: <20190626183344.GA5265@roeck-us.net>
References: <20190626083606.302057200@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626083606.302057200@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 26, 2019 at 04:45:12PM +0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.184 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 28 Jun 2019 08:35:42 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 333 pass: 333 fail: 0

Guenter
