Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA6C64F8FB
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 13:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiLQMwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 07:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiLQMwg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 07:52:36 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA6BFD3E;
        Sat, 17 Dec 2022 04:52:35 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id a16so7069601edb.9;
        Sat, 17 Dec 2022 04:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V0/FvtrKk43Yr22AsZ/gI3Ef+eAPPhrmJIgnb/NYUVE=;
        b=k+3vOaldPGFjWNoAJ7Db4gTHx6kzwbAwHoZaHZHWgJngyWY7GPF4OxBYQLYNIP6yzE
         6TmfcjMrUDZUOTaY8TGfMXhjXy8Ul7HuCtgTYmcSP2ktHLdguSEHQk8sMawU/NRdUXEZ
         OkzOcwe1AsLiemxIPSkWfOKvupjOoKt18iXfZtg0EpwN58Yic6iNghrOqJY5MnDBLM5l
         7tx7DI2wqBQkikuJCI/AzAHeogAY/nxBM2noPmT6XLEQ5KAZnyO1W/vSjfSv5YtKst9p
         zz4ujrSl8ZT6axYQB5+8VDI6e8a9oIsYCfkSwYVtxUki96tBG4sXUc29T3vB0r+hvH7a
         tkyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V0/FvtrKk43Yr22AsZ/gI3Ef+eAPPhrmJIgnb/NYUVE=;
        b=14FP9WUd93RW0j3XLRz45EcrpFws69uOCbJQ6Xs/et9MbLp5Iyc/Z4ExMv6TH6hJY4
         tgRQOSUWyv1LPZsmXCRxr4dmZQcWhivqDkCf64c0a4+5ctGXOSVqNsuXpfKFNAICEr/e
         on1Ue0kgnkOkl7fVhof8C0LWUBiAX2TS30+5Nd6fei+tLbuHAecpyBxdRFu1tBlJVv52
         3bVawvaaVRYQGWvad8nr1OoZEG+0issmib6TBq81rjQKB3rhO4NBVy3Fh4b9GBJlz19E
         XtGEOoo1mOO7X9r8N3tLPZpO3aR/30URAQhbBsSbkrcjv9eiynOGoTZYJin2OEqG6a/T
         u8aw==
X-Gm-Message-State: ANoB5pkzx1ZHcz+oLUBVh/G8lDXC82q0bMNqb9iv9fKqLGOzTXE1NV3w
        qHdjeo49CzUOJYM0uiW/DYU=
X-Google-Smtp-Source: AA0mqf4yU7/dy5/Zo+Zy66e1jii/H1j6lhynuvV+b63JjoKEju9kvwMO4zvzJP0uBn0W0C4Zw1A/1Q==
X-Received: by 2002:a50:ed0a:0:b0:46b:19ab:68d8 with SMTP id j10-20020a50ed0a000000b0046b19ab68d8mr33837702eds.40.1671281553489;
        Sat, 17 Dec 2022 04:52:33 -0800 (PST)
Received: from rog (dynamic-046-114-141-166.46.114.pool.telefonica.de. [46.114.141.166])
        by smtp.gmail.com with ESMTPSA id d22-20020a056402401600b004585eba4baesm1946202eda.80.2022.12.17.04.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 04:52:32 -0800 (PST)
Date:   Sat, 17 Dec 2022 13:52:29 +0100
From:   Philipp Zabel <philipp.zabel@gmail.com>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     rafael@kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        anson.tsao@amd.com, ben@bcheng.me, paul@zogpog.com,
        bilkow@tutanota.com, Shyam-sundar.S-k@amd.com,
        stable@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ACPI: x86: s2idle: Stop using AMD specific codepath
 for Rembrandt+
Message-ID: <Y527jSpi96ARTZVN@rog>
References: <20221215191617.1438-1-mario.limonciello@amd.com>
 <20221215191617.1438-3-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215191617.1438-3-mario.limonciello@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Thu, Dec 15, 2022 at 01:16:16PM -0600 schrieb Mario Limonciello:
> After we introduced a module parameter and quirk infrastructure for
> picking the Microsoft GUID over the SOC vendor GUID we discovered
> that lots and lots of systems are getting this wrong.
> 
> The table continues to grow, and is becoming unwieldy.
> 
> We don't really have any benefit to forcing vendors to populate the
> AMD GUID. This is just extra work, and more and more vendors seem
> to mess it up.  As the Microsoft GUID is used by Windows as well,
> it's very likely that it won't be messed up like this.
> 
> So drop all the quirks forcing it and the Rembrandt behavior. This
> means that Cezanne or later effectively only run the Microsoft GUID
> codepath with the exception of HP Elitebook 8*5 G9.
> 
> Fixes: fd894f05cf30 ("ACPI: x86: s2idle: If a new AMD _HID is missing assume Rembrandt")
> Cc: stable@vger.kernel.org # 6.1
> Reported-by: Benjamin Cheng <ben@bcheng.me>
> Reported-by: bilkow@tutanota.com
> Reported-by: Paul <paul@zogpog.com>
> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2292
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=216768
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>

Reviewed-by: Philipp Zabel <philipp.zabel@gmail.com>
Tested-by: Philipp Zabel <philipp.zabel@gmail.com>

regards
Philipp
