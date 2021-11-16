Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F65F45362C
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 16:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238377AbhKPPpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 10:45:10 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:42030 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238645AbhKPPoh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 10:44:37 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id B4738212B9;
        Tue, 16 Nov 2021 15:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1637077298; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SAj4/SjslMmi0FzgQn3IjAHWrXahNXXWxcjpgKfHdds=;
        b=mS6Lug7LWryBurfazjYIzvl0HOhty00lql4VdVYJMRjiwUVzccu8tX58yvjy7hxICqPv/M
        hWsmYb1OgsMR9GpusOn3ImUAyt9a1X9Z1pfy79MZF9d1u99GzKXdZn/Zx4HWjuuseSk1pc
        /gzJ2iyaMKTDJBCBiczXOQib8YUN4rc=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 88FCAA3B8B;
        Tue, 16 Nov 2021 15:41:38 +0000 (UTC)
Date:   Tue, 16 Nov 2021 16:41:35 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Christoph Lameter <cl@gentwo.de>
Cc:     Dennis Zhou <dennis@kernel.org>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "osalvador@suse.de" <osalvador@suse.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>
Subject: Re: + mm-fix-panic-in-__alloc_pages.patch added to -mm tree
Message-ID: <YZPRL7HtQGUUAVG4@dhcp22.suse.cz>
References: <YYozLsIECu0Jnv0p@dhcp22.suse.cz>
 <af7ab3ce-fed2-1ffc-13a8-f9acbd201841@redhat.com>
 <YYpTy9eXZucxuRO/@dhcp22.suse.cz>
 <YY6wZMcx/BeddUnH@fedora>
 <YZI5TEW2BkBjOtC1@dhcp22.suse.cz>
 <B8B7E3FA-6EAB-46B7-95EB-5A31395C8ADE@vmware.com>
 <YZJZes9Gz9fe7bCC@dhcp22.suse.cz>
 <ABEDED57-93A9-4601-8EB6-2FF348A0E0BB@vmware.com>
 <YZMq++inSmJegJmj@fedora>
 <alpine.DEB.2.22.394.2111161329010.79746@gentwo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.22.394.2111161329010.79746@gentwo.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 16-11-21 13:30:45, Christoph Lameter wrote:
> On Mon, 15 Nov 2021, Dennis Zhou wrote:
> 
> > I need some clarification here. It sounds like memoryless nodes work on
> > x86, but hotplug + memoryless nodes isn't a supported use case or you're
> > introducing it as a new use case?
> 
> Could you do that step by step?
> 
> First add the new node and ensure everything is ok and that the memory is
> online.
> 
> *After* that is done bring up the new processor and associate the
> processor with *online* memory.

We are discussing that in the original thread -
http://lkml.kernel.org/r/YZN3ExwL7BiDS5nj@dhcp22.suse.cz

This patch is a a workaround that problem in the pcp code.
 

-- 
Michal Hocko
SUSE Labs
