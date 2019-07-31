Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF7F37B811
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 04:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfGaCxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 22:53:00 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37351 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbfGaCw7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 22:52:59 -0400
Received: by mail-pf1-f195.google.com with SMTP id 19so30941662pfa.4
        for <stable@vger.kernel.org>; Tue, 30 Jul 2019 19:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=56Bn5pwMSMLXsA6Sg66QvKIXarSTHoNqckCS8wh5DCE=;
        b=T5uPiL/v4zO7L+/UuiAFt+1GgbPGjLZpUWaYmgFyMFig9LiakhBOaJ2zS5/+XtanRm
         MTsOZEltRo5Tzcq3PeCMs6k3f0myRLUCegG6aMqTw2+69/Hya5c8GNZjyWBV+Bg1GpXE
         j6UtfLKhNC7PSgIEZdCBgQOmlQlszFjCktlCTLk9ocf07NxjKHknkxlLW62ABQYZwDUV
         vYYNex6Xw4pKG59W/1fVWm6ZdxvR/qDh5qYuKNr2GwRY/XYvWgTT5JpIOdpGY+CkwdLG
         n7zeJFHoeWZhQTbnOuiSGLxEyl/P123f8L/C7+MCAH1VP4ooiIQA2iKhsQ8IQ0D9rJff
         7MHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=56Bn5pwMSMLXsA6Sg66QvKIXarSTHoNqckCS8wh5DCE=;
        b=fhJUdxVKaBkKzySuYSXzgvBNrVOebd8qjOn/sa2DA1r2/Zsw33HewUg/ij4oYVHwRt
         9X+/HFEtd4utU7P0ypPsG72b5Q4PRTHRvFAgEiv/nogN5zSX12bun0JNAXDe/VpJDpii
         Rb/G2jdZD3GkidPvzq2Q5tWigwVhIPksWsSzA70/bbLrD8biASyBymWrtt6uHIBHt+2p
         PVUf8+YFRwD9G4UMZcgDfK20tRs+Es+NyQnk6Uyh2X2d49zXpv53CxPNQqoj2EbwnvE6
         2Xcg8+OVW28LVIWPujOcOnvv3M7AXJIyH1g8tGCxrriFEPEC6JoFBjD5Wcj2Ch6Y3yVh
         Rz0A==
X-Gm-Message-State: APjAAAXZ4ct8iuEOpbAq42IyfvbABXjMCPY17278efiS8VAxGYrDNj0c
        UP0u5e1ybOVVwRzOorF/P7uyld9ZmVk=
X-Google-Smtp-Source: APXvYqweDhuP41Q2XigbHyz53Mq5un5wB99GfLLAAUWTa/8XwSSoNBdz/WcJ67Oda9Ze+cRWXZaPQA==
X-Received: by 2002:a62:6044:: with SMTP id u65mr44053507pfb.15.1564541578548;
        Tue, 30 Jul 2019 19:52:58 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id b24sm35968813pfd.91.2019.07.30.19.52.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 19:52:57 -0700 (PDT)
Date:   Wed, 31 Jul 2019 08:22:53 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: Re: [PATCH v4.4 V2 00/43] V4.4 backport of arm64 Spectre patches
Message-ID: <20190731025253.ys4ph2hwa7hzdi5n@vireshk-i7>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12-07-19, 10:57, Viresh Kumar wrote:
> Hello,
> 
> This series backports arm64 spectre patches to v4.4 stable kernel. I
> have started this backport with Mark Rutland's backport of Spectre to
> 4.9 [1] and tried applying the upstream version of them over 4.4 and
> resolved conflicts by checking how they have been resolved in 4.9.

Since it has been almost 3 weeks since the patches are last posted,
here is a gentle reminder for reviewing it :)

-- 
viresh
