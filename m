Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05763A1D1E
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 20:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhFISvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 14:51:47 -0400
Received: from mail-ot1-f47.google.com ([209.85.210.47]:35759 "EHLO
        mail-ot1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbhFISvm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 14:51:42 -0400
Received: by mail-ot1-f47.google.com with SMTP id 69-20020a9d0a4b0000b02902ed42f141e1so24977711otg.2;
        Wed, 09 Jun 2021 11:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0GGyaAZauDrO2eFxFq4pq+oFFKk0jzbxmPvrcIA2A3k=;
        b=Pv2C72teN32D5FuXqe+sTNfU0rjS+gAmX7JINkv8NZSgNj4ZP3bSAP7yEafstWdqvT
         KMlIUc7N62oKxZlfjKHXknpQUbbujtcVsp1Pm9Z6piQ9uGBfnTuEsIULd/X6JH6VMrV2
         jrEVQ1RjUk+rrZlVaBanKhSnRQWW7oaZAyNqArNLbRDQU8QcUfiA89FHvEfoeoU1Jgwc
         unYcSH6xneUniIf0+ex4kNChXfmonx9zdP2pq6rb0UZn8jV5bHeClCGKxaAUwDmVr77l
         dWDD4LEtbGBhmOonnwtdecwGqca6ZRzyyC4+ZU5FSc5hC3KNulqIgCAZ4QMh94sJMs+3
         qTOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=0GGyaAZauDrO2eFxFq4pq+oFFKk0jzbxmPvrcIA2A3k=;
        b=p9h9dSh7UrwUhG/mRJJ5vLSPEMlH1GyQmRvRbImuYe1gFLrbtHOAnrR0ggtM2WabGK
         3pfc754IPCzTfpYfCC82JQH/pkx3RiuG9gSvZdhnTNIHc0VFuZQii9Ez7lbdEYE/YOEW
         gnkL78OUoEc8tjU33NrtHMYT1VnS2EY/xNSs6Ax8TJKYj7rXVocDZ5RVT5YdM0dEofae
         pdCqE6oCJC+rUNFr3fqZOaze9IYlhuZxMFY//eqFmUB0NnHQ1+G1x5FxKhrVtVI3oZt9
         eQ7sGaz34H4/1ZzWM8xq1yvX+Rwe4bFjl9CTwmj5FsoawBqLuDHkVThNMQLt0it90iqj
         d3gQ==
X-Gm-Message-State: AOAM5307KzAHBOgz2vQ/tRX0sjd/eCq1ubnk9WUblVkrokBjFd3DqqoR
        Odd357y16wCo8GymiDOGkFMZapWnoIA=
X-Google-Smtp-Source: ABdhPJxeNzfA2HEJ3kQruWn6+ds1aIkn7LbBkJPJMvgr57QiMjhnKwKre3UmS8VDsG1AZTvZbTq07w==
X-Received: by 2002:a05:6830:118c:: with SMTP id u12mr695465otq.82.1623264527205;
        Wed, 09 Jun 2021 11:48:47 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 3sm158403otu.52.2021.06.09.11.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:48:46 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 9 Jun 2021 11:48:45 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/57] 4.19.194-rc2 review
Message-ID: <20210609184845.GD2531680@roeck-us.net>
References: <20210609062858.532803536@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609062858.532803536@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 09, 2021 at 09:54:26AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.194 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Jun 2021 06:28:32 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
