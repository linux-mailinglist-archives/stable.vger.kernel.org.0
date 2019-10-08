Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24796CF4F3
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 10:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbfJHIYP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 8 Oct 2019 04:24:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48292 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730167AbfJHIYO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 04:24:14 -0400
Received: from mail-pl1-f200.google.com ([209.85.214.200])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1iHkmz-0005x3-4g
        for stable@vger.kernel.org; Tue, 08 Oct 2019 08:24:13 +0000
Received: by mail-pl1-f200.google.com with SMTP id d2so10386178pll.0
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 01:24:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=EpUnbaIFIsvPdXiYRFuIt+BLr84ee69Iv1VzaPWhcis=;
        b=Qud25b8P4aEhLkre6WcfTXFH+EyeueD+7rYx0rfg0U3YTbyJoTyfJLO3QHmE2tLS0K
         d1/gLQNIMDfQHoLW1KZ5bdhsUCOt0ucyRLmh6UeZRAQ+b8rQAnt/We/J+DSCvBsM7J8g
         Zpnf/QpOtXXWRy6SItd4AKJKEWr5aVHrn6p0toNAOTRss27/e606ctlfStLaJY6QGzeC
         tbTaDRixQObSMxLXCENaEP03uuRjeObVyigsBvLoI18BRM1P3k3Y1+wH+WlmdsL2Z9KM
         xjbyjtpF166tR9Ni462W6k86DyAX+SkSXuOq7iYE+cEbhgZZQNR+LkAmU4ndMrBPI3hT
         oZDQ==
X-Gm-Message-State: APjAAAXdByx10O8p77PJzdhlygqbAAv/o9aXLaOzab5OUawCuNrPA4X+
        CuZz28L5+CjUHoAz6QEfoCRohH4cIPpJWYTVpkpEdDXPzn7eQCaLwnP4S77r4uiDBp58gfe7Ncv
        R4UitX/wcpvXUI4NNCL9R5S+MyFTepoyCPQ==
X-Received: by 2002:a63:5020:: with SMTP id e32mr1929504pgb.302.1570523051556;
        Tue, 08 Oct 2019 01:24:11 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz8lfZOtmUGBUaLob+ysCYWb5ZUJKfV0ywa+5MiQ2rXppPua31DNuu2dIyLeNUpx64VLUVV7w==
X-Received: by 2002:a63:5020:: with SMTP id e32mr1929478pgb.302.1570523051170;
        Tue, 08 Oct 2019 01:24:11 -0700 (PDT)
Received: from 2001-b011-380f-3c42-1138-6cd0-3dc6-cfa2.dynamic-ip6.hinet.net (2001-b011-380f-3c42-1138-6cd0-3dc6-cfa2.dynamic-ip6.hinet.net. [2001:b011:380f:3c42:1138:6cd0:3dc6:cfa2])
        by smtp.gmail.com with ESMTPSA id w189sm17403666pfw.101.2019.10.08.01.24.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 01:24:10 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3594.4.19\))
Subject: Re: [PATCH] drm/edid: Add 6 bpc quirk for SDC panel in Lenovo G50
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <54557F79-6DE1-4AA4-895A-C0F014926590@canonical.com>
Date:   Tue, 8 Oct 2019 16:24:08 +0800
Cc:     dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <E40AB4FE-7F61-48C9-A1C9-C24454FE0586@canonical.com>
References: <20190402033037.21877-1-kai.heng.feng@canonical.com>
 <54557F79-6DE1-4AA4-895A-C0F014926590@canonical.com>
To:     maarten.lankhorst@linux.intel.com, maxime.ripard@bootlin.com,
        sean@poorly.run, airlied@linux.ie, daniel@ffwll.ch
X-Mailer: Apple Mail (2.3594.4.19)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Jun 6, 2019, at 16:04, Kai-Heng Feng <kai.heng.feng@canonical.com> wrote:
> 
> Hi,
> 
> at 11:30, Kai-Heng Feng <kai.heng.feng@canonical.com> wrote:
> 
>> Another panel that needs 6BPC quirk.
> 
> Please include this patch if possible.

Another gentle ping.

> 
> Kai-Heng
> 
>> 
>> BugLink: https://bugs.launchpad.net/bugs/1819968
>> Cc: <stable@vger.kernel.org> # v4.8+
>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> ---
>> drivers/gpu/drm/drm_edid.c | 3 +++
>> 1 file changed, 3 insertions(+)
>> 
>> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
>> index 990b1909f9d7..1cb4d0052efe 100644
>> --- a/drivers/gpu/drm/drm_edid.c
>> +++ b/drivers/gpu/drm/drm_edid.c
>> @@ -166,6 +166,9 @@ static const struct edid_quirk {
>> 	/* Medion MD 30217 PG */
>> 	{ "MED", 0x7b8, EDID_QUIRK_PREFER_LARGE_75 },
>> 
>> +	/* Lenovo G50 */
>> +	{ "SDC", 18514, EDID_QUIRK_FORCE_6BPC },
>> +
>> 	/* Panel in Samsung NP700G7A-S01PL notebook reports 6bpc */
>> 	{ "SEC", 0xd033, EDID_QUIRK_FORCE_8BPC },
>> 
>> -- 
>> 2.17.1
> 
> 

