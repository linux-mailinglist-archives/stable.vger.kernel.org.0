Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7A51D5F44
	for <lists+stable@lfdr.de>; Sat, 16 May 2020 08:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbgEPG45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 May 2020 02:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725275AbgEPG44 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 May 2020 02:56:56 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A90C061A0C
        for <stable@vger.kernel.org>; Fri, 15 May 2020 23:56:56 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id l21so4171597eji.4
        for <stable@vger.kernel.org>; Fri, 15 May 2020 23:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=ufEiffPhcdP1WFgoGgcsuuopbnAWO2zcIgZgPK4ybrw=;
        b=UTdXNDalGYLrLOXK9iqt2npY4Iu8ydQrcgKzEZ1Bl7b+k1XQEny7HyKvRMWlHbk4Vu
         bfZ7xU6HGhrcUFsT045L9FmtKYb+KuNDuj0LwI7YK27bjMFsSLvZgTyzk4yNfmdOugu/
         nYeplNdFfbQ8Pmsz599w+Eu61gc4tJfpyHqJo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=ufEiffPhcdP1WFgoGgcsuuopbnAWO2zcIgZgPK4ybrw=;
        b=elUweRTKpzCQMUrBYeMSsEKTd99HdGilIrW3vO4AZzyCVj3fQ/pTdq14ju1wTUj2hO
         3762Mm+SC8VDrJRR8/vlZmEBi+pn/aUqcs1VkQ9PVhE7qUKBDaBu34FfzNI3hk1PmVjt
         HTeDc6nzhg70x2tXrluTvcQxB7cjSuuonekgK7l0n6BDWUCh8T1rMJ2+6ur82T5Jy3IR
         mvghUCecAdsL5Q/pJ0GK7aU3ZMZuHCLvVvshmBWBe+u40a7fjGV/8uKje4wfSsS2NTOn
         e4k+eXXBxN/tU9IH7o4iRNEaPkI15nW9U4sGa1bGvdsjDLmgraPAQ6RfWZE5u+OZRelX
         fTDA==
X-Gm-Message-State: AOAM53074MLibk5LaWZOeJidF1wuRp6K+p0aAquuHOJyUBmfAYCzMd0H
        EZrMKKIhHQpSteyMCSgBFlIS7D4isqPw1XW5AkQ1XA==
X-Google-Smtp-Source: ABdhPJxTDXezfYE0PaU0TaBXJVNiuc9ittt8gwZVnbU8oL6eWbSdJzBq0qD/BgelhdTtWPk36mwGGsF39bGnRDopDKQ=
X-Received: by 2002:a17:906:5255:: with SMTP id y21mr6540516ejm.306.1589612214360;
 Fri, 15 May 2020 23:56:54 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
References: <20200508085242.23406-1-chandrakanth.patil@broadcom.com> <b007f7ae-0a9d-2bfd-6da8-e72576c40353@suse.de>
In-Reply-To: <b007f7ae-0a9d-2bfd-6da8-e72576c40353@suse.de>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQJgInzLHphm3XOTq02c+mL5v6fZnAIOEm9Ip4XnPXA=
Date:   Sat, 16 May 2020 12:26:51 +0530
Message-ID: <8e37b956275b2837da4ba71773033c7d@mail.gmail.com>
Subject: RE: [PATCH 4/5] megaraid_sas: TM command refire leads to controller
 firmware crash
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>,
        Sankar Patra <sankar.patra@broadcom.com>,
        Sasikumar PC <sasikumar.pc@broadcom.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> > Issue: When TM command times-out driver invokes the controller reset.
> > Post reset, driver re-fires pended TM commands which leads to firmware
> > crash.
> >
> > Fix: Post controller reset, return pended TM commands back to OS.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> > Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
> > ---
> >   drivers/scsi/megaraid/megaraid_sas_fusion.c | 7 ++++++-
> >   1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > index 87f91a38..319f241 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > @@ -4180,6 +4180,7 @@ static void megasas_refire_mgmt_cmd(struct
> megasas_instance *instance,
> >   	struct fusion_context *fusion;
> >   	struct megasas_cmd *cmd_mfi;
> >   	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
> > +	struct MPI2_RAID_SCSI_IO_REQUEST *scsi_io_req;
> >   	u16 smid;
> >   	bool refire_cmd = false;
> >   	u8 result;
> > @@ -4247,6 +4248,11 @@ static void megasas_refire_mgmt_cmd(struct
> megasas_instance *instance,
> >   			result = COMPLETE_CMD;
> >   		}
> >
> > +		scsi_io_req = (struct MPI2_RAID_SCSI_IO_REQUEST *)
> > +				cmd_fusion->io_request;
> > +		if (scsi_io_req->Function == MPI2_FUNCTION_SCSI_TASK_MGMT)
> > +			result = RETURN_CMD;
> > +
> >   		switch (result) {
> >   		case REFIRE_CMD:
> >   			megasas_fire_cmd_fusion(instance, req_desc); @@ -4475,7
> +4481,6
> > @@ megasas_issue_tm(struct megasas_instance *instance, u16
> > device_handle,
> >   	if (!timeleft) {
> >   		dev_err(&instance->pdev->dev,
> >   			"task mgmt type 0x%x timed out\n", type);
> > -		cmd_mfi->flags |= DRV_DCMD_SKIP_REFIRE;
> >   		mutex_unlock(&instance->reset_mutex);
> >   		rc = megasas_reset_fusion(instance->host, MFI_IO_TIMEOUT_OCR);
> >   		mutex_lock(&instance->reset_mutex);
> >
> Why didn't the 'DRV_DCMD_SKIP_REFIRE' work?
> And if it doesn't work, can't it be removed completely?

Re-fire logic doesn't check  'DRV_DCMD_SKIP_REFIRE'  flag for TM commands
but it will check the flag for DCMDs
Hence, 'DRV_DCMD_SKIP_REFIRE' flag is only removed for TM commands.

-Chandrakanth Patil
