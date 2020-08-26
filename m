Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977DD2539F4
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 23:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgHZVyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 17:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbgHZVyt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 17:54:49 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCA3C061574
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 14:54:48 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id p4so3973484qkf.0
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 14:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=jw7Kyg7fHulcOKqx+s05R6rdxT47EVNO2nxbzCeqXR0=;
        b=EQjKtUzXujJtw1hRT8+MiesIjVJBWY5i+EQQQLcsa4cTzC3aCRCNAGhVyoeFQdQFdv
         BuCzjQv5BSAtGNfEaAqdyESzAP5L04CdnUc5NKbMFXz1wJ30Wz6QFQyM3U+C6GPlI6xF
         ruD/j4nEeVDVwB4fhUjmBC/dSheF2h29txDUhy1hju8YP+cPTA+xQUn3Zinmqk97aq+1
         9SZr5B/Fa9bCO72YjwRu/ZoVo03+IgIKFx/16STYNQEtKoEg8r26Ujc+iK72/dpUl8jx
         wALpDqShCew3XisXAfgpBue4ncy1FPzjx5I6hGdklJAc5veLTBGGnkOi3ugvF6RcicKJ
         VSDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=jw7Kyg7fHulcOKqx+s05R6rdxT47EVNO2nxbzCeqXR0=;
        b=Nq+tR+V7j+bPT6rMolNW8xs//Vmi/QRHIv2fQuRNxpJTzGyZmi1SkpKedTsLaZrQEL
         vr/wur3uliFDp1xGsDybNq0ml8LBDzNWQ7XicmMvLW5FY7Q9KF20lOdJ+rAhyLEwNZi+
         0kxxuQ/1jlp3oB0m7kkeGVKjMoVrDPE6P7SZ//yrwsyo0U5xiW1eQPwm42gTc7XNdeTL
         1c1eGVhynWgMo5ANrpoacIBdZRJpEQnWV+GPi4YASmEn4xiXxiQhHc1Pwptul9cazYEr
         hLA7lZOq3UrkYVSsuWD8iIGq+uO4r/XOKAhuzE17q/aOe34cTPNnDN6WxQOOtzsLjm5v
         NWIQ==
X-Gm-Message-State: AOAM531sLD1qHpbuAO8XSMcYLy7EKGrhnMSW81EMT7rRxKNWTKYQenTo
        GaKDNLXwjjD6DPdTpTV8zoB1tg==
X-Google-Smtp-Source: ABdhPJw361DJrHAaD9chC7zQt3BWkWfPT8MLKg31lHiY8eb370BP0SJniWqeMrcuPHpiZhefLXD6gA==
X-Received: by 2002:a37:44e:: with SMTP id 75mr2823653qke.330.1598478886837;
        Wed, 26 Aug 2020 14:54:46 -0700 (PDT)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id o21sm256449qkk.94.2020.08.26.14.54.44
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Wed, 26 Aug 2020 14:54:45 -0700 (PDT)
Date:   Wed, 26 Aug 2020 14:54:31 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     Sasha Levin <sashal@kernel.org>
cc:     Hugh Dickins <hughd@google.com>,
        Greg KH <gregkh@linuxfoundation.org>, aarcange@redhat.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        mike.kravetz@oracle.com, songliubraving@fb.com,
        torvalds@linux-foundation.org, stable-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Patch "khugepaged: khugepaged_test_exit() check mmget_still_valid()"
 has been added to the 5.8-stable tree
In-Reply-To: <20200826214623.GM8670@sasha-vm>
Message-ID: <alpine.LSU.2.11.2008261453350.2508@eggly.anvils>
References: <1597841669128213@kroah.com> <alpine.LSU.2.11.2008190625060.24442@eggly.anvils> <20200819135306.GA3311904@kroah.com> <alpine.LSU.2.11.2008211739460.9564@eggly.anvils> <20200822212053.GE8670@sasha-vm> <alpine.LSU.2.11.2008221900570.11463@eggly.anvils>
 <alpine.LSU.2.11.2008240758110.2486@eggly.anvils> <alpine.LSU.2.11.2008261148000.1479@eggly.anvils> <20200826214623.GM8670@sasha-vm>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 26 Aug 2020, Sasha Levin wrote:
> On Wed, Aug 26, 2020 at 11:53:24AM -0700, Hugh Dickins wrote:
> > 
> > I see 5.8 is at 5.8.5-rc1 today, but the commit below still missing:
> > please re-add it, then we can all forget about it at last - thanks!
> 
> Greg went for a fast release cycle and I didn't have time to queue it
> up, sorry. But don't worry - this patch isn't forgotten, I'll queue it
> for the next release on Friday/Saturday.

Great, thanks for the reassurance, I'll relax now.

Hugh
