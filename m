Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83EB0DB4BB
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 19:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732385AbfJQRty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 13:49:54 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37727 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729798AbfJQRty (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 13:49:54 -0400
Received: by mail-pl1-f196.google.com with SMTP id u20so1484413plq.4;
        Thu, 17 Oct 2019 10:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=/QpBt/5mAOgelZJiTzAwHWuluSTu6a1opW8nwuOlEe4=;
        b=oXzly/O4Ik9JE2BGj2REu8kmJYtB7cafrsbA696k61+qtizgxIUOnU2dM/ZnC4W4tr
         5JzwZnhwF38omXMNLPtNN2tSNT+lWTb3RUnH+f0o2E8R5uIE78tg6OFyWM0y5oD7gwnv
         52nCJQWdNCLZdcSEqnUMqIL558XcoDNg72ylbADGAkNrQJJ8AkSDprsTyxHQtoUV5S2Q
         F7kNnBj6lZw8kc6uShy/oNUYIItjq/8dyYb/L09rkayGHuq47fNUsRsTFjDT9vfAY6u2
         SiDNMl2h7A/z6ONBuVSjapZY9nJRr1P+YfdEHzyHdF5Qmep+cdDwciwzF7AfO3wraJcK
         VDUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=/QpBt/5mAOgelZJiTzAwHWuluSTu6a1opW8nwuOlEe4=;
        b=RSmInVffqT0zf75LaNJdipqlQi5udniLYKvFUArh8NjXF/Ogf5aqbsNjrGtnRT9mXA
         trRMjSXvWlgjrKI2GYAPEcJp+uzXhc88u9fqhtfoAEjlyLLb2cLk+7C3evYpA4Wfpb6e
         LkcB1AJ2YWjy1wnf0ojdfBnUh7OvXoDO0yMGBQjSV8sZMA3mpSwcE+LSvOG3bCApCKye
         3A1G/EaEDsV7MF0IZwYzz4VsTnJKNE1L+CT7gr1WgJsuQkxePxbMDauZI5vnVTSHyX1w
         58itPTC8SPCLf5xjicuzWTW71w1gmK54XxeRlKm0M96fzoaqy3OKss2cC12Nf5QETXJQ
         OTUg==
X-Gm-Message-State: APjAAAW+tj/GEd7RdlwLHF/10BYH072FqgnNaJty1bYRRoIRiIzFIFYL
        SPlilv1Oe39F9kvFr9cui5g=
X-Google-Smtp-Source: APXvYqyu0QXMHaXeDuPzBNWe8UL/n21EdJYj2QxWirL3fT4lDQ0iBo5AJNm1rbGIu+XMSuH+7w8cYQ==
X-Received: by 2002:a17:902:123:: with SMTP id 32mr5383248plb.258.1571334593388;
        Thu, 17 Oct 2019 10:49:53 -0700 (PDT)
Received: from iclxps (155-97-232-235.usahousing.utah.edu. [155.97.232.235])
        by smtp.gmail.com with ESMTPSA id o11sm2790242pgp.13.2019.10.17.10.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 10:49:52 -0700 (PDT)
Message-ID: <b113dd8da86934acc90859dc592e0234fa88cfdc.camel@gmail.com>
Subject: Re: [PATCH v5 2/4] lib: devres: add a helper function for ioremap_uc
From:   Tuowen Zhao <ztuowen@gmail.com>
To:     Sasha Levin <sashal@kernel.org>, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org
Cc:     andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
        stable@vger.kernel.org
Date:   Thu, 17 Oct 2019 11:49:50 -0600
In-Reply-To: <20191017143144.9985421848@mail.kernel.org>
References: <20191016210629.1005086-3-ztuowen@gmail.com>
         <20191017143144.9985421848@mail.kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry, patches in this set should have tag # v4.19+

Should I resubmit a set with the correct tags?

Tuowen

