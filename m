Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538071D1BD5
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 19:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbgEMRDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 13:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728068AbgEMRDw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 13:03:52 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048B3C061A0C;
        Wed, 13 May 2020 10:03:52 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 145so5455pfw.13;
        Wed, 13 May 2020 10:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CoCyU01dYX3XZKtLwSO7VKp8hkT2GZrLHqIw/RONq2s=;
        b=UYN5JKU10jkr8LeAR45s5xt2dLkhk8yHAbPtJgb7D0KjYSZ+kIGUCYwwiYFpkslO3u
         bgtZKjRrOocONT3Vsqlc5jLgJhfIaYPRFQN17egjKQNFrrESxEOOtf3ZciMWfhK1xt+x
         ZFk7CqZBSEQa7ET4Kn4Q1lXqK0XCOb+8abrXw/mAROco/R3lvmfUoxgVnOYY94joN03V
         Tp9+VfMlA3U9aXOjFRu88nf3sKfdqiPKz389dxqPJuoZAAWInH+WykrweQeBqvA5/8nm
         tZr7DqPdI/DcY8uwO0k3HVKQMUr4oF00Cp0T5+o2Xbv6xCA/65IbQNA2FLrDylnzHVFa
         KcXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=CoCyU01dYX3XZKtLwSO7VKp8hkT2GZrLHqIw/RONq2s=;
        b=qiZf8sYl6GINlQm+lUpRqjBpLI6Pfn5EwV6XYOmcSp6visoTAmYEQ8LTR/2DXEPCcM
         URtGrRcocIYAxdMLlDMIwePyZ76V/ritsb/J9mcf5nFoGBvm1aSeYnflr5yKrIQrlx/Q
         dgLtXWjHQUm37P+jCz/pLy2T40+plzWdQHMwYSpEuTIXVeZ7YPvGRBBjclm7g9Jnux0+
         TRDyBnX6OfmqEt3snndNWYwzd0zu669K+KnZx1YN8KtzMj0C5xnxiXL2sP5lEU0Xmkmh
         S9H48gUiynzMy/EpsVIfIEbWu5aD5+krYobj6VuOdBRZmmA1FmoW+5e599zoU+s+9KYM
         WAZA==
X-Gm-Message-State: AOAM532PAIsx4kBx7Zs+O1cw7AT5SLZ1g9Js3LgmcActl/FY9FCBfm6+
        HVqQDcFCiMR9M8t26iA5D0U=
X-Google-Smtp-Source: ABdhPJyhI1ji7fkYUMbD78jAV/R2fVb0kYArtgrL1GLtbJ5DhkPm3mrozdcdK+h69qKMKLZB50qQ+w==
X-Received: by 2002:a63:d909:: with SMTP id r9mr242333pgg.245.1589389431556;
        Wed, 13 May 2020 10:03:51 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id gz19sm15909824pjb.7.2020.05.13.10.03.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 13 May 2020 10:03:51 -0700 (PDT)
Date:   Wed, 13 May 2020 10:03:50 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/90] 5.4.41-rc1 review
Message-ID: <20200513170350.GB224971@roeck-us.net>
References: <20200513094408.810028856@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 13, 2020 at 11:43:56AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.41 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 15 May 2020 09:41:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Guenter
