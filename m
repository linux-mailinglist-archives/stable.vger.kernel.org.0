Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435116B2086
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 10:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjCIJrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 04:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjCIJqm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 04:46:42 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2489EE681F
        for <stable@vger.kernel.org>; Thu,  9 Mar 2023 01:45:30 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id j3so713595wms.2
        for <stable@vger.kernel.org>; Thu, 09 Mar 2023 01:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678355128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r/CEEmT9yjwga5EOHyB11d5kpRkYTDfVDqStXRyqNgs=;
        b=D7JT75tlmd/63EQMbsBVoZ3YA+taB5qGiDaNgUfQ/cxc768vaRZdImoxJqLhzpqPXE
         3Z33wJOArbdU2KKmyUpk837ooADUUMCN6F0+hPakJUASNknwoHoy+YBCMCTWQUyqdusH
         Fgx3jfdehw8Y4OF+lJlrAsTLFXAYPYJwx8MRPIqOmF6huSdhmbn0Iz/pBBmBa0BW1j8p
         zgttZ31zcJaBcI9QPXqRP5ykjmyS4PU8gs7Kn/1qvhmldGv4BFzCQV8KM8oF0+g4u2kV
         OGUgK25HfdfnheVw/lHE2OfzwHL4Cb57Hvfs9QUFlvB65S0f+XY+arM7qVY+QTualRoA
         Srcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678355128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r/CEEmT9yjwga5EOHyB11d5kpRkYTDfVDqStXRyqNgs=;
        b=ClgLG9sVeovPM4sVYp2+tDbEfzKJN5r+pUzx3zmvYzl4BjP5qL0uU4i6Wxk4jcwOyG
         bZdFhdT4PRTtmzLsjIl1yZ/TlQRdSPj4jNV+xMtfhrAisxZya1GepHqqG0Um7Cg9UuHT
         Z92tTx+EpUAc/p0PFcRX9Z11BWIat2/wRuZ5JVZ8sa/JtfFFXX/1Yxvq54B9GzdJdkvS
         /uPRtYpcrMxVSRV6M8UHqDULzF1X/CNxpeBlL7mN5lqoTqWVDjdNvKabbgVpRCNn7RfM
         fTHN0iLowuYgdRKohPd9rHmL0LwNE9TfZ7nw0efKqaGP8up3hCI5m44Lcbb3J0LvUhod
         7pqQ==
X-Gm-Message-State: AO0yUKW1Jyde0JDfEc0eK8nzmovenbnMrSc/bVenR18zDSvktmlR4n+7
        BgVNh3DkOrJyjTWWjui3AYU=
X-Google-Smtp-Source: AK7set9DKfIwYdITs+rtcfuqm7a7eLR7EDmjZhN7l6vysUxLwwS9ydCy9TyZH6xWofrar72lphkzRg==
X-Received: by 2002:a05:600c:45c7:b0:3eb:368c:5eb with SMTP id s7-20020a05600c45c700b003eb368c05ebmr19368569wmo.36.1678355128514;
        Thu, 09 Mar 2023 01:45:28 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id p12-20020a05600c468c00b003eb596cbc54sm2279910wmo.0.2023.03.09.01.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 01:45:27 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
        id 26ED9BE2DE0; Thu,  9 Mar 2023 10:45:27 +0100 (CET)
Date:   Thu, 9 Mar 2023 10:45:27 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Martin Wilck <mwilck@suse.com>,
        Christoph Hellwig <hch@infradead.org>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Subject: Re: Please apply commit 06e472acf964 ("scsi: mpt3sas: Remove usage
 of dma_get_required_mask() API") to stable series
Message-ID: <ZAmqt45uu1YoEnaD@eldamar.lan>
References: <ZAMUx8rG8xukulTu@eldamar.lan>
 <yq1356hnzd2.fsf@ca-mkp.ca.oracle.com>
 <ZAi4k/09acWV0wRZ@eldamar.lan>
 <yq1wn3rgj7a.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1wn3rgj7a.fsf@ca-mkp.ca.oracle.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Martin,

On Wed, Mar 08, 2023 at 02:05:01PM -0500, Martin K. Petersen wrote:
> 
> Salvatore,
> 
> > So I believe the right thing would be to revert first in the stable
> > series where it was applied (5.10.y, 5.15.y) the commit e0e0747de0ea
> > ("scsi: mpt3sas: Fix return value check of dma_get_required_mask()")
> > and then on top of this revert apply the patches:
> >
> > 9df650963bf6 ("scsi: mpt3sas: Don't change DMA mask while reallocating pools")
> > 1a2dcbdde82e ("scsi: mpt3sas: re-do lost mpt3sas DMA mask fix")
> > 06e472acf964 ("scsi: mpt3sas: Remove usage of dma_get_required_mask() API")
> >
> > Attached mbox file implements this.
> >
> > Does that looks now good for resolving the regression?
> 
> Yes, that's one way to resolve it.
> 
> At a quick glance your mbox looks fine. Best way to validate would be to
> compare the resulting _base_config_dma_addressing() function between
> your tree and upstream. I don't believe we have had additional changes
> here so there should be no delta.

Yes, the resulting _base_config_dma_addressing() function is the same
after applying the series of commits.

In both cases it will be:

/**
 * _base_config_dma_addressing - set dma addressing
 * @ioc: per adapter object
 * @pdev: PCI device struct
 *
 * Return: 0 for success, non-zero for failure.
 */
static int
_base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
{
        struct sysinfo s;
        u64 coherent_dma_mask, dma_mask;

        if (ioc->is_mcpu_endpoint || sizeof(dma_addr_t) == 4) {
                ioc->dma_mask = 32;
                coherent_dma_mask = dma_mask = DMA_BIT_MASK(32);
        /* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
        } else if (ioc->hba_mpi_version_belonged > MPI2_VERSION) {
                ioc->dma_mask = 63;
                coherent_dma_mask = dma_mask = DMA_BIT_MASK(63);
        } else {
                ioc->dma_mask = 64;
                coherent_dma_mask = dma_mask = DMA_BIT_MASK(64);
        }

        if (ioc->use_32bit_dma)
                coherent_dma_mask = DMA_BIT_MASK(32);

        if (dma_set_mask(&pdev->dev, dma_mask) ||
            dma_set_coherent_mask(&pdev->dev, coherent_dma_mask))
                return -ENODEV;

        if (ioc->dma_mask > 32) {
                ioc->base_add_sg_single = &_base_add_sg_single_64;
                ioc->sge_size = sizeof(Mpi2SGESimple64_t);
        } else {
                ioc->base_add_sg_single = &_base_add_sg_single_32;
                ioc->sge_size = sizeof(Mpi2SGESimple32_t);
        }

        si_meminfo(&s);
        ioc_info(ioc, "%d BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (%ld kB)\n",
                ioc->dma_mask, convert_to_kb(s.totalram));

        return 0;
}

Regards,
Salvatore
