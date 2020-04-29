Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498291BE3C0
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 18:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgD2QZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 12:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726493AbgD2QZP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 12:25:15 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69229C03C1AD
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 09:25:14 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id h11so1002333plr.11
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 09:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=cROEAGYYza5/SrHokOviDRSWqd6+xhDTFL4geBPcAqo=;
        b=TTj5La8EAywCeDblq+PAGJEhTQj1V2T4mW2cP6wtmgtZIiyg85037V/7L9QzrkFkc2
         Lq5fFJpLmnjB40z8DFzNagGc2/pJWnluFbjixDpt3CpSSsGzLGbJG+aommwFUYbx08Vp
         GopVaWEZ37RQPSXsCwp5mbTrP9BnwZXzKVM7W1fZTu3Yo+CpzBv46miFzVx1WHBbj1zQ
         ux5dKi3q08yPPOnENS0ebhfo3VytpLuF1XUSpQl0EqEFru4ggMNCOPLjmRNZjtYoq+r+
         RXpgkrbfh2FZmRxeH6zjpvE6uxq8itG/r6QFVWpyFrqMUT/QzPlwcOeKGHcgm+K9VWjd
         I1gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=cROEAGYYza5/SrHokOviDRSWqd6+xhDTFL4geBPcAqo=;
        b=H34W957OTtcZBCAm3Et6HDgyYqVxRiGRXNnY/aDeO3EEZbD71Vf/Y+OoiTex+fTXyH
         C0S6L2LEPfLWCFwoxc73cVELAUqWnHMHyy1faqeNuEkIziKXJpK1ulCOu8w+Yqo+MRyj
         23WiqdWd6hZ6GT+BXCkuTwf3Jp7M2jc+FyVlzXN7ZQNL0PrFHdPnhT8aPUsal2imrghQ
         Vw9l5lK6z5/a+fIIYLpQ8zzC08fTXovELgWJIhSqaNqOfhmK4jnNUVE2isuVOABKx24u
         gAru8RhUJ66CpXWDo+9yUZexciq5HpFmPjpekH7FbYVw1WyuEAHq5rQRUPLixtHuXRls
         Alxg==
X-Gm-Message-State: AGi0PuaNiknKc30q7tTJoU6mFgSd9FKKnNYqIs4sR/ShhIL3jmhQQvRC
        oqErIplfqhU4nnJ1Zi8h5i567dMV
X-Google-Smtp-Source: APiQypIB3Qpt0qfR5kk3GEI06PQkYJNFCDc7xpf2azmvDvxw9cL0KDQbOvf2Mo4usqAdmOMwvb/Z9g==
X-Received: by 2002:a17:90a:17ed:: with SMTP id q100mr4353303pja.80.1588177513541;
        Wed, 29 Apr 2020 09:25:13 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k12sm1381409pfp.158.2020.04.29.09.25.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 Apr 2020 09:25:12 -0700 (PDT)
Date:   Wed, 29 Apr 2020 09:25:10 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Commit ab6f762f0f5 ("printk: queue wake_up_klogd irq_work only if
 per-CPU areas are ready") for v5.4.y/v5.6.y
Message-ID: <20200429162510.GA40432@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

commit ab6f762f0f53 ("printk: queue wake_up_klogd irq_work only if per-CPU
areas are ready") fixes a critical problem introduced with commit
1b710b1b10ef ("char/random: silence a lockdep splat with printk()").
Since commit 1b710b1b10ef has been applied to v5.4.y, commit ab6f762f0f53
needs to be applied as well.

An alternative might be to revert commit 1b710b1b10ef from v5.4.y, as
it was done for older kernel branches. However, we found that ab6f762f0f53
applies cleanly to v5.4.y and fixes the problem, so applying the fix
is probably a better solution.

Commit ab6f762f0f53 also needs to be applied to v5.6.y.

Thanks,
Guenter
