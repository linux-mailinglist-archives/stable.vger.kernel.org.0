Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC5D390146
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 14:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbhEYMs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 08:48:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37776 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231907AbhEYMsu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 08:48:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621946840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YXmsHziycKqj5sjG90gli5vNMCQewicI2zvKUV1QGAk=;
        b=ezSe1ECLP0f0KkaYTMKMwdN95R9/5bRGFfLYkL2CRCrcZeoMScq34uwL6+QP1GbmjC4tGI
        AkLk6QA5ua0lFdTvPb5opozN1JNscJjUqJBn2b4U7Y7LOP281F06uFpEp2XgcNWc552lv+
        ZBPIXlTmTSHoZhDREhLuR0jSbJ4Ft1w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-SO5tl9TpNvmx3t9BmEArIg-1; Tue, 25 May 2021 08:47:18 -0400
X-MC-Unique: SO5tl9TpNvmx3t9BmEArIg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05644107ACC7;
        Tue, 25 May 2021 12:47:18 +0000 (UTC)
Received: from host1.jankratochvil.net (unknown [10.40.193.68])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E12DE690FA;
        Tue, 25 May 2021 12:47:16 +0000 (UTC)
Date:   Tue, 25 May 2021 14:47:14 +0200
From:   Jan Kratochvil <jan.kratochvil@redhat.com>
To:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: LTS perf unwind fix
Message-ID: <YKzx0jEp7PXbaewj@host1.jankratochvil.net>
References: <682895f7a145df0a20814001c508688113322854.camel@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <682895f7a145df0a20814001c508688113322854.camel@nokia.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 May 2021 14:41:15 +0200, Rantala, Tommi T. (Nokia - FI/Espoo) wrote:
> Can you please cherry-pick this to LTS:
> 
> commit bf53fc6b5f415cddc7118091cb8fd6a211b2320d
> Author: Jan Kratochvil <jan.kratochvil@redhat.com>
> Date:   Fri Dec 4 09:17:02 2020 -0300
> 
>     perf unwind: Fix separate debug info files when using elfutils' libdw's unwinder

It needs to be cherry-picked together with this commit as my commit did cause
a regression:

commit 4e1481445407b86a483616c4542ffdc810efb680
Author: Dave Rigby <d.rigby@me.com>
Date:   Thu Feb 18 16:56:54 2021 +0000

    perf unwind: Set userdata for all __report_module() paths


Jan Kratochvil

