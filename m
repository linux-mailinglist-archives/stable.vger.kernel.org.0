Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1A66AA903
	for <lists+stable@lfdr.de>; Sat,  4 Mar 2023 10:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjCDJwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Mar 2023 04:52:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjCDJwM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Mar 2023 04:52:12 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DABA18152
        for <stable@vger.kernel.org>; Sat,  4 Mar 2023 01:52:10 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id q16so4431379wrw.2
        for <stable@vger.kernel.org>; Sat, 04 Mar 2023 01:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677923529;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=hHyp+2d4yiZBmL7TlrkW3/dAr7k1h7hgYIqxni25jL4=;
        b=CEcZV76qcifjkWnrMtwFRkC3GPCxeBhUG8ODpGEiZTTo56riA0VhqRZ083YFheFZ4r
         kHifQJJbBoPBmeozPUsiSKi8mqzb2BdnJT+B6B2thyujwT2J93BXXjyPANsSRKDHf5Iv
         ZP07zM0O5T4CQbAr7Cc8dPXDwzoh46m4b60ErRIs7KCSAZSfrHBjNh9ZV9CjgGxgT51L
         VDHUJDTaLkIUiuoDqckDktvFS7nbvFQ5iIznGQMF53+eoLsxWyinXWgMTDCBOTHCAD2Z
         j325hC8rdzFImIPvcGHTDxbe+Vlr5FMtHaeDTTUFeIWn0WMjpe9hwCE9dxsuq4BOLsvo
         u3Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677923529;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hHyp+2d4yiZBmL7TlrkW3/dAr7k1h7hgYIqxni25jL4=;
        b=F+poB42hCRSgig90CskM4P4vcdzCtv0dztg2wxhWgsJeVNp7083Wka7rQabpTWMU7L
         S+OCsdDE1jAqvvCKbJy/fgc5ab4v1ZjieUWXIC5LkvJOCRWoaQeAMYX0+psdyHjfl4Ld
         DehdEl2C8dPXsuIT3vQKHMuXA9d+OGBYJM5oi7uSKx9wt5fOsdut8s5qb9S6iuqxnYRj
         2UzTQD9jzJv4ZFhpcGuHE+KG97y3MinR3ARdmPlzvTtI8+sIIpv1j9Ftds4MkmBl+PQM
         EOQ/y3Q9wy9Ofag8O6mEqTYcBVqqSCGVAL8u+P6DZQE5fiuUpjHZ4FNuZVR7HhxpESad
         D/5Q==
X-Gm-Message-State: AO0yUKXjPTDm5pmCHGEbrfBkkMz6t6c5Pa4n8IlGhnym1DTYZTW3dnIz
        WJmz6OKMeySC8niXFydwk/E=
X-Google-Smtp-Source: AK7set9kQ83vnsOEZgQr1aM6jS/HyB2ZFEfEtLrOUivWD4p/LIvvhiZlFXugzEVRB01qPuh8d65Jog==
X-Received: by 2002:a5d:614d:0:b0:2c7:d6a:cca9 with SMTP id y13-20020a5d614d000000b002c70d6acca9mr3385149wrt.23.1677923528857;
        Sat, 04 Mar 2023 01:52:08 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id t20-20020a0560001a5400b002c54f4d0f71sm4616431wry.38.2023.03.04.01.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Mar 2023 01:52:08 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
        id 4EBFCBE2DE0; Sat,  4 Mar 2023 10:52:07 +0100 (CET)
Date:   Sat, 4 Mar 2023 10:52:07 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Christoph Hellwig <hch@infradead.org>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Subject: Please apply commit 06e472acf964 ("scsi: mpt3sas: Remove usage of
 dma_get_required_mask() API") to stable series
Message-ID: <ZAMUx8rG8xukulTu@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear stable maintainers,

Please backport the aboove commit to the stable series. Note, though
as a first step it just applies cleanly to 6.1.y. Due to 9df650963bf6
("scsi: mpt3sas: Don't change DMA mask while reallocating pools") it
does not apply cleanly to earlier series.

For context: There were several reports in Debian about regression in
5.10.y already:

https://bugs.debian.org/1022268
https://bugs.debian.org/1023183
https://bugs.debian.org/1025747
https://bugs.debian.org/1022126

https://lore.kernel.org/linux-scsi/Y1JkuKTjVYrOWbvm@eldamar.lan/ is
the initial reporting to upstream and later on brought as well to the
regression list:

https://lore.kernel.org/regressions/754b030c-ba14-167c-e2d0-2f4f5bf55e99@leemhuis.info/

Thorsten suggested to first get the patch applied at least in 6.1.y
but for further steps down we need help. Sreekanth and Martin is this
still on your radar? Help with getting this back to 5.10.y would be
welcome, and I'm sure with a tentative patch I can get some of the
reporting users to report a Tested-by.

While people are "unhappy" why it is not fixed yet in Debian, I'm not
willing to diverge and appy a patch which is not approved and aimed to
go upstream into the respective stable series. But I have too less
knowledge here to see which is the correct change to apply to back to
5.10.y alone in case we need to diverge, as 9df650963bf6 picking as
well is not an option. Input from you experts on that would be more
the appreciated.

Regards,
Salvatore
