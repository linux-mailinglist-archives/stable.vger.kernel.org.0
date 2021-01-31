Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075A7309EF8
	for <lists+stable@lfdr.de>; Sun, 31 Jan 2021 21:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhAaUhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 15:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhAaUhb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jan 2021 15:37:31 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0DA5C061573
        for <stable@vger.kernel.org>; Sun, 31 Jan 2021 12:36:50 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id dj23so16532486edb.13
        for <stable@vger.kernel.org>; Sun, 31 Jan 2021 12:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dVXCN7SYo1yW1UQJgwONNhl7rEbTJKlKscqEvO76lyQ=;
        b=Bv6kT4f4hz3OLNbyznnQJ+Hw1xxLuC6JvBE61Z4nHFObd6NvrgJtq9aTXMU3oTaDOD
         jCjRAK/cYJgcujCnaPWC+4p/SJyG0Js+w5ENawl2WdxEF+2JogcbbC+byOIAuQ0jtcAf
         JuskR1VOmFoIOWk7y0wBhZETHKgWRxzxbTH5qYYiDz+r/35TJknzWwd7JV30bIh3YZkM
         fL4pXw2v5Iluo4NNrUix4JMW6XmOMO8Bc0WiM6c7FGEqOoxOgJ6ExfnGYRKRkWWKgTwT
         PWFfNpfiwQ87S1WSeeZro08ntyLoDySP4HizNH63+sr3pvMPOm93pqLPkdT0f7/+4lWt
         54kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=dVXCN7SYo1yW1UQJgwONNhl7rEbTJKlKscqEvO76lyQ=;
        b=ik19+eLpsZAvp8OyyKgTFWTS732Sa1GxBQM/NMg3JdCB3PPLKWnTGprFo6YN3bNPyZ
         Q0iFRb9gn3Pz97Hy3+9KfT6M+ryGa3W10O56lWZGIrU9UuiSu4oKSqlyT+LykhstwF2O
         BRZkPjMuWSgAPTErP/c0QHOpbkYYmWSZrGJnf8w2hwGsH3Ui61vb95TJxHLGkw29uE3c
         LljtEwl6JSSsZG/XNp2b+IanrDAko7zcVRS/YUk6wexO1tV+RNlMPY1idJJz5MV1qsl5
         ZQ4Jh5rqcqtfEr5b5gEIxzqCiddjf7/z9DqoU9quvssuFrcjcwFps0VGc/vGAJudUb9o
         e++w==
X-Gm-Message-State: AOAM5320AkHY5hXtbNAu8ZJobNj/x3HYHJ458ZYcJhPxkFZLTyils4bv
        VhUVObga1UM/1qkp/cuiH8c=
X-Google-Smtp-Source: ABdhPJwaB3oipxyNMl7pE4/bfKKNYRjY2AV8Di/w939vneJNZES7jeqxpbl2EgB2Ylwi0xRqm6CNVA==
X-Received: by 2002:a50:fe85:: with SMTP id d5mr16162341edt.140.1612125409787;
        Sun, 31 Jan 2021 12:36:49 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id u3sm6730055eje.63.2021.01.31.12.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jan 2021 12:36:48 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Sun, 31 Jan 2021 21:36:47 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Jason Andryuk <jandryuk@gmail.com>
Cc:     stable@vger.kernel.org,
        Michael Labriola <michael.d.labriola@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Sasha Levin <sashal@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Roger Pau Monne <roger.pau@citrix.com>,
        Marek =?iso-8859-1?Q?Marczykowski-G=F3recki?= 
        <marmarek@invisiblethingslab.com>, Juergen Gross <jgross@suse.com>
Subject: Re: Request: xen: Fix XenStore initialisation for XS_LOCAL
Message-ID: <YBcU3/cl/j4ppLJY@eldamar.lan>
References: <CAKf6xptBwdnhgVYgXhXRvUg9jL3TOf9hT4EcnkZFLJsVVp2M-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKf6xptBwdnhgVYgXhXRvUg9jL3TOf9hT4EcnkZFLJsVVp2M-Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Sun, Jan 31, 2021 at 12:20:18PM -0500, Jason Andryuk wrote:
> xen: Fix XenStore initialisation for XS_LOCAL
> 
> commit 5f46400f7a6a4fad635d5a79e2aa5a04a30ffea1 upstream
> 
> The requested patch fixes Xen Dom0 xenstore support.  It has a "Fixes:
> 3499ba8198ca ("xen: Fix event channel callback via INTX/GSI")" in the
> commit - that patch was introduced to stable in 5.4.93 and 5.10.11
> (didn't check other branches).

Confirmed it is needed as well for older branches as well. The commit
was backported to 4.14.218, 4.19.171, 5.4.93 and 5.10.11. At least for
4.19.y I could confirm (by a report of a user in Debian) that it is
broken in 4.19.171 and fixed by cherry-picking the above mentioned
commit. 

Regards,
Salvatore
