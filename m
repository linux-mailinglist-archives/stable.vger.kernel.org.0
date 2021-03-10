Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18365336820
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 00:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233917AbhCJXwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 18:52:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232948AbhCJXwN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 18:52:13 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1935FC061574;
        Wed, 10 Mar 2021 15:52:13 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id v192so13594360oia.5;
        Wed, 10 Mar 2021 15:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=M/yq+WvJ/I125/G22rM7s8BLtVfRRINr2jK8uoP36h4=;
        b=IHFdTggtAHlpaDv9RqDVtNbpc2C8eDgqr2wxwf2VUVq+gp9CTk2Ojul7fbKT+cdnZ4
         NPyEJljWyvgQKfUVj/7hvRS/1FezHk88bbbOnrHbeN+t8e8+YtGNUJ9E//E0V0GZC7u9
         JhG2kjIj/+RNqR8E3Veu28hsSVSutpB5yS6nSQPRnNdMQHDeUS0FRa0qEBHlBdxQoNcy
         OKuvvDfr/sinpqrwKYM69XOPqE42BmL//LNaoPLjizL6QEBhe40rJ96O4fjEtc+EgLFq
         d1QxbYakG8Bm4q7LWK3aWE4mZe/bb9/609GzjAjveLvw8aLoH+KKrO4QBnCRYHGQcxeG
         5w1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=M/yq+WvJ/I125/G22rM7s8BLtVfRRINr2jK8uoP36h4=;
        b=cTlmLiD+kurCovobsLUAEGfM5pEv9b7UvI7+L5NW6K10xUrQ97DdGnedciU3kkM0dP
         +SdpzY1kPCWREWZpp2RAXblWCiOEpgKS8WyqUI7d1CN21ayzjKLR6VZKFNszIWgJ6B+O
         PnUyKWdrsIGF9i4qi2nZ56p13R88uBYp2uXbhvUBiVSpZhrc3kK47gtay9ApwD88Grll
         +YHVulAMg+3lSTgUJGiurgOcaPQ4284LVioZmX0BtKAmyyCJ4lh3oUTORnHww713tCUI
         oc860hQ3TVzSiLju86enfu7vMiz+K+dh5bgAlQMPbFHYXAXNZggWJjwwPjoH62JJbRbH
         HTxg==
X-Gm-Message-State: AOAM53200cVvOUdwODxhkdqHludZQNSbJnQ6SQSQMcQKwRh+Le+dkwAm
        JOeLmxpyUboWqy73WlTgLINs7kyJFcA=
X-Google-Smtp-Source: ABdhPJzkCpAOIPg+W+5mQwzqFv7+iTUY1JTis0njH3VkgEPA6wGnwHxkgcXsG/CGXnTtQS7COacxbw==
X-Received: by 2002:aca:c707:: with SMTP id x7mr918597oif.92.1615420332590;
        Wed, 10 Mar 2021 15:52:12 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d21sm204357oic.54.2021.03.10.15.52.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Mar 2021 15:52:12 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 10 Mar 2021 15:52:11 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/24] 5.4.105-rc1 review
Message-ID: <20210310235211.GE195769@roeck-us.net>
References: <20210310132320.550932445@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310132320.550932445@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 02:24:12PM +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.4.105 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
