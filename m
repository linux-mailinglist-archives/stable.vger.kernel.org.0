Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F295D145A
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 18:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731699AbfJIQnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 12:43:53 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:38532 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730708AbfJIQnx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 12:43:53 -0400
Received: by mail-ot1-f65.google.com with SMTP id e11so2296077otl.5
        for <stable@vger.kernel.org>; Wed, 09 Oct 2019 09:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DUSbnv2FlQ+tlZLh0/AZ++thl7IaYgxKL4kpTbX3210=;
        b=Wvj8P2/uCXMIowpFJjSKAQUWqDSR/HHxDJQLf9Q6piaA+bvNYjt+Jqk6MSbayoP0xv
         SE8MMdUV8E9oX2eV7VY45yldWAdcMWD/SJizELp/72KXWvYimVS8FZaAcGw3WmzrTvB2
         ZkIQRANPT7Poj6TRFX3zRewhIbsJg0CF58UkLE76AZ+ywa0C+TxvHrXRtCKdV40t6o0N
         yy7T8TTCKMzkqmbxQEEs3u83RAAiMh64LsBQ3gWkyliwlf4dFsitTLW9d6Rjo/osK94l
         WddVlf5i7VNmGR9FlgoFv/PNBPmDf17PVGu2jJnACgbI2eafM5bQtWsRatkqN52WjSZg
         7HPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DUSbnv2FlQ+tlZLh0/AZ++thl7IaYgxKL4kpTbX3210=;
        b=b8Y/iQe9ilWLHWT+L5K8K2vTBHdpqKQMx19SSqvsey+7HBFIcGyKqGS9gFwhVHG4nt
         itf8z6HdAdUanzLxyUODpmKV3PTDO4FiV4pJdpxf3X/Y6hkjlPJV57rT79GvGmxOHCRM
         Wy0Zm6AdyovllLlhAgp9yi8DQurWlX8reOXHROsGWiNZ7TgS4+6GCPaFlzJ4Mp2+CFfr
         0eurEthIONbyUBfD8TO+1UV1wxAuLOoQ1SF4NN2lPnsu4EHAW/B2JTDXWX31mR6uhS8E
         yvaB+rpL9HhnEpXknqsDQCH3j/nmh/QZFFFkMzij4tlV4V2A0Oqky/Ddl0fs1yDkeMgX
         KLqw==
X-Gm-Message-State: APjAAAV3FSGgI5GV+VMVaO9Pjaq50cf5EINgpcivwAf1p/4bTA7ADuqV
        HDaCqm3/NvljmpjbeEDChs18GnSk0kAkYXoronhnHQ==
X-Google-Smtp-Source: APXvYqxvk1evfvGM6xwDMOeUu3m6TGtFdra2sjStLwJ9NZ5coY1rh+enOLBM+quOhney2f/0AVcTwjXiwrHDAfVbWjo=
X-Received: by 2002:a9d:7c92:: with SMTP id q18mr3803154otn.363.1570639432488;
 Wed, 09 Oct 2019 09:43:52 -0700 (PDT)
MIME-Version: 1.0
References: <157056215310918@kroah.com> <20191009161138.GS1396@sasha-vm>
In-Reply-To: <20191009161138.GS1396@sasha-vm>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 9 Oct 2019 09:43:40 -0700
Message-ID: <CAPcyv4jhFjS0WH4g55359YGN8Mej+-KUGAcH1dn=uBiHegnDSQ@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] libnvdimm: prevent nvdimm from requesting
 key when security" failed to apply to 5.3-stable tree
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Dave Jiang <dave.jiang@intel.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 9, 2019 at 9:11 AM Sasha Levin <sashal@kernel.org> wrote:
>
> On Tue, Oct 08, 2019 at 09:15:53PM +0200, gregkh@linuxfoundation.org wrote:
> >
> >The patch below does not apply to the 5.3-stable tree.
> >If someone wants it applied there, or to any other stable or longterm
> >tree, then please email the backport, including the original git commit
> >id to <stable@vger.kernel.org>.
> >
> >thanks,
> >
> >greg k-h
> >
> >------------------ original commit in Linus's tree ------------------
> >
> >From 674f31a352da5e9f621f757b9a89262f486533a0 Mon Sep 17 00:00:00 2001
> >From: Dave Jiang <dave.jiang@intel.com>
> >Date: Tue, 24 Sep 2019 10:34:49 -0700
> >Subject: [PATCH] libnvdimm: prevent nvdimm from requesting key when security
> > is disabled
> >
> >Current implementation attempts to request keys from the keyring even when
> >security is not enabled. Change behavior so when security is disabled it
> >will skip key request.
> >
> >Error messages seen when no keys are installed and libnvdimm is loaded:
> >
> >    request-key[4598]: Cannot find command to construct key 661489677
> >    request-key[4606]: Cannot find command to construct key 34713726
> >
> >Cc: stable@vger.kernel.org
> >Fixes: 4c6926a23b76 ("acpi/nfit, libnvdimm: Add unlock of nvdimm support for Intel DIMMs")
> >Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> >Link: https://lore.kernel.org/r/156934642272.30222.5230162488753445916.stgit@djiang5-desk3.ch.intel.com
> >Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> The issue was that the way we represent security flags changed due to
> d78c620a2e824 ("libnvdimm/security: Introduce a 'frozen' attribute"). I
> fixed up 674f31a352da5 to address that and queued it for 5.3.

Thanks Sasha!
