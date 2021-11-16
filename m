Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C8C45324F
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 13:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236243AbhKPMlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 07:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236306AbhKPMlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 07:41:19 -0500
X-Greylist: delayed 446 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 16 Nov 2021 04:38:21 PST
Received: from gentwo.de (gentwo.de [IPv6:2a02:c206:2048:5042::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8616C061570;
        Tue, 16 Nov 2021 04:38:20 -0800 (PST)
Received: by gentwo.de (Postfix, from userid 1001)
        id 0992BB00434; Tue, 16 Nov 2021 13:30:45 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by gentwo.de (Postfix) with ESMTP id 08372B00192;
        Tue, 16 Nov 2021 13:30:45 +0100 (CET)
Date:   Tue, 16 Nov 2021 13:30:45 +0100 (CET)
From:   Christoph Lameter <cl@gentwo.de>
To:     Dennis Zhou <dennis@kernel.org>
cc:     Alexey Makhalov <amakhalov@vmware.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "osalvador@suse.de" <osalvador@suse.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>
Subject: Re: + mm-fix-panic-in-__alloc_pages.patch added to -mm tree
In-Reply-To: <YZMq++inSmJegJmj@fedora>
Message-ID: <alpine.DEB.2.22.394.2111161329010.79746@gentwo.de>
References: <20211108205031.UxDPHBZWa%akpm@linux-foundation.org> <YYozLsIECu0Jnv0p@dhcp22.suse.cz> <af7ab3ce-fed2-1ffc-13a8-f9acbd201841@redhat.com> <YYpTy9eXZucxuRO/@dhcp22.suse.cz> <YY6wZMcx/BeddUnH@fedora> <YZI5TEW2BkBjOtC1@dhcp22.suse.cz>
 <B8B7E3FA-6EAB-46B7-95EB-5A31395C8ADE@vmware.com> <YZJZes9Gz9fe7bCC@dhcp22.suse.cz> <ABEDED57-93A9-4601-8EB6-2FF348A0E0BB@vmware.com> <YZMq++inSmJegJmj@fedora>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Nov 2021, Dennis Zhou wrote:

> I need some clarification here. It sounds like memoryless nodes work on
> x86, but hotplug + memoryless nodes isn't a supported use case or you're
> introducing it as a new use case?

Could you do that step by step?

First add the new node and ensure everything is ok and that the memory is
online.

*After* that is done bring up the new processor and associate the
processor with *online* memory.


