Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEB62B3B74
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 03:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbgKPCUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Nov 2020 21:20:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgKPCUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Nov 2020 21:20:03 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0297C0613CF
        for <stable@vger.kernel.org>; Sun, 15 Nov 2020 18:20:02 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id q22so15538802qkq.6
        for <stable@vger.kernel.org>; Sun, 15 Nov 2020 18:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=0y9XyRmQKhhrTLP4iKfzDNSMPctS5Lsy1tUWaX8yTAI=;
        b=mQhRkjUh+C7zH4CxpWVSOzFgrWYcbrO8Hu78D9Mm4OC7vWO+LaNBq087TeLEnje1TL
         38AfRous9aA6HWOpK6wez9XvFez366WOfEcIS1n458x0gQMzxG0qQKlGSw9ukZXJAQJ+
         QvXLdpGDSm5Jcbx7/6t7r2LCpUyYJzzc80RPNPUTLTiFrddzeyk+uKkid+EcZx5UWX22
         y09lVb+pFjCpoq+nD51FouZT0sms0FCL9uZro2ZCNLPIGgkSq+7c5pnDGQ6QoZXice+c
         gDDOw3vV7jBJf33EkA0UNGEppNtL04mqQIq+p7PuCDZCPTx0ZrzFi3rI8e8wJarBK2+s
         qS9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=0y9XyRmQKhhrTLP4iKfzDNSMPctS5Lsy1tUWaX8yTAI=;
        b=K6ro0Nq212kIZ3Nvy/SYfEQzlgZuG1zfEw4cHJn0/Q2DSgj+xvspr3LBVysgkm4iGy
         JLijbEFl/NxOc1tnLHpCibhqJhy4KRnCf1ezhrbFPPVXeRQkseYBfUFBVbDpOMMTJIYp
         JfqmFHEQGpl9GkNtRbfLH7wwMKpJWjT1yZ78Jq6nxMLJbZZ8F3wHlqj7BYxnR7x/TMD8
         M8uOj3Utz9llMkLWOq9FQzwV5vtLduhbrdB1KskU7PBTJFzEuoc/m7acPLvpJ0K5VnQY
         ms3T7/utp/sT1KMl0Y/rBipCABoC/EfquHw/wSJNhC70JengbY+LJIQf4YK3GX0z6WLx
         Hbcw==
X-Gm-Message-State: AOAM532jFttl9MRiEOe5uQ8ukIk7trYaq2xqEryoUciJqkFQ2ykTNiWf
        6W6QjHBTMIOZjlBwe+W30RV/9z4a6Ac=
X-Google-Smtp-Source: ABdhPJxttMZMIRRC9mtKonRbsUmnObaUtPBSUmBYIhahFglvoSl1rcMgrt71I/8VRGcrsGr5juxteA==
X-Received: by 2002:a37:a1c1:: with SMTP id k184mr12576399qke.287.1605493201603;
        Sun, 15 Nov 2020 18:20:01 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id s27sm11694342qkj.33.2020.11.15.18.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 18:20:00 -0800 (PST)
Date:   Sun, 15 Nov 2020 19:19:59 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     Martin =?iso-8859-1?Q?Hundeb=F8ll?= <martin@geanix.com>,
        Mark Brown <broonie@kernel.org>
Subject: Apply bc7f2cd7559c5595dc38b909ae9a8d43e0215994 to 5.4+
Message-ID: <20201116021959.GA4186045@ubuntu-m3-large-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg and Sasha,

Please apply commit bc7f2cd7559c ("spi: bcm2835: remove use of
uninitialized gpio flags variable") as a fix to commit
5e31ba0c0543 ("spi: bcm2835: fix gpio cs level inversion"), which
appears to be in 5.4 and 5.9 at the time of writing this. I did not try
to apply it but I did not see an outstanding failure email about it. If
it does not apply cleanly, let me know.

Cheers,
Nathan
