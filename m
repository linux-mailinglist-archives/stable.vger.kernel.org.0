Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A927439CF0C
	for <lists+stable@lfdr.de>; Sun,  6 Jun 2021 14:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhFFMgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Jun 2021 08:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbhFFMgE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Jun 2021 08:36:04 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813ECC061766;
        Sun,  6 Jun 2021 05:34:14 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id c10so21853451eja.11;
        Sun, 06 Jun 2021 05:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=2ne4so7aRRUV0VoDQgZq0B5fQZUAB/4sfsbMfwYFgt8=;
        b=UtER8GAvPS0hr8zd8sQUFC1hmrPyNlFZbQsgwfTdGtRsVRWwQFnTkLA5WH8xVgQCpR
         h2JstD00wUf5WqDcBjy7YqkL23T+PdgN/tUnmBp3ajgyINelMZCWxm1jh4U8bwOSvitQ
         Dtqgapz0f0/MS/Cx907mIZcb2owbI1gdxhxMr//LObczuRMEJ0472ve28MnuQ8Qy2f/Y
         56HDf3ffZdQ4cMJtn9M4FRTsV6y+s3hfgG/LQkyictJHed8+8KnwVWd8mNHcifCEhUwI
         sDAtZwDRsNsirTcPVidy+q5+tckbrtxHwxwcQ9KOwfs8NZ4wJ1gl+MAYm1js37TJtSmP
         rZ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=2ne4so7aRRUV0VoDQgZq0B5fQZUAB/4sfsbMfwYFgt8=;
        b=kEth5bA5sbESuqVCNKB6/UTP/w2PgsSv2WgrSKsYLWkuZIaw4cbTibQlCZb29Rv4Ox
         tZIuz/EfFOqJNCYUDk2zRwNxpoGQI1ZK24FyeVpFTVDOYImyeReBKg/oizZngDTGuxkv
         W/OIP1wBA3cf+2P0Orbp6KN9C2y1B3tE2c5j2+fxP7w2dluqvaJP6lUd5mdIuPsuyZpo
         vuUV5I48yg0rOkpIphfrCDtqttbWp0rQ0YU473JxDNpp7gmrLh7FdyL6VyTa8mkzfKit
         3EMMfuU9s+6PTaWhtSCvgdtlKwse4sq+ipLbOMtO8pmSppGCatLF4Sasfyi11uesaSFu
         04Pg==
X-Gm-Message-State: AOAM533+lViQ7BMPhdLeyHOIPZf0x3W/ZaolRrl5r7SS+R1cd3vfO3Tm
        dqCX5JZsuzK6b04b3o4KP2T1dJEkm5DA/A==
X-Google-Smtp-Source: ABdhPJxq7GMEQlgMJaUczYZCdSeiiQNtBQtfJuKV/Zw6ne6ggaixFkJYTJXy19ClFL+QuYF9Zi7Odw==
X-Received: by 2002:a17:906:4fcb:: with SMTP id i11mr3347670ejw.366.1622982853120;
        Sun, 06 Jun 2021 05:34:13 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id n5sm1575845edd.40.2021.06.06.05.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jun 2021 05:34:12 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Sun, 6 Jun 2021 14:34:11 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg KH <greg@kroah.com>
Cc:     =?utf-8?Q?Lauren=C8=9Biu_P=C4=83ncescu?= <lpancescu@gmail.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Backporting fix for #199981 to 4.19.y?
Message-ID: <YLzAw27CQpdEshBl@eldamar.lan>
References: <c75fcd12-e661-bc03-e077-077799ef1c44@gmail.com>
 <YLiNrCFFGEmltssD@kroah.com>
 <5399984e-0860-170e-377e-1f4bf3ccb3a0@gmail.com>
 <YLiel5ZEcq+mlshL@kroah.com>
 <addc193a-5b19-f7f3-5f26-cdce643cd436@gmail.com>
 <YLpJyhTNF+MLPHCi@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YLpJyhTNF+MLPHCi@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Laurențiu, Greg,

On Fri, Jun 04, 2021 at 05:42:02PM +0200, Greg KH wrote:
> On Fri, Jun 04, 2021 at 04:50:19PM +0200, Laurențiu Păncescu wrote:
> > Hi Greg,
> > 
> > On 6/3/21 11:19 AM, Greg KH wrote:
> > > That commit does not apply cleanly and I need a backported version.  Can
> > > you do that and test it to verify it works and then send it to us to be
> > > applied?
> > 
> > I now have a patch against linux-4.19.y, tested on my EeePC just now: the
> > battery status and discharge rate are shown correctly.
> > 
> > I've never submitted a patch before, should I put "commit <short-hash>
> > upstream." as the first line of my commit message, followed by another line
> > stating which branch I would like this to be merged to? Should I also
> > include the original commit message of the backported commit? And then use
> > git format-patch? I just read through [1] and [2], but they don't say
> > anything specific about commit messages for backported patches.
> 
> Yes, what you describe here should be great.  Look at the stable mailing
> list archives on lore.kernel.org for other examples of this happening,
> https://lore.kernel.org/r/20210603162852.1814513-1-zsm@chromium.org is
> one example.

Instead of doing a specific backport, maybe it is enough to pick
a46393c02c76 ("ACPI: probe ECDT before loading AML tables regardless
of module-level code flag") frst on 4.19.y and then the mentioned fix
b1c0330823fe ("ACPI: EC: Look for ECDT EC after calling
acpi_load_tables()").

Note I have only checked that this resolved the clean apply on top of
the current v4.19.193.

Regards,
Salvatore
