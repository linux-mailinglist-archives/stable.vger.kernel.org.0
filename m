Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21BD41795BA
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 17:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgCDQw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 11:52:27 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38644 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgCDQw1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 11:52:27 -0500
Received: by mail-pg1-f194.google.com with SMTP id x7so1256261pgh.5;
        Wed, 04 Mar 2020 08:52:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=O+IWH9/VJGKqjcXO+5Dmjhi6fFNEO2fCJbjERHhLO8Q=;
        b=QYd6sy2V3ZYMJioSZaclyPQp9MA4EatIs8wLu4CjQMeVRegEhMwWzpa3T22Mrofzxy
         eSiX5rsDD9yiFLNIUldO2H5LcY6sARQ2vZ4P7jop6GdJnECnqW96RXFD1DQscukeOPYM
         mUDeANTCOtvPNYoLIcmTzJytKTcXeOWg5W6KQn54nYyLig4HTlYGAKabXFF5jcIW+NAm
         xB9iLw9kgHCsMEVcX8A8XFQELgtTBtFle9M2pMvOc4rD1M78U22LaKty6pOyZDICigdA
         wG7LLAVvKAu+keO7OFppwAfE0pIMyZUU5yG0uCfYwH4izgJ5p5mA3I6SfzTKVHb8WGKe
         WnVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=O+IWH9/VJGKqjcXO+5Dmjhi6fFNEO2fCJbjERHhLO8Q=;
        b=h43I95mcZu7zkIXfA5y4UuglWnupSc/8hKtl+QkvFx73eXvj53jDmT8xpQQAvldnEC
         XbPOtWCcq0BNn4uOqWv7c8Cnx1yCAUoavY4LIx7VxAYI78FQZvMLT4QD8rlW9MyZF9z4
         QNHkE0ENbDfHTqBZUKxYzF7EVIgPvr181soKi2q9eR7R7b8QMH3rlmOdi37GQ2BxEP1G
         6FI9dHE7hTiS9axTTVoYi5qYaQJs5Mc+ZHMQWJB5AQe+53v79YhvLLtu7x8CHGsvStYk
         1besVkhumkRXcITVReW0Llq/YgQWPmTbg8imH66UbAz9XcbQsaz4Q9EjtaH++DBruEqm
         O3Mg==
X-Gm-Message-State: ANhLgQ1mp1L4C3l6YgpCIjiutraCH8G2IYTElNt4sROEBUQk8Tv6PmQM
        Qx1vba4BjFTHRyd46ZL6n+o=
X-Google-Smtp-Source: ADFU+vuIHxidRo4skphZgMQHYmfvJlnQGrrtl0W9QPyRGi6g4icyKEphqIzm40gN6MEXJm3wOy3CHQ==
X-Received: by 2002:aa7:9796:: with SMTP id o22mr3906364pfp.101.1583340746170;
        Wed, 04 Mar 2020 08:52:26 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u6sm27810267pgj.7.2020.03.04.08.52.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 04 Mar 2020 08:52:24 -0800 (PST)
Date:   Wed, 4 Mar 2020 08:52:23 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/87] 4.19.108-stable review
Message-ID: <20200304165223.GA22358@roeck-us.net>
References: <20200303174349.075101355@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 03, 2020 at 06:42:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.108 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Mar 2020 17:43:27 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 414 pass: 414 fail: 0

Guenetr
