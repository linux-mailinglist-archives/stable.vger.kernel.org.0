Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7054138A1F
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 05:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387474AbgAMEEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jan 2020 23:04:47 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35845 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387415AbgAMEEr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jan 2020 23:04:47 -0500
Received: by mail-ed1-f67.google.com with SMTP id j17so7254675edp.3;
        Sun, 12 Jan 2020 20:04:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YnyjyeBwwZr9qnp1y/94ZH/bjZ4Zleb23W13zJRNH0w=;
        b=cJYOu5uurFKRO2SGrHsFjHIYKq5KdS4yXez4riFZ8I/8c5IOBse1eVwxDQdLDlwzN+
         ArC0ZR+jJn5H81WpOYAHHbnpI8bagGBezCK6088Y0NRua9PMh4H7eAtDuYDNPzEL/jJZ
         tzOWQe5URR7E67mqf3tzEIlDgB98eghseSlHDiqEPTrmowBtSiVX2LIX8ga2kZ3g5CRQ
         phvh5gfNQ3TV+BrAwGirYaiDLK249hOfaG4k704WjFoTRso0+5B0lH0wTLHr1o2sUyIV
         Fp6CP+7hGHWtzEY221kb4cfLikNx24Np1xsi9JpcOjTJKkNy0LTAGFpb9KzujStBZumg
         MeeQ==
X-Gm-Message-State: APjAAAXD3Jeobz5t1GXcloneMoy3XEEjtBg4RNsNdTrx6aFBWfT4Likp
        N0Z2AQ8QVFtIsuBw2el/HQeSG4JwBYM=
X-Google-Smtp-Source: APXvYqzddlPRYzVrqaVhh49IUibhAGSKzYOaoynWHr9wBegeTSuSFI7W3jWGkyZafxKfIsZNMUg4pQ==
X-Received: by 2002:a50:dacd:: with SMTP id s13mr15165113edj.194.1578888285416;
        Sun, 12 Jan 2020 20:04:45 -0800 (PST)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com. [209.85.128.49])
        by smtp.gmail.com with ESMTPSA id o19sm414495ejx.36.2020.01.12.20.04.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jan 2020 20:04:45 -0800 (PST)
Received: by mail-wm1-f49.google.com with SMTP id d73so8089485wmd.1;
        Sun, 12 Jan 2020 20:04:44 -0800 (PST)
X-Received: by 2002:a1c:a50e:: with SMTP id o14mr16972151wme.2.1578888284770;
 Sun, 12 Jan 2020 20:04:44 -0800 (PST)
MIME-Version: 1.0
References: <20200113035310.18950-1-samuel@sholland.org> <20200113035310.18950-2-samuel@sholland.org>
In-Reply-To: <20200113035310.18950-2-samuel@sholland.org>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Mon, 13 Jan 2020 12:04:36 +0800
X-Gmail-Original-Message-ID: <CAGb2v66GOHBkuEaKZTe1ez4WHwyY28jvhO3ADfDPOzzH6Ui4pQ@mail.gmail.com>
Message-ID: <CAGb2v66GOHBkuEaKZTe1ez4WHwyY28jvhO3ADfDPOzzH6Ui4pQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/8] power: supply: axp20x_ac_power: Fix reporting
 online status
To:     Samuel Holland <samuel@sholland.org>
Cc:     Sebastian Reichel <sre@kernel.org>,
        Oskari Lemmela <oskari@lemmela.net>,
        "open list:THERMAL" <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 13, 2020 at 11:53 AM Samuel Holland <samuel@sholland.org> wrote:
>
> AXP803/AXP813 have a flag that enables/disables the AC power supply
> input. This flag does not affect the status bits in PWR_INPUT_STATUS.
> Its effect can be verified by checking the battery charge/discharge
> state (bit 2 of PWR_INPUT_STATUS), or by examining the current draw on
> the AC input.
>
> Take this flag into account when getting the ONLINE property of the AC
> input, on PMICs where this flag is present.
>
> Fixes: 7693b5643fd2 ("power: supply: add AC power supply driver for AXP813")
> Cc: stable@vger.kernel.org
> Signed-off-by: Samuel Holland <samuel@sholland.org>

Reviewed-by: Chen-Yu Tsai <wens@csie.org>
