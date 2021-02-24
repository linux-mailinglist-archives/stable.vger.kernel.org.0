Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF01324393
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 19:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbhBXSKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 13:10:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47806 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232700AbhBXSKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 13:10:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614190130;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DAP/4+bo7rMPoBzDXwzNHiMou9v/EWvyN52pN1kejRI=;
        b=SYBbaTSXX0bpj8U375KgeRGsOdV94tiK+FRXZ02fEfMZZlAEdaH+57AQh1y70Tzyy/9fV6
        xBX4FZ6Awx+Lt9m2tLpXx4kqj6v6BUFo7loZj56h97fqPcOoJjd92Q1SHVYScLD1UWMFp0
        /Ubw9/aOL1Xu+t6uAUyPqFBYCEUV5o4=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-FlsqrvFiOkueULoL0SDNFA-1; Wed, 24 Feb 2021 13:08:48 -0500
X-MC-Unique: FlsqrvFiOkueULoL0SDNFA-1
Received: by mail-qt1-f197.google.com with SMTP id h13so2232167qti.21
        for <stable@vger.kernel.org>; Wed, 24 Feb 2021 10:08:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :in-reply-to:references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=DAP/4+bo7rMPoBzDXwzNHiMou9v/EWvyN52pN1kejRI=;
        b=Zpomxe91mSbCdtliCZ23bBn6jkXTPbLOjR5NUi1KOPvmZBCPWe2CHAyMybdS9Mkdna
         Q7itm27HR4i5gsUcGejkXYTO7HO8lMSaGgGoHvUXL6BI4dY9A39w0hG6b3kFN+BT1pJP
         gMzqMtki3+n7hCU+S+2dBU1Zz6lBW4b31TRHQJJG0FacqUpJMrLb0vEFBAKwY7hvD3IG
         SmeC63+E9GwKI3OL0/cTPVEcfHvWsbsToe3VElFDSHU/jvOWKVA3pdDIfwy8qfoiGPMu
         C6O+3h2ixIj+/jhflc3yAaIEZwUlrf8vbop022qY62qJGCJ4FjxR5rQ0PTBX1zYYEKCT
         hC6A==
X-Gm-Message-State: AOAM532eOAmMZwGtGo1Ez1COw0DcQB1wOI1e3Ov/poQjfLw3S3SkvS6u
        vNajnDJyEbSYdOWJl4bxoFUCynLTj7qKfQOXW/TpcorD7ZyMrfrO5uBCqy8ary9R96D4ftX61j6
        GlVisC9DFTi1dPCqn
X-Received: by 2002:ae9:ec17:: with SMTP id h23mr31041206qkg.193.1614190127842;
        Wed, 24 Feb 2021 10:08:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyOiPoU8eUpYjHTThc7Exq6uyWIxcAuV5WGFv/iTh/FdLngbd0IEMYKc96a/MGLQrJ4qjrufQ==
X-Received: by 2002:ae9:ec17:: with SMTP id h23mr31041187qkg.193.1614190127691;
        Wed, 24 Feb 2021 10:08:47 -0800 (PST)
Received: from Whitewolf.lyude.net (pool-108-49-102-102.bstnma.fios.verizon.net. [108.49.102.102])
        by smtp.gmail.com with ESMTPSA id g186sm893793qke.0.2021.02.24.10.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 10:08:47 -0800 (PST)
Message-ID: <10aa57cb1a982cbc07195319580bc9604961f186.camel@redhat.com>
Subject: Re: [PATCH v2 0/2] Set CLEAR_PAYLOAD_ID_TABLE as broadcast request
From:   Lyude Paul <lyude@redhat.com>
Reply-To: lyude@redhat.com
To:     Wayne Lin <Wayne.Lin@amd.com>, dri-devel@lists.freedesktop.org
Cc:     ville.syrjala@linux.intel.com, stable@vger.kernel.org,
        Nicholas.Kazlauskas@amd.com, harry.wentland@amd.com,
        jerry.zuo@amd.com, eryk.brol@amd.com, qingqing.zhuo@amd.com
Date:   Wed, 24 Feb 2021 13:08:46 -0500
In-Reply-To: <20210224101521.6713-1-Wayne.Lin@amd.com>
References: <20210224101521.6713-1-Wayne.Lin@amd.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

also - I meant to reply to v2, not v1 :). Just so you don't worry that I pushed
the wrong patch series version

On Wed, 2021-02-24 at 18:15 +0800, Wayne Lin wrote:
> While testing MST hotplug events on daisy chain monitors, find out
> that CLEAR_PAYLOAD_ID_TABLE is not broadcasted and payload id table
> is not reset. Dig in deeper and find out two parts needed to be fixed.
> 
> 1. Link_Count_Total & Link_Count_Remaining of Broadcast message are
> incorrect. Should set lct=1 & lcr=6
> 2. CLEAR_PAYLOAD_ID_TABLE request message is not set as path broadcast
> request message. Should fix this.
> 
> Changes since v1:
> *Refer to the suggestion from Ville Syrjala. While preparing hdr-rad,
> take broadcast case into consideration.
> 
> Wayne Lin (2):
>   drm/dp_mst: Revise broadcast msg lct & lcr
>   drm/dp_mst: Set CLEAR_PAYLOAD_ID_TABLE as broadcast
> 
>  drivers/gpu/drm/drm_dp_mst_topology.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> --
> 2.17.1
> 

-- 
Sincerely,
   Lyude Paul (she/her)
   Software Engineer at Red Hat
   
Note: I deal with a lot of emails and have a lot of bugs on my plate. If you've
asked me a question, are waiting for a review/merge on a patch, etc. and I
haven't responded in a while, please feel free to send me another email to check
on my status. I don't bite!

