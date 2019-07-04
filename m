Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 075E45F249
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 07:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbfGDF2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 01:28:05 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33909 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbfGDF2E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jul 2019 01:28:04 -0400
Received: by mail-pg1-f193.google.com with SMTP id p10so2349183pgn.1;
        Wed, 03 Jul 2019 22:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1n66lybRz2BBooW4LCGS2ygiszJ16IsBgK4/RXES9oI=;
        b=umy/9vcjgyiyO7J2/XtKmpdvTsHufSK+AEQ/F6BCSUV6FOv10GT16t7n2MbzrL+GsQ
         QC0vqLXD7GP3zOq1gYQwZhT2Ab6eFKuqFzdeKserfZ0KsEhX0F1nfdRvTMSLM0yzXarN
         QtaJx+P3RgMQAk2LyYBlZBQmqgFtqUirEtvPQ7+owvdTWugLe6s7lmtzFhdn+7/OrtDD
         byzdAfVPgcrwA8R0gxpRZCKxFyqsKfPuRvUBt533J72tBamxWG5f5G9osUFX4yT7pBqW
         XmjpZ5nYP7e7A8HRokT+hwfpsRA9vfhXQh3GqVlHbDqwHW5p3j1OrICQo3Uxkt6wLAGL
         j5AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1n66lybRz2BBooW4LCGS2ygiszJ16IsBgK4/RXES9oI=;
        b=d/2Buz+GUH5uJgFG00XYPQ++WeJQpK4ZdEH5nN39pXPmiyrRtAibTuspCeeJYbMrAC
         A6pwIEQ/7TJeiP+uyE8r2JrURO+v8txbrecrPrSmGns7I/4Lq3TsKcnkl2bWJygiWe3/
         FmKgTvDuXznbEq+Zc2JtzTvAy72hguaE5gmXuhBfQB7Qz0iwTLKtpfrYg9iqI/qjlF9R
         QsjrVRV6cnGNq0Q7ak5U/SY81NDttnK0dOfNzuPma/GgpS+mP0RNqS7VX5xsFYXuQap8
         +8Wql2eFqKGObb7ImfG/Zn77LvlUL99PziQihvrWu3mUBBfubrdtRjSr8J+zEqnaqJ/f
         Lowg==
X-Gm-Message-State: APjAAAWVeQbnAWq4Lq8KF7eR4PLGY8odSH7DgDw3XA4CcRyYeSWrFpc/
        T0vJkBBL9nxB2vXybs25BjLRXEOl
X-Google-Smtp-Source: APXvYqzXwvbvExRb1AhWn0Hl6ucXcz/UGnPc/bx1Lm7WPwz69fU8Pvn9iztopDFqIbdl3pjup71Jpg==
X-Received: by 2002:a63:7e1d:: with SMTP id z29mr10336908pgc.346.1562218083856;
        Wed, 03 Jul 2019 22:28:03 -0700 (PDT)
Received: from bharath12345-Inspiron-5559 ([103.110.42.34])
        by smtp.gmail.com with ESMTPSA id h12sm4191717pje.12.2019.07.03.22.27.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 22:28:03 -0700 (PDT)
Date:   Thu, 4 Jul 2019 10:57:41 +0530
From:   Bharath Vedartham <linux.bhar@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/55] 5.1.16-stable review
Message-ID: <20190704052741.GB16449@bharath12345-Inspiron-5559>
References: <20190702080124.103022729@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tested and booted on my x86 system. No regressions.
