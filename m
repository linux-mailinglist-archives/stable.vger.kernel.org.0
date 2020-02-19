Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6BA164E4A
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 20:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgBSTCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 14:02:22 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37547 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgBSTCV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Feb 2020 14:02:21 -0500
Received: by mail-pf1-f196.google.com with SMTP id p14so530106pfn.4;
        Wed, 19 Feb 2020 11:02:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:to:cc:cc:cc:subject
         :references:in-reply-to;
        bh=8ve6EAIa0mteEpntsUQ3aTXDFQ6XprvcJ5I+N3SPGaQ=;
        b=gp/JWMdRuQhZq3r638Uh84x5b1u8kP3cOCU/cld5iaolDmtWtgn/7PNjuzktWfX657
         K8r7hSYWtwQEJFyZdeSbYu+f7icosVg73HcDyqxn457TBzExZqfqm7WhtZMJmPGoXAT9
         HBsSkbNxrGLoI0EGRPtLcIpCkcISXO//7DqDKgoQX3OiMD6oQDtie0ubh/ak0UhXl0qF
         cCIf65r5UkPIdU9WvC12GF/7LJken8zvbcE5s/TXotLyWiGEh0LCyjxO6x92no7c27H7
         vZT58abZz3D0yD6wq84lfOgD/w4XTYaTlkvbHO3bBpVs01iqGtOyrZdtRa0IfIrlcoIK
         5nvg==
X-Gm-Message-State: APjAAAUGeNn3RK1VJ0xzQsjaetoaJg7h6J1BaQcnDkIJDTQytaqijazY
        S5IZw2u11PJulz1vSMH7Iq0=
X-Google-Smtp-Source: APXvYqx9OcV1TGaGspwn3Rsjucan0AVm2E8MH3mexVmIn3LIMMiVSPGYNtKZFipTVy3mhbKlh2ouVQ==
X-Received: by 2002:a63:2254:: with SMTP id t20mr29922920pgm.423.1582138940832;
        Wed, 19 Feb 2020 11:02:20 -0800 (PST)
Received: from localhost ([2601:646:8a00:9810:5af3:56d9:f882:39d4])
        by smtp.gmail.com with ESMTPSA id l29sm428731pgb.86.2020.02.19.11.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 11:02:20 -0800 (PST)
Message-ID: <5e4d863c.1c69fb81.25df8.14d3@mx.google.com>
Date:   Wed, 19 Feb 2020 11:02:14 -0800
From:   Paul Burton <paulburton@kernel.org>
To:     Paul Cercueil <paul@crapouillou.net>
CC:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
CC:     Zhou Yanjie <zhouyanjie@wanyeetech.com>, od@zcrc.me,
        linux-mips@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        stable@vger.kernel.org
CC:     linux-mips@vger.kernel.org
Subject: Re: [PATCH] MIPS: ingenic: DTS: Fix watchdog nodes
References:  <20200211145337.16311-1-paul@crapouillou.net>
In-Reply-To:  <20200211145337.16311-1-paul@crapouillou.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Paul Cercueil wrote:
> The devicetree ABI was broken on purpose by commit 6d532143c915
> ("watchdog: jz4740: Use regmap provided by TCU driver"), and
> commit 1d9c30745455 ("watchdog: jz4740: Use WDT clock provided
> by TCU driver"). The commit message of the latter explains why the ABI
> was broken.
> 
> However, the current devicetree files were not updated to the new ABI
> described in Documentation/devicetree/bindings/timer/ingenic,tcu.txt,
> so the watchdog driver would not probe.
> 
> Fix this problem by updating the watchdog nodes to comply with the new
> ABI.
> 
> Fixes: 6d532143c915 ("watchdog: jz4740: Use regmap provided by TCU
> driver")

Applied to mips-fixes.

> commit 11479e8e3cd8
> https://git.kernel.org/mips/c/11479e8e3cd8
> 
> Fixes: 6d532143c915 ("watchdog: jz4740: Use regmap provided by TCU driver")
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> Signed-off-by: Paul Burton <paulburton@kernel.org>

Thanks,
    Paul

[ This message was auto-generated; if you believe anything is incorrect
  then please email paulburton@kernel.org to report it. ]
