Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6C75145CFE
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 21:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgAVUSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 15:18:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43417 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725827AbgAVUSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 15:18:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579724311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CZFB953qV+gIBO5olx5LNPvRiXJZ0yhjDpEkk+yDmPc=;
        b=TGWPEFeEej6Ls5fGKu3oC/hYEjHy3Pza5WYfCCmJxR47IMkkISsZ8puquAINBkcayGAdDJ
        UnJpDilSain+dJovMLXEeSssqhASQe0griiP6NdNs4F5t11XBusM1623K3d9QynXHYA9nf
        yY6xhv2fqeiwwrlx1w2z5K13swjD7Ec=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-SMWK3eoVPVmP8lRQuPiovw-1; Wed, 22 Jan 2020 15:18:30 -0500
X-MC-Unique: SMWK3eoVPVmP8lRQuPiovw-1
Received: by mail-qt1-f198.google.com with SMTP id e8so627586qtg.9
        for <stable@vger.kernel.org>; Wed, 22 Jan 2020 12:18:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=CZFB953qV+gIBO5olx5LNPvRiXJZ0yhjDpEkk+yDmPc=;
        b=s4VGX7o2J9OuPxmH2nFQyLgoB9KrIy88wnyfjoyGsR/D5uZoa6N50lA3Wkev59kpWc
         1nOoJxJbA4tn5BvGpon8PjxL83mb/OdbaQyc3VGe64EOQrvjBn8xrXsoCw1LFNhZWF8x
         NHzHVKf5nBZXsAzLqVHAZhP8yONaY5pBR52JW6w0EzMLZBtD8SPBlSJRF2S7HkJJ+9r5
         UlNzhZEH37j7hcc/oUaTdJG2yB8Yc4FgiZG/XCPMZuylzN+2m+ry8ynJfIIZNphPJVRE
         bEnAg1PQIXcOqepOj6KmVltI8SX3Ng5vhqYCDi44D7tALZuarqk5gRr/GTIHiRhMJvEF
         to2g==
X-Gm-Message-State: APjAAAWkOGtQjrw74lZFr/vllZqR9S0976upuIQc5sFxnyolODWQ5GBU
        Jsy2ZqJR9akGsgNqKQL8uNrDqZOKxeCQSFSWibad+hxdlb7xCMsMh6EbCMRSft6muXu3S+hSjhj
        SF7Jieif1QTB4eBOR
X-Received: by 2002:a05:620a:56f:: with SMTP id p15mr10557830qkp.160.1579724305525;
        Wed, 22 Jan 2020 12:18:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqxJt7eLOsdHLJ4QKtTD3EU7lXYZhiFee2cOwokWCRVaccEWePb8GAyHZ6oAM374sdLYV1zyoA==
X-Received: by 2002:a05:620a:56f:: with SMTP id p15mr10557814qkp.160.1579724305308;
        Wed, 22 Jan 2020 12:18:25 -0800 (PST)
Received: from dhcp-10-20-1-90.bss.redhat.com ([144.121.20.162])
        by smtp.gmail.com with ESMTPSA id m8sm21978682qtk.60.2020.01.22.12.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 12:18:24 -0800 (PST)
Message-ID: <696e7d77904ecbe86878169efa18f49d7cb1a4ec.camel@redhat.com>
Subject: Re: [PATCH v2] drm/dp_mst: Remove VCPI while disabling topology mgr
From:   Lyude Paul <lyude@redhat.com>
To:     "Lin, Wayne" <Wayne.Lin@amd.com>, Sean Paul <sean@poorly.run>
Cc:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Wed, 22 Jan 2020 15:18:23 -0500
In-Reply-To: <DM6PR12MB4137A84B694D85E26F8050D8FC0C0@DM6PR12MB4137.namprd12.prod.outlook.com>
References: <20191205090043.7580-1-Wayne.Lin@amd.com>
         <a6c4db964da7e00a6069d40abcb3aa887ef5522b.camel@redhat.com>
         <ec3e020798d99ce638c05b0f3eb00ebf53c3bd7c.camel@redhat.com>
         <DM6PR12MB41371AC4B0EC24E84AB0C84DFC580@DM6PR12MB4137.namprd12.prod.outlook.com>
         <CAMavQK+pS40SQibFuirjLAmjmy8NbOcXWvNsFP8PanS6dEcXWw@mail.gmail.com>
         <31d9eabe57a25ff8f4df22e645494d57715cdc0b.camel@redhat.com>
         <CAMavQK+pOtQ62mp4DSRDW7nHDz4doW3LA5AV1NML-wFa3s3cQA@mail.gmail.com>
         <cfae7fec779bd8fa4da0ad0e7664cf797a1700ab.camel@redhat.com>
         <DM6PR12MB4137A84B694D85E26F8050D8FC0C0@DM6PR12MB4137.namprd12.prod.outlook.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2020-01-22 at 04:48 +0000, Lin, Wayne wrote:
> [AMD Public Use]
> 
> Sorry for any inconvenience I brought.

Nothing to be sorry about! This happens from time to time, it's my fault for
not noticing it in the first place anyway :P. Ville from Intel is able to
review it, so there's no rush

> Thank you so much Lyude, I will have a look on that fix patch later.
> 
> > -----Original Message-----
> > From: Lyude Paul <lyude@redhat.com>
> > Sent: Saturday, January 18, 2020 4:45 AM
> > To: Sean Paul <sean@poorly.run>
> > Cc: Lin, Wayne <Wayne.Lin@amd.com>; dri-devel@lists.freedesktop.org;
> > amd-gfx@lists.freedesktop.org; Zuo, Jerry <Jerry.Zuo@amd.com>; Kazlauskas,
> > Nicholas <Nicholas.Kazlauskas@amd.com>; stable@vger.kernel.org
> > Subject: Re: [PATCH v2] drm/dp_mst: Remove VCPI while disabling topology
> > mgr
> > 
> > Yeah that's fine with me, I'll send out a revert for this in just a moment
> > 
> > On Fri, 2020-01-17 at 15:43 -0500, Sean Paul wrote:
> > > On Fri, Jan 17, 2020 at 3:27 PM Lyude Paul <lyude@redhat.com> wrote:
> > > > On Fri, 2020-01-17 at 11:19 -0500, Sean Paul wrote:
> > > > > On Mon, Dec 9, 2019 at 12:56 AM Lin, Wayne <Wayne.Lin@amd.com>
> > wrote:
> > > > > > > -----Original Message-----
> > > > > > > From: Lyude Paul <lyude@redhat.com>
> > > > > > > Sent: Saturday, December 7, 2019 3:57 AM
> > > > > > > To: Lin, Wayne <Wayne.Lin@amd.com>;
> > > > > > > dri-devel@lists.freedesktop.org; amd-gfx@lists.freedesktop.org
> > > > > > > Cc: Kazlauskas, Nicholas <Nicholas.Kazlauskas@amd.com>;
> > > > > > > Wentland, Harry <Harry.Wentland@amd.com>; Zuo, Jerry
> > > > > > > <Jerry.Zuo@amd.com>; stable@vger.kernel.org
> > > > > > > Subject: Re: [PATCH v2] drm/dp_mst: Remove VCPI while
> > > > > > > disabling topology mgr
> > > > > > > 
> > > > > > > On Fri, 2019-12-06 at 14:24 -0500, Lyude Paul wrote:
> > > > > > > > Reviewed-by: Lyude Paul <lyude@redhat.com>
> > > > > > > > 
> > > > > > > > I'll go ahead and push this to drm-misc-next-fixes right
> > > > > > > > now, thanks!
> > > > > > > 
> > > > > > > Whoops-meant to say drm-misc-next here, anyway, pushed!
> > > > > > Thanks for your time!
> > > > > > 
> > > > > 
> > > > > I'm getting the following warning on unplug with this patch:
> > > > > 
> > > 
> > > \snip
> > > 
> > > > I think I've got a better fix for this that should avoid that
> > > > problem, I'll write up a patch and send it out in a bit
> > > 
> > > Thanks Lyude! Should we revert this patch for the time being?
> > > 
> > > > --
> > > > Cheers,
> > > >         Lyude Paul
> > > > 
> > --
> > Cheers,
> > 	Lyude Paul
> --
> Best regards,
> Wayne
-- 
Cheers,
	Lyude Paul

