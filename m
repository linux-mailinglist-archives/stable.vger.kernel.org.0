Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9A96ACF95
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 21:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjCFUxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 15:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjCFUxi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 15:53:38 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C43937B5D
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 12:53:37 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id r18so10198192wrx.1
        for <stable@vger.kernel.org>; Mon, 06 Mar 2023 12:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678136015;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QyIdiuydQzRyRRYEOWZBcl6yDDKMSyGp5EhIxpERjgA=;
        b=ge3AnYCirRpe0tVAGXhMzK2D/Ig2+Fg3WTVOnu5KJmjqu1p8Fs1Zr+5SAHCT5SEl/L
         CymU4xhofPVwgzUNfiEegUmt2vmYjnV7WkmiuYlHZE8Xj9HnGCo2UHjVETNFi85LpCKJ
         7zNQktC+cKMKcL3aDRzQjejq6zgRvPn++hRgE/yQ6lotE4UuWmXq/8PbPU2Lk+X5yYS0
         EItr0K/sZEmbP/l87VWm4TS7mQxjQ42ekydAlV7iXdE/qajDAcIOseYXXUtKXosDqbN3
         tOtldbjDw08+SBJ3WH1RxH94QLlCt2a2QJpy39QqBr/qlFZlFUwx/JFOVNLeC5YBEhYD
         30uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678136015;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QyIdiuydQzRyRRYEOWZBcl6yDDKMSyGp5EhIxpERjgA=;
        b=Dor51WqusHm5ZKeUZUZC18XRhV1kF4QrhWbtseSvUlBc9KGoO/V1/Ng5P6My/JeT6e
         FeSOpVKmeLCTg4+OqFgW7KHkDoyjLVx+Evz1Wfr8F2O+7JFd5YXh2qdF2ri0JpwPuOdk
         6xb69eUpvvRmsm5X79z8BcfrarDl62DvU2CvTvJTFYnyPMgI66v1BegZ0UAbRZXKG68/
         wOf1GrdEJCtZ2UFzaQuxi0zxxK3n10gEjtnQst6lLf7WXhD+Lb8ry5uYH/M+AbGWzpkp
         MDnDaae/bd4xaFkUG+4LHgsAzdcYe8aYUvykVNtDzrQ448/BrFv3LK9cf8DGlPDdGMnj
         BQmA==
X-Gm-Message-State: AO0yUKXN60OrsSScyOf5y4ZDIsPQyu4SEP7y7DPLFvaZzkoB/vry9E+o
        XRjoZNEKuwgTJMTTF6eQ/Ec=
X-Google-Smtp-Source: AK7set+9wnvIn9G36PcqhdyM8pj3IknOjvYcNEZ2hEkjd6QjKAbkpAfRmI9dx92x8WH2m8W8Pwz/wQ==
X-Received: by 2002:adf:e492:0:b0:2c7:1d70:561 with SMTP id i18-20020adfe492000000b002c71d700561mr6600870wrm.45.1678136015691;
        Mon, 06 Mar 2023 12:53:35 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id r11-20020a5d494b000000b002c54c9bd71fsm10408998wrs.93.2023.03.06.12.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 12:53:35 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
        id 22F6ABE2DE0; Mon,  6 Mar 2023 21:53:34 +0100 (CET)
Date:   Mon, 6 Mar 2023 21:53:34 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Christoph Hellwig <hch@infradead.org>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Subject: Re: Please apply commit 06e472acf964 ("scsi: mpt3sas: Remove usage
 of dma_get_required_mask() API") to stable series
Message-ID: <ZAZSzhH8NTSZxpu+@eldamar.lan>
References: <ZAMUx8rG8xukulTu@eldamar.lan>
 <ZAWUbo4HTXl/u8Zw@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAWUbo4HTXl/u8Zw@kroah.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Mar 06, 2023 at 08:21:18AM +0100, Greg Kroah-Hartman wrote:
> On Sat, Mar 04, 2023 at 10:52:07AM +0100, Salvatore Bonaccorso wrote:
> > Dear stable maintainers,
> > 
> > Please backport the aboove commit to the stable series. Note, though
> > as a first step it just applies cleanly to 6.1.y. Due to 9df650963bf6
> > ("scsi: mpt3sas: Don't change DMA mask while reallocating pools") it
> > does not apply cleanly to earlier series.
> > 
> > For context: There were several reports in Debian about regression in
> > 5.10.y already:
> > 
> > https://bugs.debian.org/1022268
> > https://bugs.debian.org/1023183
> > https://bugs.debian.org/1025747
> > https://bugs.debian.org/1022126
> > 
> > https://lore.kernel.org/linux-scsi/Y1JkuKTjVYrOWbvm@eldamar.lan/ is
> > the initial reporting to upstream and later on brought as well to the
> > regression list:
> > 
> > https://lore.kernel.org/regressions/754b030c-ba14-167c-e2d0-2f4f5bf55e99@leemhuis.info/
> > 
> > Thorsten suggested to first get the patch applied at least in 6.1.y
> > but for further steps down we need help. Sreekanth and Martin is this
> > still on your radar? Help with getting this back to 5.10.y would be
> > welcome, and I'm sure with a tentative patch I can get some of the
> > reporting users to report a Tested-by.
> 
> It only applies to 6.1.y, I would need a working backport to apply it to
> any older kernels.

Yes. Sorry if that was not clear from the above. Waiting fror input
from Sreekanth and Martin on it.

Regards,
Salvatore
