Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06ABFFD07F
	for <lists+stable@lfdr.de>; Thu, 14 Nov 2019 22:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfKNVnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 16:43:05 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:39125 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfKNVnF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Nov 2019 16:43:05 -0500
Received: by mail-io1-f67.google.com with SMTP id k1so8553040ioj.6
        for <stable@vger.kernel.org>; Thu, 14 Nov 2019 13:43:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OuheF7AXL4KEuu5esQPEloYFJLM+rFePn8qyxHsJg4E=;
        b=wUE42iaD6J1KTnO6y4RL65zgRjxgDPIY7aq2aHxhzZu5x6ofXzqnxA+0DXq/qIVUML
         7KRqZAALfvu+NQu9Vmsx4y5oEzQVnM6t3yQ8P9Hm2Ngq0OIhAynC6/6LP/dGxBXsXRO6
         XR2k1Fj3AgwmxXH47ULMm9OkqlrjAktMcd2U6sMT61CTpGWHWGgppw4OANG7N2qQSzxr
         yug/9tMdELD8J8RcfdGOKwRTWjmRbakgdcpr8I7K53bFHbEXnNIs5AgOpjai2gp06HrD
         WteTQ5K8sa87CqvVRhlJu4qeg/vrch7Ws+qH9aLbXBPf8bKvAQHDMmIaSTi8qR70mI8E
         7ijg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OuheF7AXL4KEuu5esQPEloYFJLM+rFePn8qyxHsJg4E=;
        b=LCEpussVqucswBiybYrEvfVBXg8FZjcP2j6XwwmHa/U5uILb/4IWVIzHXUscWioIjM
         Oxt8lad1LvA0LURAHm+R1xBUJ6Cikxy5OmUsNknDWoVcKHAyq9UZFb8v5oevuemtAKTV
         mLhBpMdxaVg4emk40Cti9p169DQc8/v6QAcUZpKzFuDBTB6CmqlRtyvmk8fSXbplw6sp
         Pczs/1h1Qck5Qi5NbXZuOHqTlaQNqkMfetPKkaiVMUC9Nt60Erdp9WVRpl9Wvep6KzxD
         rDUne1CfEufCsUeif1iAylmt2BUg+9QKKWKuFYDgMMaSL3dLKKUlMaO2RTqlbN0FIX//
         8MJQ==
X-Gm-Message-State: APjAAAVwuC7K2eJRNKcYEExvLQdeTMRyDr3cNwhbGFpYuj8ordI8NGSS
        P98aY2+LNVsZl1u0TLFcJT7JZA==
X-Google-Smtp-Source: APXvYqykHIZm7W8ks21s27PuMpYGDitmGtY9cXfyCZVREuyY1mIarwRIzqjtcnv99tMPNLWzr/a8fw==
X-Received: by 2002:a02:3f1e:: with SMTP id d30mr668548jaa.102.1573767784130;
        Thu, 14 Nov 2019 13:43:04 -0800 (PST)
Received: from google.com ([2620:15c:183:200:855f:8919:84a7:4794])
        by smtp.gmail.com with ESMTPSA id c10sm955237ilq.37.2019.11.14.13.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 13:43:03 -0800 (PST)
Date:   Thu, 14 Nov 2019 14:43:01 -0700
From:   Ross Zwisler <zwisler@google.com>
To:     Jacob Rasmussen <jacobraz@chromium.org>
Cc:     linux-kernel@vger.kernel.org,
        Jacob Rasmussen <jacobraz@google.com>,
        Bard Liao <bardliao@realtek.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Oder Chiou <oder_chiou@realtek.com>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ASoC: rt5645: Fixed typo for buddy jack support.
Message-ID: <20191114214301.GA159315@google.com>
References: <20191114190844.42484-1-jacobraz@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191114190844.42484-1-jacobraz@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 14, 2019 at 12:08:44PM -0700, Jacob Rasmussen wrote:
> Had a typo in e7cfd867fd98 that resulted in buddy jack support not being
> fixed.
> 
> Fixes: e7cfd867fd98 ("ASoC: rt5645: Fixed buddy jack support.")
> Cc: <zwisler@google.com>
> Cc: <jacobraz@google.com>
> CC: stable@vger.kernel.org

Need to add your signed-off-by.  With that added you can add:

Reviewed-by: Ross Zwisler <zwisler@google.com>
