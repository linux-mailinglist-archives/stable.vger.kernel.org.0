Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71313A9CCF
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 10:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732521AbfIEITT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 04:19:19 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34612 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfIEITT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 04:19:19 -0400
Received: by mail-wr1-f66.google.com with SMTP id s18so1623926wrn.1;
        Thu, 05 Sep 2019 01:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7vrD1vbAUmCFFfdIktyw4RQaBVS3ITim3VvuBMdETos=;
        b=KrDqJT9pnaYjHlbMev2uN7ZQDpp4ATsX7iMQbyUVPvh7Zyex0SB+oyInc5ZZRKBALx
         4YRvbckrzDpG1nT0XswKerNPGvzMEe96kQY98ITPkN1mU8xw6tQ+n+6G+Qkg/woR77cR
         dpwgv3K4VnnE7KSKhZztW2gDMM/V1eLAOj//dDnEsk0KMmqU5SW+ozed1YDFze7sBquI
         t/o38y4o/EoxKILmRM9AjLqvfG15+z8QFT594yanB9ivEOtf5VoPDpS83cFQvmYHLwUV
         ZDsK0Y5NrSflQS+FbewoBw9/ke2FDkPsRlHPTWAmvY/hwLtW/GNXiBeMJTeHsk++Uoi9
         4CMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=7vrD1vbAUmCFFfdIktyw4RQaBVS3ITim3VvuBMdETos=;
        b=NfT4JWcBDQs35Nd5WW4sZ2LhxrYUr+BfCmUcnBioaGXN3Up2C4Ccl6nPgLClX20UJg
         /ijZaCmGP4ZBGRndVgMpLXSRjOr386ZTfpKIr9UbI3WHMjelqtU11JEvMOtgFcIHfUPO
         uFnetJdv/jWEPcbjDa6OfvIgd8nJ4sTDZhdoIP0PiiWmeU80Tz3Ie7fSk97iIGCve1TP
         BKfpiSRDsc4x1SRYAPkGeghKV66YHj2016pRyHINowPcvA0TDuz+gktsTimI00Qoa2gF
         Z9giminJ+RdiVpt7Uj/H68dwaAgLMSYCoBRlBCiKvVYKm0YWZAGs551zH9q5gbyPgdvB
         /ZkA==
X-Gm-Message-State: APjAAAXrrF18CTn30BlcOI8BXylfw8UfK0FJ8wCHUMnsZSZE84IGmBRq
        3h0sZ8bxtzYH2Tz+M4U/Q5s=
X-Google-Smtp-Source: APXvYqypRpPI1L8/VzXxqLP6zlec8VR5j0yZcibllXCpQiOHKv1zx3kMkVX/NbRsKv7XAOtrZMasCw==
X-Received: by 2002:adf:e392:: with SMTP id e18mr1587213wrm.87.1567671557098;
        Thu, 05 Sep 2019 01:19:17 -0700 (PDT)
Received: from gmail.com (2E8B0CD5.catv.pool.telekom.hu. [46.139.12.213])
        by smtp.gmail.com with ESMTPSA id o22sm3223544wra.96.2019.09.05.01.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 01:19:16 -0700 (PDT)
Date:   Thu, 5 Sep 2019 10:19:14 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Mike Travis <mike.travis@hpe.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 0/8] x86/platform/UV: Update UV Hubless System Support
Message-ID: <20190905081914.GA28060@gmail.com>
References: <20190903001815.504418099@stormcage.eag.rdlabs.hpecorp.net>
 <20190903074717.GA34890@gmail.com>
 <481b2921-760a-c0f3-489b-2b9c5f792883@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481b2921-760a-c0f3-489b-2b9c5f792883@hpe.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


* Mike Travis <mike.travis@hpe.com> wrote:

> 
> 
> On 9/3/2019 12:47 AM, Ingo Molnar wrote:
> > 
> > * Mike Travis <mike.travis@hpe.com> wrote:
> > 
> > > 
> > > These patches support upcoming UV systems that do not have a UV HUB.
> > > 
> > > 	* Save OEM_ID from ACPI MADT probe
> > > 	* Return UV Hubless System Type
> > > 	* Add return code to UV BIOS Init function
> > > 	* Setup UV functions for Hubless UV Systems
> > > 	* Add UV Hubbed/Hubless Proc FS Files
> > > 	* Decode UVsystab Info
> > > 	* Account for UV Hubless in is_uvX_hub Ops
> > 
> > Beyond addressing Christoph's feedback, please also make sure the series
> > applies cleanly to tip:master, because right now it doesn't.
> > 
> > Thanks,
> > 
> > 	Ingo
> > 
> 
> I will do this, and retest.  Currently we are using the latest upstream
> version but obviously that thinking is flawed, since we are hoping to
> get into the next merge period.

You are really cutting it close timing-wise ... unless by 'next' you mean 
not v5.4 but v5.5?

> I also noticed that the MAINTAINERS list for UV is out of date, I will 
> tend to that too.

Thanks!

	Ingo
